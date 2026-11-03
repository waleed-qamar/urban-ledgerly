-- ==============================================================================
-- RECEIPT & DISBURSEMENT DELETE & UPDATE FUNCTIONS WITH LEDGER CLEANUP
-- Run this in your Supabase SQL Editor
-- ==============================================================================

BEGIN;

-- 1. DELETE RECEIPT: Permanently deletes the receipt, its allocations,
--    its associated ledger credit entries, and its account transactions.
CREATE OR REPLACE FUNCTION public.delete_receipt(
    p_receipt_id BIGINT
) RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    -- 1. Delete all associated ledger entries for this receipt
    DELETE FROM ledger 
    WHERE party_type = 'client' 
      AND transaction_source IN (
          'receipt',
          'receipt_allocation',
          'receipt_advance',
          'receipt_allocation_reversal',
          'receipt_advance_reversal'
      )
      AND reference_id = p_receipt_id::TEXT;

    -- 2. Delete associated cash/bank account transaction
    DELETE FROM account_transactions 
    WHERE reference_type = 'receipt' 
      AND reference_id = p_receipt_id;

    -- 3. Delete invoice allocations for this receipt
    DELETE FROM receipt_allocations 
    WHERE receipt_id = p_receipt_id;

    -- 4. Delete the receipt record itself
    DELETE FROM receipts 
    WHERE id = p_receipt_id;
END;
$$;

-- 2. DELETE DISBURSEMENT: Permanently deletes the disbursement,
--    its associated vendor ledger debit entry, and its account transaction.
CREATE OR REPLACE FUNCTION public.delete_disbursement(
    p_disbursement_id BIGINT
) RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    -- 1. Delete associated vendor ledger entry
    DELETE FROM ledger 
    WHERE party_type = 'vendor' 
      AND transaction_source = 'disbursement'
      AND reference_id = p_disbursement_id::TEXT;

    -- 2. Delete associated cash/bank account transaction
    DELETE FROM account_transactions 
    WHERE reference_type = 'disbursement' 
      AND reference_id = p_disbursement_id;

    -- 3. Delete the disbursement record itself
    DELETE FROM disbursements 
    WHERE id = p_disbursement_id;
END;
$$;

-- 3. Ensure permissions exist in the RBAC permissions table
INSERT INTO permissions (module, action, description)
VALUES 
    ('receipts', 'create', 'Record new client cash/bank receipts'),
    ('receipts', 'read', 'View receipts list and details'),
    ('receipts', 'update', 'Edit existing receipts and update ledger'),
    ('receipts', 'delete', 'Delete receipts and associated ledger/account entries'),
    ('disbursements', 'create', 'Record new vendor disbursements'),
    ('disbursements', 'read', 'View vendor disbursements'),
    ('disbursements', 'update', 'Edit vendor disbursements and update ledger'),
    ('disbursements', 'delete', 'Delete disbursements and associated ledger/account entries')
ON CONFLICT (key) DO NOTHING;

-- 4. Grant full permissions to master role
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id 
FROM roles r, permissions p 
WHERE r.name = 'master' 
  AND p.module IN ('receipts', 'disbursements')
ON CONFLICT DO NOTHING;

-- 5. Grant update and delete permissions to accountant role if accountant role exists
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id 
FROM roles r, permissions p 
WHERE r.name = 'accountant' 
  AND p.module IN ('receipts', 'disbursements')
ON CONFLICT DO NOTHING;

COMMIT;

