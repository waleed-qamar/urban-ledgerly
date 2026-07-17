-- =====================================================================
-- Ledgerly / Urban Constructions — Attendance System
-- Schema Updates & Data Seed — Session of 2026-07-15
--
-- This file documents every change made on top of the original
-- attendance_system.sql, attendance_rbac.sql, and attendance_review.sql.
-- Run top to bottom in a fresh environment if replicating this setup,
-- or use as a historical record of what was applied to production.
-- =====================================================================


-- =====================================================================
-- PART 1: Permission grant fix
-- -----------------------------------------------------------------
-- Root cause: `service_role` was missing standard Postgres GRANTs on
-- the attendance_* tables. This is NOT an RLS issue — service_role
-- bypasses RLS by design, but still needs table-level grants, which
-- normally auto-apply via Supabase's default privilege wiring. That
-- wiring did not apply cleanly when attendance_system.sql was run,
-- leaving service_role unable to SELECT/INSERT even on tables it
-- itself was allowed to create.
--
-- Symptom: Edge Function returned
--   {"error":"Device lookup failed","details":"permission denied for table attendance_devices"}
-- and separately, debug_token queries returned Postgres error code 42501
-- (insufficient_privilege) against attendance_agent_tokens.
-- =====================================================================

GRANT USAGE ON SCHEMA public TO service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO service_role;

-- Ensures any future tables created in this schema also get service_role
-- access automatically, so this class of bug can't recur.
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


-- =====================================================================
-- PART 2: operators table — add device_employee_code column
-- -----------------------------------------------------------------
-- Enables exact-match auto-mapping between ZKTeco MB20 device user IDs
-- and Ledgerly operators, instead of relying purely on manual
-- reconciliation. UNIQUE constraint prevents two operators from
-- accidentally claiming the same device code.
-- =====================================================================

ALTER TABLE public.operators
ADD COLUMN IF NOT EXISTS device_employee_code text UNIQUE;


-- =====================================================================
-- PART 3: Initial operator data seed (35 employees)
-- -----------------------------------------------------------------
-- Populated from the ZKTeco MB20 enrolled-user list (pull_2026-07-11
-- CSV export). Two device codes were deliberately excluded:
--   - code 1  ("Admin")  — device admin account, not a real employee
--   - code 2  ("Waleed") — used during device setup/testing
--
-- All employees seeded as work_group_id=3 (Workers) / default_wage_role_id=1
-- (Pressman), EXCEPT Salman (device code 101), who is work_group_id=1
-- (Office) / default_wage_role_id=5 (Office Staff).
--
-- KNOWN DUMMY VALUES — replace with real data when available:
--   - phone: all rows set to '0300-0000000' (placeholder, not unique-constrained)
--   - joining_date: all rows set to CURRENT_DATE (actual join dates unknown)
--   - cnic: left NULL for all rows (unique constraint allows multiple NULLs)
-- =====================================================================

INSERT INTO public.operators
  (name, phone, joining_date, work_group_id, default_wage_role_id, device_employee_code)
VALUES
  ('Salman', '0300-0000000', CURRENT_DATE, 1, 5, '101'),
  ('RanaAli', '0300-0000000', CURRENT_DATE, 3, 1, '102'),
  ('Shaban', '0300-0000000', CURRENT_DATE, 3, 1, '104'),
  ('HassanAli', '0300-0000000', CURRENT_DATE, 3, 1, '105'),
  ('AhmadAli', '0300-0000000', CURRENT_DATE, 3, 1, '106'),
  ('UmairKhalid', '0300-0000000', CURRENT_DATE, 3, 1, '107'),
  ('Jamshaid', '0300-0000000', CURRENT_DATE, 3, 1, '108'),
  ('Dildar', '0300-0000000', CURRENT_DATE, 3, 1, '109'),
  ('Ahmad', '0300-0000000', CURRENT_DATE, 3, 1, '110'),
  ('AmeerHamza', '0300-0000000', CURRENT_DATE, 3, 1, '111'),
  ('Faraz', '0300-0000000', CURRENT_DATE, 3, 1, '112'),
  ('Muzamil', '0300-0000000', CURRENT_DATE, 3, 1, '113'),
  ('Shoaib', '0300-0000000', CURRENT_DATE, 3, 1, '114'),
  ('MohsinAli', '0300-0000000', CURRENT_DATE, 3, 1, '115'),
  ('RanaMohsin', '0300-0000000', CURRENT_DATE, 3, 1, '116'),
  ('Arslan', '0300-0000000', CURRENT_DATE, 3, 1, '117'),
  ('RanaUmar', '0300-0000000', CURRENT_DATE, 3, 1, '118'),
  ('JamshadHsn', '0300-0000000', CURRENT_DATE, 3, 1, '119'),
  ('Mubeen', '0300-0000000', CURRENT_DATE, 3, 1, '120'),
  ('Basharat', '0300-0000000', CURRENT_DATE, 3, 1, '121'),
  ('Moazam', '0300-0000000', CURRENT_DATE, 3, 1, '122'),
  ('AbuHuraira', '0300-0000000', CURRENT_DATE, 3, 1, '123'),
  ('Ashraf', '0300-0000000', CURRENT_DATE, 3, 1, '124'),
  ('UmairQ', '0300-0000000', CURRENT_DATE, 3, 1, '125'),
  ('Nadeem', '0300-0000000', CURRENT_DATE, 3, 1, '126'),
  ('Imran', '0300-0000000', CURRENT_DATE, 3, 1, '127'),
  ('Niamat', '0300-0000000', CURRENT_DATE, 3, 1, '128'),
  ('AbuBakar', '0300-0000000', CURRENT_DATE, 3, 1, '129'),
  ('UmairOff', '0300-0000000', CURRENT_DATE, 3, 1, '130'),
  ('Shakeel', '0300-0000000', CURRENT_DATE, 3, 1, '131'),
  ('MuneebAli', '0300-0000000', CURRENT_DATE, 3, 1, '132'),
  ('RazaWS', '0300-0000000', CURRENT_DATE, 3, 1, '133'),
  ('Khuram', '0300-0000000', CURRENT_DATE, 3, 1, '134'),
  ('Anayat', '0300-0000000', CURRENT_DATE, 3, 1, '135'),
  ('Tayyab', '0300-0000000', CURRENT_DATE, 3, 1, '136')
ON CONFLICT (device_employee_code) DO NOTHING;


-- =====================================================================
-- PART 4: One-time mapping generation (device_id = 1)
-- -----------------------------------------------------------------
-- Auto-generates operator_device_mappings rows by exact-matching the
-- device_employee_code now present on operators. This is a one-time
-- bulk version of what Trigger 3 (Part 6) does automatically going
-- forward for any operator added later.
-- =====================================================================

INSERT INTO public.operator_device_mappings (attendance_device_id, device_employee_code, operator_id)
SELECT 1, o.device_employee_code, o.id
FROM public.operators o
WHERE o.device_employee_code IS NOT NULL
ON CONFLICT (attendance_device_id, device_employee_code) DO NOTHING;


-- =====================================================================
-- PART 5: One-time backfill of pre-existing unmapped punches
-- -----------------------------------------------------------------
-- 739 punches were uploaded via the desktop agent BEFORE operators
-- and mappings existed, so they landed in attendance_raw_uploads with
-- mapping_status = 'unmapped' and operator_id = NULL. This resolves
-- them retroactively now that mappings exist, then propagates the
-- newly-resolved rows into attendance_events (which the Edge Function
-- only writes to at initial ingest time, not on later backfill).
--
-- NOTE: after Part 6's triggers are installed, this step becomes
-- unnecessary for future mapping additions — it's included here only
-- as a record of the one-time manual catch-up that was needed.
-- =====================================================================

UPDATE public.attendance_raw_uploads aru
SET operator_id = odm.operator_id,
    mapping_status = 'mapped'
FROM public.operator_device_mappings odm
WHERE odm.attendance_device_id = aru.attendance_device_id
  AND odm.device_employee_code = aru.device_employee_code
  AND odm.is_active = true
  AND aru.mapping_status = 'unmapped';

INSERT INTO public.attendance_events
  (attendance_device_id, operator_id, device_employee_code, punched_at, status, punch, first_seen_run_uuid)
SELECT
  aru.attendance_device_id, aru.operator_id, aru.device_employee_code, aru.punched_at, aru.status, aru.punch, aru.first_seen_run_uuid
FROM public.attendance_raw_uploads aru
WHERE aru.mapping_status = 'mapped'
  AND aru.operator_id IS NOT NULL
ON CONFLICT (attendance_device_id, device_employee_code, punched_at) DO NOTHING;


-- =====================================================================
-- PART 6: Automation triggers — mapping and event propagation
-- -----------------------------------------------------------------
-- Three triggers that together make attendance ingestion fully
-- "fire and forget" regardless of whether operator/mapping data
-- arrives before or after the punches themselves:
--
--   1. try_map_raw_upload         — BEFORE INSERT on attendance_raw_uploads
--        Resolves operator_id/mapping_status at insert time if a
--        mapping already exists (handles the "mapping first" case).
--
--   2. push_to_attendance_events  — AFTER INSERT on attendance_raw_uploads
--        If trigger 1 resolved the row as mapped, immediately writes
--        the corresponding row into attendance_events.
--
--   3. backfill_on_new_mapping    — AFTER INSERT on operator_device_mappings
--        Handles the "punches first, mapping later" case — e.g. a new
--        hire enrolled on the device before their operator record
--        existed. Retroactively resolves any already-stored unmapped
--        rows for that (device, code) pair and pushes them into
--        attendance_events too.
--
-- With all three in place, the manager-facing "map this employee code"
-- UI only ever needs to do one thing: INSERT INTO operator_device_mappings.
-- Everything downstream (raw_uploads resolution + attendance_events
-- population) happens automatically.
-- =====================================================================

CREATE OR REPLACE FUNCTION public.try_map_raw_upload()
RETURNS trigger
LANGUAGE plpgsql
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

DROP TRIGGER IF EXISTS trg_try_map_raw_upload ON public.attendance_raw_uploads;
CREATE TRIGGER trg_try_map_raw_upload
BEFORE INSERT ON public.attendance_raw_uploads
FOR EACH ROW EXECUTE FUNCTION public.try_map_raw_upload();


CREATE OR REPLACE FUNCTION public.push_to_attendance_events()
RETURNS trigger
LANGUAGE plpgsql
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

DROP TRIGGER IF EXISTS trg_push_to_attendance_events ON public.attendance_raw_uploads;
CREATE TRIGGER trg_push_to_attendance_events
AFTER INSERT ON public.attendance_raw_uploads
FOR EACH ROW EXECUTE FUNCTION public.push_to_attendance_events();


CREATE OR REPLACE FUNCTION public.backfill_on_new_mapping()
RETURNS trigger
LANGUAGE plpgsql
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

DROP TRIGGER IF EXISTS trg_backfill_on_new_mapping ON public.operator_device_mappings;
CREATE TRIGGER trg_backfill_on_new_mapping
AFTER INSERT ON public.operator_device_mappings
FOR EACH ROW EXECUTE FUNCTION public.backfill_on_new_mapping();


-- =====================================================================
-- OUTSTANDING / NOT YET DONE (for future sessions):
--   - Manager-facing "Unmapped Punches" review UI (Flutter) — reuses
--     the existing SearchableDropdown<T> component. Not yet built.
--   - attendance_daily recalculation job/trigger (rolling up
--     attendance_events into daily in/out + normal/overtime minutes) —
--     not yet designed, separate from what's covered here.
--   - Real phone numbers, joining_date, and cnic for all 35 seeded
--     operators — currently placeholder/dummy values (see Part 3).
--   - Edge Function's inline mapping-lookup logic is now redundant
--     given the triggers above, but left as-is; can be simplified later.
-- =====================================================================
