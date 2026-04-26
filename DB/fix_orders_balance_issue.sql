-- Fix: PostgREST 42703 on orders insert due to stale DB objects
-- Error: column "balance" does not exist
--
-- Run this in Supabase SQL editor.

begin;

-- 1) Ensure current table shape (no legacy balance column expected)
alter table if exists public.orders
  drop column if exists balance;

-- 2) Drop any RLS policies on orders that still reference "balance"
do $$
declare
  p record;
begin
  for p in
    select policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = 'orders'
      and (
        coalesce(qual, '') ilike '%balance%'
        or coalesce(with_check, '') ilike '%balance%'
      )
  loop
    execute format('drop policy if exists %I on public.orders', p.policyname);
  end loop;
end
$$;

-- 3) Drop non-internal triggers on orders whose function body references "balance"
do $$
declare
  t record;
begin
  for t in
    select tg.tgname as trigger_name
    from pg_trigger tg
    join pg_class c on c.oid = tg.tgrelid
    join pg_namespace n on n.oid = c.relnamespace
    join pg_proc pr on pr.oid = tg.tgfoid
    where n.nspname = 'public'
      and c.relname = 'orders'
      and not tg.tgisinternal
      and pg_get_functiondef(pr.oid) ilike '%balance%'
  loop
    execute format('drop trigger if exists %I on public.orders', t.trigger_name);
  end loop;
end
$$;

-- 4) Keep a strict, current schema for orders and order_items
create table if not exists public.orders (
  id bigint generated always as identity primary key,
  client_id bigint not null,
  status text default 'pending',
  created_at timestamp with time zone default now()
);

create table if not exists public.order_items (
  id bigint generated always as identity primary key,
  order_id bigint references public.orders(id) on delete cascade,
  product_id bigint references public.products(id),
  quantity double precision not null,
  price double precision not null
);

commit;
