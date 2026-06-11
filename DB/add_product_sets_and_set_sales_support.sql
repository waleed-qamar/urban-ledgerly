-- Product sets
-- Note: use TIMESTAMPTZ, not TIMESTAMPZ.

CREATE TABLE IF NOT EXISTS product_sets (
    set_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS product_set_items (
    set_id BIGINT NOT NULL REFERENCES product_sets(set_id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (set_id, product_id)
);

CREATE INDEX IF NOT EXISTS idx_product_set_items_set_id
    ON product_set_items(set_id);

CREATE INDEX IF NOT EXISTS idx_product_set_items_product_id
    ON product_set_items(product_id);

-- Order / invoice support for set sales
-- These columns allow a set to survive as a first-class line item until
-- invoice generation and dispatch.

ALTER TABLE order_items
    ADD COLUMN IF NOT EXISTS set_id BIGINT REFERENCES product_sets(set_id) ON DELETE RESTRICT;

ALTER TABLE order_items
    ADD COLUMN IF NOT EXISTS set_name TEXT;

ALTER TABLE invoice_items
    ADD COLUMN IF NOT EXISTS set_id BIGINT REFERENCES product_sets(set_id) ON DELETE RESTRICT;

ALTER TABLE invoice_items
    ADD COLUMN IF NOT EXISTS set_name TEXT;

CREATE INDEX IF NOT EXISTS idx_order_items_set_id
    ON order_items(set_id);

CREATE INDEX IF NOT EXISTS idx_invoice_items_set_id
    ON invoice_items(set_id);

-- Optional safety check. Keep it commented until the app writes set-aware rows.
-- ALTER TABLE order_itemsaa
--     ADD CONSTRAINT order_items_product_or_set_chk
--     CHECK (product_id IS NOT NULL OR set_id IS NOT NULL);
--
-- ALTER TABLE invoice_items
--     ADD CONSTRAINT invoice_items_product_or_set_chk
--     CHECK (product_id IS NOT NULL OR set_id IS NOT NULL);