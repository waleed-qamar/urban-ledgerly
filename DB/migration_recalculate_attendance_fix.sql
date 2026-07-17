-- =====================================================================
-- Fixed: recalculate_attendance_daily
-- Urban Constructions / Ledgerly — 2026-07-17
--
-- Replaces the version in attendance_functions.sql (Section C) and
-- recalculate_attendance_daily_fix.sql.
--
-- BUGS FIXED vs previous version:
--
--   BUG 1 — Timezone mismatch (date bucketing)
--     Old:  punched_at::date
--           Uses the PostgreSQL session timezone (UTC in Supabase).
--           A punch at 07:00 PKT on March 15 is stored as 02:00 UTC,
--           so ::date returns March 14 in a UTC session — wrong day.
--     Fix:  (punched_at AT TIME ZONE 'Asia/Karachi')::date
--           Forces PKT bucketing regardless of session timezone.
--
--   BUG 2 — NULL-clobber in adjustment variable reuse
--     Old:  SELECT adjusted_in_at INTO v_first FROM attendance_adjustments ...
--           When no row matches, PostgreSQL sets v_first = NULL,
--           losing the raw punch value already in v_first.
--           The subsequent COALESCE then re-fetches from attendance_events,
--           but the double-query is fragile and the initial fetch is wasted.
--     Fix:  Use separate v_adj_in / v_adj_out variables.
--           Fetch punch extremes into v_first / v_last first.
--           Then COALESCE(adjustment, punch) with the separate variables.
--           This is a single clear read per field, no re-fetch needed.
--
-- UNCHANGED behaviour:
--   - Skips days already 'manager_approved' or 'finalized'
--   - Shift duration from work_groups (confirmed: role → work_group)
--   - Rate lookup via get_operator_wage_rate() (now always finds a row
--     after migration_operator_rate_fields.sql seeds operator_wage_rates)
--   - daily_work_assignments: keeps manager overrides, creates defaults
--   - daily_work_segments: cleared and rewritten on each recalc run
--   - OT enabled: respects both operator.overtime_enabled AND
--     work_group.overtime_enabled (both must be true)
-- =====================================================================

CREATE OR REPLACE FUNCTION public.recalculate_attendance_daily(
  p_from_date  date,
  p_to_date    date,
  p_operator_id bigint default null
)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_operator       record;
  v_work_group     record;
  v_date           date;

  -- Raw punch extremes for the day
  v_first          timestamptz;
  v_last           timestamptz;

  -- Separate variables for adjustments — avoids NULL-clobber (Bug 2 fix)
  v_adj_in         timestamptz;
  v_adj_out        timestamptz;

  v_punch_count    int;
  v_shift_minutes  int;
  v_worked_minutes int;
  v_normal_minutes int;
  v_overtime_minutes int;
  v_is_absent      boolean;
  v_status         text;

  v_shift_role_id  bigint;
  v_ot_role_id     bigint;
  v_shift_rate     public.operator_wage_rates;
  v_ot_rate        public.operator_wage_rates;
  v_ot_payable     numeric(12,2);
BEGIN

  FOR v_operator IN
    SELECT * FROM public.operators
    WHERE is_active = true
      AND (p_operator_id IS NULL OR id = p_operator_id)
  LOOP

    -- Fetch the work_group once per operator (shift times + pay_type live here)
    SELECT * INTO v_work_group
    FROM public.work_groups
    WHERE id = v_operator.work_group_id;

    FOR v_date IN
      SELECT generate_series(p_from_date, p_to_date, interval '1 day')::date
    LOOP

      -- ---------------------------------------------------------------
      -- Lock check: never touch manager-approved or finalized days
      -- ---------------------------------------------------------------
      IF EXISTS (
        SELECT 1 FROM public.attendance_daily
        WHERE operator_id      = v_operator.id
          AND attendance_date  = v_date
          AND calculation_status IN ('manager_approved', 'finalized')
      ) THEN
        CONTINUE;
      END IF;

      -- ---------------------------------------------------------------
      -- Punch count for the day — uses PKT date bucket (Bug 1 fix)
      -- ---------------------------------------------------------------
      SELECT count(*) INTO v_punch_count
      FROM public.attendance_events
      WHERE operator_id = v_operator.id
        AND (punched_at AT TIME ZONE 'Asia/Karachi')::date = v_date;

      -- ---------------------------------------------------------------
      -- Role resolution: manager's daily_work_assignments win;
      -- fall back to the operator's default_wage_role_id
      -- ---------------------------------------------------------------
      SELECT dwa.shift_role_id, dwa.overtime_role_id
        INTO v_shift_role_id, v_ot_role_id
      FROM public.daily_work_assignments dwa
      WHERE dwa.operator_id     = v_operator.id
        AND dwa.attendance_date = v_date;

      v_shift_role_id := coalesce(v_shift_role_id, v_operator.default_wage_role_id);
      v_ot_role_id    := coalesce(v_ot_role_id,    v_operator.default_wage_role_id);

      -- Create a default assignment row if the manager hasn't set one
      INSERT INTO public.daily_work_assignments
        (operator_id, attendance_date, shift_role_id, overtime_role_id, source)
      VALUES
        (v_operator.id, v_date, v_shift_role_id, v_ot_role_id, 'default')
      ON CONFLICT (operator_id, attendance_date) DO NOTHING;

      -- ---------------------------------------------------------------
      -- Step 1: Raw punch extremes — PKT date bucket (Bug 1 fix)
      -- ---------------------------------------------------------------
      SELECT min(punched_at), max(punched_at)
        INTO v_first, v_last
      FROM public.attendance_events
      WHERE operator_id = v_operator.id
        AND (punched_at AT TIME ZONE 'Asia/Karachi')::date = v_date;

      -- ---------------------------------------------------------------
      -- Step 2: Apply manual adjustments (Bug 2 fix — separate vars)
      -- Adjustment wins over raw punch; raw punch is fallback.
      -- ---------------------------------------------------------------
      v_adj_in  := NULL;
      v_adj_out := NULL;

      SELECT adjusted_in_at INTO v_adj_in
      FROM public.attendance_adjustments
      WHERE operator_id      = v_operator.id
        AND attendance_date  = v_date
        AND adjustment_type  = 'manual_in_time';

      SELECT adjusted_out_at INTO v_adj_out
      FROM public.attendance_adjustments
      WHERE operator_id      = v_operator.id
        AND attendance_date  = v_date
        AND adjustment_type  = 'manual_out_time';

      -- If an adjustment exists, it overrides the raw punch for that side.
      -- If no adjustment, keep the raw punch value (v_first / v_last unchanged).
      v_first := COALESCE(v_adj_in,  v_first);
      v_last  := COALESCE(v_adj_out, v_last);

      -- ---------------------------------------------------------------
      -- Step 3: Classify the day
      -- ---------------------------------------------------------------
      IF v_first IS NOT NULL AND v_last IS NOT NULL THEN

        v_is_absent := false;

        -- If we only have one biometric punch and filled the other side
        -- via an adjustment, flag as 'estimated' (not yet fully confirmed)
        v_status := CASE WHEN v_punch_count = 1 THEN 'estimated' ELSE 'calculated' END;

        v_worked_minutes := extract(epoch FROM (v_last - v_first)) / 60;

        -- Shift duration from work_group (role → work_group mapping)
        v_shift_minutes := extract(epoch FROM (
          v_work_group.default_shift_end - v_work_group.default_shift_start
        )) / 60;

        -- Guard against overnight shifts (negative interval after subtraction)
        IF v_shift_minutes < 0 THEN
          v_shift_minutes := v_shift_minutes + 1440;
        END IF;

        v_normal_minutes   := LEAST(v_worked_minutes, v_shift_minutes);
        v_overtime_minutes := GREATEST(v_worked_minutes - v_shift_minutes, 0);

      ELSIF v_first IS NULL AND v_last IS NULL THEN

        -- Zero punches + no adjustment = truly absent
        v_is_absent        := true;
        v_status           := 'calculated';
        v_normal_minutes   := 0;
        v_overtime_minutes := 0;

      ELSE

        -- Only one side of the punch pair — needs manager intervention
        v_is_absent        := false;
        v_status           := 'needs_review';
        v_normal_minutes   := 0;
        v_overtime_minutes := 0;

      END IF;

      -- ---------------------------------------------------------------
      -- Step 4: Persist daily summary
      -- ---------------------------------------------------------------
      INSERT INTO public.attendance_daily
        (operator_id, attendance_date, work_group_id,
         first_punch_at, last_punch_at,
         effective_in_at, effective_out_at,
         normal_minutes, overtime_minutes,
         is_absent, calculation_status, recalculated_at)
      VALUES
        (v_operator.id, v_date, v_operator.work_group_id,
         v_first, v_last,
         v_first, v_last,
         v_normal_minutes, v_overtime_minutes,
         v_is_absent, v_status, now())
      ON CONFLICT (operator_id, attendance_date) DO UPDATE SET
        work_group_id       = excluded.work_group_id,
        first_punch_at      = excluded.first_punch_at,
        last_punch_at       = excluded.last_punch_at,
        effective_in_at     = excluded.effective_in_at,
        effective_out_at    = excluded.effective_out_at,
        normal_minutes      = excluded.normal_minutes,
        overtime_minutes    = excluded.overtime_minutes,
        is_absent           = excluded.is_absent,
        calculation_status  = excluded.calculation_status,
        recalculated_at     = now();

      -- ---------------------------------------------------------------
      -- Step 5: Rebuild pay segments (clear auto-calculated only)
      -- ---------------------------------------------------------------
      DELETE FROM public.daily_work_segments
      WHERE operator_id     = v_operator.id
        AND attendance_date = v_date
        AND source          = 'calculated';

      -- Only compute pay segments if the day has usable time data
      IF NOT v_is_absent AND v_status IN ('calculated', 'estimated') THEN

        -- --- Shift segment (daily_wage operators) ---
        IF v_work_group.pay_type = 'daily_wage' AND v_normal_minutes > 0 THEN

          v_shift_rate := public.get_operator_wage_rate(
            v_operator.id, v_shift_role_id, v_date
          );

          IF v_shift_rate.id IS NULL OR v_shift_rate.daily_wage IS NULL THEN
            -- Rate missing from operator_wage_rates — flag for manager
            UPDATE public.attendance_daily
            SET calculation_status = 'needs_review'
            WHERE operator_id = v_operator.id AND attendance_date = v_date;
          ELSE
            INSERT INTO public.daily_work_segments
              (operator_id, attendance_date, segment_type, wage_role_id,
               operator_wage_rate_id, start_at, end_at, minutes,
               rate_type, rate_amount, payable_amount, source)
            VALUES
              (v_operator.id, v_date, 'shift', v_shift_role_id,
               v_shift_rate.id, v_first, v_last, v_normal_minutes,
               'daily_wage',
               v_shift_rate.daily_wage,
               v_shift_rate.daily_wage,   -- full day = one daily_wage unit
               'calculated');
          END IF;

        END IF;

        -- --- Overtime segment (both daily_wage and monthly_salary) ---
        -- Requires both operator.overtime_enabled AND work_group.overtime_enabled
        IF v_overtime_minutes > 0
           AND v_operator.overtime_enabled
           AND v_work_group.overtime_enabled
        THEN

          v_ot_rate := public.get_operator_wage_rate(
            v_operator.id, v_ot_role_id, v_date
          );

          IF v_ot_rate.id IS NULL OR v_ot_rate.overtime_rate_per_hour IS NULL THEN
            UPDATE public.attendance_daily
            SET calculation_status = 'needs_review'
            WHERE operator_id = v_operator.id AND attendance_date = v_date;
          ELSE
            v_ot_payable := round(
              v_overtime_minutes / 60.0 * v_ot_rate.overtime_rate_per_hour,
              2
            );
            INSERT INTO public.daily_work_segments
              (operator_id, attendance_date, segment_type, wage_role_id,
               operator_wage_rate_id, start_at, end_at, minutes,
               rate_type, rate_amount, payable_amount, source)
            VALUES
              (v_operator.id, v_date, 'overtime', v_ot_role_id,
               v_ot_rate.id, v_first, v_last, v_overtime_minutes,
               CASE
                 WHEN v_work_group.pay_type = 'monthly_salary'
                 THEN 'monthly_salary_overtime'
                 ELSE 'hourly_overtime'
               END,
               v_ot_rate.overtime_rate_per_hour,
               v_ot_payable,
               'calculated');
          END IF;

        END IF;

      END IF; -- end pay segment block

    END LOOP; -- end date loop
  END LOOP;   -- end operator loop

END;
$$;

GRANT EXECUTE ON FUNCTION public.recalculate_attendance_daily TO authenticated;

-- Force PostgREST to pick up the updated function signature immediately
NOTIFY pgrst, 'reload schema';

-- =====================================================================
-- USAGE (unchanged from before):
--
-- Recalculate a specific week:
--   SELECT public.recalculate_attendance_daily('2026-03-01', '2026-03-31');
--
-- Recalculate for one operator only:
--   SELECT public.recalculate_attendance_daily('2026-03-01', '2026-03-31', 7);
--
-- Lock a finalized period so it can never be touched again:
--   SELECT public.finalize_attendance_week('2026-03-01', '2026-03-31');
--
-- IMPORTANT — do NOT call recalculate on every page load in Flutter.
-- Call it only on explicit manager action (button press / refresh).
-- The Flutter UI should READ from attendance_daily / daily_work_segments
-- directly; those tables are the persistent, stable source of truth.
-- =====================================================================
