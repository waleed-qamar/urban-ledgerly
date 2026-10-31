-- ===============================================================
-- LEDGERLY: Complete Payroll & Overtime Schema & RPC Migration (Fixed)
-- ===============================================================

BEGIN;

-- 1. Ensure payroll_sheets table exists with sheet_type column
CREATE TABLE IF NOT EXISTS public.payroll_sheets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company TEXT NOT NULL DEFAULT 'Urban Composites/Urban Constructions',
    category TEXT NOT NULL DEFAULT 'Labour',
    title TEXT NOT NULL,
    cutoff_date DATE NOT NULL,
    sheet_type TEXT NOT NULL DEFAULT 'kharcha' CHECK (sheet_type IN ('kharcha', 'overtime')),
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'finalized')),
    operator_name TEXT NULL,
    amount_given NUMERIC NOT NULL DEFAULT 0.0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT (now() AT TIME ZONE 'utc')
);

-- Ensure sheet_type column exists if table was created previously
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
          AND table_name = 'payroll_sheets' 
          AND column_name = 'sheet_type'
    ) THEN
        ALTER TABLE public.payroll_sheets 
        ADD COLUMN sheet_type TEXT NOT NULL DEFAULT 'kharcha' 
        CHECK (sheet_type IN ('kharcha', 'overtime'));
    END IF;
END $$;

-- 2. Ensure operators table has default_per_day column
ALTER TABLE public.operators 
ADD COLUMN IF NOT EXISTS default_per_day NUMERIC NOT NULL DEFAULT 0.0;

-- 3. Ensure payroll_rows table exists with hours column
CREATE TABLE IF NOT EXISTS public.payroll_rows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sheet_id UUID NOT NULL REFERENCES public.payroll_sheets(id) ON DELETE CASCADE,
    employee_id BIGINT NOT NULL,
    name_snapshot TEXT NOT NULL DEFAULT '',
    sort_order INT NOT NULL DEFAULT 0,
    days NUMERIC NOT NULL DEFAULT 0.0,
    hours NUMERIC NOT NULL DEFAULT 0.0,
    per_day NUMERIC NOT NULL DEFAULT 0.0,
    advance NUMERIC NOT NULL DEFAULT 0.0,
    demand NUMERIC NOT NULL DEFAULT 0.0,
    overtime NUMERIC NOT NULL DEFAULT 0.0,
    overrides JSONB NOT NULL DEFAULT '{}'::jsonb,
    salary NUMERIC NOT NULL DEFAULT 0.0,
    current_amt NUMERIC NOT NULL DEFAULT 0.0,
    payable NUMERIC NOT NULL DEFAULT 0.0,
    total NUMERIC NOT NULL DEFAULT 0.0,
    version INT NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT (now() AT TIME ZONE 'utc')
);

-- Ensure hours column exists if table was created previously
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
          AND table_name = 'payroll_rows' 
          AND column_name = 'hours'
    ) THEN
        ALTER TABLE public.payroll_rows 
        ADD COLUMN hours NUMERIC NOT NULL DEFAULT 0.0;
    END IF;
END $$;

-- 4. Backfill per_day from operators table for any rows where per_day is currently 0
UPDATE public.payroll_rows pr
SET per_day = COALESCE(o.default_per_day, 0.0)
FROM public.operators o
WHERE pr.employee_id = o.id
  AND pr.per_day = 0.0
  AND o.default_per_day > 0.0;

-- 5. Automatic Calculation Trigger for both Kharcha & Overtime
CREATE OR REPLACE FUNCTION public.fn_calculate_payroll_row()
RETURNS TRIGGER AS $$
DECLARE
    v_sheet_type TEXT;
    v_salary NUMERIC;
    v_current NUMERIC;
    v_payable NUMERIC;
    v_total NUMERIC;
    v_day_ot NUMERIC;
    v_hour_ot NUMERIC;
    v_hourly_rate NUMERIC;
BEGIN
    SELECT sheet_type INTO v_sheet_type 
    FROM public.payroll_sheets 
    WHERE id = NEW.sheet_id;

    IF v_sheet_type = 'overtime' THEN
        -- Overtime Calculations:
        -- Hourly Rate = Salary/Day / 8
        IF NEW.per_day > 0 THEN
            v_hourly_rate := NEW.per_day / 8.0;
        ELSE
            v_hourly_rate := 0.0;
        END IF;

        v_day_ot := ROUND(COALESCE(NEW.days, 0) * COALESCE(NEW.per_day, 0), 2);
        v_hour_ot := ROUND(COALESCE(NEW.hours, 0) * v_hourly_rate, 2);
        
        NEW.salary := v_day_ot;
        NEW.overtime := v_hour_ot;

        IF NEW.overrides ? 'payable' AND (NEW.overrides->>'payable') IS NOT NULL THEN
            v_total := (NEW.overrides->>'payable')::numeric;
        ELSIF NEW.overrides ? 'paid_amount' AND (NEW.overrides->>'paid_amount') IS NOT NULL THEN
            v_total := (NEW.overrides->>'paid_amount')::numeric;
        ELSE
            v_total := ROUND(v_day_ot + v_hour_ot, 2);
        END IF;

        NEW.payable := v_total;
        NEW.total := v_total;
        NEW.current_amt := v_total;
    ELSE
        -- Kharcha Calculations:
        IF NEW.overrides ? 'salary' AND (NEW.overrides->>'salary') IS NOT NULL THEN
            v_salary := (NEW.overrides->>'salary')::numeric;
        ELSE
            v_salary := ROUND(COALESCE(NEW.days, 0) * COALESCE(NEW.per_day, 0), 2);
        END IF;
        NEW.salary := v_salary;

        IF NEW.overrides ? 'current' AND (NEW.overrides->>'current') IS NOT NULL THEN
            v_current := (NEW.overrides->>'current')::numeric;
        ELSE
            v_current := ROUND(v_salary - COALESCE(NEW.advance, 0), 2);
        END IF;
        NEW.current_amt := v_current;

        IF NEW.overrides ? 'payable' AND (NEW.overrides->>'payable') IS NOT NULL THEN
            v_payable := (NEW.overrides->>'payable')::numeric;
        ELSE
            v_payable := ROUND(LEAST(COALESCE(NEW.demand, 0), v_current), 2);
        END IF;
        NEW.payable := v_payable;

        IF NEW.overrides ? 'total' AND (NEW.overrides->>'total') IS NOT NULL THEN
            v_total := (NEW.overrides->>'total')::numeric;
        ELSE
            v_total := ROUND(v_payable + COALESCE(NEW.overtime, 0), 2);
        END IF;
        NEW.total := v_total;
    END IF;

    NEW.updated_at := now() AT TIME ZONE 'utc';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_calculate_payroll_row ON public.payroll_rows;
CREATE TRIGGER trg_calculate_payroll_row
BEFORE INSERT OR UPDATE ON public.payroll_rows
FOR EACH ROW EXECUTE FUNCTION public.fn_calculate_payroll_row();

-- 4. Cleanly drop any existing overloaded versions of fn_create_payroll_sheet
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT oid::regprocedure AS func_signature
        FROM pg_proc
        WHERE proname = 'fn_create_payroll_sheet'
          AND pronamespace = 'public'::regnamespace
    ) LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || r.func_signature || ' CASCADE;';
    END LOOP;
END $$;

-- 5. RPC Function accepting p_sheet_type DEFAULT 'kharcha'
CREATE OR REPLACE FUNCTION public.fn_create_payroll_sheet(
    p_company TEXT,
    p_category TEXT,
    p_title TEXT,
    p_cutoff_date DATE,
    p_operator_name TEXT DEFAULT NULL,
    p_amount_given NUMERIC DEFAULT 0.0,
    p_sheet_type TEXT DEFAULT 'kharcha'
)
RETURNS UUID AS $$
DECLARE
    v_sheet_id UUID;
BEGIN
    INSERT INTO public.payroll_sheets (
        company,
        category,
        title,
        cutoff_date,
        operator_name,
        amount_given,
        sheet_type,
        status
    ) VALUES (
        COALESCE(p_company, 'Urban Composites/Urban Constructions'),
        COALESCE(p_category, 'Labour'),
        p_title,
        p_cutoff_date,
        p_operator_name,
        COALESCE(p_amount_given, 0.0),
        COALESCE(p_sheet_type, 'kharcha'),
        'draft'
    ) RETURNING id INTO v_sheet_id;

    -- Automatically seed all active operators
    INSERT INTO public.payroll_rows (
        sheet_id,
        employee_id,
        name_snapshot,
        sort_order,
        days,
        hours,
        per_day,
        advance,
        demand,
        overtime,
        overrides,
        salary,
        current_amt,
        payable,
        total
    )
    SELECT
        v_sheet_id,
        o.id,
        o.name,
        row_number() OVER (ORDER BY o.id),
        0.0,
        0.0,
        COALESCE(o.default_per_day, 0.0),
        0.0,
        0.0,
        0.0,
        '{}'::jsonb,
        0.0,
        0.0,
        0.0,
        0.0
    FROM public.operators o
    WHERE o.is_active = true
    ORDER BY o.id;

    RETURN v_sheet_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Grant access permissions unambiguously specifying argument types
GRANT ALL ON TABLE public.payroll_sheets TO authenticated;
GRANT ALL ON TABLE public.payroll_rows TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_create_payroll_sheet(TEXT, TEXT, TEXT, DATE, TEXT, NUMERIC, TEXT) TO authenticated, anon, service_role;

COMMIT;
