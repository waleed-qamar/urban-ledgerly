-- 1. Empty existing TRUNCATE TABLE invoice_items, invoices;

-- ALTER TABLE invoice_items 
-- ADD COLUMN user_id UUID NOT NULL DEFAULT auth.uid() 
-- REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE accounts 
ADD COLUMN user_id UUID NOT NULL DEFAULT auth.uid() 
REFERENCES auth.users(id) ON DELETE CASCADE;



-- 3. Drop the old insecure public policies
DROP POLICY IF EXISTS "Allow public read access on accounts" ON accounts;
DROP POLICY IF EXISTS "Allow public insert access on accounts" ON accounts;
DROP POLICY IF EXISTS "Allow public update access on accounts" ON accounts;
DROP POLICY IF EXISTS "Allow public delete access on accounts" ON accounts;


-- 4. Create new secure RLS policies matching the user's ID
CREATE POLICY "Users can manage their own accounts"
ON accounts FOR ALL 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);


