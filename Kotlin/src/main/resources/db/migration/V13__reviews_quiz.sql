-- Reviews + Quiz (catalog P2 / P5).

CREATE TABLE product_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating SMALLINT NOT NULL CONSTRAINT ck_review_rating CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(150),
    body TEXT,
    verified_purchase BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CONSTRAINT ck_review_status CHECK (status IN ('pending', 'approved', 'rejected')),
    helpful_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uq_review_user_product UNIQUE (user_id, product_id)
);

CREATE INDEX idx_reviews_product ON product_reviews(product_id, status);

-- Quiz: 5-7 questions, weighted dimension scoring (arch.md §9).
CREATE TABLE quiz_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sort_order INT NOT NULL DEFAULT 0,
    text_ar TEXT NOT NULL,
    text_en TEXT,
    dimension VARCHAR(30) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE quiz_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
    label_ar TEXT NOT NULL,
    label_en TEXT,
    scores JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE recommendation_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    answers JSONB NOT NULL DEFAULT '[]',
    results JSONB NOT NULL DEFAULT '[]',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Seed: 6 questions (sleep position, pain, weight, heat, firmness, budget handled via price filter).
INSERT INTO quiz_questions (id, sort_order, text_ar, text_en, dimension) VALUES
    ('11111111-1111-1111-1111-111111111111', 1, 'بتنام على إيه غالباً؟', 'Usual sleep position?', 'support'),
    ('22222222-2222-2222-2222-222222222222', 2, 'عندك ألم في الظهر أو الرقبة؟', 'Back or neck pain?', 'support'),
    ('33333333-3333-3333-3333-333333333333', 3, 'بتحرر بالنوم ولا بتسقع؟', 'Do you sleep hot?', 'cooling'),
    ('44444444-4444-4444-4444-444444444444', 4, 'تحب المرتبة ناشفة ولا طرية؟', 'Preferred firmness?', 'firmness'),
    ('55555555-5555-5555-5555-555555555555', 5, 'وزنك التقريبي؟', 'Approximate weight?', 'support'),
    ('66666666-6666-6666-6666-666666666666', 6, 'تفضل خامة طبيعية (قطن/لاتكس) ولا صناعية؟', 'Natural or synthetic materials?', 'material')
ON CONFLICT (id) DO NOTHING;

INSERT INTO quiz_options (question_id, label_ar, label_en, scores) VALUES
    ('11111111-1111-1111-1111-111111111111', 'على ضهري', 'On back', '{"support": 1}'),
    ('11111111-1111-1111-1111-111111111111', 'على جنبي', 'On side', '{"support": 2, "firmness": -1}'),
    ('11111111-1111-1111-1111-111111111111', 'على بطني', 'On stomach', '{"support": 2, "firmness": 1}'),
    ('22222222-2222-2222-2222-222222222222', 'أيوه، ألم مزمن', 'Yes, chronic', '{"support": 3, "firmness": 1}'),
    ('22222222-2222-2222-2222-222222222222', 'أحياناً', 'Sometimes', '{"support": 1}'),
    ('22222222-2222-2222-2222-222222222222', 'لا', 'No', '{"support": 0}'),
    ('33333333-3333-3333-3333-333333333333', 'بحرر جداً', 'Very hot', '{"cooling": 3}'),
    ('33333333-3333-3333-3333-333333333333', 'عادي', 'Normal', '{"cooling": 0}'),
    ('33333333-3333-3333-3333-333333333333', 'بسقع', 'Cold', '{"cooling": -2}'),
    ('44444444-4444-4444-4444-444444444444', 'ناشفة', 'Firm', '{"firmness": 2}'),
    ('44444444-4444-4444-4444-444444444444', 'وسط', 'Medium', '{"firmness": 0}'),
    ('44444444-4444-4444-4444-444444444444', 'طرية', 'Soft', '{"firmness": -2}'),
    ('55555555-5555-5555-5555-555555555555', 'أقل من 70', 'Under 70kg', '{"support": 0}'),
    ('55555555-5555-5555-5555-555555555555', '70-100', '70-100kg', '{"support": 1, "firmness": 1}'),
    ('55555555-5555-5555-5555-555555555555', 'أكتر من 100', 'Over 100kg', '{"support": 2, "firmness": 1}'),
    ('66666666-6666-6666-6666-666666666666', 'طبيعية', 'Natural', '{"material": 2}'),
    ('66666666-6666-6666-6666-666666666666', 'مش فارقة', 'No preference', '{"material": 0}'),
    ('66666666-6666-6666-6666-666666666666', 'صناعية', 'Synthetic', '{"material": -1}')
ON CONFLICT DO NOTHING;
