-- V37: harden link ids — every id that joins tables gets a real FK.
-- Verified zero orphans before constraining (po_items, receipt_items).
-- Intentionally-nullable ids (documented, NOT touched):
--   stock_moves.ref_id/ref_type      polymorphic reference (SALE/PO/TRANSFER/...)
--   goods_receipts.receipt linkage   none
--   supplier_payments.invoice_id/installment_id  advance payment before invoice exists
--   purchase_orders.branch_id        central purchase without branch scope yet
--   orders.customer_id/guest_phone   either-or identity (ck_order_customer)

ALTER TABLE po_items
    ADD CONSTRAINT fk_po_items_variant FOREIGN KEY (variant_id)
    REFERENCES product_variants(id) ON DELETE RESTRICT NOT VALID;
ALTER TABLE po_items VALIDATE CONSTRAINT fk_po_items_variant;

ALTER TABLE receipt_items
    ADD CONSTRAINT fk_receipt_items_variant FOREIGN KEY (variant_id)
    REFERENCES product_variants(id) ON DELETE RESTRICT NOT VALID;
ALTER TABLE receipt_items VALIDATE CONSTRAINT fk_receipt_items_variant;

CREATE INDEX IF NOT EXISTS idx_po_items_variant ON po_items(variant_id);
CREATE INDEX IF NOT EXISTS idx_receipt_items_variant ON receipt_items(variant_id);
