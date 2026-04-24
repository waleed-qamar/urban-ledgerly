-- Align ledger semantics with accounting rule:
-- Client:
--   - Order creation => DEBIT (client owes more)
--   - Client payment => CREDIT (client owes less)
-- Vendor:
--   - CREDIT increases what we owe vendor
--   - DEBIT decreases what we owe vendor
--
-- Run in Supabase SQL editor.

begin;

-- 1) Backfill: order-generated client entries should be debit.
update public.ledger
set entry_type = 'debit'
where party_type = 'client'
  and coalesce(transaction_source, '') = 'order'
  and entry_type = 'credit';

-- 2) Replace any previous trigger that forced credit for client orders.
drop trigger if exists trg_enforce_client_order_ledger_credit on public.ledger;
drop function if exists public.enforce_client_order_ledger_credit();

-- 3) Enforce future client order rows as debit.
create or replace function public.enforce_client_order_ledger_debit()
returns trigger
language plpgsql
as $$
begin
  if new.party_type = 'client'
     and coalesce(new.transaction_source, '') = 'order'
  then
    new.entry_type := 'debit';
  end if;

  return new;
end;
$$;

drop trigger if exists trg_enforce_client_order_ledger_debit on public.ledger;

create trigger trg_enforce_client_order_ledger_debit
before insert or update on public.ledger
for each row
execute function public.enforce_client_order_ledger_debit();

commit;

-- Verify:
-- select id, party_type, entry_type, amount, transaction_source, reference_id, created_at
-- from public.ledger
-- where party_type in ('client', 'vendor')
-- order by created_at desc;
