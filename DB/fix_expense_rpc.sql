CREATE OR REPLACE FUNCTION create_expense(
    p_expense_head_id BIGINT,
    p_amount NUMERIC,
    p_remarks TEXT,
    p_date TIMESTAMP,
    p_created_at TIMESTAMP DEFAULT NULL,
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
        date,
        created_at
    ) VALUES (
        p_expense_head_id,
        p_amount,
        p_remarks,
        p_date,
        COALESCE(p_created_at, NOW())
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

DO $$
BEGIN
    ALTER TABLE account_transactions DROP CONSTRAINT IF EXISTS account_transactions_reference_type_check;
    
    ALTER TABLE account_transactions ADD CONSTRAINT account_transactions_reference_type_check 
    CHECK (reference_type IN ('receipt', 'disbursement', 'transfer', 'opening_balance', 'adjustment', 'expense', 'receipt_reversal', 'disbursement_reversal', 'expense_reversal'));
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Could not modify constraint %', SQLERRM;
END $$;
