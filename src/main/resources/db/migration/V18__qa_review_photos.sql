-- Q&A + review photos (catalog nice-to-haves).

CREATE TABLE product_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT,
    answered_by VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CONSTRAINT ck_qa_status CHECK (status IN ('pending', 'answered', 'rejected')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE INDEX idx_qa_product ON product_questions(product_id, status);

ALTER TABLE product_reviews ADD COLUMN photo_urls TEXT NOT NULL DEFAULT '';
