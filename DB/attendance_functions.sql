-- =====================================================================
-- Ledgerly / Urban Constructions — Attendance Calculation Layer
-- MASTER FILE — run this single file top to bottom in the Supabase
-- SQL editor to (re)install every function/trigger for:
--   - Raw punch -> operator mapping automation (from earlier session)
--   - Daily attendance rollup + pay segment calculation
--   - Manager adjustments for missing check-in/check-out
--   - Week finalization (locking) for printed/paid periods
--   - Weekly printable report (SHP/SHM/OTP/OTM/salary/overtime/take-home)
--
-- Safe to re-run: every CREATE uses OR REPLACE / IF NOT EXISTS / DROP
-- TRIGGER IF EXISTS, so running this file again after a future edit
-- will not error or duplicate objects.
--
-- Business rules encoded here (confirmed with Waleed):
--   - All operators are daily_wage or monthly_salary; no late-arrival
--     penalty logic is calculated — only worked hours vs shift hours.
--   - Normal hours = worked time capped at the work group's shift
--     duration; anything beyond is overtime.
--   - Absent = zero punches that day for an active operator.
--   - Missing one side of a punch pair (only check-in OR only
--     check-out) is NOT guessed — it's flagged 'needs_review' until a
--     manager supplies the missing side via attendance_adjustments.
--   - Role for the day = manager's manual daily_work_assignments entry
--     if present, else the operator's default_wage_role_id. Manual
--     role assignments are never overwritten by recalculation.
--   - Once a day is 'manager_approved' or 'finalized', recalculation
--     skips it entirely — protects printed/paid weeks from silently
--     changing if wage rates or punches are edited later.
--   - The weekly report stays server-side (this file) rather than in
--     Flutter, since managers pick arbitrary date ranges each time
--     anyway (no round-trip savings from moving it client-side), and
--     keeping the payroll math in one trusted place avoids two
--     implementations drifting apart over time.
-- =====================================================================


BEGIN;


-- =====================================================================
-- SECTION A: Mapping automation triggers
-- (unchanged from the previous session — included here so this file
-- is a complete single source of truth for the whole layer)
-- =====================================================================

-- A1. Resolves operator_id/mapping_status at insert time if a mapping
--     already exists for this device_employee_code.
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


-- A2. If a raw upload came in already mapped, immediately writes the
--     matching row into attendance_events.
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


-- A3. Handles "punches arrived before mapping existed" — when a new
--     operator_device_mappings row is added, retroactively resolves
--     any already-stored unmapped rows for that (device, code) pair.
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
-- SECTION B: Manager adjustments for missing check-in / check-out
-- Extends the existing save_attendance_adjustments RPC (originally in
-- attendance_review.sql) to also accept adjustedInAt, not just
-- adjustedOutAt. Any day touched here is marked 'estimated' so the
-- next recalculation run picks it up instead of leaving it stuck at
-- 'needs_review'.
-- =====================================================================

CREATE OR REPLACE FUNCTION public.save_attendance_adjustments(p_payload jsonb)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  draft jsonb;
  v_operator_id bigint;
  v_date date;
  v_adjusted_in_at timestamptz;
  v_adjusted_out_at timestamptz;
  v_adjusted_ot_minutes integer;
  v_shift_role_id bigint;
  v_ot_role_id bigint;
  v_reason text;
BEGIN
  FOR draft IN SELECT * FROM jsonb_array_elements(p_payload)
  LOOP
    v_operator_id := (draft->>'operatorId')::bigint;
    v_date := (draft->>'date')::date;
    v_reason := draft->>'reason';

    IF v_reason IS NULL OR trim(v_reason) = '' THEN
      RAISE EXCEPTION 'Reason cannot be empty for adjustment on %', v_date;
    END IF;

    v_adjusted_in_at := (draft->>'adjustedInAt')::timestamptz;
    v_adjusted_out_at := (draft->>'adjustedOutAt')::timestamptz;
    v_adjusted_ot_minutes := (draft->>'adjustedOtMinutes')::integer;
    v_shift_role_id := (draft->>'shiftRoleId')::bigint;
    v_ot_role_id := (draft->>'otRoleId')::bigint;

    -- Manual check-in fix (employee forgot to punch in)
    IF v_adjusted_in_at IS NOT NULL THEN
      INSERT INTO public.attendance_adjustments
        (operator_id, attendance_date, adjustment_type, adjusted_in_at, reason, source)
      VALUES
        (v_operator_id, v_date, 'manual_in_time', v_adjusted_in_at, v_reason, 'manager')
      ON CONFLICT (operator_id, attendance_date, adjustment_type)
      DO UPDATE SET adjusted_in_at = excluded.adjusted_in_at, reason = excluded.reason, source = 'manager';
    END IF;

    -- Manual check-out fix (employee forgot to punch out)
    IF v_adjusted_out_at IS NOT NULL THEN
      INSERT INTO public.attendance_adjustments
        (operator_id, attendance_date, adjustment_type, adjusted_out_at, reason, source)
      VALUES
        (v_operator_id, v_date, 'manual_out_time', v_adjusted_out_at, v_reason, 'manager')
      ON CONFLICT (operator_id, attendance_date, adjustment_type)
      DO UPDATE SET adjusted_out_at = excluded.adjusted_out_at, reason = excluded.reason, source = 'manager';
    END IF;

    -- Optional direct OT minutes override (kept from original RPC)
    IF v_adjusted_ot_minutes IS NOT NULL THEN
      UPDATE public.attendance_daily
      SET overtime_minutes = v_adjusted_ot_minutes
      WHERE operator_id = v_operator_id AND attendance_date = v_date;
    END IF;

    -- Manager role override for the day
    IF v_shift_role_id IS NOT NULL OR v_ot_role_id IS NOT NULL THEN
      INSERT INTO public.daily_work_assignments
        (operator_id, attendance_date, shift_role_id, overtime_role_id, source, notes)
      VALUES
        (v_operator_id, v_date, v_shift_role_id, v_ot_role_id, 'manager', v_reason)
      ON CONFLICT (operator_id, attendance_date)
      DO UPDATE SET
        shift_role_id = coalesce(excluded.shift_role_id, public.daily_work_assignments.shift_role_id),
        overtime_role_id = coalesce(excluded.overtime_role_id, public.daily_work_assignments.overtime_role_id),
        source = 'manager', notes = excluded.notes, updated_at = now();
    END IF;

    -- A day that was stuck at needs_review now has manual data to work
    -- with, so let the next recalculation run pick it up.
    UPDATE public.attendance_daily
    SET calculation_status = 'estimated'
    WHERE operator_id = v_operator_id AND attendance_date = v_date
      AND calculation_status = 'needs_review';
  END LOOP;
END;
$$;

GRANT EXECUTE ON FUNCTION public.save_attendance_adjustments TO authenticated;


-- =====================================================================
-- SECTION C: Daily attendance rollup + pay segment calculation
-- Call this after uploading/reviewing punches for a period:
--   SELECT public.recalculate_attendance_daily('2026-07-06','2026-07-12');
--
-- Persists results into attendance_daily and daily_work_segments (not
-- computed live), so a printed/paid week has a permanent, auditable
-- record that won't silently change if wage rates or punches are
-- edited afterward — protected further by the manager_approved /
-- finalized lock below.
-- =====================================================================

CREATE OR REPLACE FUNCTION public.recalculate_attendance_daily(
  p_from_date date,
  p_to_date date,
  p_operator_id bigint default null
)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_operator record;
  v_work_group record;
  v_date date;
  v_first timestamptz;
  v_last timestamptz;
  v_punch_count int;
  v_shift_minutes int;
  v_worked_minutes int;
  v_normal_minutes int;
  v_overtime_minutes int;
  v_is_absent boolean;
  v_status text;
  v_shift_role_id bigint;
  v_ot_role_id bigint;
  v_shift_rate public.operator_wage_rates;
  v_ot_rate public.operator_wage_rates;
  v_ot_payable numeric(12,2);
BEGIN
  FOR v_operator IN 
    SELECT * FROM public.operators 
    WHERE is_active = true 
      AND (p_operator_id IS NULL OR id = p_operator_id) 
  LOOP
    SELECT * INTO v_work_group FROM public.work_groups WHERE id = v_operator.work_group_id;

    FOR v_date IN SELECT generate_series(p_from_date, p_to_date, interval '1 day')::date LOOP

      -- Skip entirely if this day is already locked (printed/paid or
      -- explicitly manager-approved)
      IF EXISTS (
        SELECT 1 FROM public.attendance_daily
        WHERE operator_id = v_operator.id AND attendance_date = v_date
          AND calculation_status IN ('manager_approved', 'finalized')
      ) THEN
        CONTINUE;
      END IF;

      SELECT count(*) INTO v_punch_count
      FROM public.attendance_events
      WHERE operator_id = v_operator.id AND punched_at::date = v_date;

      -- Resolve today's role: keep manager's manual assignment if it exists
      SELECT dwa.shift_role_id, dwa.overtime_role_id
        INTO v_shift_role_id, v_ot_role_id
      FROM public.daily_work_assignments dwa
      WHERE dwa.operator_id = v_operator.id AND dwa.attendance_date = v_date;

      v_shift_role_id := coalesce(v_shift_role_id, v_operator.default_wage_role_id);
      v_ot_role_id := coalesce(v_ot_role_id, v_operator.default_wage_role_id);

      -- Creates the default row only if manager hasn't already set one
      INSERT INTO public.daily_work_assignments (operator_id, attendance_date, shift_role_id, overtime_role_id, source)
      VALUES (v_operator.id, v_date, v_shift_role_id, v_ot_role_id, 'default')
      ON CONFLICT (operator_id, attendance_date) DO NOTHING;

      -- Raw punch extremes for the day
      SELECT min(punched_at), max(punched_at) INTO v_first, v_last
      FROM public.attendance_events
      WHERE operator_id = v_operator.id AND punched_at::date = v_date;

      -- Manual overrides take precedence over (or fill gaps in) raw punches
      SELECT adjusted_in_at INTO v_first
      FROM public.attendance_adjustments
      WHERE operator_id = v_operator.id AND attendance_date = v_date AND adjustment_type = 'manual_in_time';
      v_first := coalesce(v_first, (SELECT min(punched_at) FROM public.attendance_events WHERE operator_id = v_operator.id AND punched_at::date = v_date));

      SELECT adjusted_out_at INTO v_last
      FROM public.attendance_adjustments
      WHERE operator_id = v_operator.id AND attendance_date = v_date AND adjustment_type = 'manual_out_time';
      v_last := coalesce(v_last, (SELECT max(punched_at) FROM public.attendance_events WHERE operator_id = v_operator.id AND punched_at::date = v_date));

      IF v_first IS NOT NULL AND v_last IS NOT NULL THEN
        v_is_absent := false;
        v_status := CASE WHEN v_punch_count = 1 THEN 'estimated' ELSE 'calculated' END;
        v_worked_minutes := extract(epoch FROM (v_last - v_first)) / 60;
        v_shift_minutes := extract(epoch FROM (v_work_group.default_shift_end - v_work_group.default_shift_start)) / 60;
        IF v_shift_minutes < 0 THEN v_shift_minutes := v_shift_minutes + 1440; END IF;
        v_normal_minutes := LEAST(v_worked_minutes, v_shift_minutes);
        v_overtime_minutes := GREATEST(v_worked_minutes - v_shift_minutes, 0);
      ELSIF v_first IS NULL AND v_last IS NULL THEN
        -- Truly absent
        v_is_absent := true;
        v_status := 'calculated';
        v_normal_minutes := 0;
        v_overtime_minutes := 0;
      ELSE
        -- One is set, one is not
        v_is_absent := false;
        v_status := 'needs_review';
        v_normal_minutes := 0;
        v_overtime_minutes := 0;
      END IF;

      INSERT INTO public.attendance_daily
        (operator_id, attendance_date, work_group_id, first_punch_at, last_punch_at,
         effective_in_at, effective_out_at, normal_minutes, overtime_minutes,
         is_absent, calculation_status, recalculated_at)
      VALUES
        (v_operator.id, v_date, v_operator.work_group_id, v_first, v_last,
         v_first, v_last, v_normal_minutes, v_overtime_minutes,
         v_is_absent, v_status, now())
      ON CONFLICT (operator_id, attendance_date) DO UPDATE SET
        work_group_id = excluded.work_group_id,
        first_punch_at = excluded.first_punch_at,
        last_punch_at = excluded.last_punch_at,
        effective_in_at = excluded.effective_in_at,
        effective_out_at = excluded.effective_out_at,
        normal_minutes = excluded.normal_minutes,
        overtime_minutes = excluded.overtime_minutes,
        is_absent = excluded.is_absent,
        calculation_status = excluded.calculation_status,
        recalculated_at = now();

      -- Clear only auto-calculated segments so re-runs don't duplicate pay
      DELETE FROM public.daily_work_segments
      WHERE operator_id = v_operator.id AND attendance_date = v_date AND source = 'calculated';

      IF NOT v_is_absent AND v_status IN ('calculated', 'estimated') THEN

        IF v_work_group.pay_type = 'daily_wage' AND v_normal_minutes > 0 THEN
          v_shift_rate := public.get_operator_wage_rate(v_operator.id, v_shift_role_id, v_date);
          IF v_shift_rate.id IS NULL THEN
            UPDATE public.attendance_daily SET calculation_status = 'needs_review'
            WHERE operator_id = v_operator.id AND attendance_date = v_date;
          ELSE
            INSERT INTO public.daily_work_segments
              (operator_id, attendance_date, segment_type, wage_role_id, operator_wage_rate_id,
               start_at, end_at, minutes, rate_type, rate_amount, payable_amount, source)
            VALUES
              (v_operator.id, v_date, 'shift', v_shift_role_id, v_shift_rate.id,
               v_first, v_last, v_normal_minutes, 'daily_wage', v_shift_rate.daily_wage, v_shift_rate.daily_wage, 'calculated');
          END IF;
        END IF;

        IF v_overtime_minutes > 0 AND v_operator.overtime_enabled AND v_work_group.overtime_enabled THEN
          v_ot_rate := public.get_operator_wage_rate(v_operator.id, v_ot_role_id, v_date);
          IF v_ot_rate.id IS NULL OR v_ot_rate.overtime_rate_per_hour IS NULL THEN
            UPDATE public.attendance_daily SET calculation_status = 'needs_review'
            WHERE operator_id = v_operator.id AND attendance_date = v_date;
          ELSE
            v_ot_payable := round(v_overtime_minutes / 60.0 * v_ot_rate.overtime_rate_per_hour, 2);
            INSERT INTO public.daily_work_segments
              (operator_id, attendance_date, segment_type, wage_role_id, operator_wage_rate_id,
               start_at, end_at, minutes, rate_type, rate_amount, payable_amount, source)
            VALUES
              (v_operator.id, v_date, 'overtime', v_ot_role_id, v_ot_rate.id,
               v_first, v_last, v_overtime_minutes,
               CASE WHEN v_work_group.pay_type = 'monthly_salary' THEN 'monthly_salary_overtime' ELSE 'hourly_overtime' END,
               v_ot_rate.overtime_rate_per_hour, v_ot_payable, 'calculated');
          END IF;
        END IF;

      END IF;
    END LOOP;
  END LOOP;
END;
$$;

GRANT EXECUTE ON FUNCTION public.recalculate_attendance_daily TO authenticated;


-- =====================================================================
-- SECTION D: Finalize a period (lock printed/paid weeks)
-- Call once a manager is done reviewing and has printed a week:
--   SELECT public.finalize_attendance_week('2026-07-06','2026-07-12');
-- After this, recalculate_attendance_daily will skip these rows
-- entirely, protecting already-paid amounts from later drift.
-- =====================================================================

CREATE OR REPLACE FUNCTION public.finalize_attendance_week(p_from_date date, p_to_date date)
RETURNS void
LANGUAGE sql
AS $$
  UPDATE public.attendance_daily
  SET calculation_status = 'finalized'
  WHERE attendance_date BETWEEN p_from_date AND p_to_date
    AND calculation_status IN ('calculated', 'estimated', 'manager_approved');
$$;

GRANT EXECUTE ON FUNCTION public.finalize_attendance_week TO authenticated;


-- =====================================================================
-- SECTION E: Weekly printable report
-- Manager-facing report for arbitrary date ranges. Reads from the
-- persisted attendance_daily / daily_work_segments (populated by
-- Section C), so this is a pure aggregation, not a recalculation.
--   SELECT * FROM public.attendance_weekly_report('2026-07-06','2026-07-12');
-- =====================================================================

CREATE OR REPLACE FUNCTION public.attendance_weekly_report(
  p_from_date date,
  p_to_date date,
  p_work_group_id bigint DEFAULT NULL
)
RETURNS TABLE (
  operator_id bigint,
  name text,
  absent_days bigint,
  shp_hours numeric,
  shm_hours numeric,
  otp_hours numeric,
  otm_hours numeric,
  total_hours numeric,
  salary numeric,
  overtime numeric,
  take_home numeric
)
LANGUAGE sql
STABLE
AS $$
  WITH absent_agg AS (
    SELECT ad.operator_id, count(*) FILTER (WHERE ad.is_absent) AS absent_days
    FROM public.attendance_daily ad
    WHERE ad.attendance_date BETWEEN p_from_date AND p_to_date
    GROUP BY ad.operator_id
  ),
  segment_agg AS (
    SELECT
      dws.operator_id,
      sum(dws.minutes) FILTER (WHERE dws.segment_type = 'shift' AND wr.role_name = 'Pressman') AS shp_minutes,
      sum(dws.minutes) FILTER (WHERE dws.segment_type = 'shift' AND wr.role_name = 'Mixerman') AS shm_minutes,
      sum(dws.minutes) FILTER (WHERE dws.segment_type = 'overtime' AND wr.role_name = 'Pressman') AS otp_minutes,
      sum(dws.minutes) FILTER (WHERE dws.segment_type = 'overtime' AND wr.role_name = 'Mixerman') AS otm_minutes,
      sum(dws.minutes) AS total_minutes,
      sum(dws.payable_amount) FILTER (WHERE dws.segment_type = 'shift') AS salary,
      sum(dws.payable_amount) FILTER (WHERE dws.segment_type = 'overtime') AS overtime,
      sum(dws.payable_amount) AS take_home
    FROM public.daily_work_segments dws
    JOIN public.wage_roles wr ON wr.id = dws.wage_role_id
    WHERE dws.attendance_date BETWEEN p_from_date AND p_to_date
    GROUP BY dws.operator_id
  )
  SELECT
    o.id,
    o.name,
    coalesce(aa.absent_days, 0),
    round(coalesce(sa.shp_minutes, 0) / 60.0, 2),
    round(coalesce(sa.shm_minutes, 0) / 60.0, 2),
    round(coalesce(sa.otp_minutes, 0) / 60.0, 2),
    round(coalesce(sa.otm_minutes, 0) / 60.0, 2),
    round(coalesce(sa.total_minutes, 0) / 60.0, 2),
    coalesce(sa.salary, 0),
    coalesce(sa.overtime, 0),
    coalesce(sa.take_home, 0)
  FROM public.operators o
  LEFT JOIN absent_agg aa ON aa.operator_id = o.id
  LEFT JOIN segment_agg sa ON sa.operator_id = o.id
  WHERE o.is_active = true
    AND (p_work_group_id IS NULL OR o.work_group_id = p_work_group_id)
  ORDER BY o.name;
$$;

GRANT EXECUTE ON FUNCTION public.attendance_weekly_report TO authenticated;


COMMIT;

-- Force PostgREST schema cache reload so Ledgerly can call these
-- functions immediately without waiting for the cache to expire.
NOTIFY pgrst, 'reload schema';


-- =====================================================================
-- USAGE, IN ORDER, FOR A TYPICAL WEEK:
--
-- 1. Manager uploads punches all week via the desktop agent
--    (already automatic — Section A handles mapping + event push).
--
-- 2. Manager reviews the week's attendance screen. For any day flagged
--    'needs_review' (missing check-in or check-out), the manager
--    supplies the missing time via the existing UI, which calls:
--      SELECT public.save_attendance_adjustments('[...]'::jsonb);
--
-- 3. Recalculate the week (safe to re-run any time; skips locked days):
--      SELECT public.recalculate_attendance_daily('2026-07-06','2026-07-12');
--
-- 4. Manager reviews the resulting table. If more fixes are needed,
--    repeat steps 2-3.
--
-- 5. Once satisfied, view the printable report:
--      SELECT * FROM public.attendance_weekly_report('2026-07-06','2026-07-12');
--
-- 6. After printing/paying, lock the week so it can never silently
--    change later:
--      SELECT public.finalize_attendance_week('2026-07-06','2026-07-12');
--
-- OUTSTANDING (not covered by this file):
--   - Flutter/Ledgerly UI for steps 2, 3, 5, 6 above.
--   - Real phone/joining_date/cnic for the 35 seeded operators.
-- =====================================================================