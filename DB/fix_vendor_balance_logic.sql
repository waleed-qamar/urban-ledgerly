-- ============================================================
-- ROOT CAUSE:
-- Historical vendor entries have SWAPPED entry_type values.
-- They were entered when Flutter code treated vendor same as
-- client (debit = adds to balance). The Flutter code is now
-- correct (vendor credit = add, vendor debit = subtract), but
-- the old data has inverted entry_types.
--
-- PROOF: balance query returned -21212 for vendor party_id=1.
-- Large negative means debits outweigh credits. abs(-21212)=21212
-- on screen. Adding another debit makes it -22212, abs=22212.
-- User sees the number go UP even though they're paying.
--
-- FIX BELOW: Atomically swap debit <-> credit for all vendor rows.
-- The CHECK constraint allows 'debit' and 'credit' only, so we
-- use a CASE expression to swap in a single UPDATE (no temp value).
-- ============================================================

BEGIN;

-- Atomically swap entry_type for all vendor entries.
-- Old 'debit' (was: vendor billed us) -> becomes 'credit' (correct term)
-- Old 'credit' (was: we paid vendor)  -> becomes 'debit'  (correct term)
UPDATE public.ledger
SET entry_type = CASE
  WHEN entry_type = 'debit'  THEN 'credit'
  WHEN entry_type = 'credit' THEN 'debit'
END
WHERE party_type = 'vendor';

COMMIT;


-- ============================================================
-- VERIFY: Run this after the UPDATE above.
-- Balance should now be POSITIVE (we owe the vendor money).
-- Expected result: something like +21212.00
-- ============================================================
SELECT
  party_id,
  SUM(CASE WHEN entry_type = 'credit' THEN amount ELSE -amount END) AS computed_balance
FROM public.ledger
WHERE party_type = 'vendor'
GROUP BY party_id
ORDER BY party_id;
