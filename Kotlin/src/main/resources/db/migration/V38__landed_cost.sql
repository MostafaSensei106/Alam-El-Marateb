-- V38: landed cost per shipment with auditable per-batch allocations.
-- Design: unit_cost stays the NET supplier price (AP reconciliation);
-- landed_unit_cost is the TRUE inventory cost driving COGS + valuation.
-- Allocation rows are INSERT-ONLY (re-runs append, history preserved).
-- Sold units are never restated: their share goes to variance_amount.

-- Link the receiving event to its shipment (nullable: local buys + old receipts).
ALTER TABLE goods_receipts
    ADD COLUMN IF NOT EXISTS shipment_id UUID REFERENCES supplier_shipments(id) ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS idx_receipts_shipment ON goods_receipts(shipment_id);

-- True per-unit cost on the batch (starts equal to net, grows with allocations).
ALTER TABLE inventory_batches
    ADD COLUMN IF NOT EXISTS landed_unit_cost NUMERIC(12, 2) NOT NULL DEFAULT 0;
UPDATE inventory_batches SET landed_unit_cost = unit_cost WHERE landed_unit_cost = 0;
ALTER TABLE inventory_batches
    ADD CONSTRAINT ck_batch_landed CHECK (landed_unit_cost >= 0);

CREATE TABLE shipment_landed_costs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shipment_id UUID NOT NULL REFERENCES supplier_shipments(id) ON DELETE RESTRICT,
    kind VARCHAR(20) NOT NULL,
    amount NUMERIC(12, 2) NOT NULL,
    allocation_method VARCHAR(10) NOT NULL DEFAULT 'BY_VALUE',
    status VARCHAR(10) NOT NULL DEFAULT 'ESTIMATED',
    -- Signed: sold units' share of (final - estimated); negative = over-accrued.
    variance_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    finalized_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_landed_kind CHECK (kind IN ('FREIGHT', 'CUSTOMS', 'INSURANCE', 'HANDLING', 'OTHER')),
    CONSTRAINT ck_landed_amount CHECK (amount > 0),
    CONSTRAINT ck_landed_method CHECK (allocation_method IN ('BY_VALUE', 'BY_QTY')),
    CONSTRAINT ck_landed_status CHECK (status IN ('ESTIMATED', 'FINAL'))
);

-- Append-only allocation detail: which batch absorbed what, and when.
CREATE TABLE shipment_landed_cost_allocations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    landed_cost_id UUID NOT NULL REFERENCES shipment_landed_costs(id) ON DELETE CASCADE,
    batch_id UUID NOT NULL REFERENCES inventory_batches(id) ON DELETE RESTRICT,
    allocated_qty INT NOT NULL,
    -- Signed: finalize runs append positive or negative adjustments.
    allocated_amount NUMERIC(12, 2) NOT NULL,
    allocated_unit_cost NUMERIC(12, 2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_alloc_qty CHECK (allocated_qty >= 0)
);

CREATE INDEX IF NOT EXISTS idx_landed_shipment ON shipment_landed_costs(shipment_id, status);
CREATE INDEX IF NOT EXISTS idx_alloc_cost ON shipment_landed_cost_allocations(landed_cost_id);
CREATE INDEX IF NOT EXISTS idx_alloc_batch ON shipment_landed_cost_allocations(batch_id);
