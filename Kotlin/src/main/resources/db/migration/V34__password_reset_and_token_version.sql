-- Phase: auth hardening (skills: auth-implementation-patterns,
-- broken-authentication §10, backend-security-coder).
-- 1. users.token_version: bumped on password change/reset -> all previously
--    issued access+refresh tokens are rejected (logout-everywhere without a
--    token table; version travels inside the JWT `tv` claim).
-- 2. password_reset_tokens: single-use, expiry-bound, account-bound reset
--    tokens. Only the SHA-256 hash is stored (leaked DB dump != usable token).

ALTER TABLE users ADD COLUMN IF NOT EXISTS token_version INT NOT NULL DEFAULT 0;

CREATE TABLE password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(64) NOT NULL UNIQUE,
    expires_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_reset_tokens_user ON password_reset_tokens(user_id, expires_at);
