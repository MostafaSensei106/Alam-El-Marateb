-- Phase 5: audit_logs -> monthly RANGE partitions on created_at.
-- Same rebuild pattern as V32 (no inbound FKs; PK becomes (created_at, id)).
-- Retention 365d (audit trails outlive behavior data) via partition drops.

ALTER TABLE audit_logs RENAME TO audit_logs_legacy;
-- Index names are database-global: rename legacy ones so the partitioned
-- table can reuse the canonical names (legacy table is dropped below).
ALTER INDEX IF EXISTS idx_audit_entity RENAME TO idx_audit_entity_legacy;
ALTER INDEX IF EXISTS idx_audit_created RENAME TO idx_audit_created_legacy;
ALTER INDEX IF EXISTS idx_audit_branch_created RENAME TO idx_audit_branch_created_legacy;
ALTER INDEX IF EXISTS idx_audit_actor RENAME TO idx_audit_actor_legacy;

CREATE TABLE audit_logs (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    actor VARCHAR(150),
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entity VARCHAR(100) NOT NULL,
    entity_id UUID,
    details TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT pk_audit_logs PRIMARY KEY (created_at, id)
) PARTITION BY RANGE (created_at);

CREATE INDEX idx_audit_entity ON audit_logs(entity, entity_id);
CREATE INDEX idx_audit_created ON audit_logs(created_at DESC);
CREATE INDEX idx_audit_branch_created ON audit_logs(branch_id, created_at DESC);
CREATE INDEX idx_audit_actor ON audit_logs(actor, created_at DESC);

DO $$
DECLARE
    m DATE := DATE '2026-01-01';
BEGIN
    WHILE m < DATE '2029-01-01' LOOP
        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS %I PARTITION OF audit_logs FOR VALUES FROM (%L) TO (%L)',
            'audit_logs_p' || to_char(m, 'YYYY_MM'), m, m + INTERVAL '1 month'
        );
        m := m + INTERVAL '1 month';
    END LOOP;
END $$;

CREATE TABLE IF NOT EXISTS audit_logs_default PARTITION OF audit_logs DEFAULT;

INSERT INTO audit_logs
    (id, actor, branch_id, action, entity, entity_id, details,
     created_at, updated_at, created_by, updated_by, version)
    SELECT id, actor, branch_id, action, entity, entity_id, details,
        created_at, updated_at, created_by, updated_by, version
    FROM audit_logs_legacy;

DROP TABLE audit_logs_legacy;
