-- ==============================================================================
-- ACCOUNT LEDGER MIGRATION SCRIPT FOR SUPABASE
-- Run this in your Supabase SQL Editor
-- ==============================================================================

-- 1. Ensure accounts.current_balance is NUMERIC(15, 2) instead of INTEGER
ALTER TABLE public.accounts 
  ALTER COLUMN current_balance TYPE numeric(15, 2) USING current_balance::numeric(15, 2),
  ALTER COLUMN current_balance SET DEFAULT 0.00;

-- 2. Add initial_balance column to accounts table
ALTER TABLE public.accounts 
  ADD COLUMN IF NOT EXISTS initial_balance numeric(15, 2) DEFAULT 0.00;

-- 3. Update account_transactions check constraint to support all reference types
--    (including 'withdrawal', 'initial_balance', and 'payroll')
ALTER TABLE public.account_transactions 
  DROP CONSTRAINT IF EXISTS account_transactions_reference_type_check;

ALTER TABLE public.account_transactions 
  ADD CONSTRAINT account_transactions_reference_type_check CHECK (
    reference_type = ANY (
      ARRAY[
        'receipt'::text,
        'disbursement'::text,
        'transfer'::text,
        'opening_balance'::text,
        'initial_balance'::text,
        'withdrawal'::text,
        'adjustment'::text,
        'expense'::text,
        'payroll'::text,
        'receipt_reversal'::text,
        'disbursement_reversal'::text,
        'expense_reversal'::text
      ]
    )
  );

-- 4. Create trigger function to automatically synchronize current_balance and initial_balance
CREATE OR REPLACE FUNCTION public.fn_sync_account_balance()
RETURNS TRIGGER AS $$
DECLARE
  v_account_id INT;
  v_calc_balance NUMERIC(15, 2);
  v_init_balance NUMERIC(15, 2);
BEGIN
  IF (TG_OP = 'DELETE') THEN
    v_account_id := OLD.account_id;
  ELSE
    v_account_id := NEW.account_id;
  END IF;

  -- 1) Calculate total current balance: credits - debits
  SELECT COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'credit' THEN amount 
      WHEN transaction_type = 'debit' THEN -amount 
      ELSE 0 
    END
  ), 0.00)
  INTO v_calc_balance
  FROM public.account_transactions
  WHERE account_id = v_account_id;

  -- 2) Calculate initial / opening balance from transactions
  SELECT COALESCE(SUM(amount), 0.00)
  INTO v_init_balance
  FROM public.account_transactions
  WHERE account_id = v_account_id 
    AND reference_type IN ('opening_balance', 'initial_balance');

  -- 3) Update the account row
  UPDATE public.accounts
  SET 
    current_balance = v_calc_balance,
    initial_balance = v_init_balance,
    updated_at = NOW()
  WHERE id = v_account_id;

  -- If this was an UPDATE that changed account_id, also recalculate the old account
  IF (TG_OP = 'UPDATE' AND OLD.account_id <> NEW.account_id) THEN
    SELECT COALESCE(SUM(
      CASE 
        WHEN transaction_type = 'credit' THEN amount 
        WHEN transaction_type = 'debit' THEN -amount 
        ELSE 0 
      END
    ), 0.00)
    INTO v_calc_balance
    FROM public.account_transactions
    WHERE account_id = OLD.account_id;

    SELECT COALESCE(SUM(amount), 0.00)
    INTO v_init_balance
    FROM public.account_transactions
    WHERE account_id = OLD.account_id 
      AND reference_type IN ('opening_balance', 'initial_balance');

    UPDATE public.accounts
    SET 
      current_balance = v_calc_balance,
      initial_balance = v_init_balance,
      updated_at = NOW()
    WHERE id = OLD.account_id;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 5. Attach the trigger to account_transactions
DROP TRIGGER IF EXISTS trg_sync_account_balance ON public.account_transactions;

CREATE TRIGGER trg_sync_account_balance
AFTER INSERT OR UPDATE OR DELETE ON public.account_transactions
FOR EACH ROW
EXECUTE FUNCTION public.fn_sync_account_balance();

-- 6. One-time backfill/synchronization for existing accounts & transactions
UPDATE public.accounts a
SET 
  current_balance = COALESCE((
    SELECT SUM(
      CASE 
        WHEN t.transaction_type = 'credit' THEN t.amount 
        WHEN t.transaction_type = 'debit' THEN -t.amount 
        ELSE 0 
      END
    )
    FROM public.account_transactions t
    WHERE t.account_id = a.id
  ), 0.00),
  initial_balance = COALESCE((
    SELECT SUM(t.amount)
    FROM public.account_transactions t
    WHERE t.account_id = a.id 
      AND t.reference_type IN ('opening_balance', 'initial_balance')
  ), 0.00);

