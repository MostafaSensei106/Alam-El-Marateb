-- V35: distributor economics — price sheets, channel prices, batch cost layers (FIFO),
-- supplier shipments / invoices / installments.
-- Rule: selling price is per-channel current; inventory cost is per-batch immutable.

-- 1. Supplier price sheets (official list per period, never deleted).
CREATE TABLE supplier_price_sheets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_id UUID NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    sheet_no VARCHAR(60) NOT NULL,
    valid_from DATE NOT NULL,
    valid_until DATE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uq_sheet_supplier_no UNIQUE (supplier_id, sheet_no),
    CONSTRAINT ck_sheet_dates CHECK (valid_until IS NULL OR valid_until >= valid_from)
);

CREATE TABLE price_sheet_lines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sheet_id UUID NOT NULL REFERENCES supplier_price_sheets(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE RESTRICT,
    list_cost NUMERIC(12, 2) NOT NULL CONSTRAINT ck_sheet_line_cost CHECK (list_cost >= 0),
    suggested_selling NUMERIC(12, 2) NOT NULL CONSTRAINT ck_sheet_line_sell CHECK (suggested_selling >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uq_sheet_line UNIQUE (sheet_id, variant_id)
);

-- 2. Channel selling prices (history preserved; current = latest effective_from <= now).
CREATE TABLE selling_prices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    channel VARCHAR(20) NOT NULL,
    price NUMERIC(12, 2) NOT NULL CONSTRAINT ck_selling_price CHECK (price >= 0),
    effective_from TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_selling_channel CHECK (channel IN ('PLATFORM', 'STAFF', 'DEALER'))
);

CREATE INDEX idx_selling_variant_channel_time ON selling_prices(variant_id, channel, effective_from DESC);

-- Seed current channel prices from existing variants so old flows keep working.
INSERT INTO selling_prices (variant_id, channel, price, effective_from)
SELECT id, ch, selling_price, NOW()
FROM product_variants, (VALUES ('PLATFORM'), ('STAFF'), ('DEALER')) AS c(ch);

-- 3. Inventory batches: one row per goods receipt line (immutable cost).
CREATE TABLE inventory_batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_no VARCHAR(60) NOT NULL UNIQUE,
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE RESTRICT,
    warehouse_id UUID NOT NULL REFERENCES warehouses(id) ON DELETE RESTRICT,
    receipt_id UUID REFERENCES goods_receipts(id) ON DELETE SET NULL,
    qty_received INT NOT NULL CONSTRAINT ck_batch_received CHECK (qty_received > 0),
    qty_remaining INT NOT NULL CONSTRAINT ck_batch_remaining CHECK (qty_remaining >= 0),
    unit_cost NUMERIC(12, 2) NOT NULL CONSTRAINT ck_batch_cost CHECK (unit_cost >= 0),
    received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE INDEX idx_batches_variant_warehouse ON inventory_batches(variant_id, warehouse_id, received_at);

-- Backfill one batch per existing stock level at variant cost (unknown history = single layer).
INSERT INTO inventory_batches (batch_no, variant_id, warehouse_id, qty_received, qty_remaining, unit_cost, received_at)
SELECT 'MIGR-' || substr(md5(random()::text || clock_timestamp()::text), 1, 12),
    sl.variant_id, sl.warehouse_id, sl.qty, sl.qty, pv.cost_price, NOW()
FROM stock_levels sl
JOIN product_variants pv ON pv.id = sl.variant_id
WHERE sl.qty > 0;

-- 4. Link stock moves to a batch (nullable: old moves + adjustments have none).
ALTER TABLE stock_moves ADD COLUMN IF NOT EXISTS batch_id UUID REFERENCES inventory_batches(id) ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS idx_stock_moves_batch ON stock_moves(batch_id);

-- 5. COGS per order line + FIFO consumption detail.
ALTER TABLE order_items ADD COLUMN IF NOT EXISTS cogs_total NUMERIC(12, 2) NOT NULL DEFAULT 0;

CREATE TABLE order_item_batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_item_id UUID NOT NULL REFERENCES order_items(id) ON DELETE CASCADE,
    batch_id UUID NOT NULL REFERENCES inventory_batches(id) ON DELETE RESTRICT,
    qty INT NOT NULL CONSTRAINT ck_oib_qty CHECK (qty > 0),
    unit_cost NUMERIC(12, 2) NOT NULL CONSTRAINT ck_oib_cost CHECK (unit_cost >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_oib_order_item ON order_item_batches(order_item_id);
CREATE INDEX idx_oib_batch ON order_item_batches(batch_id);

-- 6. Supplier finance split: shipment (logistics) vs invoice (payable) vs installments (schedule).
CREATE TABLE supplier_shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_id UUID NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    shipment_no VARCHAR(60) NOT NULL,
    arrived_at DATE,
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uq_shipment_supplier_no UNIQUE (supplier_id, shipment_no)
);

CREATE TABLE supplier_invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_id UUID NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    invoice_no VARCHAR(60) NOT NULL,
    total NUMERIC(12, 2) NOT NULL CONSTRAINT ck_sinv_total CHECK (total >= 0),
    issued_at DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'confirmed',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uq_sinv_supplier_no UNIQUE (supplier_id, invoice_no),
    CONSTRAINT ck_sinv_status CHECK (status IN ('draft', 'confirmed', 'partial', 'paid', 'cancelled'))
);

CREATE TABLE invoice_shipment_allocations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID NOT NULL REFERENCES supplier_invoices(id) ON DELETE CASCADE,
    shipment_id UUID NOT NULL REFERENCES supplier_shipments(id) ON DELETE RESTRICT,
    amount NUMERIC(12, 2) NOT NULL CONSTRAINT ck_alloc_amount CHECK (amount >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_alloc_invoice_shipment UNIQUE (invoice_id, shipment_id)
);

CREATE TABLE supplier_installments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID NOT NULL REFERENCES supplier_invoices(id) ON DELETE CASCADE,
    amount NUMERIC(12, 2) NOT NULL CONSTRAINT ck_sinst_amount CHECK (amount > 0),
    due_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    paid_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_sinst_status CHECK (status IN ('pending', 'paid', 'overdue'))
);

CREATE TABLE supplier_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_id UUID NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    invoice_id UUID REFERENCES supplier_invoices(id) ON DELETE SET NULL,
    installment_id UUID REFERENCES supplier_installments(id) ON DELETE SET NULL,
    amount NUMERIC(12, 2) NOT NULL CONSTRAINT ck_spay_amount CHECK (amount > 0),
    method VARCHAR(20) NOT NULL DEFAULT 'CASH',
    paid_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ref VARCHAR(120),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE INDEX idx_sinv_supplier ON supplier_invoices(supplier_id, status);
CREATE INDEX idx_sinst_invoice ON supplier_installments(invoice_id, status, due_date);
CREATE INDEX idx_spay_supplier ON supplier_payments(supplier_id, paid_at DESC);
