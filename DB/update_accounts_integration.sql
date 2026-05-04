-- Drop old functions if necessary, but CREATE OR REPLACE should handle it if parameter signature is the same.
-- Since we are changing parameters, we might need to DROP the old ones first.
DROP FUNCTION IF EXISTS create_receipt(BIGINT, NUMERIC, TEXT, TEXT, TEXT, TIMESTAMP, JSONB);
DROP FUNCTION IF EXISTS create_disbursement(BIGINT, NUMERIC, TEXT, TEXT, TEXT, TEXT, TIMESTAMP);

-- Recreate create_receipt with p_account_id
CREATE OR REPLACE FUNCTION create_receipt(
    p_client_id BIGINT,
    p_total_amount NUMERIC,
    p_payment_method TEXT,
    p_account_no TEXT DEFAULT NULL,
    p_remarks TEXT DEFAULT NULL,
    p_received_date TIMESTAMP DEFAULT NOW(),
    p_allocations JSONB DEFAULT '[]'::JSONB,
    p_account_id INT DEFAULT NULL
) RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    v_receipt_id BIGINT;
    v_receipt_number TEXT;
    v_allocation JSONB;
    v_invoice_id BIGINT;
    v_amount NUMERIC(12,2);
    v_invoice_client_id BIGINT;
    v_invoice_grand_total NUMERIC(12,2);
    v_paid_amount NUMERIC(12,2);
    v_allocated_total NUMERIC(12,2);
BEGIN
    IF p_total_amount <= 0 THEN
        RAISE EXCEPTION 'Receipt total_amount must be greater than zero';
    END IF;

    SELECT COALESCE(SUM((allocation ->> 'amount')::NUMERIC(12,2)), 0)
    INTO v_allocated_total
    FROM jsonb_array_elements(COALESCE(p_allocations, '[]'::JSONB)) AS allocation;

    IF v_allocated_total > p_total_amount THEN
        RAISE EXCEPTION 'Allocation total cannot exceed receipt total amount';
    END IF;

    INSERT INTO receipts (
        client_id,
        receipt_number,
        total_amount,
        payment_method,
        account_no,
        remarks,
        received_date
    ) VALUES (
        p_client_id,
        NULL,
        p_total_amount,
        p_payment_method,
        p_account_no,
        p_remarks,
        p_received_date
    ) RETURNING id INTO v_receipt_id;

    v_receipt_number := 'RCPT-' || LPAD(v_receipt_id::TEXT, 8, '0');

    UPDATE receipts
    SET receipt_number = v_receipt_number
    WHERE id = v_receipt_id;

    FOR v_allocation IN SELECT * FROM jsonb_array_elements(COALESCE(p_allocations, '[]'::JSONB)) LOOP
        v_invoice_id := (v_allocation ->> 'invoice_id')::BIGINT;
        v_amount := (v_allocation ->> 'amount')::NUMERIC(12,2);

        IF v_amount <= 0 THEN
            RAISE EXCEPTION 'Allocation amount must be greater than zero';
        END IF;

        SELECT
            i.client_id,
            i.grand_total,
            COALESCE(SUM(ra.amount), 0)::NUMERIC(12,2)
        INTO
            v_invoice_client_id,
            v_invoice_grand_total,
            v_paid_amount
        FROM invoices i
        LEFT JOIN receipt_allocations ra ON ra.invoice_id = i.id
        WHERE i.id = v_invoice_id
        GROUP BY i.client_id, i.grand_total;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Invoice % not found', v_invoice_id;
        END IF;

        IF v_invoice_client_id <> p_client_id THEN
            RAISE EXCEPTION 'Invoice % does not belong to client %', v_invoice_id, p_client_id;
        END IF;

        IF v_amount > GREATEST(v_invoice_grand_total - v_paid_amount, 0) THEN
            RAISE EXCEPTION 'Allocation amount exceeds remaining invoice balance for invoice %', v_invoice_id;
        END IF;

        INSERT INTO receipt_allocations (
            receipt_id,
            invoice_id,
            amount
        ) VALUES (
            v_receipt_id,
            v_invoice_id,
            v_amount
        );
    END LOOP;

    INSERT INTO ledger (
        party_type,
        party_id,
        invoice_number,
        entry_type,
        amount,
        payment_method,
        entry_date,
        transaction_source,
        reference_id,
        remarks,
        created_at
    ) VALUES (
        'client',
        p_client_id,
        v_receipt_number,
        'credit',
        p_total_amount,
        p_payment_method,
        p_received_date::DATE,
        'receipt',
        v_receipt_id::TEXT,
        COALESCE(p_remarks, 'Receipt received'),
        NOW()
    );

    -- ADD TO ACCOUNT TRANSACTIONS
    IF p_account_id IS NOT NULL THEN
        INSERT INTO account_transactions (
            account_id,
            amount,
            transaction_type,
            reference_type,
            reference_id,
            description,
            transaction_date,
            external_reference
        ) VALUES (
            p_account_id,
            p_total_amount,
            'credit',
            'receipt',
            v_receipt_id,
            COALESCE(p_remarks, 'Receipt ' || v_receipt_number),
            p_received_date,
            p_account_no
        );
    END IF;

    RETURN v_receipt_id;
END;
$$;


-- Update delete_receipt to handle account_transactions reversal
CREATE OR REPLACE FUNCTION delete_receipt(
    p_receipt_id BIGINT
) RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_receipt RECORD;
BEGIN
    SELECT * INTO v_receipt
    FROM receipts
    WHERE id = p_receipt_id;

    IF NOT FOUND THEN
        RETURN;
    END IF;

    INSERT INTO ledger (
        party_type,
        party_id,
        invoice_number,
        entry_type,
        amount,
        payment_method,
        entry_date,
        transaction_source,
        reference_id,
        remarks,
        created_at
    ) VALUES (
        'client',
        v_receipt.client_id,
        v_receipt.receipt_number,
        'debit',
        v_receipt.total_amount,
        v_receipt.payment_method,
        v_receipt.received_date::DATE,
        'receipt_reversal',
        v_receipt.id::TEXT,
        COALESCE(v_receipt.remarks, 'Receipt deleted and reversed'),
        NOW()
    );

    -- Reversal for account transaction
    IF EXISTS (SELECT 1 FROM account_transactions WHERE reference_type = 'receipt' AND reference_id = p_receipt_id) THEN
        INSERT INTO account_transactions (
            account_id,
            amount,
            transaction_type,
            reference_type,
            reference_id,
            description,
            transaction_date
        )
        SELECT 
            account_id,
            amount,
            'debit',
            'receipt_reversal',
            p_receipt_id,
            'Reversal of receipt ' || v_receipt.receipt_number,
            NOW()
        FROM account_transactions 
        WHERE reference_type = 'receipt' AND reference_id = p_receipt_id;
    END IF;

    DELETE FROM receipts WHERE id = p_receipt_id;
END;
$$;


-- Recreate create_disbursement with p_account_id
CREATE OR REPLACE FUNCTION create_disbursement(
    p_supplier_id BIGINT,
    p_total_amount NUMERIC,
    p_payment_method TEXT,
    p_account_no TEXT DEFAULT NULL,
    p_category TEXT DEFAULT NULL,
    p_remarks TEXT DEFAULT NULL,
    p_paid_date TIMESTAMP DEFAULT NOW(),
    p_account_id INT DEFAULT NULL
) RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    v_disbursement_id BIGINT;
    v_disbursement_number TEXT;
    v_vendor_balance NUMERIC(12,2);
    v_final_remarks TEXT;
BEGIN
    IF p_total_amount <= 0 THEN
        RAISE EXCEPTION 'Disbursement total_amount must be greater than zero';
    END IF;

    IF p_payment_method NOT IN ('cash', 'bank', 'cheque') THEN
        RAISE EXCEPTION 'Invalid payment method. Allowed values: cash, bank, cheque';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM vendors WHERE id = p_supplier_id) THEN
        RAISE EXCEPTION 'Vendor % not found', p_supplier_id;
    END IF;

    SELECT COALESCE(
        SUM(
            CASE
                WHEN entry_type = 'credit' THEN amount
                ELSE -amount
            END
        ),
        0
    )::NUMERIC(12,2)
    INTO v_vendor_balance
    FROM ledger
    WHERE party_type = 'vendor'
      AND party_id = p_supplier_id;

    IF p_total_amount > v_vendor_balance THEN
        RAISE EXCEPTION
            'Disbursement amount % exceeds vendor due balance % for vendor %',
            p_total_amount,
            v_vendor_balance,
            p_supplier_id;
    END IF;

    INSERT INTO disbursements (
        supplier_id,
        disbursement_number,
        total_amount,
        payment_method,
        account_no,
        category,
        remarks,
        paid_date
    ) VALUES (
        p_supplier_id,
        NULL,
        p_total_amount,
        p_payment_method,
        p_account_no,
        p_category,
        p_remarks,
        p_paid_date
    ) RETURNING id INTO v_disbursement_id;

    v_disbursement_number := 'DSB-' || LPAD(v_disbursement_id::TEXT, 8, '0');

    UPDATE disbursements
    SET disbursement_number = v_disbursement_number
    WHERE id = v_disbursement_id;

    v_final_remarks := COALESCE(
        p_remarks,
        format(
            'Auto payment log from disbursement %s | vendor_id=%s | category=%s | method=%s',
            v_disbursement_number,
            p_supplier_id,
            COALESCE(p_category, 'general'),
            p_payment_method
        )
    );

    INSERT INTO ledger (
        party_type,
        party_id,
        invoice_number,
        entry_type,
        amount,
        payment_method,
        entry_date,
        transaction_source,
        reference_id,
        remarks,
        created_at
    ) VALUES (
        'vendor',
        p_supplier_id,
        v_disbursement_number,
        'debit',
        p_total_amount,
        p_payment_method,
        p_paid_date::DATE,
        'disbursement',
        v_disbursement_id::TEXT,
        v_final_remarks,
        NOW()
    );

    -- ADD TO ACCOUNT TRANSACTIONS
    IF p_account_id IS NOT NULL THEN
        INSERT INTO account_transactions (
            account_id,
            amount,
            transaction_type,
            reference_type,
            reference_id,
            description,
            transaction_date,
            external_reference
        ) VALUES (
            p_account_id,
            p_total_amount,
            'debit',
            'disbursement',
            v_disbursement_id,
            COALESCE(p_remarks, 'Disbursement ' || v_disbursement_number),
            p_paid_date,
            p_account_no
        );
    END IF;

    RETURN v_disbursement_id;
END;
$$;


-- Add expense reference_type and expense_reversal to account_transactions
-- Since reference_type is a CHECK constraint, we might need to alter it if it exists.
-- ALTER TABLE account_transactions DROP CONSTRAINT IF EXISTS account_transactions_reference_type_check;
-- ALTER TABLE account_transactions ADD CONSTRAINT account_transactions_reference_type_check CHECK (reference_type IN ('receipt', 'disbursement', 'transfer', 'opening_balance', 'adjustment', 'expense', 'receipt_reversal', 'disbursement_reversal', 'expense_reversal'));

-- Ensure we create an RPC for create_expense as well so it's transactional
CREATE OR REPLACE FUNCTION create_expense(
    p_expense_head_id BIGINT,
    p_amount NUMERIC,
    p_remarks TEXT,
    p_date TIMESTAMP,
    p_account_id INT DEFAULT NULL
) RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    v_expense_id BIGINT;
BEGIN
    INSERT INTO expenses (
        expense_head_id,
        amount,
        remarks,
        date
    ) VALUES (
        p_expense_head_id,
        p_amount,
        p_remarks,
        p_date
    ) RETURNING id INTO v_expense_id;

    IF p_account_id IS NOT NULL THEN
        INSERT INTO account_transactions (
            account_id,
            amount,
            transaction_type,
            reference_type,
            reference_id,
            description,
            transaction_date
        ) VALUES (
            p_account_id,
            p_amount,
            'debit',
            'expense',
            v_expense_id,
            p_remarks,
            p_date
        );
    END IF;

    RETURN v_expense_id;
END;
$$;
