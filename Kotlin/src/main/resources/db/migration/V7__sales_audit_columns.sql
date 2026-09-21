-- Align V6 sales tables with EntityBase audit columns (validate mode).
-- V6 itself is already applied and must not be edited.

ALTER TABLE carts ADD COLUMN created_by VARCHAR(100), ADD COLUMN updated_by VARCHAR(100);
ALTER TABLE cart_items ADD COLUMN created_by VARCHAR(100), ADD COLUMN updated_by VARCHAR(100);
ALTER TABLE installments ADD COLUMN created_by VARCHAR(100), ADD COLUMN updated_by VARCHAR(100);
ALTER TABLE installment_plans ADD COLUMN created_by VARCHAR(100), ADD COLUMN updated_by VARCHAR(100);
ALTER TABLE invoices ADD COLUMN created_by VARCHAR(100), ADD COLUMN updated_by VARCHAR(100);
ALTER TABLE order_items ADD COLUMN created_by VARCHAR(100), ADD COLUMN updated_by VARCHAR(100);
ALTER TABLE delivery_zones ADD COLUMN created_by VARCHAR(100), ADD COLUMN updated_by VARCHAR(100);
ALTER TABLE carry_up_fees ADD COLUMN created_by VARCHAR(100), ADD COLUMN updated_by VARCHAR(100);
ALTER TABLE cash_drops
    ADD COLUMN updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD COLUMN updated_by VARCHAR(100),
    ADD COLUMN version BIGINT NOT NULL DEFAULT 0;
ALTER TABLE cash_shifts ADD COLUMN created_by VARCHAR(100), ADD COLUMN updated_by VARCHAR(100);
