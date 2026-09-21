-- Phase 1: transactional outbox foundation.
-- Business transaction writes business rows + outbox_events atomically.
-- OutboxRelay polls and publishes to the event transport (in-process now,
-- Kafka in Phase 2). Survives broker outages: nothing is lost on rollback
-- or transport failure.

CREATE TABLE outbox_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aggregate_type VARCHAR(60) NOT NULL,
    aggregate_id UUID,
    type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL DEFAULT '{}',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    attempts INT NOT NULL DEFAULT 0,
    next_attempt_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    published_at TIMESTAMPTZ,
    last_error TEXT,
    CONSTRAINT ck_outbox_status CHECK (status IN ('PENDING', 'PUBLISHED', 'FAILED'))
);

-- Hot poll path: oldest pending first.
CREATE INDEX idx_outbox_pending ON outbox_events(status, next_attempt_at, created_at)
    WHERE status = 'PENDING';
CREATE INDEX idx_outbox_type ON outbox_events(type, created_at);
CREATE INDEX idx_outbox_aggregate ON outbox_events(aggregate_type, aggregate_id);
