-- =====================================================================
-- Urban Constructions — Attendance Review Additions
-- RPCs and Views for manager-facing Attendance Review screen
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. attendance_review_rows (Read side)
-- Fetches the flattened rows for the UI table for a specific operator & date range.
-- ---------------------------------------------------------------------
create or replace function public.attendance_review_rows(
  p_operator_id bigint,
  p_from_date date,
  p_to_date date
)
returns table (
  operator_id bigint,
  attendance_date date,
  in_at timestamptz,
  out_at timestamptz,
  shift_role_id bigint,
  shift_role_name text,
  ot_role_id bigint,
  ot_role_name text,
  shift_minutes integer,
  ot_minutes integer,
  is_absent boolean,
  salary_amount numeric(12,2),
  overtime_amount numeric(12,2),
  take_home_amount numeric(12,2),
  calculation_status text,
  existing_adjustment_reason text
)
language plpgsql
stable
as $$
begin
  return query
  select
    ad.operator_id,
    ad.attendance_date,
    ad.effective_in_at as in_at,
    ad.effective_out_at as out_at,
    dwa.shift_role_id,
    wr_shift.role_name as shift_role_name,
    dwa.overtime_role_id as ot_role_id,
    wr_ot.role_name as ot_role_name,
    coalesce(ad.normal_minutes, 0) as shift_minutes,
    coalesce(ad.overtime_minutes, 0) as ot_minutes,
    ad.is_absent,
    -- salary amount (from shift segment)
    coalesce((select sum(payable_amount) from public.daily_work_segments dws
              where dws.operator_id = ad.operator_id
                and dws.attendance_date = ad.attendance_date
                and dws.segment_type = 'shift'), 0) as salary_amount,
    -- overtime amount (from overtime segment)
    coalesce((select sum(payable_amount) from public.daily_work_segments dws
              where dws.operator_id = ad.operator_id
                and dws.attendance_date = ad.attendance_date
                and dws.segment_type = 'overtime'), 0) as overtime_amount,
    -- take home amount (total)
    coalesce((select sum(payable_amount) from public.daily_work_segments dws
              where dws.operator_id = ad.operator_id
                and dws.attendance_date = ad.attendance_date), 0) as take_home_amount,
    ad.calculation_status,
    -- latest manual adjustment reason
    (select reason from public.attendance_adjustments adj
     where adj.operator_id = ad.operator_id
       and adj.attendance_date = ad.attendance_date
     order by created_at desc limit 1) as existing_adjustment_reason
  from public.attendance_daily ad
  left join public.daily_work_assignments dwa
    on dwa.operator_id = ad.operator_id and dwa.attendance_date = ad.attendance_date
  left join public.wage_roles wr_shift on wr_shift.id = dwa.shift_role_id
  left join public.wage_roles wr_ot on wr_ot.id = dwa.overtime_role_id
  where ad.operator_id = p_operator_id
    and ad.attendance_date >= p_from_date
    and ad.attendance_date <= p_to_date
  order by ad.attendance_date asc;
end;
$$;

-- Grant execution to authenticated users
GRANT EXECUTE ON FUNCTION public.attendance_review_rows TO authenticated;

-- ---------------------------------------------------------------------
-- 2. save_attendance_adjustments (Write side)
-- Transactional save of multiple drafts for one operator
-- Expects a JSONB array of objects matching the AttendanceAdjustmentDraft structure.
-- ---------------------------------------------------------------------
create or replace function public.save_attendance_adjustments(
  p_payload jsonb
)
returns void
language plpgsql
as $$
declare
  draft jsonb;
  v_operator_id bigint;
  v_date date;
  v_adjusted_out_at timestamptz;
  v_adjusted_ot_minutes integer;
  v_shift_role_id bigint;
  v_ot_role_id bigint;
  v_reason text;
begin
  for draft in select * from jsonb_array_elements(p_payload)
  loop
    v_operator_id := (draft->>'operatorId')::bigint;
    v_date := (draft->>'date')::date;
    v_reason := draft->>'reason';

    if v_reason is null or trim(v_reason) = '' then
      raise exception 'Reason cannot be empty for adjustment on %', v_date;
    end if;

    -- Optional fields
    v_adjusted_out_at := (draft->>'adjustedOutAt')::timestamptz;
    v_adjusted_ot_minutes := (draft->>'adjustedOtMinutes')::integer;
    v_shift_role_id := (draft->>'shiftRoleId')::bigint;
    v_ot_role_id := (draft->>'otRoleId')::bigint;

    -- 1. Insert/Update into attendance_adjustments (for out time override)
    if v_adjusted_out_at is not null then
      insert into public.attendance_adjustments
        (operator_id, attendance_date, adjustment_type, adjusted_out_at, reason, source)
      values
        (v_operator_id, v_date, 'manual_out_time', v_adjusted_out_at, v_reason, 'manager')
      on conflict (operator_id, attendance_date, adjustment_type)
      do update set
        adjusted_out_at = excluded.adjusted_out_at,
        reason = excluded.reason,
        source = 'manager';
    end if;

    -- Update attendance_daily directly for OT minutes override (for simplicity in this mock,
    -- normally an adjustment record might trigger a recalculation process).
    if v_adjusted_ot_minutes is not null then
      update public.attendance_daily
      set overtime_minutes = v_adjusted_ot_minutes,
          calculation_status = 'manager_approved' -- Or keep it 'draft' if a separate recalc is needed
      where operator_id = v_operator_id
        and attendance_date = v_date;
    end if;

    -- 2. Upsert daily_work_assignments
    if v_shift_role_id is not null or v_ot_role_id is not null then
      insert into public.daily_work_assignments
        (operator_id, attendance_date, shift_role_id, overtime_role_id, source, notes)
      values
        (v_operator_id, v_date, v_shift_role_id, v_ot_role_id, 'manager', v_reason)
      on conflict (operator_id, attendance_date)
      do update set
        shift_role_id = coalesce(excluded.shift_role_id, public.daily_work_assignments.shift_role_id),
        overtime_role_id = coalesce(excluded.overtime_role_id, public.daily_work_assignments.overtime_role_id),
        source = 'manager',
        notes = excluded.notes,
        updated_at = now();
    end if;

    -- NOTE: In a complete system, we would also need to recalculate `daily_work_segments` 
    -- based on these new assignments and overtime minutes, which is assumed to be handled 
    -- by a database trigger or another routine after changes to attendance_daily/daily_work_assignments.
  end loop;
end;
$$;

-- Grant execution to authenticated users
GRANT EXECUTE ON FUNCTION public.save_attendance_adjustments TO authenticated;

-- Force PostgREST schema cache reload
NOTIFY pgrst, 'reload schema';
