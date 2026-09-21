-- Phase 2: consumer-side deduplication for at-least-once delivery.
-- Every consumer claims (consumer, event_id) before applying; redeliveries
-- (outbox retry, Kafka rebalance replay) are skipped. Composite PK lets
-- each consumer track the same event independently.
CREATE TABLE consumer_processed_events (
    consumer VARCHAR(80) NOT NULL,
    event_id UUID NOT NULL,
    processed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_consumer_event PRIMARY KEY (consumer, event_id)
);

CREATE INDEX idx_processed_consumer_at ON consumer_processed_events(consumer, processed_at DESC);
