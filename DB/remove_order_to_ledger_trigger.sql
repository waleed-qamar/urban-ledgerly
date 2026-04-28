-- This script removes any trigger on the `orders` table that automatically
-- inserts a new entry into the `ledger` table upon order creation.
-- The new logic handles ledger insertion only upon invoice generation and payment.

begin;

do $$
declare
  t record;
begin
  -- Find any non-internal triggers on "orders" that reference "ledger" in their function body
  for t in
    select tg.tgname as trigger_name
    from pg_trigger tg
    join pg_class c on c.oid = tg.tgrelid
    join pg_namespace n on n.oid = c.relnamespace
    join pg_proc pr on pr.oid = tg.tgfoid
    where n.nspname = 'public'
      and c.relname = 'orders'
      and not tg.tgisinternal
      and pg_get_functiondef(pr.oid) ilike '%ledger%'
  loop
    execute format('drop trigger if exists %I on public.orders cascade', t.trigger_name);
  end loop;

  -- Additionally, we can drop the trigger we added earlier to force debit on client orders
  -- because we will no longer have ledger entries created from 'order' source.
  drop trigger if exists trg_enforce_client_order_ledger_debit on public.ledger;
  drop function if exists public.enforce_client_order_ledger_debit() cascade;

end
$$;

commit;
