-- Phase 1: query optimization indexes for the hottest read/write paths.
-- All CREATE INDEX IF NOT EXISTS so the migration is re-runnable and
-- never conflicts with indexes created by earlier modules.

-- Orders: dashboard filters (branch + status + time), payment follow-up.
CREATE INDEX IF NOT EXISTS idx_orders_branch_created ON orders(branch_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_status_created ON orders(status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_payment ON orders(payment_status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_branch_payment ON orders(branch_id, payment_status);

-- Order lines: per-variant drilldowns + order fetch.
CREATE INDEX IF NOT EXISTS idx_order_items_variant ON order_items(variant_id, order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_variant ON order_items(order_id, variant_id);

-- Invoices: order lookup is already UNIQUE(order_id); add serial time scan.
CREATE INDEX IF NOT EXISTS idx_invoices_issued ON invoices(issued_at DESC);

-- Stock moves: velocity queries filter (move_type, created_at) + variant scans.
CREATE INDEX IF NOT EXISTS idx_stock_moves_variant_created ON stock_moves(variant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_stock_moves_type_created ON stock_moves(move_type, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_stock_moves_ref ON stock_moves(ref_type, ref_id);

-- Stock levels: low-stock scan + warehouse variant lookup complement.
CREATE INDEX IF NOT EXISTS idx_stock_levels_low ON stock_levels(warehouse_id, variant_id)
    WHERE min_qty IS NOT NULL;

-- Audit trail: branch + time scans for backoffice.
CREATE INDEX IF NOT EXISTS idx_audit_branch_created ON audit_logs(branch_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_actor ON audit_logs(actor, created_at DESC);

-- Behavior events: beacon reads + retention cleanup (Phase 5 partitions later).
CREATE INDEX IF NOT EXISTS idx_app_events_created ON app_events(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_app_events_actor ON app_events(actor_id, created_at DESC)
    WHERE actor_id IS NOT NULL;

-- Inquiries follow-up: outcome + time.
CREATE INDEX IF NOT EXISTS idx_inquiries_outcome_created ON inquiries(outcome, created_at DESC);

-- CRM lookups.
CREATE INDEX IF NOT EXISTS idx_warranties_status ON warranties(status, covers_until)
    WHERE status IS NOT NULL;

-- Product catalog browsing (public list is the highest-traffic read).
CREATE INDEX IF NOT EXISTS idx_products_category_active ON products(category_id, is_active)
    WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_variants_product_active ON product_variants(product_id, is_active)
    WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_variants_sku ON product_variants(sku);
