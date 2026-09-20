-- ClickHouse star schema for heavy drilldowns (replicated from order events).
CREATE DATABASE IF NOT EXISTS alamelmateb;

CREATE TABLE IF NOT EXISTS alamelmateb.order_lines (
    day Date,
    order_id UUID,
    branch_id UUID,
    variant_id UUID,
    qty Int32,
    net Decimal(12, 2),
    cost Decimal(12, 2)
) ENGINE = MergeTree()
ORDER BY (day, branch_id, variant_id);
