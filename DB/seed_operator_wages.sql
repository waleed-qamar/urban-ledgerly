-- ===============================================================
-- LEDGERLY: Populate Operator Wages & Backfill Sheet Rows
-- ===============================================================
-- Run this in Supabase SQL Editor.
-- This script sets each operator's daily wage from the reference sheet
-- and updates existing payroll/overtime sheet rows where per_day is 0.
-- ===============================================================

BEGIN;

-- 1. Ensure the default_per_day column exists on operators
ALTER TABLE public.operators 
ADD COLUMN IF NOT EXISTS default_per_day NUMERIC NOT NULL DEFAULT 0.0;

-- 2. Populate operator wages from reference sheet by worker name
UPDATE public.operators SET default_per_day = 1600 WHERE name ILIKE '%Shahzad Mughal%';
UPDATE public.operators SET default_per_day = 1333 WHERE name ILIKE '%Huzaifa%';
UPDATE public.operators SET default_per_day = 1600 WHERE name ILIKE '%Dildaar%';
UPDATE public.operators SET default_per_day = 1400 WHERE name ILIKE '%Ashraf%';
UPDATE public.operators SET default_per_day = 1600 WHERE name ILIKE '%Shaban Shani%' OR name ILIKE '%Shaban%';
UPDATE public.operators SET default_per_day = 1400 WHERE name ILIKE '%Anayat%';
UPDATE public.operators SET default_per_day = 1400 WHERE name ILIKE '%Abu Huraira%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Umair Khalid%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Basharat%';
UPDATE public.operators SET default_per_day = 1600 WHERE name ILIKE '%Mubeen%';
UPDATE public.operators SET default_per_day = 1600 WHERE name ILIKE '%Faraz%';
UPDATE public.operators SET default_per_day = 1400 WHERE name ILIKE '%Ahmad Ali%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Arslan%';
UPDATE public.operators SET default_per_day = 1600 WHERE name ILIKE '%Mohsin Ali%';
UPDATE public.operators SET default_per_day = 1400 WHERE name ILIKE '%Jamshaid%';
UPDATE public.operators SET default_per_day = 1600 WHERE name ILIKE '%Shoaib%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Shahzaib Mehar%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Majid%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Shahzaib Mairaj%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Waqas%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Sheraaz%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Ali Raza%';
UPDATE public.operators SET default_per_day = 1664 WHERE name ILIKE '%Niyamat%';
UPDATE public.operators SET default_per_day = 1400 WHERE name ILIKE '%Abu Bakar%';
UPDATE public.operators SET default_per_day = 1400 WHERE name ILIKE '%Raza Ali%';
UPDATE public.operators SET default_per_day = 1500 WHERE name ILIKE '%Imran%';
UPDATE public.operators SET default_per_day = 7000 WHERE name ILIKE '%Haji Aslam%';
UPDATE public.operators SET default_per_day = 1000 WHERE name ILIKE '%Naveed%';
UPDATE public.operators SET default_per_day = 1400 WHERE name ILIKE '%Nadeem%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Junaid%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Mudassar%';
UPDATE public.operators SET default_per_day = 1200 WHERE name ILIKE '%Awais Hussain%';

-- 3. Update all existing payroll and overtime rows that currently have per_day = 0
UPDATE public.payroll_rows pr
SET per_day = o.default_per_day
FROM public.operators o
WHERE pr.employee_id = o.id
  AND (pr.per_day = 0 OR pr.per_day IS NULL)
  AND o.default_per_day > 0;

COMMIT;

-- 4. Verification: check that wages are now populated
SELECT id, name, default_per_day FROM public.operators ORDER BY id;

