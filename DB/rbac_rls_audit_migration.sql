-- ===============================================================
-- LEDGERLY: RBAC + RLS + AUDIT LOG MIGRATION
-- ===============================================================
-- Run this in the Supabase SQL editor for EACH client project.
-- BACK UP YOUR DATABASE FIRST (Supabase Dashboard > Database > Backups,
-- or `pg_dump`) before running this. It alters constraints on tables
-- that currently hold live data.
--
-- What this does:
--   1. Removes the unsafe user_id + ON DELETE CASCADE ownership pattern
--      from business tables (this is what caused your data loss).
--   2. Adds a proper roles / permissions / role_permissions RBAC model
--      that your admin panel can edit without further schema changes.
--   3. Rewrites RLS policies to check permissions instead of hardcoded
--      role names or row ownership.
--   4. Adds a generic audit_logs table + trigger covering all business
--      tables, so every insert/update/delete is recoverable.
-- ===============================================================

BEGIN;

-- ===============================================================
-- SECTION 0: RECONCILE TABLE NAMING
-- ===============================================================
-- Your schema.sql creates "employees" in RLS policies / functions but
-- your supplier.sql-adjacent script created "company_users". Only one
-- should exist. This renames company_users -> employees if needed.
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='company_users')
       AND NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='employees') THEN
        ALTER TABLE company_users RENAME TO employees;
    END IF;
END $$;

-- ===============================================================
-- SECTION 1: REMOVE UNSAFE OWNERSHIP + CASCADE PATTERN
-- ===============================================================
-- Business data belongs to the company, not to the employee who
-- happened to create the row. Attribution (who created it) is kept,
-- but it must never cascade-delete data or gate access.

-- suppliers
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='suppliers' AND column_name='user_id') THEN
        ALTER TABLE suppliers DROP CONSTRAINT IF EXISTS suppliers_user_id_fkey;
        ALTER TABLE suppliers RENAME COLUMN user_id TO created_by;
        ALTER TABLE suppliers ALTER COLUMN created_by DROP NOT NULL;
        ALTER TABLE suppliers ALTER COLUMN created_by DROP DEFAULT;
        ALTER TABLE suppliers ADD CONSTRAINT suppliers_created_by_fkey
            FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;
    END IF;
END $$;

-- accounts
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='accounts' AND column_name='user_id') THEN
        ALTER TABLE accounts DROP CONSTRAINT IF EXISTS accounts_user_id_fkey;
        ALTER TABLE accounts RENAME COLUMN user_id TO created_by;
        ALTER TABLE accounts ALTER COLUMN created_by DROP NOT NULL;
        ALTER TABLE accounts ALTER COLUMN created_by DROP DEFAULT;
        ALTER TABLE accounts ADD CONSTRAINT accounts_created_by_fkey
            FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;
    END IF;
END $$;

-- employees: user_id here is the actual auth login link, so it stays,
-- but deleting the auth user must NEVER delete the employee record.
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='employees' AND column_name='user_id') THEN
        ALTER TABLE employees DROP CONSTRAINT IF EXISTS employees_user_id_fkey;
        ALTER TABLE employees DROP CONSTRAINT IF EXISTS company_users_user_id_fkey;
        ALTER TABLE employees ALTER COLUMN user_id DROP NOT NULL;
        ALTER TABLE employees ADD CONSTRAINT employees_user_id_fkey
            FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;
    END IF;
END $$;

-- Operational rule (not enforceable in schema, but critical):
-- Never hard-delete a row from auth.users. Deactivate the employee
-- (is_active = false) instead. This is the actual root-cause fix;
-- the FK changes above are a safety net if that rule is ever broken.

-- ===============================================================
-- SECTION 2: RBAC SCHEMA
-- ===============================================================

CREATE TABLE IF NOT EXISTS roles (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    is_system BOOLEAN NOT NULL DEFAULT FALSE,  -- system roles can't be deleted from the admin panel
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS permissions (
    id BIGSERIAL PRIMARY KEY,
    module TEXT NOT NULL,      -- e.g. 'clients', 'invoices', 'accounts'
    action TEXT NOT NULL,      -- 'create' | 'read' | 'update' | 'delete'
    key TEXT GENERATED ALWAYS AS (module || '.' || action) STORED UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS role_permissions (
    role_id BIGINT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id BIGINT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- Seed roles. 'master' matches your existing role check constraint;
-- rename its display label to "Owner" in your admin panel UI if you like
-- without touching the schema.
INSERT INTO roles (name, is_system) VALUES ('master', TRUE) ON CONFLICT (name) DO NOTHING;
INSERT INTO roles (name) VALUES ('accountant') ON CONFLICT (name) DO NOTHING;
INSERT INTO roles (name) VALUES ('operator') ON CONFLICT (name) DO NOTHING;

-- Seed one create/read/update/delete permission per business module.
-- Adjust this list if your module set differs.
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

-- master/owner gets everything
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p WHERE r.name = 'master'
ON CONFLICT DO NOTHING;

-- sensible starting defaults -- reconfigure freely from the admin panel afterwards
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p
    ON p.module IN ('clients','vendors','invoices','ledger','accounts','receipts',
                     'disbursements','expenses','orders','products','raw_material','procurements')
WHERE r.name = 'accountant'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p
    ON p.module IN ('orders','inventory','products','raw_material') AND p.action IN ('read','create','update')
WHERE r.name = 'operator'
ON CONFLICT DO NOTHING;

-- Link employees to roles table (keep the old text column for now as a
-- backfill safety net; drop it once you've verified everything works).
ALTER TABLE employees ADD COLUMN IF NOT EXISTS role_id BIGINT REFERENCES roles(id);
UPDATE employees e SET role_id = r.id FROM roles r WHERE r.name = e.role AND e.role_id IS NULL;
-- ALTER TABLE employees ALTER COLUMN role_id SET NOT NULL;   -- uncomment once backfilled and verified
-- ALTER TABLE employees DROP COLUMN role;                    -- uncomment once you're confident

-- ===============================================================
-- SECTION 3: PERMISSION-CHECK FUNCTIONS
-- ===============================================================

CREATE OR REPLACE FUNCTION current_user_has_permission(perm_key TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
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

CREATE OR REPLACE FUNCTION current_user_is_active_employee()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (SELECT 1 FROM employees WHERE user_id = auth.uid() AND is_active = TRUE);
$$;

-- ===============================================================
-- SECTION 4: AUDIT LOG
-- ===============================================================

CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGSERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    action TEXT NOT NULL CHECK (action IN ('INSERT','UPDATE','DELETE')),
    old_data JSONB,
    new_data JSONB,
    changed_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_changed_at ON audit_logs(changed_at);

CREATE OR REPLACE FUNCTION log_audit_event()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_logs(table_name, record_id, action, old_data, changed_by)
        VALUES (TG_TABLE_NAME, OLD.id::TEXT, TG_OP, to_jsonb(OLD), auth.uid());
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_logs(table_name, record_id, action, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, NEW.id::TEXT, TG_OP, to_jsonb(OLD), to_jsonb(NEW), auth.uid());
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_logs(table_name, record_id, action, new_data, changed_by)
        VALUES (TG_TABLE_NAME, NEW.id::TEXT, TG_OP, to_jsonb(NEW), auth.uid());
    END IF;
    RETURN COALESCE(NEW, OLD);
END;
$$;

DO $$
DECLARE
    t_name TEXT;
    audited_tables TEXT[] := ARRAY[
        'clients','vendors','products','raw_material','orders','order_items',
        'invoices','invoice_items','inventory_transactions','ledger','accounts',
        'account_transactions','account_transfers','receipts','receipt_allocations',
        'disbursements','expense_heads','expenses','procurements','employees','suppliers'
    ];
BEGIN
    FOREACH t_name IN ARRAY audited_tables LOOP
        IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename=t_name) THEN
            EXECUTE format('DROP TRIGGER IF EXISTS trg_audit_%I ON %I;', t_name, t_name);
            EXECUTE format(
                'CREATE TRIGGER trg_audit_%I AFTER INSERT OR UPDATE OR DELETE ON %I FOR EACH ROW EXECUTE FUNCTION log_audit_event();',
                t_name, t_name
            );
        END IF;
    END LOOP;
END $$;

-- ===============================================================
-- SECTION 5: RLS -- PERMISSION-BASED POLICIES
-- ===============================================================

-- suppliers
DROP POLICY IF EXISTS "Users can manage their own invoices" ON suppliers;
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename='suppliers' AND schemaname='public' LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON suppliers;', pol.policyname);
    END LOOP;
END $$;
CREATE POLICY "suppliers_select" ON suppliers FOR SELECT TO authenticated USING (current_user_has_permission('suppliers.read'));
CREATE POLICY "suppliers_insert" ON suppliers FOR INSERT TO authenticated WITH CHECK (current_user_has_permission('suppliers.create'));
CREATE POLICY "suppliers_update" ON suppliers FOR UPDATE TO authenticated USING (current_user_has_permission('suppliers.update')) WITH CHECK (current_user_has_permission('suppliers.update'));
CREATE POLICY "suppliers_delete" ON suppliers FOR DELETE TO authenticated USING (current_user_has_permission('suppliers.delete'));

-- accounts
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename='accounts' AND schemaname='public' LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON accounts;', pol.policyname);
    END LOOP;
END $$;
CREATE POLICY "accounts_select" ON accounts FOR SELECT TO authenticated USING (current_user_has_permission('accounts.read'));
CREATE POLICY "accounts_insert" ON accounts FOR INSERT TO authenticated WITH CHECK (current_user_has_permission('accounts.create'));
CREATE POLICY "accounts_update" ON accounts FOR UPDATE TO authenticated USING (current_user_has_permission('accounts.update')) WITH CHECK (current_user_has_permission('accounts.update'));
CREATE POLICY "accounts_delete" ON accounts FOR DELETE TO authenticated USING (current_user_has_permission('accounts.delete'));

-- generic pattern for remaining business tables (module name == table name)
DO $$
DECLARE
    t_name TEXT;
    pol RECORD;
    generic_tables TEXT[] := ARRAY[
        'clients','vendors','products','raw_material','orders','invoices',
        'inventory','ledger','receipts','disbursements','expenses','procurements'
    ];
BEGIN
    FOREACH t_name IN ARRAY generic_tables LOOP
        IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename=t_name) THEN
            FOR pol IN SELECT policyname FROM pg_policies WHERE tablename=t_name AND schemaname='public' LOOP
                EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', pol.policyname, t_name);
            END LOOP;
            EXECUTE format('CREATE POLICY "%I_select" ON %I FOR SELECT TO authenticated USING (current_user_has_permission(''%I.read''));', t_name, t_name, t_name);
            EXECUTE format('CREATE POLICY "%I_insert" ON %I FOR INSERT TO authenticated WITH CHECK (current_user_has_permission(''%I.create''));', t_name, t_name, t_name);
            EXECUTE format('CREATE POLICY "%I_update" ON %I FOR UPDATE TO authenticated USING (current_user_has_permission(''%I.update'')) WITH CHECK (current_user_has_permission(''%I.update''));', t_name, t_name, t_name, t_name);
            EXECUTE format('CREATE POLICY "%I_delete" ON %I FOR DELETE TO authenticated USING (current_user_has_permission(''%I.delete''));', t_name, t_name, t_name);
        END IF;
    END LOOP;
END $$;

-- employees: everyone active can read (needed for dropdowns/attribution),
-- only someone with employees.update permission can manage the roster
DROP POLICY IF EXISTS "Allow users to view employees" ON employees;
DROP POLICY IF EXISTS "Masters can manage employees" ON employees;
CREATE POLICY "employees_select" ON employees FOR SELECT TO authenticated USING (current_user_is_active_employee());
CREATE POLICY "employees_manage" ON employees FOR ALL TO authenticated
    USING (current_user_has_permission('employees.update'))
    WITH CHECK (current_user_has_permission('employees.update'));

-- RBAC + audit tables: readable by active employees, editable only by
-- whoever holds employees.update (i.e. the owner/admin panel)
ALTER TABLE roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE role_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "roles_read" ON roles;
CREATE POLICY "roles_read" ON roles FOR SELECT TO authenticated USING (current_user_is_active_employee());
DROP POLICY IF EXISTS "roles_manage" ON roles;
CREATE POLICY "roles_manage" ON roles FOR ALL TO authenticated
    USING (current_user_has_permission('employees.update')) WITH CHECK (current_user_has_permission('employees.update'));

DROP POLICY IF EXISTS "permissions_read" ON permissions;
CREATE POLICY "permissions_read" ON permissions FOR SELECT TO authenticated USING (current_user_is_active_employee());

DROP POLICY IF EXISTS "role_permissions_read" ON role_permissions;
CREATE POLICY "role_permissions_read" ON role_permissions FOR SELECT TO authenticated USING (current_user_is_active_employee());
DROP POLICY IF EXISTS "role_permissions_manage" ON role_permissions;
CREATE POLICY "role_permissions_manage" ON role_permissions FOR ALL TO authenticated
    USING (current_user_has_permission('employees.update')) WITH CHECK (current_user_has_permission('employees.update'));

-- audit_logs: read-only for admins, no direct writes allowed at all --
-- only the SECURITY DEFINER trigger function can insert into it
DROP POLICY IF EXISTS "audit_logs_read" ON audit_logs;
CREATE POLICY "audit_logs_read" ON audit_logs FOR SELECT TO authenticated USING (current_user_has_permission('employees.update'));

COMMIT;

-- ===============================================================
-- POST-MIGRATION CHECKLIST
-- ===============================================================
-- 1. Confirm `employees` is the correct/only table name (see Section 0).
-- 2. Log in as each existing employee and verify role_id was backfilled
--    correctly: SELECT id, name, role, role_id FROM employees;
-- 3. Once verified, uncomment the NOT NULL / DROP COLUMN lines in
--    Section 2 to fully retire the old text `role` column.
-- 4. Build the admin panel screen against role_permissions -- it should
--    just be a checkbox grid of roles x permissions.
-- 5. From now on: to remove a user's access, set employees.is_active =
--    false. Never delete the row or the auth.users record.
-- ===============================================================
