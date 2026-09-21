-- Estimator module: saved estimate runs + spin-wheel campaigns.

CREATE TABLE estimate_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    channel VARCHAR(10) NOT NULL DEFAULT 'shop'
        CONSTRAINT ck_estimate_channel CHECK (channel IN ('shop', 'pos')),
    input JSONB NOT NULL DEFAULT '{}',
    result JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_estimate_runs_channel ON estimate_runs(channel, created_at);

-- Spin wheel: a campaign owns up to 6 prizes, runs in a time window.
CREATE TABLE spin_campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL,
    starts_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ends_at TIMESTAMPTZ,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    spins_per_customer INT NOT NULL DEFAULT 1 CONSTRAINT ck_spins_per_customer CHECK (spins_per_customer > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE spin_prizes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL REFERENCES spin_campaigns(id) ON DELETE CASCADE,
    label VARCHAR(150) NOT NULL,
    kind VARCHAR(20) NOT NULL
        CONSTRAINT ck_prize_kind CHECK (kind IN ('PERCENT', 'FIXED', 'GIFT', 'NONE')),
    value NUMERIC(12, 2) NOT NULL DEFAULT 0,
    gift_variant_id UUID REFERENCES product_variants(id) ON DELETE SET NULL,
    weight INT NOT NULL DEFAULT 1 CONSTRAINT ck_prize_weight CHECK (weight > 0),
    max_wins INT CONSTRAINT ck_prize_max_wins CHECK (max_wins IS NULL OR max_wins > 0),
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE spin_plays (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL REFERENCES spin_campaigns(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    prize_id UUID REFERENCES spin_prizes(id) ON DELETE SET NULL,
    won BOOLEAN NOT NULL DEFAULT FALSE,
    promo_code VARCHAR(60),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_spin_plays_campaign_user ON spin_plays(campaign_id, user_id);
