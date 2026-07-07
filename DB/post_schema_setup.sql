-- ================================================================
-- LEDGERLY: Post-Schema Setup Script
-- ================================================================
-- Run this AFTER you have already run schema.sql in a new Supabase
-- project. It sets up:
--   1. Table GRANTs  <- THE CRITICAL STEP (missing this = 42501 errors)
--   2. RBAC tables + seed data (roles, permissions, role_permissions)
--   3. Helper functions (permission check, get_my_employee_profile RPC)
--   4. RLS enabled with simple authenticated-user policies
--   5. Audit log table + triggers
--   6. employees.role_id backfill
--
-- CRITICAL LESSON LEARNED:
--   PostgreSQL has TWO independent access layers:
--     a) Table-level GRANT  -> does the role have permission to touch the table?
--     b) RLS policy         -> which rows can they see?
--   You MUST configure BOTH. Missing GRANTs causes "permission denied for table X"
--   even when your RLS policies say USING (true).
-- ================================================================

BEGIN;

-- ================================================================
-- STEP 1: GRANT TABLE ACCESS TO THE authenticated ROLE
-- ================================================================

GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- Apply to future tables automatically
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT USAGE, SELECT ON SEQUENCES TO authenticated;

-- ================================================================
-- STEP 2: RBAC SCHEMA
-- ================================================================

CREATE TABLE IF NOT EXISTS roles (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    is_system BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS permissions (
    id BIGSERIAL PRIMARY KEY,
    module TEXT NOT NULL,
    action TEXT NOT NULL,
    key TEXT GENERATED ALWAYS AS (module || '.' || action) STORED UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS role_permissions (
    role_id BIGINT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id BIGINT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- ================================================================
-- STEP 3: SEED ROLES
-- ================================================================

INSERT INTO roles (name, is_system) VALUES ('master', TRUE)  ON CONFLICT (name) DO NOTHING;
INSERT INTO roles (name)            VALUES ('accountant')     ON CONFLICT (name) DO NOTHING;
INSERT INTO roles (name)            VALUES ('operator')       ON CONFLICT (name) DO NOTHING;

-- ================================================================
-- STEP 4: SEED PERMISSIONS
-- ================================================================

DO $$
DECLARE
    m TEXT;
    a TEXT;
    modules TEXT[] := ARRAY[
        'clients','vendors','products','raw_material','orders','invoices',
        'inventory','ledger','accounts','receipts','disbursements','expenses',
        'procurements','employees','suppliers','dps','overview'
    ];
    actions TEXT[] := ARRAY['create','read','update','delete'];
BEGIN
    FOREACH m IN ARRAY modules LOOP
        FOREACH a IN ARRAY actions LOOP
            INSERT INTO permissions (module, action) VALUES (m, a)
            ON CONFLICT (key) DO NOTHING;
        END LOOP;
    END LOOP;
END $$;

-- ================================================================
-- STEP 5: SEED ROLE -> PERMISSION MAPPINGS
-- ================================================================

-- master: all permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p WHERE r.name = 'master'
ON CONFLICT DO NOTHING;

-- accountant: financial modules
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p
    ON p.module IN ('clients','vendors','invoices','ledger','accounts','receipts',
                    'disbursements','expenses','orders','products','raw_material','procurements')
WHERE r.name = 'accountant'
ON CONFLICT DO NOTHING;

-- operator: production modules, no delete
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p
    ON p.module IN ('orders','inventory','products','raw_material')
    AND p.action IN ('read','create','update')
WHERE r.name = 'operator'
ON CONFLICT DO NOTHING;

-- ================================================================
-- STEP 6: LINK employees TO roles (add role_id column + backfill)
-- ================================================================

ALTER TABLE employees ADD COLUMN IF NOT EXISTS role_id BIGINT REFERENCES roles(id);
UPDATE employees e SET role_id = r.id FROM roles r WHERE r.name = e.role AND e.role_id IS NULL;

-- ================================================================
-- STEP 7: HELPER FUNCTIONS
-- ================================================================

-- 7a. Permission check (used by RLS in future if needed)
CREATE OR REPLACE FUNCTION current_user_has_permission(perm_key TEXT)
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM employees e
        JOIN role_permissions rp ON rp.role_id = e.role_id
        JOIN permissions p ON p.id = rp.permission_id
        WHERE e.user_id = auth.uid()
          AND e.is_active = TRUE
          AND p.key = perm_key
    );
$$;

-- 7b. Active employee check
CREATE OR REPLACE FUNCTION current_user_is_active_employee()
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
    SELECT EXISTS (SELECT 1 FROM employees WHERE user_id = auth.uid() AND is_active = TRUE);
$$;

-- 7c. RPC to fetch own employee profile (bypasses RLS via SECURITY DEFINER)
--     The Flutter app calls this at login instead of querying employees directly.
--     This prevents the chicken-and-egg RLS problem at startup.
CREATE OR REPLACE FUNCTION get_my_employee_profile()
RETURNS SETOF employees
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
    SELECT * FROM public.employees WHERE user_id = auth.uid() LIMIT 1;
$$;
GRANT EXECUTE ON FUNCTION get_my_employee_profile() TO authenticated;

-- ================================================================
-- STEP 8: ENABLE RLS + SIMPLE AUTHENTICATED POLICIES
-- ================================================================
-- Strategy: Database enforces authentication-only access.
-- Fine-grained role/permission control lives in the Flutter app
-- via hasPermissionProvider. This avoids circular dependency issues.

DO $$
DECLARE
    t TEXT;
    pol RECORD;
    tables TEXT[] := ARRAY[
        'clients','vendors','suppliers','products','product_sets',
        'product_set_items','raw_material','operators','orders','order_items',
        'invoices','invoice_items','inventory_transactions','ledger',
        'accounts','account_transactions','account_transfers',
        'account_monthly_balances','receipts','receipt_allocations',
        'disbursements','expense_heads','expenses','procurements',
        'procurement_items','machines','dps_reports','dps_energy_logs',
        'dps_production_logs','dps_consumption_logs','dps_damage_logs',
        'employees','roles','permissions','role_permissions','audit_logs'
    ];
BEGIN
    FOREACH t IN ARRAY tables LOOP
        IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = t) THEN
            EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
            FOR pol IN SELECT policyname FROM pg_policies WHERE schemaname='public' AND tablename=t LOOP
                EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', pol.policyname, t);
            END LOOP;
            EXECUTE format(
                'CREATE POLICY "authenticated_full_access" ON public.%I '
                'FOR ALL TO authenticated USING (true) WITH CHECK (true)',
                t
            );
        END IF;
    END LOOP;
END $$;

-- ================================================================
-- STEP 9: AUDIT LOG TABLE + TRIGGERS
-- ================================================================

CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGSERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    action TEXT NOT NULL CHECK (action IN ('INSERT','UPDATE','DELETE')),
    old_data JSONB,
    new_data JSONB,
    changed_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    changed_by_name TEXT,
    description TEXT,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_changed_at   ON audit_logs(changed_at);

CREATE OR REPLACE FUNCTION log_audit_event()
RETURNS TRIGGER
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE
    v_name TEXT;
BEGIN
    SELECT name INTO v_name FROM employees WHERE user_id = auth.uid() LIMIT 1;
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_logs(table_name, record_id, action, old_data, changed_by, changed_by_name)
        VALUES (TG_TABLE_NAME, OLD.id::TEXT, TG_OP, to_jsonb(OLD), auth.uid(), v_name);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_logs(table_name, record_id, action, old_data, new_data, changed_by, changed_by_name)
        VALUES (TG_TABLE_NAME, NEW.id::TEXT, TG_OP, to_jsonb(OLD), to_jsonb(NEW), auth.uid(), v_name);
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_logs(table_name, record_id, action, new_data, changed_by, changed_by_name)
        VALUES (TG_TABLE_NAME, NEW.id::TEXT, TG_OP, to_jsonb(NEW), auth.uid(), v_name);
    END IF;
    RETURN COALESCE(NEW, OLD);
END;
$$;

DO $$
DECLARE
    t TEXT;
    audited TEXT[] := ARRAY[
        'clients','vendors','suppliers','products','product_sets','raw_material',
        'operators','orders','order_items','invoices','invoice_items',
        'inventory_transactions','ledger','accounts','account_transactions',
        'account_transfers','receipts','receipt_allocations','disbursements',
        'expense_heads','expenses','procurements','procurement_items','employees'
    ];
BEGIN
    FOREACH t IN ARRAY audited LOOP
        IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename=t) THEN
            EXECUTE format('DROP TRIGGER IF EXISTS trg_audit_%I ON public.%I', t, t);
            EXECUTE format(
                'CREATE TRIGGER trg_audit_%I '
                'AFTER INSERT OR UPDATE OR DELETE ON public.%I '
                'FOR EACH ROW EXECUTE FUNCTION log_audit_event()',
                t, t
            );
        END IF;
    END LOOP;
END $$;

COMMIT;

-- ================================================================
-- VERIFICATION (run manually after setup)
-- ================================================================
-- SELECT name, is_system FROM roles ORDER BY id;
-- SELECT r.name AS role, p.key FROM role_permissions rp
--   JOIN roles r ON r.id = rp.role_id
--   JOIN permissions p ON p.id = rp.permission_id ORDER BY r.name, p.key;
-- SELECT id, name, role, role_id, is_active FROM employees;
-- ================================================================
