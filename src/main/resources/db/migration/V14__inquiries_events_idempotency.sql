-- Inquiries (showroom questions) + behavior events + idempotency store.

CREATE TABLE inquiries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    staff_id UUID REFERENCES users(id) ON DELETE SET NULL,
    product_id UUID REFERENCES products(id) ON DELETE SET NULL,
    variant_id UUID REFERENCES product_variants(id) ON DELETE SET NULL,
    note TEXT,
    outcome VARCHAR(30) NOT NULL DEFAULT 'just_asking'
        CONSTRAINT ck_inquiry_outcome CHECK (outcome IN ('bought_later', 'no_stock', 'price', 'just_asking')),
    customer_phone VARCHAR(20),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE INDEX idx_inquiries_branch ON inquiries(branch_id, created_at);

-- Raw behavior landing (90-day retention) for the beacon endpoint.
CREATE TABLE app_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(80) NOT NULL,
    actor_id UUID REFERENCES users(id) ON DELETE SET NULL,
    anonymous_id VARCHAR(80),
    payload JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_app_events_type ON app_events(type, created_at);

-- Durable idempotency record (api-status.md §1): key -> original outcome.
CREATE TABLE idempotency_keys (
    key VARCHAR(120) PRIMARY KEY,
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    response_code INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
