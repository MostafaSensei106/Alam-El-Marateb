-- Phase 5: app_events -> monthly RANGE partitions on created_at.
-- Raw behavior stream (highest write volume). No FKs point INTO this table,
-- so rebuild-by-rename is safe. PK becomes (created_at, id): every PK/UNIQUE
-- on a partitioned table must include the partition key. JPA single-@Id on
-- `id` keeps working (inserts supply created_at via NOW(), deletes by id).
-- Retention (90d) is enforced by dropping whole partitions (fast, no bloat).

ALTER TABLE app_events RENAME TO app_events_legacy;
-- Index names are database-global: rename legacy ones so the partitioned
-- table can reuse the canonical names (legacy table is dropped below).
ALTER INDEX IF EXISTS idx_app_events_type RENAME TO idx_app_events_type_legacy;
ALTER INDEX IF EXISTS idx_app_events_created RENAME TO idx_app_events_created_legacy;
ALTER INDEX IF EXISTS idx_app_events_actor RENAME TO idx_app_events_actor_legacy;

CREATE TABLE app_events (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    type VARCHAR(80) NOT NULL,
    actor_id UUID REFERENCES users(id) ON DELETE SET NULL,
    anonymous_id VARCHAR(80),
    payload JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_app_events PRIMARY KEY (created_at, id)
) PARTITION BY RANGE (created_at);

CREATE INDEX idx_app_events_type ON app_events(type, created_at);
CREATE INDEX idx_app_events_created ON app_events(created_at DESC);
CREATE INDEX idx_app_events_actor ON app_events(actor_id, created_at DESC)
    WHERE actor_id IS NOT NULL;

-- Monthly partitions 2026-01 .. 2028-12 + DEFAULT catch-all for strays
-- (backdated inserts, clock skew). Rolling future handled by RetentionService.
DO $$
DECLARE
    m DATE := DATE '2026-01-01';
BEGIN
    WHILE m < DATE '2029-01-01' LOOP
        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS %I PARTITION OF app_events FOR VALUES FROM (%L) TO (%L)',
            'app_events_p' || to_char(m, 'YYYY_MM'), m, m + INTERVAL '1 month'
        );
        m := m + INTERVAL '1 month';
    END LOOP;
END $$;

CREATE TABLE IF NOT EXISTS app_events_default PARTITION OF app_events DEFAULT;

INSERT INTO app_events (id, type, actor_id, anonymous_id, payload, created_at)
    SELECT id, type, actor_id, anonymous_id, payload, created_at FROM app_events_legacy;

DROP TABLE app_events_legacy;
