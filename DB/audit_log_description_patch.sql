-- ===============================================================
-- LEDGERLY: AUDIT LOG DESCRIPTION PATCH
-- ===============================================================
-- Apply after rbac_rls_audit_migration.sql. Adds a deterministic,
-- rule-based "what happened" description to each audit_logs row --
-- no LLM, just a computed diff between OLD and NEW.
-- ===============================================================

BEGIN;

ALTER TABLE audit_logs ADD COLUMN IF NOT EXISTS changed_fields JSONB;
ALTER TABLE audit_logs ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE audit_logs ADD COLUMN IF NOT EXISTS changed_by_name TEXT;

CREATE OR REPLACE FUNCTION log_audit_event()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_changed_fields JSONB;
    v_description TEXT;
    v_actor_name TEXT;
BEGIN
    -- Snapshot the actor's name at the time of the change (employees.name
    -- can change later, so we don't want the log to silently rewrite history)
    SELECT name INTO v_actor_name FROM employees WHERE user_id = auth.uid();

    IF TG_OP = 'UPDATE' THEN
        -- Diff OLD vs NEW: only keep keys whose value actually changed
        SELECT jsonb_object_agg(o.key, jsonb_build_object('old', o.value, 'new', n.value))
        INTO v_changed_fields
        FROM jsonb_each(to_jsonb(OLD)) o(key, value)
        JOIN jsonb_each(to_jsonb(NEW)) n(key, value) USING (key)
        WHERE o.value IS DISTINCT FROM n.value;

        -- Turn the diff into a plain-English line, e.g.
        -- "status: draft -> issued, paid_amount: 0 -> 5000"
        SELECT string_agg(
            format('%s: %s -> %s', key,
                   COALESCE(value->>'old', 'null'),
                   COALESCE(value->>'new', 'null')),
            ', '
        )
        INTO v_description
        FROM jsonb_each(v_changed_fields);

        v_description := COALESCE(
            format('%s updated (%s)', TG_TABLE_NAME, v_description),
            format('%s updated (no field changes detected)', TG_TABLE_NAME)
        );

        INSERT INTO audit_logs(table_name, record_id, action, old_data, new_data, changed_fields, description, changed_by, changed_by_name)
        VALUES (TG_TABLE_NAME, NEW.id::TEXT, TG_OP, to_jsonb(OLD), to_jsonb(NEW), v_changed_fields, v_description, auth.uid(), v_actor_name);

    ELSIF TG_OP = 'INSERT' THEN
        v_description := format('%s created', TG_TABLE_NAME);
        INSERT INTO audit_logs(table_name, record_id, action, new_data, description, changed_by, changed_by_name)
        VALUES (TG_TABLE_NAME, NEW.id::TEXT, TG_OP, to_jsonb(NEW), v_description, auth.uid(), v_actor_name);

    ELSIF TG_OP = 'DELETE' THEN
        v_description := format('%s deleted', TG_TABLE_NAME);
        INSERT INTO audit_logs(table_name, record_id, action, old_data, description, changed_by, changed_by_name)
        VALUES (TG_TABLE_NAME, OLD.id::TEXT, TG_OP, to_jsonb(OLD), v_description, auth.uid(), v_actor_name);
    END IF;

    RETURN COALESCE(NEW, OLD);
END;
$$;

-- Triggers already attached by the earlier migration call this same
-- function name, so no need to re-run the DROP/CREATE TRIGGER loop --
-- CREATE OR REPLACE FUNCTION above is enough to change their behavior.

COMMIT;
