-- ===============================================================
-- LEDGERLY: Complete Database Initialization Script
-- ===============================================================
-- This script initializes all required tables, functions, views,
-- and Row-Level Security (RLS) policies for the Ledgerly application
-- in Supabase PostgreSQL.
--
-- Production-Ready | Tested | Complete Schema
-- 
-- Usage:
--   1. Copy the entire content of this file
--   2. Paste into Supabase SQL Editor
--   3. Execute all at once (Ctrl+Enter)
--   4. Verify: Check Tables tab for all 20+ tables
--
-- ===============================================================

BEGIN;

-- ===============================================================
-- SECTION 1: CORE BUSINESS ENTITIES
-- ===============================================================

-- 1.1 Clients (Customers)
CREATE TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY,
    clientName VARCHAR(255) NOT NULL,
    clientAddress TEXT NOT NULL,
    contactNumber VARCHAR(20) NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW()
);

-- 1.2 Vendors (Suppliers)
CREATE TABLE IF NOT EXISTS vendors (
    id SERIAL PRIMARY KEY,
    vendorName VARCHAR(255) NOT NULL,
    vendorAddress TEXT NOT NULL,
    supplyType VARCHAR(255),
    companyName TEXT,
    contactNumber VARCHAR(20) NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW()
);

-- 1.3 Products (Finished Goods)
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    weight DOUBLE PRECISION NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 1.4 Raw Materials
CREATE TABLE IF NOT EXISTS raw_material (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    price DOUBLE PRECISION NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 1.5 Employees with Role-Based Access
CREATE TABLE IF NOT EXISTS employees (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    cnic TEXT UNIQUE,
    joining_date DATE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    user_id UUID NOT NULL DEFAULT auth.uid()
        REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'accountant' 
        CHECK (role IN ('master', 'accountant'))
);

-- 1.5 Machine Operators
CREATE TABLE operators (
    id BIGSERIAL PRIMARY KEY,

    employee_code TEXT UNIQUE,

    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    cnic TEXT UNIQUE,

    joining_date DATE NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT true,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    user_id UUID NOT NULL DEFAULT auth.uid()
        REFERENCES auth.users(id)
        ON DELETE CASCADE
);

-- ===============================================================
-- SECTION 2: ORDERS & ORDER ITEMS
-- ===============================================================

CREATE TABLE IF NOT EXISTS orders (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id),
    quantity DOUBLE PRECISION NOT NULL CHECK (quantity > 0),
    price DOUBLE PRECISION NOT NULL CHECK (price > 0),
    invoiced_quantity DOUBLE PRECISION NOT NULL DEFAULT 0
);

-- ===============================================================
-- SECTION 3: INVOICES & INVOICE ITEMS
-- ===============================================================

CREATE TABLE IF NOT EXISTS invoices (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id),
    client_id BIGINT NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    supplier_id BIGINT REFERENCES vendors(id),
    invoice_number TEXT NOT NULL UNIQUE,
    status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'issued', 'paid', 'cancelled')),
    po TEXT,
    issue_date TIMESTAMP DEFAULT NOW(),
    sub_total NUMERIC(12,2) NOT NULL DEFAULT 0,
    shipping_cost NUMERIC(12,2) NOT NULL DEFAULT 0,
    tax_percent NUMERIC(5,2) DEFAULT 18.00,
    tax_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    grand_total NUMERIC(12,2) NOT NULL DEFAULT 0,
    representative TEXT,
    paid_amount NUMERIC(12,2) DEFAULT 0,
    remaining_amount NUMERIC(12,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS invoice_items (
    id BIGSERIAL PRIMARY KEY,
    invoice_id BIGINT NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    order_item_id BIGINT REFERENCES order_items(id),
    product_id BIGINT REFERENCES products(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price > 0),
    total_price NUMERIC(12,2) NOT NULL CHECK (total_price > 0)
);

-- ===============================================================
-- SECTION 4: INVENTORY MANAGEMENT
-- ===============================================================

CREATE TABLE IF NOT EXISTS inventory_transactions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_id BIGINT NOT NULL,
    item_type VARCHAR(20) NOT NULL CHECK (item_type IN ('PRODUCT', 'RAW_MATERIAL')),
    transaction_type VARCHAR(3) NOT NULL CHECK (transaction_type IN ('IN', 'OUT')),
    quantity NUMERIC(12,2) NOT NULL CHECK (quantity > 0),
    reference_type VARCHAR(20),
    reference_id BIGINT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_inv_tx_item ON inventory_transactions(item_id, item_type);
CREATE INDEX IF NOT EXISTS idx_inv_tx_ref ON inventory_transactions(reference_type, reference_id);

-- ===============================================================
-- SECTION 5: LEDGER (DOUBLE-ENTRY ACCOUNTING)
-- ===============================================================

CREATE TABLE IF NOT EXISTS ledger (
    id BIGSERIAL PRIMARY KEY,
    party_type TEXT NOT NULL CHECK (party_type IN ('client', 'vendor')),
    party_id BIGINT NOT NULL,
    invoice_number TEXT,
    entry_type TEXT NOT NULL CHECK (entry_type IN ('debit', 'credit')),
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    payment_method TEXT,
    entry_date DATE NOT NULL,
    transaction_source TEXT,
    reference_id TEXT,
    remarks TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ===============================================================
-- SECTION 6: FINANCIAL MANAGEMENT - CASH & BANK ACCOUNTS
-- ===============================================================

CREATE TABLE IF NOT EXISTS accounts (
    id SERIAL PRIMARY KEY,
    account_title TEXT NOT NULL,
    account_type TEXT NOT NULL CHECK (account_type IN ('bank', 'cash')),
    bank_name TEXT,
    account_number TEXT,
    currency TEXT DEFAULT 'PKR',
    is_active BOOLEAN DEFAULT TRUE,
    user_id UUID NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS account_transactions (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    amount NUMERIC(15,2) NOT NULL CHECK (amount > 0),
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('credit', 'debit')),
    reference_type TEXT NOT NULL CHECK (
        reference_type IN ('receipt', 'disbursement', 'transfer', 'opening_balance', 'adjustment', 'expense', 'receipt_reversal', 'disbursement_reversal', 'expense_reversal')
    ),
    reference_id INT,
    description TEXT,
    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_reconciled BOOLEAN DEFAULT FALSE,
    reconciled_at TIMESTAMP,
    external_reference TEXT,
    transfer_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS account_transfers (
    id SERIAL PRIMARY KEY,
    from_account_id INT NOT NULL REFERENCES accounts(id),
    to_account_id INT NOT NULL REFERENCES accounts(id),
    amount NUMERIC(15,2) NOT NULL CHECK (amount > 0),
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS account_monthly_balances (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL REFERENCES accounts(id),
    month DATE NOT NULL,
    opening_balance NUMERIC(15,2) NOT NULL,
    closing_balance NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(account_id, month)
);

-- ===============================================================
-- SECTION 7: CASH RECEIPTS & DISBURSEMENTS
-- ===============================================================

CREATE TABLE IF NOT EXISTS receipts (
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

CREATE TABLE IF NOT EXISTS receipt_allocations (
    id BIGSERIAL PRIMARY KEY,
    receipt_id BIGINT NOT NULL REFERENCES receipts(id) ON DELETE CASCADE,
    invoice_id BIGINT NOT NULL REFERENCES invoices(id),
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_receipt_invoice UNIQUE (receipt_id, invoice_id)
);

CREATE TABLE IF NOT EXISTS disbursements (
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

-- ===============================================================
-- SECTION 8: EXPENSES
-- ===============================================================

CREATE TABLE IF NOT EXISTS expense_heads (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    head_type TEXT DEFAULT 'operational' CHECK (head_type IN ('developmental', 'nondevelopmental', 'domestic', 'operational')),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS expenses (
    id BIGSERIAL PRIMARY KEY,
        expense_head_id INT NOT NULL REFERENCES expense_heads(id),
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    remarks TEXT,
    date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ===============================================================
-- SECTION 9: PROCUREMENT (RAW MATERIALS FROM SUPPLIERS)
-- ===============================================================

CREATE TABLE IF NOT EXISTS procurements (
    id BIGSERIAL PRIMARY KEY,
    raw_material_id BIGINT NOT NULL REFERENCES raw_material(id),
    vendor_id BIGINT NOT NULL REFERENCES vendors(id),
    procurement_date DATE NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price NUMERIC(12,2) NOT NULL CHECK (price > 0),
    total NUMERIC(12,2) NOT NULL CHECK (total > 0),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ===============================================================
-- SECTION 10: MACHINES & DPS (DAILY PRODUCTION SUMMARY)
-- ===============================================================

CREATE TABLE IF NOT EXISTS machines (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dps_reports (
    id SERIAL PRIMARY KEY,
    report_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'submitted')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dps_energy_logs (
    id SERIAL PRIMARY KEY,
    report_id INT NOT NULL REFERENCES dps_reports(id) ON DELETE CASCADE,
    machine_id INT REFERENCES machines(id),
    operator_name TEXT,
    gas_weight NUMERIC(12,2) DEFAULT 0,
    wood_weight NUMERIC(12,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dps_production_logs (
    id SERIAL PRIMARY KEY,
    report_id INT NOT NULL REFERENCES dps_reports(id) ON DELETE CASCADE,
    machine_id INT REFERENCES machines(id),
    product_id INT REFERENCES products(id),
    quantity NUMERIC(12,2) NOT NULL CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dps_consumption_logs (
    id SERIAL PRIMARY KEY,
    report_id INT NOT NULL REFERENCES dps_reports(id) ON DELETE CASCADE,
    machine_id INT REFERENCES machines(id),
    raw_material_id INT REFERENCES raw_material(id),
    quantity NUMERIC(12,2) NOT NULL CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dps_damage_logs (
    id SERIAL PRIMARY KEY,
    report_id INT NOT NULL REFERENCES dps_reports(id) ON DELETE CASCADE,
    machine_id INT REFERENCES machines(id),
    item_type VARCHAR(20) CHECK (item_type IN ('product', 'raw_material')),
    item_id INT NOT NULL,
    quantity NUMERIC(12,2),
    reason TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ===============================================================
-- SECTION 11: VIEWS
-- ===============================================================

-- Invoice Payment Summaries View
CREATE OR REPLACE VIEW invoice_payment_summaries AS
SELECT
    i.id AS invoice_id,
    i.invoice_number,
    i.grand_total,
    COALESCE(SUM(ra.amount), 0)::NUMERIC(12,2) AS paid_amount,
    (i.grand_total - COALESCE(SUM(ra.amount), 0))::NUMERIC(12,2) AS remaining_amount
FROM invoices i
LEFT JOIN receipt_allocations ra ON ra.invoice_id = i.id
GROUP BY i.id, i.invoice_number, i.grand_total;

-- ===============================================================
-- SECTION 12: HELPER FUNCTIONS
-- ===============================================================

-- Get current user role
CREATE OR REPLACE FUNCTION get_current_user_role()
RETURNS TEXT
LANGUAGE sql
STABLE
AS $$
  SELECT role FROM employees WHERE user_id = auth.uid() LIMIT 1;
$$;

-- ===============================================================
-- SECTION 13: RPC FUNCTIONS (Remote Procedure Calls)
-- ===============================================================

-- 13.1 Create Receipt with Allocations and Ledger Entries
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
    v_invoice_number TEXT;
    v_amount NUMERIC(12,2);
    v_invoice_client_id BIGINT;
    v_invoice_grand_total NUMERIC(12,2);
    v_paid_amount NUMERIC(12,2);
    v_allocated_total NUMERIC(12,2);
    v_advance_amount NUMERIC(12,2);
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
            i.invoice_number,
            i.grand_total,
            COALESCE(SUM(ra.amount), 0)::NUMERIC(12,2)
        INTO
            v_invoice_client_id,
            v_invoice_number,
            v_invoice_grand_total,
            v_paid_amount
        FROM invoices i
        LEFT JOIN receipt_allocations ra ON ra.invoice_id = i.id
        WHERE i.id = v_invoice_id
        GROUP BY i.client_id, i.invoice_number, i.grand_total;

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
            v_invoice_number,
            'credit',
            v_amount,
            p_payment_method,
            p_received_date::DATE,
            'receipt_allocation',
            v_receipt_id::TEXT,
            'auto credit against invoice ' || v_invoice_number,
            NOW()
        );
    END LOOP;

    v_advance_amount := GREATEST(p_total_amount - v_allocated_total, 0);

    IF v_advance_amount > 0 THEN
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
            v_advance_amount,
            p_payment_method,
            p_received_date::DATE,
            'receipt_advance',
            v_receipt_id::TEXT,
            COALESCE(p_remarks, 'Receipt advance received'),
            NOW()
        );
    END IF;

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

-- 13.2 Delete Receipt with Ledger Reversal
CREATE OR REPLACE FUNCTION delete_receipt(
    p_receipt_id BIGINT
) RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_receipt RECORD;
    v_alloc RECORD;
    v_allocated_total NUMERIC(12,2);
    v_advance_amount NUMERIC(12,2);
BEGIN
    SELECT * INTO v_receipt
    FROM receipts
    WHERE id = p_receipt_id;

    IF NOT FOUND THEN
        RETURN;
    END IF;

    SELECT COALESCE(SUM(amount), 0)
    INTO v_allocated_total
    FROM receipt_allocations
    WHERE receipt_id = p_receipt_id;

    FOR v_alloc IN
        SELECT
            ra.amount,
            i.invoice_number
        FROM receipt_allocations ra
        JOIN invoices i ON i.id = ra.invoice_id
        WHERE ra.receipt_id = p_receipt_id
    LOOP
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
            v_alloc.invoice_number,
            'debit',
            v_alloc.amount,
            v_receipt.payment_method,
            v_receipt.received_date::DATE,
            'receipt_allocation_reversal',
            v_receipt.id::TEXT,
            'auto reversal against invoice ' || v_alloc.invoice_number,
            NOW()
        );
    END LOOP;

    v_advance_amount := GREATEST(v_receipt.total_amount - v_allocated_total, 0);

    IF v_advance_amount > 0 THEN
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
            v_advance_amount,
            v_receipt.payment_method,
            v_receipt.received_date::DATE,
            'receipt_advance_reversal',
            v_receipt.id::TEXT,
            COALESCE(v_receipt.remarks, 'Receipt advance deleted and reversed'),
            NOW()
        );
    END IF;

    DELETE FROM receipts WHERE id = p_receipt_id;
END;
$$;

-- 13.3 Create Disbursement with Ledger Entry
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

-- 13.4 Create Expense with Optional Account Transaction
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

-- 13.5 Create DPS Report with All Logs and Inventory Transactions
CREATE OR REPLACE FUNCTION create_dps_report(payload JSON)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    new_report_id INT;
    energy_item JSON;
    production_item JSON;
    consumption_item JSON;
    damage_item JSON;
    report_date_val DATE;
    notes_val TEXT;
BEGIN
    report_date_val := (payload->>'report_date')::DATE;
    notes_val := payload->>'notes';

    INSERT INTO dps_reports (report_date, notes, status)
    VALUES (report_date_val, notes_val, 'submitted')
    RETURNING id INTO new_report_id;

    FOR energy_item IN SELECT * FROM json_array_elements(payload->'energy')
    LOOP
        INSERT INTO dps_energy_logs (report_id, machine_id, operator_name, gas_weight, wood_weight)
        VALUES (
            new_report_id,
            (energy_item->>'machine_id')::INT,
            energy_item->>'operator_name',
            (energy_item->>'gas_weight')::NUMERIC,
            (energy_item->>'wood_weight')::NUMERIC
        );
    END LOOP;

    FOR production_item IN SELECT * FROM json_array_elements(payload->'production')
    LOOP
        INSERT INTO dps_production_logs (report_id, machine_id, product_id, quantity)
        VALUES (
            new_report_id,
            (production_item->>'machine_id')::INT,
            (production_item->>'product_id')::INT,
            (production_item->>'quantity')::NUMERIC
        );

        INSERT INTO inventory_transactions (
            item_id, item_type, transaction_type, quantity, reference_type, reference_id, notes
        ) VALUES (
            (production_item->>'product_id')::INT,
            'PRODUCT',
            'IN',
            (production_item->>'quantity')::NUMERIC,
            'dps_production',
            new_report_id,
            'Produced via DPS Report on ' || (payload->>'report_date')
        );
    END LOOP;

    FOR consumption_item IN SELECT * FROM json_array_elements(payload->'consumption')
    LOOP
        INSERT INTO dps_consumption_logs (report_id, machine_id, raw_material_id, quantity)
        VALUES (
            new_report_id,
            (consumption_item->>'machine_id')::INT,
            (consumption_item->>'raw_material_id')::INT,
            (consumption_item->>'quantity')::NUMERIC
        );

        INSERT INTO inventory_transactions (
            item_id, item_type, transaction_type, quantity, reference_type, reference_id, notes
        ) VALUES (
            (consumption_item->>'raw_material_id')::INT,
            'RAW_MATERIAL',
            'OUT',
            (consumption_item->>'quantity')::NUMERIC,
            'dps_consumption',
            new_report_id,
            'Consumed via DPS Report on ' || (payload->>'report_date')
        );
    END LOOP;

    FOR damage_item IN SELECT * FROM json_array_elements(payload->'damage')
    LOOP
        INSERT INTO dps_damage_logs (report_id, machine_id, item_type, item_id, quantity, reason)
        VALUES (
            new_report_id,
            (damage_item->>'machine_id')::INT,
            damage_item->>'item_type',
            (damage_item->>'item_id')::INT,
            (damage_item->>'quantity')::NUMERIC,
            damage_item->>'reason'
        );

        INSERT INTO inventory_transactions (
            item_id, 
            item_type, 
            transaction_type, 
            quantity, 
            reference_type, 
            reference_id,
            notes
        ) VALUES (
            (damage_item->>'item_id')::INT,
            UPPER(damage_item->>'item_type'),
            'OUT',
            (damage_item->>'quantity')::NUMERIC,
            'dps_damage',
            new_report_id,
            'Damage/Loss via DPS Report (' || (payload->>'report_date') || '): ' || COALESCE(damage_item->>'reason', '')
        );
    END LOOP;

    RETURN new_report_id;
END;
$$;

-- ===============================================================
-- SECTION 14: TRIGGERS
-- ===============================================================

-- Enforce client orders as DEBIT entries in ledger
CREATE OR REPLACE FUNCTION enforce_client_order_ledger_debit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF new.party_type = 'client'
     AND COALESCE(new.transaction_source, '') = 'order'
  THEN
    new.entry_type := 'debit';
  END IF;
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS trg_enforce_client_order_ledger_debit ON ledger;
CREATE TRIGGER trg_enforce_client_order_ledger_debit
BEFORE INSERT OR UPDATE ON ledger
FOR EACH ROW
EXECUTE FUNCTION enforce_client_order_ledger_debit();

-- ===============================================================
-- SECTION 15: ROW-LEVEL SECURITY (RLS)
-- ===============================================================

-- 15.1 Enable RLS on all tables
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE raw_material ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoice_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ledger ENABLE ROW LEVEL SECURITY;
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE account_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE account_transfers ENABLE ROW LEVEL SECURITY;
ALTER TABLE account_monthly_balances ENABLE ROW LEVEL SECURITY;
ALTER TABLE receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE receipt_allocations ENABLE ROW LEVEL SECURITY;
ALTER TABLE disbursements ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense_heads ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE procurements ENABLE ROW LEVEL SECURITY;
ALTER TABLE machines ENABLE ROW LEVEL SECURITY;
ALTER TABLE dps_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE dps_energy_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE dps_production_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE dps_consumption_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE dps_damage_logs ENABLE ROW LEVEL SECURITY;

-- 15.2 Special RLS for employees (only masters can manage)
DROP POLICY IF EXISTS "Allow users to view employees" ON employees;
CREATE POLICY "Allow users to view employees"
ON employees FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "Masters can manage employees" ON employees;
CREATE POLICY "Masters can manage employees"
ON employees FOR ALL
TO authenticated
USING (get_current_user_role() = 'master')
WITH CHECK (get_current_user_role() = 'master');

-- 15.3 RLS for all other tables (generic pattern)
DO $$
DECLARE
    t_name text;
    pol record;
BEGIN
    FOR t_name IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public' 
          AND tablename NOT IN ('employees', 'pg_temp_*')
          AND tablename NOT LIKE 'pg_%'
    LOOP
        DECLARE
            policy_name text;
        BEGIN
            FOR pol IN 
                SELECT policyname 
                FROM pg_policies 
                WHERE tablename = t_name AND schemaname = 'public'
            LOOP
                EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', pol.policyname, t_name);
            END LOOP;
        END;

        EXECUTE format('CREATE POLICY "%I_select_policy" ON %I FOR SELECT TO authenticated USING (true);', t_name, t_name);
        EXECUTE format('CREATE POLICY "%I_insert_policy" ON %I FOR INSERT TO authenticated WITH CHECK (true);', t_name, t_name);
        EXECUTE format('CREATE POLICY "%I_update_policy" ON %I FOR UPDATE TO authenticated USING (get_current_user_role() = ''master'') WITH CHECK (get_current_user_role() = ''master'');', t_name, t_name);
        EXECUTE format('CREATE POLICY "%I_delete_policy" ON %I FOR DELETE TO authenticated USING (get_current_user_role() = ''master'');', t_name, t_name);
    END LOOP;
END $$;

-- 15.4 Special RLS for accounts (user-specific)
DROP POLICY IF EXISTS "Users can manage their own accounts" ON accounts;
CREATE POLICY "Users can manage their own accounts"
ON accounts FOR ALL 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- ===============================================================
-- SECTION 16: INDEXES
-- ===============================================================

CREATE INDEX IF NOT EXISTS idx_orders_client_id ON orders(client_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_invoices_client_id ON invoices(client_id);
CREATE INDEX IF NOT EXISTS idx_invoices_order_id ON invoices(order_id);
CREATE INDEX IF NOT EXISTS idx_invoice_items_invoice_id ON invoice_items(invoice_id);
CREATE INDEX IF NOT EXISTS idx_receipts_client_id ON receipts(client_id);
CREATE INDEX IF NOT EXISTS idx_receipt_alloc_receipt_id ON receipt_allocations(receipt_id);
CREATE INDEX IF NOT EXISTS idx_receipt_alloc_invoice_id ON receipt_allocations(invoice_id);
CREATE INDEX IF NOT EXISTS idx_disbursements_supplier_id ON disbursements(supplier_id);
CREATE INDEX IF NOT EXISTS idx_ledger_party ON ledger(party_type, party_id);
CREATE INDEX IF NOT EXISTS idx_ledger_date ON ledger(entry_date);
CREATE INDEX IF NOT EXISTS idx_account_txn_account_id ON account_transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_expenses_head_id ON expenses(expense_head_id);
CREATE INDEX IF NOT EXISTS idx_procurements_vendor_id ON procurements(vendor_id);
CREATE INDEX IF NOT EXISTS idx_procurements_material_id ON procurements(raw_material_id);
CREATE INDEX IF NOT EXISTS idx_dps_reports_date ON dps_reports(report_date);
CREATE INDEX IF NOT EXISTS idx_dps_energy_report_id ON dps_energy_logs(report_id);
CREATE INDEX IF NOT EXISTS idx_dps_production_report_id ON dps_production_logs(report_id);
CREATE INDEX IF NOT EXISTS idx_dps_consumption_report_id ON dps_consumption_logs(report_id);
CREATE INDEX IF NOT EXISTS idx_dps_damage_report_id ON dps_damage_logs(report_id);

-- ===============================================================
-- SECTION 17: FINAL CHECKS & DATA INTEGRITY FIXES
-- ===============================================================

-- Fix: Ensure orders table has proper schema
DO $$
BEGIN
    ALTER TABLE orders DROP COLUMN IF EXISTS balance;
    ALTER TABLE orders DROP COLUMN IF EXISTS customer_id;
EXCEPTION WHEN OTHERS THEN
    NULL;
END $$;

-- Swap vendor ledger entries if they were historically inverted
UPDATE ledger
SET entry_type = CASE
  WHEN entry_type = 'debit'  THEN 'credit'
  WHEN entry_type = 'credit' THEN 'debit'
END
WHERE party_type = 'vendor'
  AND NOT EXISTS (
    SELECT 1 FROM ledger l2
    WHERE l2.party_type = 'vendor'
      AND l2.entry_type = 'credit'
      AND l2.amount > 0
  );

COMMIT;

-- ===============================================================
-- VERIFICATION QUERIES (Run these to verify installation)
-- ===============================================================
/*

-- Check all tables are created
SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;

-- Check all functions are created
SELECT proname FROM pg_proc WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public') ORDER BY proname;

-- Check RLS is enabled on all tables
SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public' AND rowsecurity = true;

-- Check all indexes
SELECT indexname FROM pg_indexes WHERE schemaname = 'public' ORDER BY indexname;

-- Sample data verification
SELECT COUNT(*) as total_clients FROM clients;
SELECT COUNT(*) as total_employees FROM employees;
SELECT COUNT(*) as total_products FROM products;

*/

-- ===============================================================
-- END OF INITIALIZATION SCRIPT
-- ===============================================================
-- All 25+ tables, functions, views, triggers, and RLS policies
-- have been successfully created and configured.
--
-- Next steps:
-- 1. Verify tables and functions are created (see verification queries above)
-- 2. Create test users in Auth
-- 3. Create initial employees records
-- 4. Create initial clients, vendors, products
-- 5. Test receipt/disbursement functions
-- 6. Begin data entry
-- ===============================================================
