-- 1. Create a function to quickly get the current user's role
CREATE OR REPLACE FUNCTION get_current_user_role()
RETURNS TEXT
LANGUAGE sql
STABLE
AS $$
  SELECT role FROM employees WHERE user_id = auth.uid() LIMIT 1;
$$;

-- 2. Define policies for the employees table itself
-- Only masters can manage employees
DROP POLICY IF EXISTS "Allow users to view employees" ON employees;
CREATE POLICY "Allow users to view employees"
ON employees FOR SELECT
TO authenticated
USING (true); -- Everyone can view employees (needed for some queries)

DROP POLICY IF EXISTS "Masters can manage employees" ON employees;
CREATE POLICY "Masters can manage employees"
ON employees FOR ALL
TO authenticated
USING (get_current_user_role() = 'master')
WITH CHECK (get_current_user_role() = 'master');

-- 3. Define policies for other key tables (e.g., clients, vendors, receipts, ledger, dps_reports)
-- Pattern: All authenticated users can SELECT and INSERT. Only masters can UPDATE and DELETE.

DO $$
DECLARE
    t_name text;
BEGIN
    FOR t_name IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public' 
          AND tablename != 'employees' -- Exclude employees because we handle it specially
    LOOP
        -- Enable RLS
        EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY;', t_name);

        -- Drop ALL existing policies for the table to prevent OR logic conflicts
        DECLARE
            pol record;
        BEGIN
            FOR pol IN 
                SELECT policyname 
                FROM pg_policies 
                WHERE tablename = t_name AND schemaname = 'public'
            LOOP
                EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', pol.policyname, t_name);
            END LOOP;
        END;

        -- SELECT Policy: All authenticated users
        EXECUTE format('DROP POLICY IF EXISTS "%I_select_policy" ON %I;', t_name, t_name);
        EXECUTE format('CREATE POLICY "%I_select_policy" ON %I FOR SELECT TO authenticated USING (true);', t_name, t_name);

        -- INSERT Policy: All authenticated users (accountant and master)
        EXECUTE format('DROP POLICY IF EXISTS "%I_insert_policy" ON %I;', t_name, t_name);
        EXECUTE format('CREATE POLICY "%I_insert_policy" ON %I FOR INSERT TO authenticated WITH CHECK (true);', t_name, t_name);

        -- UPDATE Policy: Master and Accountant (any registered employee)
        EXECUTE format('DROP POLICY IF EXISTS "%I_update_policy" ON %I;', t_name, t_name);
        EXECUTE format('CREATE POLICY "%I_update_policy" ON %I FOR UPDATE TO authenticated USING (get_current_user_role() IN (''master'', ''accountant'')) WITH CHECK (get_current_user_role() IN (''master'', ''accountant''));', t_name, t_name);

        -- DELETE Policy: Only master
        EXECUTE format('DROP POLICY IF EXISTS "%I_delete_policy" ON %I;', t_name, t_name);
        EXECUTE format('CREATE POLICY "%I_delete_policy" ON %I FOR DELETE TO authenticated USING (get_current_user_role() = ''master'');', t_name, t_name);
    END LOOP;
END $$;
