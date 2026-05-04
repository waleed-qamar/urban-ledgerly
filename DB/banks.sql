

CREATE TABLE ACCOUNTS (
    id SERIAL PRIMARY KEY,
    account_title TEXT NOT NULL,
    account_type TEXT NOT NULL CHECK (account_type IN ('bank', 'cash')),
    
    -- Bank-specific fields (nullable for cash)
    bank_name TEXT,
    account_number TEXT,

    currency TEXT DEFAULT 'PKR',

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE ACCOUNT_TRANSACTIONS (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL REFERENCES ACCOUNTS(id) ON DELETE CASCADE,

    amount NUMERIC(15,2) NOT NULL CHECK (amount > 0),

    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('credit', 'debit')),

    -- What caused this transaction
    reference_type TEXT NOT NULL CHECK (
        reference_type IN ('receipt', 'disbursement', 'transfer', 'opening_balance', 'adjustment')
    ),
    reference_id INT,

    description TEXT,

    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Reconciliation fields
    is_reconciled BOOLEAN DEFAULT FALSE,
    reconciled_at TIMESTAMP,
    external_reference TEXT, -- bank statement ref, cheque no, etc.

    -- Transfer linking
    transfer_id INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE ACCOUNT_TRANSFERS (
    id SERIAL PRIMARY KEY,

    from_account_id INT NOT NULL REFERENCES ACCOUNTS(id),
    to_account_id INT NOT NULL REFERENCES ACCOUNTS(id),

    amount NUMERIC(15,2) NOT NULL CHECK (amount > 0),

    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE ACCOUNT_MONTHLY_BALANCES (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL REFERENCES ACCOUNTS(id),

    month DATE NOT NULL,

    opening_balance NUMERIC(15,2) NOT NULL,
    closing_balance NUMERIC(15,2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(account_id, month)
);