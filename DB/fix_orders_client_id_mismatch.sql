-- Fix: orders client/customer column mismatch
-- Symptoms:
--   - PostgREST 42703: column "customer_id" does not exist
--   - SQL errors mentioning "o.customer_id does not exist"
--
-- Run in Supabase SQL editor.

begin;

-- 1) Ensure orders uses client_id (rename legacy customer_id if needed)
do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'orders'
      and column_name = 'customer_id'
  ) and not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'orders'
      and column_name = 'client_id'
  ) then
    alter table public.orders rename column customer_id to client_id;
  end if;
end
$$;

-- 2) Rewrite public functions that still reference customer_id.
do $$
declare
  fn record;
  fn_sql text;
begin
  for fn in
    select p.oid
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.prokind in ('f', 'p')
  loop
    begin
      fn_sql := pg_get_functiondef(fn.oid);
      if fn_sql ilike '%customer_id%' then
        fn_sql := replace(fn_sql, 'customer_id', 'client_id');
        execute fn_sql;
      end if;
    exception
      when others then
        -- Skip unsupported routine kinds or extension-managed routines.
        continue;
    end;
  end loop;
end
$$;

-- 3) Rewrite public views that still reference customer_id.
do $$
declare
  v record;
  v_sql text;
begin
  for v in
    select schemaname, viewname, definition
    from pg_views
    where schemaname = 'public'
      and definition ilike '%customer_id%'
  loop
    v_sql := format(
      'create or replace view %I.%I as %s',
      v.schemaname,
      v.viewname,
      replace(v.definition, 'customer_id', 'client_id')
    );
    execute v_sql;
  end loop;
end
$$;

commit;
    
-- Verify remaining references:
-- select n.nspname as schema_name, p.proname as function_name
-- from pg_proc p
-- join pg_namespace n on n.oid = p.pronamespace
-- where n.nspname = 'public'
--   and p.prokind in ('f', 'p')
--   and pg_get_functiondef(p.oid) ilike '%customer_id%';
--
-- select schemaname, viewname
-- from pg_views
-- where schemaname = 'public'
--   and definition ilike '%customer_id%';
