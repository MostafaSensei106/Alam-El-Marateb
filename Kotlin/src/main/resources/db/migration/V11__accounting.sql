-- Accounting module (P6): chart of accounts, journal entries + lines,
-- treasuries + transfers, expenses, checks.

CREATE TABLE chart_of_accounts (
    code VARCHAR(20) PRIMARY KEY,
    name_ar VARCHAR(150) NOT NULL,
    name_en VARCHAR(150),
    type VARCHAR(20) NOT NULL,
    parent_code VARCHAR(20) REFERENCES chart_of_accounts(code) ON DELETE RESTRICT,
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_account_type CHECK (type IN ('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE'))
);

CREATE TABLE journal_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    entry_date DATE NOT NULL,
    source VARCHAR(30) NOT NULL,
    ref VARCHAR(100),
    memo TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE journal_lines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entry_id UUID NOT NULL REFERENCES journal_entries(id) ON DELETE CASCADE,
    account_code VARCHAR(20) NOT NULL REFERENCES chart_of_accounts(code) ON DELETE RESTRICT,
    debit NUMERIC(12,2) NOT NULL DEFAULT 0,
    credit NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_line_side CHECK (debit = 0 OR credit = 0),
    CONSTRAINT ck_line_positive CHECK (debit > 0 OR credit > 0)
);

CREATE TABLE treasuries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    name VARCHAR(150) NOT NULL,
    balance NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE treasury_transfers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_id UUID NOT NULL REFERENCES treasuries(id) ON DELETE RESTRICT,
    to_id UUID NOT NULL REFERENCES treasuries(id) ON DELETE RESTRICT,
    amount NUMERIC(12,2) NOT NULL,
    at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    by_name VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_transfer_amount CHECK (amount > 0),
    CONSTRAINT ck_transfer_distinct CHECK (from_id <> to_id)
);

CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    category VARCHAR(100) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    receipt_photo TEXT,
    approved_by VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_expense_amount CHECK (amount > 0)
);

CREATE TABLE checks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    direction VARCHAR(10) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    due_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'held',
    party VARCHAR(150),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_check_direction CHECK (direction IN ('in', 'out')),
    CONSTRAINT ck_check_amount CHECK (amount > 0),
    CONSTRAINT ck_check_status CHECK (status IN ('held', 'cashed', 'bounced', 'returned'))
);

CREATE INDEX idx_journal_entries_date ON journal_entries(entry_date);
CREATE INDEX idx_journal_entries_branch ON journal_entries(branch_id);
CREATE INDEX idx_journal_lines_entry ON journal_lines(entry_id);
CREATE INDEX idx_journal_lines_account ON journal_lines(account_code);
CREATE INDEX idx_treasuries_branch ON treasuries(branch_id);
CREATE INDEX idx_transfers_from ON treasury_transfers(from_id);
CREATE INDEX idx_transfers_to ON treasury_transfers(to_id);
CREATE INDEX idx_expenses_branch ON expenses(branch_id);
CREATE INDEX idx_checks_status ON checks(status);
CREATE INDEX idx_checks_due ON checks(due_date);

-- Standard Egyptian SME chart seed (prices VAT-inclusive; VAT reported via tax report).
INSERT INTO chart_of_accounts (code, name_ar, name_en, type) VALUES
    ('1010', 'النقدية', 'Cash', 'ASSET'),
    ('1020', 'البنك', 'Bank', 'ASSET'),
    ('1100', 'المخزون', 'Inventory', 'ASSET'),
    ('1200', 'العملاء (ذمم مدينة)', 'Receivables', 'ASSET'),
    ('2010', 'الموردون (ذمم دائنة)', 'Payables', 'LIABILITY'),
    ('2100', 'ضريبة القيمة المضافة مستحقة', 'VAT payable', 'LIABILITY'),
    ('3010', 'رأس المال', 'Capital', 'EQUITY'),
    ('4010', 'المبيعات', 'Sales', 'REVENUE'),
    ('4020', 'رسوم التوصيل', 'Delivery fees', 'REVENUE'),
    ('5010', 'تكلفة البضاعة المباعة', 'COGS', 'EXPENSE'),
    ('5020', 'المرتبات والأجور', 'Salaries', 'EXPENSE'),
    ('5030', 'الإيجار', 'Rent', 'EXPENSE'),
    ('5040', 'المرافق', 'Utilities', 'EXPENSE'),
    ('5090', 'مصاريف أخرى', 'Other expenses', 'EXPENSE')
ON CONFLICT (code) DO NOTHING;
