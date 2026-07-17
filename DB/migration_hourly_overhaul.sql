-- =====================================================================
-- Phase 1: Hourly Attendance Overhaul Migration
-- Ledgerly / Urban Constructions
-- Date: 2026-07-17
-- =====================================================================

-- 1. Create junction table for operator rates
CREATE TABLE IF NOT EXISTS public.operator_role_rates (
  operator_id bigint REFERENCES public.operators(id) ON DELETE CASCADE,
  wage_role_id bigint REFERENCES public.wage_roles(id) ON DELETE CASCADE,
  hourly_rate numeric(12,2) NOT NULL,
  PRIMARY KEY (operator_id, wage_role_id)
);

-- 2. Clean `operators` table
DROP TRIGGER IF EXISTS sync_operator_rate_history_trigger ON public.operators;
DROP FUNCTION IF EXISTS public.sync_operator_rate_history() CASCADE;

ALTER TABLE public.operators DROP COLUMN IF EXISTS daily_wage;
ALTER TABLE public.operators DROP COLUMN IF EXISTS overtime_rate_per_hour;

-- 3. Create helper view for easy Flutter fetching
CREATE OR REPLACE VIEW public.vw_operator_role_rates AS
SELECT 
  orr.operator_id,
  orr.wage_role_id,
  wr.role_name,
  orr.hourly_rate
FROM public.operator_role_rates orr
JOIN public.wage_roles wr ON wr.id = orr.wage_role_id;

-- 4. Drop the old function before redefining to avoid signature conflicts if any
DROP FUNCTION IF EXISTS public.recalculate_attendance_daily(date, date, bigint);

-- 5. New Recalculate Logic with Strict Intersection Math
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

  v_first          timestamptz;
  v_last           timestamptz;
  v_adj_in         timestamptz;
  v_adj_out        timestamptz;

  v_shift_start_ts timestamptz;
  v_shift_end_ts   timestamptz;
  v_normal_start   timestamptz;
  v_normal_end     timestamptz;

  v_punch_count    int;
  v_worked_minutes int;
  v_normal_minutes int;
  v_overtime_minutes int;
  v_is_absent      boolean;
  v_status         text;

  v_shift_role_id  bigint;
  v_ot_role_id     bigint;
  v_shift_rate     numeric(12,2);
  v_ot_rate        numeric(12,2);
  v_shift_pay      numeric(12,2);
  v_ot_pay         numeric(12,2);
BEGIN

  FOR v_operator IN
    SELECT * FROM public.operators
    WHERE is_active = true
      AND (p_operator_id IS NULL OR id = p_operator_id)
  LOOP

    SELECT * INTO v_work_group
    FROM public.work_groups
    WHERE id = v_operator.work_group_id;

    FOR v_date IN
      SELECT generate_series(p_from_date, p_to_date, interval '1 day')::date
    LOOP

      IF EXISTS (
        SELECT 1 FROM public.attendance_daily
        WHERE operator_id      = v_operator.id
          AND attendance_date  = v_date
          AND calculation_status IN ('manager_approved', 'finalized')
      ) THEN
        CONTINUE;
      END IF;

      SELECT count(*) INTO v_punch_count
      FROM public.attendance_events
      WHERE operator_id = v_operator.id
        AND (punched_at AT TIME ZONE 'Asia/Karachi')::date = v_date;

      SELECT dwa.shift_role_id, dwa.overtime_role_id
        INTO v_shift_role_id, v_ot_role_id
      FROM public.daily_work_assignments dwa
      WHERE dwa.operator_id     = v_operator.id
        AND dwa.attendance_date = v_date;

      v_shift_role_id := coalesce(v_shift_role_id, v_operator.default_wage_role_id);
      v_ot_role_id    := coalesce(v_ot_role_id,    v_operator.default_wage_role_id);

      INSERT INTO public.daily_work_assignments
        (operator_id, attendance_date, shift_role_id, overtime_role_id, source)
      VALUES
        (v_operator.id, v_date, v_shift_role_id, v_ot_role_id, 'default')
      ON CONFLICT (operator_id, attendance_date) DO NOTHING;

      SELECT min(punched_at), max(punched_at)
        INTO v_first, v_last
      FROM public.attendance_events
      WHERE operator_id = v_operator.id
        AND (punched_at AT TIME ZONE 'Asia/Karachi')::date = v_date;

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

      v_first := COALESCE(v_adj_in,  v_first);
      v_last  := COALESCE(v_adj_out, v_last);

      IF v_first IS NOT NULL AND v_last IS NOT NULL THEN
        v_is_absent := false;
        v_status := CASE WHEN v_punch_count = 1 THEN 'estimated' ELSE 'calculated' END;

        -- Shift window mapping (PKT timezone)
        v_shift_start_ts := (v_date + v_work_group.default_shift_start) AT TIME ZONE 'Asia/Karachi';
        v_shift_end_ts   := (v_date + v_work_group.default_shift_end) AT TIME ZONE 'Asia/Karachi';
        
        -- Handle overnight shifts
        IF v_shift_end_ts < v_shift_start_ts THEN
          v_shift_end_ts := v_shift_end_ts + interval '1 day';
        END IF;

        -- Intersection Math
        v_normal_start := GREATEST(v_first, v_shift_start_ts);
        v_normal_end   := LEAST(v_last, v_shift_end_ts);

        IF v_normal_end > v_normal_start THEN
          v_normal_minutes := EXTRACT(EPOCH FROM (v_normal_end - v_normal_start)) / 60;
        ELSE
          v_normal_minutes := 0;
        END IF;

        v_worked_minutes := EXTRACT(EPOCH FROM (v_last - v_first)) / 60;
        v_overtime_minutes := GREATEST(v_worked_minutes - v_normal_minutes, 0);

      ELSIF v_first IS NULL AND v_last IS NULL THEN
        v_is_absent        := true;
        v_status           := 'calculated';
        v_normal_minutes   := 0;
        v_overtime_minutes := 0;

      ELSE
        v_is_absent        := false;
        v_status           := 'needs_review';
        v_normal_minutes   := 0;
        v_overtime_minutes := 0;
      END IF;

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

      DELETE FROM public.daily_work_segments
      WHERE operator_id     = v_operator.id
        AND attendance_date = v_date
        AND source          = 'calculated';

      IF NOT v_is_absent AND v_status IN ('calculated', 'estimated') THEN

        -- --- Normal Shift Segment ---
        IF v_normal_minutes > 0 THEN
          IF v_work_group.pay_type = 'daily_wage' THEN
            -- Fetch Hourly Rate
            SELECT hourly_rate INTO v_shift_rate 
            FROM public.operator_role_rates 
            WHERE operator_id = v_operator.id AND wage_role_id = v_shift_role_id;

            IF v_shift_rate IS NULL THEN
              UPDATE public.attendance_daily SET calculation_status = 'needs_review'
              WHERE operator_id = v_operator.id AND attendance_date = v_date;
            ELSE
              v_shift_pay := ROUND((v_normal_minutes / 60.0) * v_shift_rate, 2);
              INSERT INTO public.daily_work_segments
                (operator_id, attendance_date, segment_type, wage_role_id, start_at, end_at, minutes, rate_type, rate_amount, payable_amount, source)
              VALUES
                (v_operator.id, v_date, 'shift', v_shift_role_id, v_normal_start, v_normal_end, v_normal_minutes, 'hourly', v_shift_rate, v_shift_pay, 'calculated');
            END IF;
          ELSIF v_work_group.pay_type = 'monthly_salary' THEN
            -- Salary logic: No daily segment amount calculated (it's fixed monthly)
            -- But we can still log the segment
            INSERT INTO public.daily_work_segments
              (operator_id, attendance_date, segment_type, wage_role_id, start_at, end_at, minutes, rate_type, rate_amount, payable_amount, source)
            VALUES
              (v_operator.id, v_date, 'shift', v_shift_role_id, v_normal_start, v_normal_end, v_normal_minutes, 'salary', 0, 0, 'calculated');
          END IF;
        END IF;

        -- --- Overtime Segment ---
        IF v_overtime_minutes > 0 AND v_operator.overtime_enabled AND v_work_group.overtime_enabled THEN
          
          -- Overtime for both daily_wage and monthly_salary is fetched from operator_role_rates
          SELECT hourly_rate INTO v_ot_rate 
          FROM public.operator_role_rates 
          WHERE operator_id = v_operator.id AND wage_role_id = v_ot_role_id;

          IF v_ot_rate IS NULL THEN
            UPDATE public.attendance_daily SET calculation_status = 'needs_review'
            WHERE operator_id = v_operator.id AND attendance_date = v_date;
          ELSE
            v_ot_pay := ROUND((v_overtime_minutes / 60.0) * v_ot_rate, 2);
            INSERT INTO public.daily_work_segments
              (operator_id, attendance_date, segment_type, wage_role_id, start_at, end_at, minutes, rate_type, rate_amount, payable_amount, source)
            VALUES
              (v_operator.id, v_date, 'overtime', v_ot_role_id, v_first, v_last, v_overtime_minutes, 'hourly_overtime', v_ot_rate, v_ot_pay, 'calculated');
          END IF;
        END IF;

      END IF;

    END LOOP;
  END LOOP;
END;
$$;

GRANT EXECUTE ON FUNCTION public.recalculate_attendance_daily(date, date, bigint) TO authenticated;
NOTIFY pgrst, 'reload schema';
