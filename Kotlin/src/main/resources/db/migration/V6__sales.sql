-- Sales module: promotions, carts, orders, invoices, returns,
-- reservations, installments, cash shifts, idempotency,
-- + delivery zones/fees (used by shipping estimate; owned later by delivery).

CREATE TABLE promotions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(60) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    promo_type VARCHAR(20) NOT NULL,
    value_percent NUMERIC(5, 2),
    value_amount NUMERIC(12, 2),
    bundle_price NUMERIC(12, 2),
    target_product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    target_variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE,
    min_cart_total NUMERIC(12, 2),
    starts_at TIMESTAMPTZ,
    ends_at TIMESTAMPTZ,
    max_uses INT,
    used_count INT NOT NULL DEFAULT 0,
    exclusive BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE promotion_bundle_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    promotion_id UUID NOT NULL REFERENCES promotions(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE,
    required_qty INT NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    guest_key VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE cart_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE RESTRICT,
    qty INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_cart_variant UNIQUE (cart_id, variant_id),
    CONSTRAINT ck_cart_qty_positive CHECK (qty > 0)
);

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE RESTRICT,
    customer_id UUID REFERENCES users(id) ON DELETE SET NULL,
    guest_phone VARCHAR(20),
    channel VARCHAR(10) NOT NULL DEFAULT 'pos',
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    payment_method VARCHAR(20),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'unpaid',
    subtotal NUMERIC(12, 2) NOT NULL DEFAULT 0,
    discount_total NUMERIC(12, 2) NOT NULL DEFAULT 0,
    delivery_fee NUMERIC(12, 2) NOT NULL DEFAULT 0,
    carry_up_fee NUMERIC(12, 2) NOT NULL DEFAULT 0,
    grand_total NUMERIC(12, 2) NOT NULL DEFAULT 0,
    delivery_zone_id UUID,
    floor_number INT,
    collect_from_branch BOOLEAN NOT NULL DEFAULT FALSE,
    tracking_number VARCHAR(60) UNIQUE,
    idempotency_key VARCHAR(100) UNIQUE,
    sales_rep_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_order_channel CHECK (channel IN ('pos', 'shop')),
    CONSTRAINT ck_order_status CHECK (status IN ('draft', 'confirmed', 'preparing', 'delivering', 'delivered', 'returned', 'cancelled', 'failed')),
    CONSTRAINT ck_order_customer CHECK (customer_id IS NOT NULL OR guest_phone IS NOT NULL)
);

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE RESTRICT,
    qty INT NOT NULL,
    unit_price NUMERIC(12, 2) NOT NULL,
    discount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    net NUMERIC(12, 2) NOT NULL,
    applied_promo_codes TEXT NOT NULL DEFAULT '',
    is_gift BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_item_qty_positive CHECK (qty > 0)
);

CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL UNIQUE REFERENCES orders(id) ON DELETE CASCADE,
    serial VARCHAR(60) NOT NULL UNIQUE,
    pdf_path TEXT,
    issued_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE returns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE RESTRICT,
    status VARCHAR(20) NOT NULL DEFAULT 'requested',
    reason TEXT NOT NULL,
    refund_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    refund_method VARCHAR(20),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_return_status CHECK (status IN ('requested', 'approved', 'rejected', 'refunded'))
);

CREATE TABLE reservations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE RESTRICT,
    customer_id UUID REFERENCES users(id) ON DELETE SET NULL,
    guest_phone VARCHAR(20),
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE RESTRICT,
    qty INT NOT NULL,
    deposit NUMERIC(12, 2) NOT NULL DEFAULT 0,
    deliver_at DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_res_status CHECK (status IN ('active', 'fulfilled', 'expired', 'cancelled'))
);

CREATE TABLE installment_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE RESTRICT,
    total NUMERIC(12, 2) NOT NULL,
    down_payment NUMERIC(12, 2) NOT NULL DEFAULT 0,
    months INT NOT NULL,
    monthly_amount NUMERIC(12, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE installments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    plan_id UUID NOT NULL REFERENCES installment_plans(id) ON DELETE CASCADE,
    due_date DATE NOT NULL,
    amount NUMERIC(12, 2) NOT NULL,
    paid_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_inst_status CHECK (status IN ('pending', 'paid', 'overdue'))
);

CREATE TABLE cash_shifts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE RESTRICT,
    cashier_id UUID REFERENCES users(id) ON DELETE SET NULL,
    opened_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    opening_balance NUMERIC(12, 2) NOT NULL DEFAULT 0,
    closed_at TIMESTAMPTZ,
    expected_cash NUMERIC(12, 2),
    actual_cash NUMERIC(12, 2),
    status VARCHAR(20) NOT NULL DEFAULT 'open',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_shift_status CHECK (status IN ('open', 'closed'))
);

CREATE TABLE cash_drops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shift_id UUID NOT NULL REFERENCES cash_shifts(id) ON DELETE CASCADE,
    amount NUMERIC(12, 2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100)
);

CREATE TABLE delivery_zones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    governorate VARCHAR(100) NOT NULL,
    area VARCHAR(150) NOT NULL,
    fee NUMERIC(12, 2) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_zone UNIQUE (governorate, area)
);

CREATE TABLE carry_up_fees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    floor_from INT NOT NULL,
    floor_to INT NOT NULL,
    fee NUMERIC(12, 2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE INDEX idx_orders_branch_status ON orders(branch_id, status);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_tracking ON orders(tracking_number);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_cart_customer ON carts(customer_id);
CREATE INDEX idx_promos_active ON promotions(is_active);

INSERT INTO delivery_zones (governorate, area, fee) VALUES
    ('القاهرة', 'مدينة نصر', 100),
    ('القاهرة', 'المعادي', 100),
    ('القاهرة', 'مصر الجديدة', 100),
    ('الجيزة', 'فيصل', 80),
    ('الجيزة', 'الهرم', 80),
    ('الجيزة', 'أكتوبر', 120);

INSERT INTO carry_up_fees (floor_from, floor_to, fee) VALUES
    (1, 2, 50),
    (3, 3, 100),
    (4, 4, 150),
    (5, 99, 200);
