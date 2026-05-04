-- ============================================================
-- Fix: Add invoiced_quantity column to order_items
--
-- This column tracks how many units of each order line item
-- have already been invoiced. It is incremented by the app
-- each time an invoice is generated for that order item.
--
-- Without this column:
--   - invoiced_quantity reads as NULL → 0
--   - remaining always shows full order quantity
--   - invoice quantity tracking never persists
--
-- Run this in the Supabase SQL editor.
-- ============================================================

BEGIN;

-- 1. Add the column (defaults to 0 for all existing rows)
ALTER TABLE public.order_items
  ADD COLUMN IF NOT EXISTS invoiced_quantity DOUBLE PRECISION NOT NULL DEFAULT 0;

-- 2. Verify
SELECT
  oi.id,
  oi.order_id,
  oi.product_id,
  oi.quantity,
  oi.invoiced_quantity,
  GREATEST(oi.quantity - oi.invoiced_quantity, 0) AS remaining_to_invoice
FROM public.order_items oi
ORDER BY oi.order_id, oi.id;

COMMIT;
