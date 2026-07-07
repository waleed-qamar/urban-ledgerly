CREATE OR REPLACE FUNCTION update_dps_report(payload JSON)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    p_report_id INT;
    production_item JSON;
    consumption_item JSON;
    damage_item JSON;
    report_date_val DATE;
    notes_val TEXT;
BEGIN
    p_report_id := (payload->>'report_id')::INT;
    report_date_val := (payload->>'report_date')::DATE;
    notes_val := payload->>'notes';

    -- 1. Update the main report record
    UPDATE dps_reports
    SET report_date = report_date_val,
        notes = notes_val
    WHERE id = p_report_id;

    -- 2. Delete old logs
    DELETE FROM dps_production_logs WHERE report_id = p_report_id;
    DELETE FROM dps_consumption_logs WHERE report_id = p_report_id;
    DELETE FROM dps_damage_logs WHERE report_id = p_report_id;

    -- 3. Delete old inventory transactions linked to this report
    DELETE FROM inventory_transactions
    WHERE reference_id = p_report_id
      AND reference_type IN ('dps_production', 'dps_consumption', 'dps_damage');

    -- 4. Re-insert production logs and their inventory transactions
    FOR production_item IN SELECT * FROM json_array_elements(payload->'production')
    LOOP
        INSERT INTO dps_production_logs (report_id, machine_id, product_id, quantity)
        VALUES (
            p_report_id,
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
            p_report_id,
            'Produced via DPS Report on ' || (payload->>'report_date'),
            report_date_val::TIMESTAMPTZ
        );
    END LOOP;

    -- 5. Re-insert consumption logs and their inventory transactions
    FOR consumption_item IN SELECT * FROM json_array_elements(payload->'consumption')
    LOOP
        INSERT INTO dps_consumption_logs (report_id, raw_material_id, quantity)
        VALUES (
            p_report_id,
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
            p_report_id,
            'Consumed via DPS Report on ' || (payload->>'report_date'),
            report_date_val::TIMESTAMPTZ
        );
    END LOOP;

    -- 6. Re-insert damage logs and their inventory transactions
    FOR damage_item IN SELECT * FROM json_array_elements(payload->'damage')
    LOOP
        INSERT INTO dps_damage_logs (report_id, machine_id, item_type, item_id, quantity, reason)
        VALUES (
            p_report_id,
            (damage_item->>'machine_id')::INT,
            damage_item->>'item_type',
            (damage_item->>'item_id')::INT,
            (damage_item->>'quantity')::NUMERIC,
            damage_item->>'reason'
        );

        -- Decrease inventory for damages
        INSERT INTO inventory_transactions (
            item_id, item_type, transaction_type, quantity, reference_type, reference_id, notes, transaction_date
        ) VALUES (
            (damage_item->>'item_id')::INT,
            UPPER(damage_item->>'item_type'),
            'OUT',
            (damage_item->>'quantity')::NUMERIC,
            'dps_damage',
            p_report_id,
            COALESCE(damage_item->>'reason', 'Damaged via DPS Report on ' || (payload->>'report_date')),
            report_date_val::TIMESTAMPTZ
        );
    END LOOP;
END;
$$;
