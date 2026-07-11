-- =====================================================================
-- Urban Constructions — Attendance & Payroll Schema
-- Run this once, top to bottom, in the Supabase SQL editor.
-- Assumes: only `public.operators` exists so far.
-- =====================================================================

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------
-- 1. work_groups
-- Office / Workshop / Workers — shift timing + pay type only.
-- ---------------------------------------------------------------------
create table if not exists public.work_groups (
  id bigserial primary key,
  name text not null unique,
  default_shift_start time not null,
  default_shift_end time not null,
  pay_type text not null check (pay_type in ('monthly_salary', 'daily_wage')),
  overtime_enabled boolean not null default true,
  created_at timestamptz not null default now()
);

insert into public.work_groups
  (name, default_shift_start, default_shift_end, pay_type, overtime_enabled)
values
  ('Office', '09:00', '17:00', 'monthly_salary', true),
  ('Workshop', '08:00', '16:00', 'daily_wage', true),
  ('Workers', '07:00', '15:00', 'daily_wage', true)
on conflict (name) do nothing;

-- ---------------------------------------------------------------------
-- 2. wage_roles
-- Pure catalog of role names. NO money here — money is per-operator.
-- ---------------------------------------------------------------------
create table if not exists public.wage_roles (
  id bigserial primary key,
  work_group_id bigint not null references public.work_groups(id) on delete restrict,
  role_name text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (work_group_id, role_name)
);

insert into public.wage_roles (work_group_id, role_name)
values
  ((select id from public.work_groups where name = 'Workers'), 'Pressman'),
  ((select id from public.work_groups where name = 'Workers'), 'Mixerman'),
  ((select id from public.work_groups where name = 'Workshop'), 'Senior'),
  ((select id from public.work_groups where name = 'Workshop'), 'Junior'),
  ((select id from public.work_groups where name = 'Office'), 'Office Staff')
on conflict (work_group_id, role_name) do nothing;

-- ---------------------------------------------------------------------
-- 3. operator_wage_rates
-- One (operator, role) can have MANY rows over time — full wage history.
-- "Current rate" = the row with the latest effective_from <= as-of date.
-- ---------------------------------------------------------------------
create table if not exists public.operator_wage_rates (
  id bigserial primary key,
  operator_id bigint not null references public.operators(id) on delete cascade,
  wage_role_id bigint not null references public.wage_roles(id) on delete restrict,
  daily_wage numeric(12,2),
  monthly_salary numeric(12,2),
  overtime_rate_per_hour numeric(12,2),
  effective_from date not null default current_date,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (operator_id, wage_role_id, effective_from)
);

create index if not exists idx_operator_wage_rates_lookup
on public.operator_wage_rates(operator_id, wage_role_id, effective_from desc);

-- Helper: the wage rate in effect for an operator+role on a given date.
-- Used by payroll calculation when building daily_work_segments.
create or replace function public.get_operator_wage_rate(
  p_operator_id bigint,
  p_wage_role_id bigint,
  p_as_of_date date default current_date
)
returns public.operator_wage_rates
language sql
stable
as $$
  select *
  from public.operator_wage_rates
  where operator_id = p_operator_id
    and wage_role_id = p_wage_role_id
    and is_active = true
    and effective_from <= p_as_of_date
  order by effective_from desc
  limit 1;
$$;

-- Example seed (replace operator_id / role ids with real ones):
-- insert into public.operator_wage_rates (operator_id, wage_role_id, daily_wage, overtime_rate_per_hour, effective_from)
-- values
--   (1, (select id from public.wage_roles where role_name = 'Pressman'), 1400, 175, '2026-01-01'),
--   (2, (select id from public.wage_roles where role_name = 'Pressman'), 1200, 150, '2026-01-01'),
--   (1, (select id from public.wage_roles where role_name = 'Mixerman'), 1300, 160, '2026-01-01');
--
-- A raise, e.g. W1's Pressman rate goes from 1400 to 1500 starting Aug 1, 2026,
-- is just a NEW row — never update/delete the old one:
-- insert into public.operator_wage_rates (operator_id, wage_role_id, daily_wage, overtime_rate_per_hour, effective_from)
-- values (1, (select id from public.wage_roles where role_name = 'Pressman'), 1500, 190, '2026-08-01');

-- ---------------------------------------------------------------------
-- 4. operators — additions to the existing table
-- ---------------------------------------------------------------------
alter table public.operators
add column if not exists work_group_id bigint references public.work_groups(id) on delete restrict;

alter table public.operators
add column if not exists default_wage_role_id bigint references public.wage_roles(id) on delete restrict;

alter table public.operators
add column if not exists overtime_enabled boolean not null default true;

-- ---------------------------------------------------------------------
-- 5. attendance_devices
-- ---------------------------------------------------------------------
create table if not exists public.attendance_devices (
  id bigserial primary key,
  device_code text not null unique,
  device_name text not null,
  site_name text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

-- Example:
-- insert into public.attendance_devices (device_code, device_name, site_name)
-- values ('mb20-01', 'Factory MB20', 'Main Factory')
-- returning id;

-- ---------------------------------------------------------------------
-- 6. attendance_agent_tokens
-- Hashed desktop app tokens. Raw token lives only in the desktop app.
-- ---------------------------------------------------------------------
create table if not exists public.attendance_agent_tokens (
  id bigserial primary key,
  attendance_device_id bigint not null references public.attendance_devices(id) on delete cascade,
  label text not null,
  token_hash text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  last_used_at timestamptz
);

-- Example:
-- insert into public.attendance_agent_tokens (attendance_device_id, label, token_hash)
-- values (1, 'Factory desktop attendance app',
--   encode(digest('factory-agent-change-this-secret-token', 'sha256'), 'hex'));

-- ---------------------------------------------------------------------
-- 7. operator_device_mappings
-- MB20 employee code -> operators.id
-- ---------------------------------------------------------------------
create table if not exists public.operator_device_mappings (
  id bigserial primary key,
  attendance_device_id bigint not null references public.attendance_devices(id) on delete cascade,
  device_employee_code text not null,
  operator_id bigint not null references public.operators(id) on delete restrict,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (attendance_device_id, device_employee_code)
);

-- ---------------------------------------------------------------------
-- 8. attendance_events
-- Raw biometric punches accepted from the desktop app. Facts, not truth-adjusted.
-- ---------------------------------------------------------------------
create table if not exists public.attendance_events (
  id bigserial primary key,
  attendance_device_id bigint not null references public.attendance_devices(id) on delete restrict,
  operator_id bigint not null references public.operators(id) on delete restrict,
  device_employee_code text not null,
  punched_at timestamptz not null,
  status integer,
  punch integer,
  source text not null default 'desktop_agent',
  first_seen_run_uuid uuid,
  created_at timestamptz not null default now(),
  unique (attendance_device_id, device_employee_code, punched_at)
);

create index if not exists idx_attendance_events_operator_time
on public.attendance_events(operator_id, punched_at);

create index if not exists idx_attendance_events_device_time
on public.attendance_events(attendance_device_id, punched_at);

-- ---------------------------------------------------------------------
-- 9. attendance_daily
-- Calculated daily attendance (effective in/out, normal/overtime minutes).
-- ---------------------------------------------------------------------
create table if not exists public.attendance_daily (
  id bigserial primary key,
  operator_id bigint not null references public.operators(id) on delete restrict,
  attendance_date date not null,
  work_group_id bigint references public.work_groups(id) on delete restrict,
  shift_start timestamptz,
  shift_end timestamptz,
  first_punch_at timestamptz,
  last_punch_at timestamptz,
  effective_in_at timestamptz,
  effective_out_at timestamptz,
  effective_in_source text,
  effective_out_source text,
  normal_minutes integer not null default 0,
  overtime_minutes integer not null default 0,
  absent_minutes integer not null default 0,
  is_absent boolean not null default false,
  calculation_status text not null default 'draft'
    check (calculation_status in ('draft', 'estimated', 'manager_approved', 'finalized', 'needs_review')),
  notes text,
  recalculated_at timestamptz not null default now(),
  unique (operator_id, attendance_date)
);

create index if not exists idx_attendance_daily_date
on public.attendance_daily(attendance_date);

-- ---------------------------------------------------------------------
-- 10. attendance_adjustments
-- Manager/system changes without creating fake biometric punches.
-- ---------------------------------------------------------------------
create table if not exists public.attendance_adjustments (
  id bigserial primary key,
  operator_id bigint not null references public.operators(id) on delete restrict,
  attendance_date date not null,
  adjustment_type text not null
    check (adjustment_type in ('manual_in_time', 'manual_out_time', 'estimated_out_time', 'absence_override', 'payroll_override')),
  adjusted_in_at timestamptz,
  adjusted_out_at timestamptz,
  reason text not null,
  source text not null default 'manager'
    check (source in ('manager', 'system_suggestion')),
  approved_by bigint references public.operators(id) on delete set null,
  created_at timestamptz not null default now(),
  unique (operator_id, attendance_date, adjustment_type)
);

-- ---------------------------------------------------------------------
-- 11. daily_work_assignments
-- The role used for shift + overtime on a specific day (handles role swaps).
-- ---------------------------------------------------------------------
create table if not exists public.daily_work_assignments (
  id bigserial primary key,
  operator_id bigint not null references public.operators(id) on delete restrict,
  attendance_date date not null,
  shift_role_id bigint references public.wage_roles(id) on delete restrict,
  overtime_role_id bigint references public.wage_roles(id) on delete restrict,
  source text not null default 'default'
    check (source in ('default', 'manager', 'system')),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (operator_id, attendance_date)
);

-- ---------------------------------------------------------------------
-- 12. daily_work_segments
-- Exact payable breakdown. rate_amount is resolved via
-- get_operator_wage_rate(operator_id, wage_role_id, attendance_date) at
-- calculation time, and operator_wage_rate_id snapshots exactly which
-- historical rate row was used (so a later raise never rewrites past pay).
-- ---------------------------------------------------------------------
create table if not exists public.daily_work_segments (
  id bigserial primary key,
  operator_id bigint not null references public.operators(id) on delete restrict,
  attendance_date date not null,
  segment_type text not null check (segment_type in ('shift', 'overtime')),
  wage_role_id bigint not null references public.wage_roles(id) on delete restrict,
  operator_wage_rate_id bigint references public.operator_wage_rates(id) on delete restrict,
  start_at timestamptz,
  end_at timestamptz,
  minutes integer not null default 0,
  rate_type text not null check (rate_type in ('daily_wage', 'hourly_overtime', 'monthly_salary_overtime')),
  rate_amount numeric(12,2) not null default 0,
  payable_amount numeric(12,2) not null default 0,
  source text not null default 'calculated'
    check (source in ('calculated', 'manager')),
  notes text,
  created_at timestamptz not null default now()
);

create index if not exists idx_daily_work_segments_operator_date
on public.daily_work_segments(operator_id, attendance_date);

-- ---------------------------------------------------------------------
-- 13. attendance_sync_runs
-- Upload history from the desktop app.
-- ---------------------------------------------------------------------
create table if not exists public.attendance_sync_runs (
  id bigserial primary key,
  run_uuid uuid not null unique,
  attendance_device_id bigint not null references public.attendance_devices(id) on delete restrict,
  records_received integer not null default 0,
  records_accepted integer not null default 0,
  records_duplicate integer not null default 0,
  records_rejected integer not null default 0,
  created_at timestamptz not null default now()
);

-- =====================================================================
-- Notes:
-- * A worker filling in for a different role (e.g. a Pressman covering as
--   Mixerman) is paid HIS OWN rate for that role, from his own
--   operator_wage_rates row — never the "role's" rate, since roles no
--   longer carry money at all.
-- * If daily_work_assignments assigns a role an operator has no
--   operator_wage_rates row for, get_operator_wage_rate() returns null.
--   Payroll calculation should catch that and set
--   attendance_daily.calculation_status = 'needs_review' rather than
--   guessing a rate.
-- =====================================================================