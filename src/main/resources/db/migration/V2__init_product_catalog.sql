CREATE TABLE categories (
                            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                            name VARCHAR(100) NOT NULL,
                            slug VARCHAR(120) NOT NULL UNIQUE,
                            description TEXT,
                            is_active BOOLEAN NOT NULL DEFAULT TRUE,
                            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                            updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                            created_by VARCHAR(100),
                            updated_by VARCHAR(100),
                            version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE products (
                          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                          category_id UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
                          name VARCHAR(150) NOT NULL,
                          slug VARCHAR(180) NOT NULL UNIQUE,
                          brand VARCHAR(100) NOT NULL,
                          chassis_type VARCHAR(50) NOT NULL,
                          feel VARCHAR(50) NOT NULL,
                          fabric_type NOT NULL VARCHAR(100),
                          warranty_years INT NOT NULL DEFAULT 10,
                          description TEXT,
                          is_active BOOLEAN NOT NULL DEFAULT TRUE,
                          created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                          updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                          created_by VARCHAR(100),
                          updated_by VARCHAR(100),
                          version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE product_variants (
                                  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
                                  sku VARCHAR(60) NOT NULL UNIQUE,
                                  barcode VARCHAR(60) UNIQUE,
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
                                  CONSTRAINT uk_product_dimensions UNIQUE (product_id, width_cm, length_cm, height_cm)
);

CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_chassis ON products(chassis_type);
CREATE INDEX idx_variants_barcode ON product_variants(barcode);
CREATE INDEX idx_variants_dimensions ON product_variants(width_cm, length_cm, height_cm);