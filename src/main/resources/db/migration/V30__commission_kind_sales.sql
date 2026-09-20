-- Align commission kind constraint with HrService.KIND_SALES (PERCENT_OF_SALES)
-- used by payroll commission. V10 only allowed FIXED_MONTHLY/PERCENT_OF_BASE
-- while code + HrFlowTest write PERCENT_OF_SALES. New migration (never edit V10).
ALTER TABLE commission_rules DROP CONSTRAINT IF EXISTS ck_commission_kind;
ALTER TABLE commission_rules ADD CONSTRAINT ck_commission_kind
    CHECK (kind IN ('FIXED_MONTHLY', 'PERCENT_OF_BASE', 'PERCENT_OF_SALES'));
