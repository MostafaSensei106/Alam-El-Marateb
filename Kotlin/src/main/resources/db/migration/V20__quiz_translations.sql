-- Quiz translations pattern (same as catalog): rows, not columns.
CREATE TABLE quiz_question_translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
    lang VARCHAR(10) NOT NULL,
    text TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uq_quiz_question_trans UNIQUE (question_id, lang)
);

CREATE TABLE quiz_option_translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    option_id UUID NOT NULL REFERENCES quiz_options(id) ON DELETE CASCADE,
    lang VARCHAR(10) NOT NULL,
    label TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uq_quiz_option_trans UNIQUE (option_id, lang)
);

-- Backfill existing bilingual seed, then drop per-language columns.
INSERT INTO quiz_question_translations (question_id, lang, text)
SELECT id, 'ar', text_ar FROM quiz_questions
ON CONFLICT DO NOTHING;

INSERT INTO quiz_question_translations (question_id, lang, text)
SELECT id, 'en', text_en FROM quiz_questions WHERE text_en IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO quiz_option_translations (option_id, lang, label)
SELECT id, 'ar', label_ar FROM quiz_options
ON CONFLICT DO NOTHING;

INSERT INTO quiz_option_translations (option_id, lang, label)
SELECT id, 'en', label_en FROM quiz_options WHERE label_en IS NOT NULL
ON CONFLICT DO NOTHING;

ALTER TABLE quiz_questions DROP COLUMN text_ar;
ALTER TABLE quiz_questions DROP COLUMN text_en;
ALTER TABLE quiz_options DROP COLUMN label_ar;
ALTER TABLE quiz_options DROP COLUMN label_en;
