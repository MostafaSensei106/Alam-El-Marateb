-- Purchasing module: suppliers, purchase orders + items, goods receipts + items.
-- Flow: suppliers -> purchase_orders (+po_items, draft) -> sent -> goods_receipts
-- (+receipt_items, one row per batch) -> stock_moves (PURCHASE) -> partial/closed.

CREATE TABLE suppliers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(30),
    address TEXT,
    tax_id VARCHAR(50),
    balance NUMERIC(12,2) NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE purchase_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_id UUID NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    total NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_po_status CHECK (status IN ('draft', 'sent', 'partial', 'closed', 'cancelled'))
);

CREATE TABLE po_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    po_id UUID NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL,
    qty INT NOT NULL,
    unit_cost NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_po_item_qty_positive CHECK (qty > 0),
    CONSTRAINT ck_po_item_cost_non_negative CHECK (unit_cost >= 0)
);

CREATE TABLE goods_receipts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    po_id UUID NOT NULL REFERENCES purchase_orders(id) ON DELETE RESTRICT,
    warehouse_id UUID NOT NULL REFERENCES warehouses(id) ON DELETE RESTRICT,
    received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    received_by VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE receipt_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    receipt_id UUID NOT NULL REFERENCES goods_receipts(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL,
    expected_qty INT NOT NULL,
    actual_qty INT NOT NULL DEFAULT 0,
    damaged_qty INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_receipt_expected_non_negative CHECK (expected_qty >= 0),
    CONSTRAINT ck_receipt_actual_non_negative CHECK (actual_qty >= 0),
    CONSTRAINT ck_receipt_damaged_non_negative CHECK (damaged_qty >= 0)
);

CREATE INDEX idx_po_supplier ON purchase_orders(supplier_id);
CREATE INDEX idx_po_branch ON purchase_orders(branch_id);
CREATE INDEX idx_po_status ON purchase_orders(status);
CREATE INDEX idx_po_items_po ON po_items(po_id);
CREATE INDEX idx_receipts_po ON goods_receipts(po_id);
CREATE INDEX idx_receipts_warehouse ON goods_receipts(warehouse_id);
CREATE INDEX idx_receipt_items_receipt ON receipt_items(receipt_id);
