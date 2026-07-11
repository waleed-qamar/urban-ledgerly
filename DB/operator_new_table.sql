create table public.operators (
  id bigserial not null,
  name text not null,
  phone text not null,
  cnic text null,
  joining_date date not null,
  is_active boolean not null default true,
  created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  updated_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  work_group_id bigint null,
  default_wage_role_id bigint null,
  overtime_enabled boolean not null default true,
  constraint operators_pkey primary key (id),
  constraint operators_cnic_key unique (cnic),
  constraint operators_default_wage_role_id_fkey foreign KEY (default_wage_role_id) references wage_roles (id) on delete RESTRICT,
  constraint operators_work_group_id_fkey foreign KEY (work_group_id) references work_groups (id) on delete RESTRICT
) TABLESPACE pg_default;