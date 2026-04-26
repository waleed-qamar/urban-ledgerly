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

-- Unified inventory transactions for both products and raw materials.
-- item_type discriminates between 'PRODUCT' and 'RAW_MATERIAL'.
-- reference_type / reference_id allow future modules (Invoice, Procurement, BOM, Production)
-- to link transactions without schema changes.
CREATE TABLE inventory_transactions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    item_id   BIGINT NOT NULL,
    item_type VARCHAR(20) NOT NULL CHECK (item_type IN ('PRODUCT', 'RAW_MATERIAL')),

    transaction_type VARCHAR(3) NOT NULL CHECK (transaction_type IN ('IN', 'OUT')),
    quantity INT NOT NULL CHECK (quantity > 0),

    -- Optional link to source document (future: invoices, procurement, BOM, production)
    reference_type VARCHAR(20),  -- 'SALE', 'PROCUREMENT', 'PRODUCTION', 'INVOICE', 'BOM'
    reference_id   BIGINT,

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Composite index for fetching all transactions for a specific item
CREATE INDEX idx_inv_tx_item ON inventory_transactions(item_id, item_type);
-- Index for reverse lookups from reference documents
CREATE INDEX idx_inv_tx_ref  ON inventory_transactions(reference_type, reference_id);


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
    client_id bigint not null,
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

-- Raw materials are distinct from finished products.
-- price here is the estimated/average cost per unit.
-- Actual purchase prices will be tracked in the future Procurement module.
create table raw_material (
  id bigint generated always as identity primary key,
  name text not null,
  price double precision not null,
  description text,
  created_at timestamp with time zone default now()
);