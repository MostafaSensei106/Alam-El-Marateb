-- HR module (P6): employees, commission rules, leaves, advances,
-- deductions, payroll runs + lines, attendance logs.
--
-- Commission design note (no sales coupling): the commission kind is
-- FIXED_MONTHLY (flat value paid when the employee is active) or
-- PERCENT_OF_BASE (value % of base_salary). Cross-module reads of sales
-- orders are intentionally avoided (never import another module's repo).

CREATE TABLE commission_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    kind VARCHAR(30) NOT NULL,
    value NUMERIC(12,2) NOT NULL,
    applies_to_category UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_commission_kind CHECK (kind IN ('FIXED_MONTHLY', 'PERCENT_OF_BASE'))
);

CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    job_title VARCHAR(100),
    hire_date DATE,
    base_salary NUMERIC(12,2) NOT NULL DEFAULT 0,
    commission_rule_id UUID REFERENCES commission_rules(id) ON DELETE SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE leave_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    type VARCHAR(30) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    substitute VARCHAR(150),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_leave_status CHECK (status IN ('pending', 'approved', 'rejected')),
    CONSTRAINT ck_leave_dates CHECK (to_date >= from_date)
);

CREATE TABLE advances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    amount NUMERIC(12,2) NOT NULL,
    remaining NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'open',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_advance_status CHECK (status IN ('open', 'closed')),
    CONSTRAINT ck_advance_amount CHECK (amount > 0)
);

CREATE TABLE deductions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    amount NUMERIC(12,2) NOT NULL,
    reason TEXT,
    payroll_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE payroll_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    month VARCHAR(7) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_payroll_status CHECK (status IN ('draft', 'approved', 'paid')),
    CONSTRAINT uq_payroll_branch_month UNIQUE (branch_id, month)
);

CREATE TABLE payroll_lines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    run_id UUID NOT NULL REFERENCES payroll_runs(id) ON DELETE CASCADE,
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    base_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    commission_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    advance_deduction NUMERIC(12,2) NOT NULL DEFAULT 0,
    other_deductions NUMERIC(12,2) NOT NULL DEFAULT 0,
    net_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE attendance_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    type VARCHAR(10) NOT NULL,
    at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT ck_attendance_type CHECK (type IN ('in', 'out'))
);

ALTER TABLE deductions
    ADD CONSTRAINT fk_deductions_payroll
    FOREIGN KEY (payroll_id) REFERENCES payroll_runs(id) ON DELETE SET NULL;

CREATE INDEX idx_employees_user ON employees(user_id);
CREATE INDEX idx_employees_branch ON employees(branch_id);
CREATE INDEX idx_leaves_employee ON leave_requests(employee_id);
CREATE INDEX idx_advances_employee ON advances(employee_id);
CREATE INDEX idx_deductions_employee ON deductions(employee_id);
CREATE INDEX idx_payroll_lines_run ON payroll_lines(run_id);
CREATE INDEX idx_payroll_lines_employee ON payroll_lines(employee_id);
CREATE INDEX idx_attendance_employee ON attendance_logs(employee_id);
