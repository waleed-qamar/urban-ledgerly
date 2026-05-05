-- 1. MACHINES
CREATE TABLE IF NOT EXISTS machines (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 2. DPS REPORTS
CREATE TABLE IF NOT EXISTS dps_reports (
    id SERIAL PRIMARY KEY,
    report_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'draft',
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 3. ENERGY LOGS
CREATE TABLE IF NOT EXISTS dps_energy_logs (
    id SERIAL PRIMARY KEY,
    report_id INT REFERENCES dps_reports(id) ON DELETE CASCADE,
    machine_id INT REFERENCES machines(id),
    operator_name TEXT,
    gas_weight NUMERIC(12,2) DEFAULT 0,
    wood_weight NUMERIC(12,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 4. PRODUCTION LOGS
CREATE TABLE IF NOT EXISTS dps_production_logs (
    id SERIAL PRIMARY KEY,
    report_id INT REFERENCES dps_reports(id) ON DELETE CASCADE,
    machine_id INT REFERENCES machines(id),
    product_id INT REFERENCES products(id),
    quantity NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 5. CONSUMPTION LOGS
CREATE TABLE IF NOT EXISTS dps_consumption_logs (
    id SERIAL PRIMARY KEY,
    report_id INT REFERENCES dps_reports(id) ON DELETE CASCADE,
    machine_id INT REFERENCES machines(id),
    raw_material_id INT REFERENCES raw_material(id),
    quantity NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 6. DAMAGE LOGS
CREATE TABLE IF NOT EXISTS dps_damage_logs (
    id SERIAL PRIMARY KEY,
    report_id INT REFERENCES dps_reports(id) ON DELETE CASCADE,
    machine_id INT REFERENCES machines(id),
    item_type VARCHAR(20) CHECK (item_type IN ('product', 'raw_material')),
    item_id INT NOT NULL,
    quantity NUMERIC(12,2),
    reason TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 7. ALTER INVENTORY TRANSACTIONS
ALTER TABLE inventory_transactions ALTER COLUMN quantity TYPE NUMERIC(12,2);

-- 8. RPC FUNCTION
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
    -- Extract top-level fields
    report_date_val := (payload->>'report_date')::DATE;
    notes_val := payload->>'notes';

    -- 1. Insert report
    INSERT INTO dps_reports (report_date, notes, status)
    VALUES (report_date_val, notes_val, 'submitted')
    RETURNING id INTO new_report_id;

    -- 2. Loop through energy array
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

    -- 3. Loop through production array
    FOR production_item IN SELECT * FROM json_array_elements(payload->'production')
    LOOP
        INSERT INTO dps_production_logs (report_id, machine_id, product_id, quantity)
        VALUES (
            new_report_id,
            (production_item->>'machine_id')::INT,
            (production_item->>'product_id')::INT,
            (production_item->>'quantity')::NUMERIC
        );

        -- Insert inventory transaction
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

    -- 4. Loop through consumption array
    FOR consumption_item IN SELECT * FROM json_array_elements(payload->'consumption')
    LOOP
        INSERT INTO dps_consumption_logs (report_id, machine_id, raw_material_id, quantity)
        VALUES (
            new_report_id,
            (consumption_item->>'machine_id')::INT,
            (consumption_item->>'raw_material_id')::INT,
            (consumption_item->>'quantity')::NUMERIC
        );

        -- Insert inventory transaction
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

    -- 5. Loop through damage array
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

        -- Insert inventory transaction
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
            UPPER(damage_item->>'item_type'), -- Map 'product' to 'PRODUCT', 'raw_material' to 'RAW_MATERIAL'
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
