-- notification_outbox missed the audit user columns (EntityBase requires them).
ALTER TABLE notification_outbox ADD COLUMN created_by VARCHAR(100);
ALTER TABLE notification_outbox ADD COLUMN updated_by VARCHAR(100);
