CREATE TABLE receipts (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES clients(id),
    receipt_number TEXT UNIQUE,
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount > 0),
    payment_method TEXT NOT NULL CHECK (payment_method IN ('cash', 'bank', 'cheque')),
    account_no TEXT,
    remarks TEXT,
    received_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE receipt_allocations (
    id BIGSERIAL PRIMARY KEY,
    receipt_id BIGINT NOT NULL REFERENCES receipts(id) ON DELETE CASCADE,
    invoice_id BIGINT NOT NULL REFERENCES invoices(id),
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_receipt_invoice UNIQUE (receipt_id, invoice_id)
);

CREATE TABLE disbursements (
    id BIGSERIAL PRIMARY KEY,
    supplier_id BIGINT NOT NULL REFERENCES vendors(id),
    disbursement_number TEXT UNIQUE,
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount > 0),
    payment_method TEXT NOT NULL CHECK (payment_method IN ('cash', 'bank', 'cheque')),
    account_no TEXT,
    category TEXT,
    remarks TEXT,
    paid_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE VIEW invoice_payment_summaries AS
SELECT
    i.id AS invoice_id,
    COALESCE(SUM(ra.amount), 0)::NUMERIC(12,2) AS paid_amount
FROM invoices i
LEFT JOIN receipt_allocations ra ON ra.invoice_id = i.id
GROUP BY i.id;

CREATE OR REPLACE FUNCTION create_receipt(
    p_client_id BIGINT,
    p_total_amount NUMERIC,
    p_payment_method TEXT,
    p_account_no TEXT DEFAULT NULL,
    p_remarks TEXT DEFAULT NULL,
    p_received_date TIMESTAMP DEFAULT NOW(),
    p_allocations JSONB DEFAULT '[]'::JSONB
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

    RETURN v_receipt_id;
END;
$$;

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

    DELETE FROM receipts WHERE id = p_receipt_id;
END;
$$;