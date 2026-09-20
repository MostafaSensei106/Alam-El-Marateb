-- Brands (nice-to-have, catalog P2) + variant-level EAV + featured flag + catalog seed.

CREATE TABLE brands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(120) NOT NULL,
    slug VARCHAR(140) NOT NULL UNIQUE,
    logo_url TEXT,
    description TEXT,
    sort_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

ALTER TABLE products ADD COLUMN brand_id UUID REFERENCES brands(id) ON DELETE SET NULL;
ALTER TABLE products ADD COLUMN is_featured BOOLEAN NOT NULL DEFAULT FALSE;

-- Backfill: distinct brand names become brand rows, linked by name.
INSERT INTO brands (name, slug)
SELECT DISTINCT brand, lower(regexp_replace(brand, '[^a-zA-Z0-9\u0600-\u06FF]+', '-', 'g'))
FROM products WHERE brand IS NOT NULL AND brand <> ''
ON CONFLICT (slug) DO NOTHING;

UPDATE products p SET brand_id = b.id FROM brands b WHERE b.name = p.brand;

-- Variant-level EAV (arch.md §4.2: products without dimensions).
CREATE TABLE variant_attribute_values (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    attribute_id UUID NOT NULL REFERENCES product_attribute_definitions(id) ON DELETE RESTRICT,
    value_type VARCHAR(20) NOT NULL,
    value_text TEXT,
    value_number NUMERIC(19, 4),
    value_boolean BOOLEAN,
    value_option_id UUID REFERENCES product_attribute_options(id) ON DELETE RESTRICT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uq_variant_attribute UNIQUE (variant_id, attribute_id)
);

-- Seed: real Egyptian-market categories + standard sizes as presets.
INSERT INTO product_categories (name, slug, description) VALUES
    ('مراتب', 'mattresses', 'جميع أنواع المراتب'),
    ('مخدات', 'pillows', 'مخدات وخداديات ومساند'),
    ('كفرات مراتب', 'mattress-covers', 'كفرات حماية وإضافات')
ON CONFLICT (slug) DO NOTHING;

INSERT INTO brands (name, slug, sort_order) VALUES
    ('سيرتا', 'serta', 1),
    ('يانسن', 'yansen', 2),
    ('تاكي', 'taki', 3),
    ('المأمون', 'almamoun', 4),
    ('فوربد', 'forbed', 5)
ON CONFLICT (slug) DO NOTHING;
