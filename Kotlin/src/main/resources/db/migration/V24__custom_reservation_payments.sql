-- Custom sizes, reservation balances, order partial payments.

-- Per-meter price basis for custom-size quoting (EGP per m2).
ALTER TABLE products ADD COLUMN price_per_meter NUMERIC(12, 2);

-- Made-to-order lines skip stock holds (no stock exists yet).
ALTER TABLE order_items ADD COLUMN is_custom BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE order_items ADD COLUMN custom_spec TEXT;

-- Reservation totals: snapshot at booking; paid accumulates via payments.
ALTER TABLE reservations ADD COLUMN total NUMERIC(12, 2) NOT NULL DEFAULT 0;
ALTER TABLE reservations ADD COLUMN paid_amount NUMERIC(12, 2) NOT NULL DEFAULT 0;

CREATE TABLE reservation_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    amount NUMERIC(12, 2) NOT NULL CONSTRAINT ck_respay_amount CHECK (amount > 0),
    method VARCHAR(20) NOT NULL DEFAULT 'CASH',
    paid_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    received_by VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_respay_reservation ON reservation_payments(reservation_id);

-- Partial payments on confirmed orders (custom orders, deposits).
ALTER TABLE orders ADD COLUMN paid_amount NUMERIC(12, 2) NOT NULL DEFAULT 0;
