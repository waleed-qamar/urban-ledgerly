CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    clientName VARCHAR(255) NOT NULL,
    clientAddress TEXT NOT NULL,
    contactNumber VARCHAR(20) NOT NULL,
    createdAt TIMESTAMP
);

CREATE TABLE vendors (
    id SERIAL PRIMARY KEY,
    vendorName VARCHAR(255) NOT NULL,
    vendorAddress TEXT NOT NULL,
    supplyType VARCHAR(255),
    companyName TEXT,
    contactNumber VARCHAR(20) NOT NULL,
    createdAt TIMESTAMP
);

CREATE TABLE inventory_transactions (
    id SERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    transaction_type VARCHAR(3) NOT NULL CHECK (transaction_type IN ('IN', 'OUT')),
    quantity INT NOT NULL CHECK (quantity > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_inventory_transactions_product_id
    ON inventory_transactions(product_id);


CREATE TABLE ledger (
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

    created_at TIMESTAMP
);

create table orders (
  id bigint generated always as identity primary key,
  customer_id bigint not null,
  status text default 'pending',
  created_at timestamp with time zone default now()
);

create table order_items (
  id bigint generated always as identity primary key,
  order_id bigint references orders(id) on delete cascade,
  product_id bigint references products(id),
  quantity double precision not null,
  price double precision not null
);