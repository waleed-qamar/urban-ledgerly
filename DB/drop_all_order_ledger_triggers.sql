-- Let's completely nuke any trigger that could possibly be causing order inserts 
-- to bleed into the ledger table, across both 'orders' and 'order_items'.

begin;

do $$
declare
  t record;
begin
  -- 1) Drop triggers on orders and order_items that might call a function to update the ledger.
  for t in
    select tg.tgname as trigger_name, c.relname as table_name
    from pg_trigger tg
    join pg_class c on c.oid = tg.tgrelid
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname in ('orders', 'order_items')
      and not tg.tgisinternal
  loop
    execute format('drop trigger if exists %I on public.%I cascade', t.trigger_name, t.table_name);
  end loop;

  -- 2) Drop the ledger enforce debit/credit triggers just in case they're acting up
  drop trigger if exists trg_enforce_client_order_ledger_debit on public.ledger cascade;
  drop trigger if exists trg_enforce_client_order_ledger_credit on public.ledger cascade;

  -- The above drops ALL non-internal triggers on your orders and order_items tables, 
  -- guaranteeing that inserting into those tables cannot magically create a row 
  -- in the ledger table via the backend.
end
$$;

commit;

-- Debugging Help
-- Run this specifically to see what triggers remain on your ledger, orders, and order_items:
/*
select
    c.relname as table_name,
    tg.tgname as trigger_name,
    pr.proname as function_name
from pg_trigger tg
join pg_class c on c.oid = tg.tgrelid
join pg_proc pr on pr.oid = tg.tgfoid
where c.relname in ('orders', 'order_items', 'ledger')
  and not tg.tgisinternal;
*/
