package com.mostafasensei.alamelmarateb.modules.hr.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.math.BigDecimal
import java.time.Instant
import java.time.LocalDate
import java.util.UUID

/**
 * HR entities (V10__hr.sql). Money is NUMERIC(12,2) mapped to BigDecimal.
 *
 * NOTE: employees uses a surrogate UUID PK `id` (EntityBase requirement,
 * same pattern as CRM) plus a UNIQUE business key `user_id` -> users(id).
 * All `employee_id` FKs reference employees(id) ON DELETE CASCADE.
 *
 * Commission note: kinds FIXED_MONTHLY (flat value) and PERCENT_OF_BASE
 * (value % of base_salary). No sales coupling by design — HR must never
 * read another module's tables.
 */
@Entity
@Table(name = "commission_rules")
class CommissionRuleJpaEntity(
    @Column(name = "name", nullable = false, length = 100)
    var name: String = "",

    @Column(name = "kind", nullable = false, length = 30)
    var kind: String = "FIXED_MONTHLY",

    @Column(name = "value", nullable = false, precision = 12, scale = 2)
    var value: BigDecimal = BigDecimal.ZERO,

    @Column(name = "applies_to_category", columnDefinition = "UUID")
    var appliesToCategory: UUID? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "employees")
class EmployeeJpaEntity(
    @Column(name = "user_id", nullable = false, unique = true, columnDefinition = "UUID")
    var userId: UUID? = null,

    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "job_title", length = 100)
    var jobTitle: String? = null,

    @Column(name = "hire_date")
    var hireDate: LocalDate? = null,

    @Column(name = "base_salary", nullable = false, precision = 12, scale = 2)
    var baseSalary: BigDecimal = BigDecimal.ZERO,

    @Column(name = "commission_rule_id", columnDefinition = "UUID")
    var commissionRuleId: UUID? = null,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,
) : EntityBase<UUID>()

@Entity
@Table(name = "leave_requests")
class LeaveRequestJpaEntity(
    @Column(name = "employee_id", nullable = false, columnDefinition = "UUID")
    var employeeId: UUID? = null,

    @Column(name = "type", nullable = false, length = 30)
    var type: String = "",

    @Column(name = "from_date", nullable = false)
    var fromDate: LocalDate? = null,

    @Column(name = "to_date", nullable = false)
    var toDate: LocalDate? = null,

    @Column(name = "substitute", length = 150)
    var substitute: String? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "pending",
) : EntityBase<UUID>()

@Entity
@Table(name = "advances")
class AdvanceJpaEntity(
    @Column(name = "employee_id", nullable = false, columnDefinition = "UUID")
    var employeeId: UUID? = null,

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "remaining", nullable = false, precision = 12, scale = 2)
    var remaining: BigDecimal = BigDecimal.ZERO,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "open",
) : EntityBase<UUID>()

@Entity
@Table(name = "deductions")
class DeductionJpaEntity(
    @Column(name = "employee_id", nullable = false, columnDefinition = "UUID")
    var employeeId: UUID? = null,

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "reason", columnDefinition = "TEXT")
    var reason: String? = null,

    @Column(name = "payroll_id", columnDefinition = "UUID")
    var payrollId: UUID? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "payroll_runs")
class PayrollRunJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "month", nullable = false, length = 7)
    var month: String = "",

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "draft",
) : EntityBase<UUID>()

@Entity
@Table(name = "payroll_lines")
class PayrollLineJpaEntity(
    @Column(name = "run_id", nullable = false, columnDefinition = "UUID")
    var runId: UUID? = null,

    @Column(name = "employee_id", nullable = false, columnDefinition = "UUID")
    var employeeId: UUID? = null,

    @Column(name = "base_amount", nullable = false, precision = 12, scale = 2)
    var baseAmount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "commission_amount", nullable = false, precision = 12, scale = 2)
    var commissionAmount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "advance_deduction", nullable = false, precision = 12, scale = 2)
    var advanceDeduction: BigDecimal = BigDecimal.ZERO,

    @Column(name = "other_deductions", nullable = false, precision = 12, scale = 2)
    var otherDeductions: BigDecimal = BigDecimal.ZERO,

    @Column(name = "net_amount", nullable = false, precision = 12, scale = 2)
    var netAmount: BigDecimal = BigDecimal.ZERO,
) : EntityBase<UUID>()

@Entity
@Table(name = "attendance_logs")
class AttendanceLogJpaEntity(
    @Column(name = "employee_id", nullable = false, columnDefinition = "UUID")
    var employeeId: UUID? = null,

    @Column(name = "type", nullable = false, length = 10)
    var type: String = "",

    @Column(name = "at", nullable = false)
    var at: Instant? = null,
) : EntityBase<UUID>()
