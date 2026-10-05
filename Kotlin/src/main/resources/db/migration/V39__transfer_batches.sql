-- V39: batch-preserving warehouse transfers.
-- A transfer moves the SAME cost layers: dispatch consumes source FIFO,
-- receive mirrors them 1:1 in the destination (no landed recalculation,
-- zero profit). Dispatch layers are staged so partial receives mirror
-- the exact source batches. Both tables are insert-only (auditable).

CREATE TABLE transfer_dispatch_layers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transfer_id UUID NOT NULL REFERENCES stock_transfers(id) ON DELETE CASCADE,
    src_batch_id UUID NOT NULL REFERENCES inventory_batches(id) ON DELETE RESTRICT,
    qty INT NOT NULL,
    unit_cost NUMERIC(12, 2) NOT NULL,
    landed_unit_cost NUMERIC(12, 2) NOT NULL,
    mirrored_qty INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_tdl_qty CHECK (qty > 0),
    CONSTRAINT ck_tdl_mirrored CHECK (mirrored_qty >= 0 AND mirrored_qty <= qty),
    CONSTRAINT ck_tdl_cost CHECK (unit_cost >= 0 AND landed_unit_cost >= 0)
);

CREATE TABLE transfer_batch_links (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transfer_id UUID NOT NULL REFERENCES stock_transfers(id) ON DELETE CASCADE,
    src_batch_id UUID NOT NULL REFERENCES inventory_batches(id) ON DELETE RESTRICT,
    dst_batch_id UUID NOT NULL REFERENCES inventory_batches(id) ON DELETE RESTRICT,
    qty INT NOT NULL,
    unit_cost NUMERIC(12, 2) NOT NULL,
    landed_unit_cost NUMERIC(12, 2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_tbl_qty CHECK (qty > 0),
    CONSTRAINT ck_tbl_cost CHECK (unit_cost >= 0 AND landed_unit_cost >= 0)
);

CREATE INDEX IF NOT EXISTS idx_tdl_transfer ON transfer_dispatch_layers(transfer_id);
CREATE INDEX IF NOT EXISTS idx_tbl_transfer ON transfer_batch_links(transfer_id);
CREATE INDEX IF NOT EXISTS idx_tbl_dst ON transfer_batch_links(dst_batch_id);
