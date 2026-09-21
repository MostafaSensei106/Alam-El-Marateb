ALTER TABLE categories RENAME TO product_categories;

CREATE TABLE product_attribute_definitions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    attribute_key VARCHAR(100) NOT NULL UNIQUE,
    attribute_type VARCHAR(20) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE product_attribute_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attribute_id UUID NOT NULL REFERENCES product_attribute_definitions(id) ON DELETE CASCADE,
    option_value VARCHAR(100) NOT NULL,
    label VARCHAR(150) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_product_attribute_option UNIQUE (attribute_id, option_value)
);

CREATE TABLE category_attributes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES product_categories(id) ON DELETE CASCADE,
    attribute_id UUID NOT NULL REFERENCES product_attribute_definitions(id) ON DELETE RESTRICT,
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_category_attribute UNIQUE (category_id, attribute_id)
);

CREATE TABLE product_attribute_values (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    attribute_id UUID NOT NULL REFERENCES product_attribute_definitions(id) ON DELETE RESTRICT,
    value_type VARCHAR(20) NOT NULL,
    value_text TEXT,
    value_number NUMERIC(19, 4),
    value_boolean BOOLEAN,
    value_option_id UUID REFERENCES product_attribute_options(id) ON DELETE RESTRICT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_product_attribute UNIQUE (product_id, attribute_id)
);

CREATE TABLE product_attribute_value_options (
    value_id UUID NOT NULL REFERENCES product_attribute_values(id) ON DELETE CASCADE,
    option_id UUID NOT NULL REFERENCES product_attribute_options(id) ON DELETE RESTRICT,
    CONSTRAINT uk_product_attribute_value_option UNIQUE (value_id, option_id)
);

CREATE TABLE product_presets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES product_categories(id) ON DELETE RESTRICT,
    name VARCHAR(150) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    warranty_years INT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE product_preset_attribute_values (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    preset_id UUID NOT NULL REFERENCES product_presets(id) ON DELETE CASCADE,
    attribute_id UUID NOT NULL REFERENCES product_attribute_definitions(id) ON DELETE RESTRICT,
    value_type VARCHAR(20) NOT NULL,
    value_text TEXT,
    value_number NUMERIC(19, 4),
    value_boolean BOOLEAN,
    value_option_id UUID REFERENCES product_attribute_options(id) ON DELETE RESTRICT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_preset_attribute UNIQUE (preset_id, attribute_id)
);

CREATE TABLE product_preset_attribute_value_options (
    value_id UUID NOT NULL REFERENCES product_preset_attribute_values(id) ON DELETE CASCADE,
    option_id UUID NOT NULL REFERENCES product_attribute_options(id) ON DELETE RESTRICT,
    CONSTRAINT uk_preset_attribute_value_option UNIQUE (value_id, option_id)
);

CREATE TABLE product_preset_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    preset_id UUID NOT NULL REFERENCES product_presets(id) ON DELETE CASCADE,
    width_cm INT NOT NULL,
    length_cm INT NOT NULL,
    height_cm INT NOT NULL,
    cost_price NUMERIC(12, 2) NOT NULL,
    selling_price NUMERIC(12, 2) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_preset_dimensions UNIQUE (preset_id, width_cm, length_cm, height_cm)
);

ALTER TABLE products
    DROP COLUMN product_type,
    DROP COLUMN chassis_type,
    DROP COLUMN feel,
    DROP COLUMN filling,
    DROP COLUMN shape,
    DROP COLUMN gel_infused;

DROP INDEX IF EXISTS idx_products_chassis;

CREATE INDEX idx_product_attribute_values_product ON product_attribute_values(product_id);
CREATE INDEX idx_category_attributes_category ON category_attributes(category_id);
CREATE INDEX idx_product_presets_category ON product_presets(category_id);
