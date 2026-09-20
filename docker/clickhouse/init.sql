-- ClickHouse star schema for heavy drilldowns (replicated from order events).
-- Phase 5 tuning:
--   * correct database name (alamelmarateb, matching CLICKHOUSE_DB everywhere)
--   * PARTITION BY month -> partition pruning + cheap drops for retention
--   * ORDER BY (branch, day, variant) -> sparse index matches dashboard filters
--   * TTL 3 years on day -> automatic old-data expiry without jobs
CREATE DATABASE IF NOT EXISTS alamelmarateb;

CREATE TABLE IF NOT EXISTS alamelmarateb.order_lines (
    day Date,
    order_id UUID,
    branch_id UUID,
    variant_id UUID,
    qty Int32,
    net Decimal(12, 2),
    cost Decimal(12, 2)
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(day)
ORDER BY (branch_id, day, variant_id)
TTL day + INTERVAL 3 YEAR;
