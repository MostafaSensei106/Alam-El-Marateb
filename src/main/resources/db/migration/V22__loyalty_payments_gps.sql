-- Loyalty, payment intents, GPS tracking, driver ratings.

-- Loyalty accounts + immutable ledger.
CREATE TABLE loyalty_accounts (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    points INT NOT NULL DEFAULT 0 CONSTRAINT ck_loyalty_points CHECK (points >= 0),
    lifetime_earned INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE loyalty_ledger (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    delta INT NOT NULL CONSTRAINT ck_loyalty_delta CHECK (delta <> 0),
    reason VARCHAR(40) NOT NULL,
    balance_after INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loyalty_ledger_user ON loyalty_ledger(user_id, created_at);

-- Payment intents (gateway-agnostic; providers plug in per gateway name).
CREATE TABLE payment_intents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    gateway VARCHAR(20) NOT NULL,
    amount NUMERIC(12, 2) NOT NULL CONSTRAINT ck_intent_amount CHECK (amount > 0),
    currency VARCHAR(10) NOT NULL DEFAULT 'EGP',
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CONSTRAINT ck_intent_status CHECK (status IN ('pending', 'authorized', 'captured', 'failed', 'cancelled', 'refunded')),
    provider_ref VARCHAR(160) UNIQUE,
    payload JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE INDEX idx_intents_order ON payment_intents(order_id, status);

-- GPS trail (driver pushes, customer reads latest via tracking).
CREATE TABLE trip_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL REFERENCES delivery_trips(id) ON DELETE CASCADE,
    lat DOUBLE PRECISION NOT NULL CONSTRAINT ck_loc_lat CHECK (lat BETWEEN -90 AND 90),
    lng DOUBLE PRECISION NOT NULL CONSTRAINT ck_loc_lng CHECK (lng BETWEEN -180 AND 180),
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_trip_locations_trip ON trip_locations(trip_id, recorded_at DESC);

ALTER TABLE trip_stops ADD COLUMN lat DOUBLE PRECISION;
ALTER TABLE trip_stops ADD COLUMN lng DOUBLE PRECISION;

-- Driver ratings from customers after successful handover.
CREATE TABLE driver_ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    driver_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating SMALLINT NOT NULL CONSTRAINT ck_driver_rating CHECK (rating BETWEEN 1 AND 5),
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_driver_rating_order UNIQUE (order_id)
);
