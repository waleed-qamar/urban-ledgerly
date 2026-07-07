-- Migration script for restructuring DPS and Raw Material
-- Run this in Supabase SQL Editor

-- 1. Add unit to raw_material
ALTER TABLE raw_material 
ADD COLUMN IF NOT EXISTS unit VARCHAR(20) DEFAULT 'kg';

-- 2. Drop dps_energy_logs
DROP TABLE IF EXISTS dps_energy_logs CASCADE;

-- 3. Modify dps_consumption_logs
-- Drop foreign key constraint on machine_id first
ALTER TABLE dps_consumption_logs DROP CONSTRAINT IF EXISTS dps_consumption_logs_machine_id_fkey;
-- Drop columns
ALTER TABLE dps_consumption_logs DROP COLUMN IF EXISTS machine_id;

-- 4. Update create_dps_report RPC
CREATE OR REPLACE FUNCTION create_dps_report(payload JSON)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    new_report_id INT;
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
            item_id, item_type, transaction_type, quantity, reference_type, reference_id, notes, transaction_date
        ) VALUES (
            (production_item->>'product_id')::INT,
            'PRODUCT',
            'IN',
            (production_item->>'quantity')::NUMERIC,
            'dps_production',
            new_report_id,
            'Produced via DPS Report on ' || (payload->>'report_date'),
            report_date_val::TIMESTAMPTZ
        );
    END LOOP;

    FOR consumption_item IN SELECT * FROM json_array_elements(payload->'consumption')
    LOOP
        INSERT INTO dps_consumption_logs (report_id, raw_material_id, quantity)
        VALUES (
            new_report_id,
            (consumption_item->>'raw_material_id')::INT,
            (consumption_item->>'quantity')::NUMERIC
        );

        INSERT INTO inventory_transactions (
            item_id, item_type, transaction_type, quantity, reference_type, reference_id, notes, transaction_date
        ) VALUES (
            (consumption_item->>'raw_material_id')::INT,
            'RAW_MATERIAL',
            'OUT',
            (consumption_item->>'quantity')::NUMERIC,
            'dps_consumption',
            new_report_id,
            'Consumed via DPS Report on ' || (payload->>'report_date'),
            report_date_val::TIMESTAMPTZ
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
            notes,
            transaction_date
        ) VALUES (
            (damage_item->>'item_id')::INT,
            CASE 
                WHEN (damage_item->>'item_type') = 'product' THEN 'PRODUCT'
                ELSE 'RAW_MATERIAL'
            END,
            'OUT',
            (damage_item->>'quantity')::NUMERIC,
            'dps_damage',
            new_report_id,
            'Damage/Loss via DPS Report (' || (payload->>'report_date') || '): ' || COALESCE(damage_item->>'reason', ''),
            report_date_val::TIMESTAMPTZ
        );
    END LOOP;

    RETURN new_report_id;
END;
$$;
