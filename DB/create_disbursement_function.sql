CREATE OR REPLACE FUNCTION create_disbursement(
    p_supplier_id BIGINT,
    p_total_amount NUMERIC,
    p_payment_method TEXT,
    p_account_no TEXT DEFAULT NULL,
    p_category TEXT DEFAULT NULL,
    p_remarks TEXT DEFAULT NULL,
    p_paid_date TIMESTAMP DEFAULT NOW()
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

    RETURN v_disbursement_id;
END;
$$;
