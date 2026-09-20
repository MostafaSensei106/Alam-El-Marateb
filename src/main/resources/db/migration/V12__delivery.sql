-- Delivery module: fleet vehicles, trips, stops.
-- NOTE: delivery_zones / carry_up_fees already exist in V6 — not recreated here.

CREATE TABLE vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    plate VARCHAR(20) NOT NULL UNIQUE,
    kind VARCHAR(30),
    capacity_kg INT,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_vehicle_status CHECK (status IN ('active', 'maintenance', 'retired'))
);

CREATE TABLE delivery_trips (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    driver_id UUID NOT NULL,
    vehicle_id UUID NOT NULL REFERENCES vehicles(id) ON DELETE RESTRICT,
    trip_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_trip_status CHECK (status IN ('draft', 'in_transit', 'done', 'cancelled'))
);

CREATE TABLE trip_stops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL REFERENCES delivery_trips(id) ON DELETE CASCADE,
    order_id UUID NOT NULL,
    seq INT NOT NULL,
    "window" VARCHAR(50),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    proof_photo TEXT,
    fail_reason TEXT,
    delivered_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_stop_status CHECK (status IN ('pending', 'delivered', 'failed')),
    CONSTRAINT uk_trip_stop UNIQUE (trip_id, seq),
    CONSTRAINT uk_trip_order UNIQUE (trip_id, order_id)
);

CREATE INDEX idx_vehicles_branch ON vehicles(branch_id);
CREATE INDEX idx_trips_driver ON delivery_trips(driver_id);
CREATE INDEX idx_trips_vehicle ON delivery_trips(vehicle_id);
CREATE INDEX idx_stops_trip ON trip_stops(trip_id);
CREATE INDEX idx_stops_order ON trip_stops(order_id);
