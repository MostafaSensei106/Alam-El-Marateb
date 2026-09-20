-- Variable pricing tables: per-model meter prices per shape + editable
-- operating brackets (global rows have product_id NULL; model rows override).

CREATE TABLE meter_prices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    shape VARCHAR(20) NOT NULL
        CONSTRAINT ck_meter_shape CHECK (shape IN ('RECT', 'OVAL', 'CIRCLE')),
    price NUMERIC(12, 2) NOT NULL CONSTRAINT ck_meter_price CHECK (price > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uq_meter_price UNIQUE (product_id, shape)
);

CREATE TABLE operating_brackets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    width_from INT NOT NULL,
    width_to INT NOT NULL,
    pct INT NOT NULL CONSTRAINT ck_bracket_pct CHECK (pct >= 0 AND pct <= 100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_bracket_range CHECK (width_from <= width_to)
);

-- Seed: the standard global brackets (product_id NULL = default for all models).
INSERT INTO operating_brackets (product_id, width_from, width_to, pct) VALUES
    (NULL, 90, 100, 24),
    (NULL, 101, 120, 20),
    (NULL, 121, 140, 13),
    (NULL, 141, 160, 8),
    (NULL, 161, 180, 4),
    (NULL, 181, 200, 2),
    (NULL, 201, 210, 0);
