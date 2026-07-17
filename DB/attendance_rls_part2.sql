-- =====================================================================
-- Ledgerly / Urban Constructions — Attendance RLS, Part 2
-- Extends attendance_rbac.sql to cover the ingest-side tables that
-- were left unprotected: attendance_events, attendance_raw_uploads,
-- operator_device_mappings, attendance_devices, attendance_sync_runs.
--
-- attendance_agent_tokens is handled separately below and does NOT
-- follow the generic pattern — see the note in that section.
--
-- IMPORTANT COMPANION CHANGE: the three mapping-automation trigger
-- functions (try_map_raw_upload, push_to_attendance_events,
-- backfill_on_new_mapping) are re-created here as SECURITY DEFINER.
-- Reason: once RLS is enabled below, these triggers can fire as a
-- side effect of an ordinary authenticated user's action (e.g. a
-- manager inserting a row into operator_device_mappings from the
-- Ledgerly UI). Without SECURITY DEFINER, the trigger's internal
-- UPDATE/INSERT statements run as that same authenticated role and
-- would be silently filtered by RLS if that specific role happens to
-- lack the matching permission — the insert itself would succeed
-- but the automation would quietly do nothing. SECURITY DEFINER makes
-- the automation itself infrastructure, not something that depends on
-- which manager happens to trigger it.
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- 1. Re-create trigger functions as SECURITY DEFINER
-- (logic unchanged from the master file — only the security context differs)
-- ---------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.try_map_raw_upload()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_operator_id bigint;
BEGIN
  SELECT operator_id INTO v_operator_id
  FROM public.operator_device_mappings
  WHERE attendance_device_id = NEW.attendance_device_id
    AND device_employee_code = NEW.device_employee_code
    AND is_active = true;

  IF v_operator_id IS NOT NULL THEN
    NEW.operator_id := v_operator_id;
    NEW.mapping_status := 'mapped';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.push_to_attendance_events()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.mapping_status = 'mapped' AND NEW.operator_id IS NOT NULL THEN
    INSERT INTO public.attendance_events
      (attendance_device_id, operator_id, device_employee_code, punched_at, status, punch, first_seen_run_uuid)
    VALUES
      (NEW.attendance_device_id, NEW.operator_id, NEW.device_employee_code, NEW.punched_at, NEW.status, NEW.punch, NEW.first_seen_run_uuid)
    ON CONFLICT (attendance_device_id, device_employee_code, punched_at) DO NOTHING;
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.backfill_on_new_mapping()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.attendance_raw_uploads
  SET operator_id = NEW.operator_id,
      mapping_status = 'mapped'
  WHERE attendance_device_id = NEW.attendance_device_id
    AND device_employee_code = NEW.device_employee_code
    AND mapping_status = 'unmapped';

  INSERT INTO public.attendance_events
    (attendance_device_id, operator_id, device_employee_code, punched_at, status, punch, first_seen_run_uuid)
  SELECT
    aru.attendance_device_id, aru.operator_id, aru.device_employee_code, aru.punched_at, aru.status, aru.punch, aru.first_seen_run_uuid
  FROM public.attendance_raw_uploads aru
  WHERE aru.attendance_device_id = NEW.attendance_device_id
    AND aru.device_employee_code = NEW.device_employee_code
    AND aru.mapping_status = 'mapped'
  ON CONFLICT (attendance_device_id, device_employee_code, punched_at) DO NOTHING;

  RETURN NEW;
END;
$$;

-- Triggers themselves are unchanged (still point at the same function
-- names), so no DROP/CREATE TRIGGER needed here.


-- ---------------------------------------------------------------------
-- 2. attendance_events
-- Read: managers/accountants viewing attendance. Writes: normally only
-- via the trigger above (now SECURITY DEFINER) or the Edge Function's
-- service_role client, both of which bypass these policies — so INSERT
-- here mainly guards against direct client-side writes.
-- ---------------------------------------------------------------------
ALTER TABLE public.attendance_events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "attendance_events_select" ON public.attendance_events;
CREATE POLICY "attendance_events_select" ON public.attendance_events
  FOR SELECT TO authenticated
  USING (current_user_has_permission('attendance.read'));

DROP POLICY IF EXISTS "attendance_events_insert" ON public.attendance_events;
CREATE POLICY "attendance_events_insert" ON public.attendance_events
  FOR INSERT TO authenticated
  WITH CHECK (current_user_has_permission('attendance.create'));

DROP POLICY IF EXISTS "attendance_events_update" ON public.attendance_events;
CREATE POLICY "attendance_events_update" ON public.attendance_events
  FOR UPDATE TO authenticated
  USING (current_user_has_permission('attendance.update'))
  WITH CHECK (current_user_has_permission('attendance.update'));

DROP POLICY IF EXISTS "attendance_events_delete" ON public.attendance_events;
CREATE POLICY "attendance_events_delete" ON public.attendance_events
  FOR DELETE TO authenticated
  USING (current_user_has_permission('attendance.delete'));


-- ---------------------------------------------------------------------
-- 3. attendance_raw_uploads
-- Read needed for the "unmapped punches" review screen. Update needed
-- so the backfill trigger's internal UPDATE succeeds when it fires as
-- SECURITY DEFINER regardless — this policy mainly matters if you ever
-- want an authenticated user to also touch this table directly.
-- ---------------------------------------------------------------------
ALTER TABLE public.attendance_raw_uploads ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "attendance_raw_uploads_select" ON public.attendance_raw_uploads;
CREATE POLICY "attendance_raw_uploads_select" ON public.attendance_raw_uploads
  FOR SELECT TO authenticated
  USING (current_user_has_permission('attendance.read'));

DROP POLICY IF EXISTS "attendance_raw_uploads_insert" ON public.attendance_raw_uploads;
CREATE POLICY "attendance_raw_uploads_insert" ON public.attendance_raw_uploads
  FOR INSERT TO authenticated
  WITH CHECK (current_user_has_permission('attendance.create'));

DROP POLICY IF EXISTS "attendance_raw_uploads_update" ON public.attendance_raw_uploads;
CREATE POLICY "attendance_raw_uploads_update" ON public.attendance_raw_uploads
  FOR UPDATE TO authenticated
  USING (current_user_has_permission('attendance.update'))
  WITH CHECK (current_user_has_permission('attendance.update'));

DROP POLICY IF EXISTS "attendance_raw_uploads_delete" ON public.attendance_raw_uploads;
CREATE POLICY "attendance_raw_uploads_delete" ON public.attendance_raw_uploads
  FOR DELETE TO authenticated
  USING (current_user_has_permission('attendance.delete'));


-- ---------------------------------------------------------------------
-- 4. operator_device_mappings
-- This is the table the manager-facing mapping UI writes to directly,
-- so insert/update need to actually work for whichever role the
-- manager has (typically attendance.create / attendance.update).
-- ---------------------------------------------------------------------
ALTER TABLE public.operator_device_mappings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "operator_device_mappings_select" ON public.operator_device_mappings;
CREATE POLICY "operator_device_mappings_select" ON public.operator_device_mappings
  FOR SELECT TO authenticated
  USING (current_user_has_permission('attendance.read'));

DROP POLICY IF EXISTS "operator_device_mappings_insert" ON public.operator_device_mappings;
CREATE POLICY "operator_device_mappings_insert" ON public.operator_device_mappings
  FOR INSERT TO authenticated
  WITH CHECK (current_user_has_permission('attendance.create'));

DROP POLICY IF EXISTS "operator_device_mappings_update" ON public.operator_device_mappings;
CREATE POLICY "operator_device_mappings_update" ON public.operator_device_mappings
  FOR UPDATE TO authenticated
  USING (current_user_has_permission('attendance.update'))
  WITH CHECK (current_user_has_permission('attendance.update'));

DROP POLICY IF EXISTS "operator_device_mappings_delete" ON public.operator_device_mappings;
CREATE POLICY "operator_device_mappings_delete" ON public.operator_device_mappings
  FOR DELETE TO authenticated
  USING (current_user_has_permission('attendance.delete'));


-- ---------------------------------------------------------------------
-- 5. attendance_devices
-- Master data (device_code, site_name etc). Same generic pattern —
-- most users will only ever need SELECT here.
-- ---------------------------------------------------------------------
ALTER TABLE public.attendance_devices ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "attendance_devices_select" ON public.attendance_devices;
CREATE POLICY "attendance_devices_select" ON public.attendance_devices
  FOR SELECT TO authenticated
  USING (current_user_has_permission('attendance.read'));

DROP POLICY IF EXISTS "attendance_devices_insert" ON public.attendance_devices;
CREATE POLICY "attendance_devices_insert" ON public.attendance_devices
  FOR INSERT TO authenticated
  WITH CHECK (current_user_has_permission('attendance.create'));

DROP POLICY IF EXISTS "attendance_devices_update" ON public.attendance_devices;
CREATE POLICY "attendance_devices_update" ON public.attendance_devices
  FOR UPDATE TO authenticated
  USING (current_user_has_permission('attendance.update'))
  WITH CHECK (current_user_has_permission('attendance.update'));

DROP POLICY IF EXISTS "attendance_devices_delete" ON public.attendance_devices;
CREATE POLICY "attendance_devices_delete" ON public.attendance_devices
  FOR DELETE TO authenticated
  USING (current_user_has_permission('attendance.delete'));


-- ---------------------------------------------------------------------
-- 6. attendance_sync_runs
-- Upload history from the desktop agent. Read-only from the app's
-- perspective — writes only ever come from the Edge Function's
-- service_role client (which bypasses RLS entirely), so no INSERT/
-- UPDATE/DELETE policy is defined for authenticated at all.
-- ---------------------------------------------------------------------
ALTER TABLE public.attendance_sync_runs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "attendance_sync_runs_select" ON public.attendance_sync_runs;
CREATE POLICY "attendance_sync_runs_select" ON public.attendance_sync_runs
  FOR SELECT TO authenticated
  USING (current_user_has_permission('attendance.read'));


-- ---------------------------------------------------------------------
-- 7. attendance_agent_tokens — DELIBERATELY NOT the generic pattern
-- This table stores token_hash values used to authenticate the
-- desktop agent itself. It should never be readable or writable by
-- ordinary authenticated users, regardless of permission level,
-- because:
--   a) it's a credential store, not attendance data, and
--   b) even a hash can be a useful oracle for an attacker who already
--      suspects a candidate token, so exposure has real value to limit.
-- RLS is enabled with NO policies for `authenticated` at all — this
-- means every authenticated request is denied by default. Only
-- service_role (which bypasses RLS) and direct SQL-editor access can
-- read/write this table. If you ever need an in-app "rotate agent
-- token" admin screen, that should go through a SECURITY DEFINER RPC
-- that checks a specific high-trust permission before touching this
-- table — not a direct table policy.
-- ---------------------------------------------------------------------
ALTER TABLE public.attendance_agent_tokens ENABLE ROW LEVEL SECURITY;
-- No policies created — default-deny for all authenticated access.

COMMIT;

NOTIFY pgrst, 'reload schema';