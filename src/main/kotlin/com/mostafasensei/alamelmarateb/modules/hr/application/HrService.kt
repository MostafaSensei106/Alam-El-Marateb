package com.mostafasensei.alamelmarateb.modules.hr.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.hr.data.repository.AdvanceRepository
import com.mostafasensei.alamelmarateb.modules.hr.data.repository.AttendanceLogRepository
import com.mostafasensei.alamelmarateb.modules.hr.data.repository.CommissionRuleRepository
import com.mostafasensei.alamelmarateb.modules.hr.data.repository.DeductionRepository
import com.mostafasensei.alamelmarateb.modules.hr.data.repository.EmployeeRepository
import com.mostafasensei.alamelmarateb.modules.hr.data.repository.LeaveRequestRepository
import com.mostafasensei.alamelmarateb.modules.hr.data.repository.PayrollLineRepository
import com.mostafasensei.alamelmarateb.modules.hr.data.repository.PayrollRunRepository
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.AdvanceJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.AttendanceLogJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.CommissionRuleJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.DeductionJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.EmployeeJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.LeaveRequestJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.PayrollLineJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.PayrollRunJpaEntity
import com.mostafasensei.alamelmarateb.modules.security.data.repository.UserRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.Instant
import java.time.LocalDate
import java.util.UUID

data class EmployeeView(
    val id: UUID?,
    val userId: UUID?,
    val branchId: UUID?,
    val jobTitle: String?,
    val hireDate: LocalDate?,
    val baseSalary: BigDecimal,
    val commissionRuleId: UUID?,
    val isActive: Boolean,
)

data class CommissionRuleView(
    val id: UUID?,
    val name: String,
    val kind: String,
    val value: BigDecimal,
    val appliesToCategory: UUID?,
)

data class LeaveView(
    val id: UUID?,
    val employeeId: UUID?,
    val type: String,
    val fromDate: LocalDate?,
    val toDate: LocalDate?,
    val substitute: String?,
    val status: String,
)

data class AdvanceView(
    val id: UUID?,
    val employeeId: UUID?,
    val amount: BigDecimal,
    val remaining: BigDecimal,
    val status: String,
)

data class DeductionView(
    val id: UUID?,
    val employeeId: UUID?,
    val amount: BigDecimal,
    val reason: String?,
    val payrollId: UUID?,
)

data class PayrollLineView(
    val id: UUID?,
    val runId: UUID?,
    val employeeId: UUID?,
    val baseAmount: BigDecimal,
    val commissionAmount: BigDecimal,
    val advanceDeduction: BigDecimal,
    val otherDeductions: BigDecimal,
    val netAmount: BigDecimal,
)

data class PayrollRunView(
    val id: UUID?,
    val branchId: UUID?,
    val month: String,
    val status: String,
    val lines: List<PayrollLineView> = emptyList(),
)

data class AttendanceView(
    val id: UUID?,
    val employeeId: UUID?,
    val type: String,
    val at: Instant?,
)

@Service
class HrService(
    private val employeeRepository: EmployeeRepository,
    private val commissionRuleRepository: CommissionRuleRepository,
    private val leaveRepository: LeaveRequestRepository,
    private val advanceRepository: AdvanceRepository,
    private val deductionRepository: DeductionRepository,
    private val payrollRunRepository: PayrollRunRepository,
    private val payrollLineRepository: PayrollLineRepository,
    private val attendanceRepository: AttendanceLogRepository,
    private val userRepository: UserRepository,
) {

    companion object {
        const val KIND_FIXED = "FIXED_MONTHLY"
        const val KIND_PERCENT = "PERCENT_OF_BASE"
    }

    private fun money(value: BigDecimal): BigDecimal =
        value.setScale(2, RoundingMode.HALF_UP)

    // ---- Employees ----

    @Transactional
    fun createEmployee(
        userId: UUID, branchId: UUID?, jobTitle: String?, hireDate: LocalDate?,
        baseSalary: BigDecimal, commissionRuleId: UUID?,
    ): EmployeeView {
        userRepository.findById(userId) ?: throw NotFoundException("error.hr.user_not_found")
        if (employeeRepository.existsByUserId(userId)) {
            throw ConflictException("error.hr.employee_exists")
        }
        if (commissionRuleId != null && !commissionRuleRepository.existsById(commissionRuleId)) {
            throw NotFoundException("error.hr.commission_not_found")
        }
        val saved = employeeRepository.save(
            EmployeeJpaEntity(
                userId = userId, branchId = branchId, jobTitle = jobTitle, hireDate = hireDate,
                baseSalary = money(baseSalary), commissionRuleId = commissionRuleId,
            ),
        )
        return toView(saved)
    }

    @Transactional(readOnly = true)
    fun getEmployee(id: UUID): EmployeeView =
        toView(employeeRepository.findById(id).orElseThrow { NotFoundException("error.hr.employee_not_found") })

    @Transactional(readOnly = true)
    fun listEmployees(branchId: UUID?): List<EmployeeView> {
        val entities = if (branchId != null) employeeRepository.findByBranchId(branchId)
        else employeeRepository.findAll()
        return entities.map { toView(it) }
    }

    @Transactional(readOnly = true)
    fun searchEmployees(branchId: UUID?, q: String?): List<EmployeeView> =
        listEmployees(branchId).filter { q.isNullOrBlank() || it.jobTitle?.contains(q, ignoreCase = true) == true }

    @Transactional
    fun updateEmployee(
        id: UUID, branchId: UUID?, jobTitle: String?, hireDate: LocalDate?,
        baseSalary: BigDecimal?, commissionRuleId: UUID?, isActive: Boolean?,
    ): EmployeeView {
        val entity = employeeRepository.findById(id).orElseThrow { NotFoundException("error.hr.employee_not_found") }
        if (branchId != null) entity.branchId = branchId
        if (jobTitle != null) entity.jobTitle = jobTitle
        if (hireDate != null) entity.hireDate = hireDate
        if (baseSalary != null) entity.baseSalary = money(baseSalary)
        if (commissionRuleId != null) {
            if (!commissionRuleRepository.existsById(commissionRuleId)) {
                throw NotFoundException("error.hr.commission_not_found")
            }
            entity.commissionRuleId = commissionRuleId
        }
        if (isActive != null) entity.isActive = isActive
        return toView(employeeRepository.save(entity))
    }

    @Transactional
    fun deleteEmployee(id: UUID) {
        val entity = employeeRepository.findById(id).orElseThrow { NotFoundException("error.hr.employee_not_found") }
        employeeRepository.delete(entity)
    }

    private fun requireEmployee(id: UUID): EmployeeJpaEntity =
        employeeRepository.findById(id).orElseThrow { NotFoundException("error.hr.employee_not_found") }

    private fun requireEmployeeByUser(userId: UUID): EmployeeJpaEntity =
        employeeRepository.findByUserId(userId).orElseThrow { NotFoundException("error.hr.employee_not_found") }

    @Transactional(readOnly = true)
    fun employeeIdForUser(userId: UUID): UUID =
        requireEmployeeByUser(userId).id!!

    // ---- Commission rules ----

    @Transactional
    fun createRule(name: String, kind: String, value: BigDecimal, appliesToCategory: UUID?): CommissionRuleView {
        if (kind != KIND_FIXED && kind != KIND_PERCENT) throw BadRequestException("error.hr.commission_not_found", listOf(kind))
        val saved = commissionRuleRepository.save(
            CommissionRuleJpaEntity(name = name, kind = kind, value = money(value), appliesToCategory = appliesToCategory),
        )
        return toRuleView(saved)
    }

    @Transactional(readOnly = true)
    fun listRules(): List<CommissionRuleView> =
        commissionRuleRepository.findAll().map { toRuleView(it) }

    @Transactional(readOnly = true)
    fun getRule(id: UUID): CommissionRuleView =
        toRuleView(commissionRuleRepository.findById(id).orElseThrow { NotFoundException("error.hr.commission_not_found") })

    @Transactional
    fun updateRule(id: UUID, name: String?, kind: String?, value: BigDecimal?): CommissionRuleView {
        val entity = commissionRuleRepository.findById(id).orElseThrow { NotFoundException("error.hr.commission_not_found") }
        if (name != null) entity.name = name
        if (kind != null) {
            if (kind != KIND_FIXED && kind != KIND_PERCENT) throw BadRequestException("error.hr.commission_not_found", listOf(kind))
            entity.kind = kind
        }
        if (value != null) entity.value = money(value)
        return toRuleView(commissionRuleRepository.save(entity))
    }

    @Transactional
    fun deleteRule(id: UUID) {
        val entity = commissionRuleRepository.findById(id).orElseThrow { NotFoundException("error.hr.commission_not_found") }
        commissionRuleRepository.delete(entity)
    }

    // ---- Leaves ----

    @Transactional
    fun requestLeave(
        employeeId: UUID, type: String, fromDate: LocalDate, toDate: LocalDate, substitute: String?,
    ): LeaveView {
        requireEmployee(employeeId)
        if (toDate.isBefore(fromDate)) throw BadRequestException("error.hr.leave_dates")
        val saved = leaveRepository.save(
            LeaveRequestJpaEntity(
                employeeId = employeeId, type = type, fromDate = fromDate, toDate = toDate,
                substitute = substitute, status = "pending",
            ),
        )
        return toLeaveView(saved)
    }

    @Transactional
    fun leaveAction(id: UUID, action: String): LeaveView {
        val entity = leaveRepository.findById(id).orElseThrow { NotFoundException("error.hr.leave_not_found") }
        if (entity.status != "pending") throw ConflictException("error.hr.leave_status", listOf(entity.status))
        entity.status = when (action.lowercase()) {
            "approve", "approved" -> "approved"
            "reject", "rejected" -> "rejected"
            else -> throw BadRequestException("error.hr.leave_status", listOf(action))
        }
        return toLeaveView(leaveRepository.save(entity))
    }

    @Transactional(readOnly = true)
    fun listLeaves(employeeId: UUID?): List<LeaveView> {
        val entities = if (employeeId != null) leaveRepository.findByEmployeeId(employeeId)
        else leaveRepository.findAll()
        return entities.map { toLeaveView(it) }
    }

    // ---- Advances ----

    @Transactional
    fun createAdvance(employeeId: UUID, amount: BigDecimal): AdvanceView {
        requireEmployee(employeeId)
        if (amount <= BigDecimal.ZERO) throw BadRequestException("error.hr.advance_amount")
        val scaled = money(amount)
        val saved = advanceRepository.save(
            AdvanceJpaEntity(employeeId = employeeId, amount = scaled, remaining = scaled, status = "open"),
        )
        return toAdvanceView(saved)
    }

    @Transactional(readOnly = true)
    fun listAdvances(employeeId: UUID?): List<AdvanceView> {
        val entities = if (employeeId != null) advanceRepository.findByEmployeeId(employeeId)
        else advanceRepository.findAll()
        return entities.map { toAdvanceView(it) }
    }

    @Transactional(readOnly = true)
    fun getAdvance(id: UUID): AdvanceView =
        toAdvanceView(advanceRepository.findById(id).orElseThrow { NotFoundException("error.hr.advance_not_found") })

    // ---- Deductions ----

    @Transactional
    fun createDeduction(employeeId: UUID, amount: BigDecimal, reason: String?): DeductionView {
        requireEmployee(employeeId)
        val saved = deductionRepository.save(
            DeductionJpaEntity(employeeId = employeeId, amount = money(amount), reason = reason),
        )
        return toDeductionView(saved)
    }

    @Transactional(readOnly = true)
    fun listDeductions(employeeId: UUID?): List<DeductionView> {
        val entities = if (employeeId != null) deductionRepository.findByEmployeeId(employeeId)
        else deductionRepository.findAll()
        return entities.map { toDeductionView(it) }
    }

    @Transactional(readOnly = true)
    fun getDeduction(id: UUID): DeductionView =
        toDeductionView(deductionRepository.findById(id).orElseThrow { NotFoundException("error.hr.deduction_not_found") })

    // ---- Payroll ----

    @Transactional
    fun calculate(branchId: UUID, month: String): PayrollRunView {
        val employees = employeeRepository.findByBranchIdAndIsActiveTrue(branchId)
        if (employees.isEmpty()) throw BadRequestException("error.hr.payroll_empty")

        val existing = payrollRunRepository.findByBranchIdAndMonth(branchId, month)
        val run = if (existing.isPresent) {
            val current = existing.get()
            if (current.status != "draft") throw ConflictException("error.hr.payroll_status", listOf(current.status))
            payrollLineRepository.deleteByRunId(current.id!!)
            payrollLineRepository.flush()
            current
        } else {
            payrollRunRepository.save(PayrollRunJpaEntity(branchId = branchId, month = month, status = "draft"))
        }

        val lines = employees.map { employee ->
            val base = money(employee.baseSalary)
            val commission = commissionFor(employee, base)
            val gross = base.add(commission)

            var advanceTaken = BigDecimal.ZERO
            var budget = gross
            for (advance in advanceRepository.findByEmployeeIdAndStatusOrderByCreatedAtAsc(employee.id!!, "open")) {
                if (budget <= BigDecimal.ZERO) break
                if (advance.remaining <= BigDecimal.ZERO) continue
                val take = advance.remaining.min(budget)
                advance.remaining = money(advance.remaining.subtract(take))
                if (advance.remaining <= BigDecimal.ZERO) {
                    advance.remaining = money(BigDecimal.ZERO)
                    advance.status = "closed"
                }
                advanceRepository.save(advance)
                advanceTaken = advanceTaken.add(take)
                budget = budget.subtract(take)
            }
            advanceTaken = money(advanceTaken)

            val pending = deductionRepository.findByEmployeeIdAndPayrollIdIsNull(employee.id!!)
            var other = BigDecimal.ZERO
            for (deduction in pending) {
                other = other.add(deduction.amount)
                deduction.payrollId = run.id
                deductionRepository.save(deduction)
            }
            other = money(other)

            val net = money(gross.subtract(advanceTaken).subtract(other))
            toLineView(
                payrollLineRepository.save(
                    PayrollLineJpaEntity(
                        runId = run.id, employeeId = employee.id,
                        baseAmount = base, commissionAmount = commission,
                        advanceDeduction = advanceTaken, otherDeductions = other, netAmount = net,
                    ),
                ),
            )
        }
        return toRunView(run, lines)
    }

    @Transactional
    fun approveRun(id: UUID): PayrollRunView {
        val run = payrollRunRepository.findById(id).orElseThrow { NotFoundException("error.hr.payroll_not_found") }
        if (run.status != "draft") throw ConflictException("error.hr.payroll_status", listOf(run.status))
        run.status = "approved"
        val saved = payrollRunRepository.save(run)
        return toRunView(saved, payrollLineRepository.findByRunId(saved.id!!).map { toLineView(it) })
    }

    @Transactional(readOnly = true)
    fun exportCsv(id: UUID): String {
        val run = payrollRunRepository.findById(id).orElseThrow { NotFoundException("error.hr.payroll_not_found") }
        val lines = payrollLineRepository.findByRunId(run.id!!)
        val rows = StringBuilder("employee_id,base_amount,commission_amount,advance_deduction,other_deductions,net_amount\n")
        for (line in lines) {
            rows.append(
                listOf(
                    line.employeeId.toString(), line.baseAmount.toPlainString(),
                    line.commissionAmount.toPlainString(), line.advanceDeduction.toPlainString(),
                    line.otherDeductions.toPlainString(), line.netAmount.toPlainString(),
                ).joinToString(","),
            ).append('\n')
        }
        return rows.toString()
    }

    private fun commissionFor(employee: EmployeeJpaEntity, base: BigDecimal): BigDecimal {
        val ruleId = employee.commissionRuleId ?: return money(BigDecimal.ZERO)
        val rule = commissionRuleRepository.findById(ruleId).orElse(null) ?: return money(BigDecimal.ZERO)
        return when (rule.kind) {
            KIND_FIXED -> money(rule.value)
            KIND_PERCENT -> money(base.multiply(rule.value).divide(BigDecimal(100), 2, RoundingMode.HALF_UP))
            else -> money(BigDecimal.ZERO)
        }
    }

    // ---- Attendance + self-service ----

    @Transactional
    fun clock(employeeUserId: UUID, type: String): AttendanceView {
        val employee = requireEmployeeByUser(employeeUserId)
        if (type != "in" && type != "out") throw BadRequestException("error.hr.leave_status", listOf(type))
        val saved = attendanceRepository.save(
            AttendanceLogJpaEntity(employeeId = employee.id, type = type, at = Instant.now()),
        )
        return toAttendanceView(saved)
    }

    @Transactional(readOnly = true)
    fun attendanceLogs(employeeId: UUID?): List<AttendanceView> {
        val entities = if (employeeId != null) attendanceRepository.findByEmployeeIdOrderByAtDesc(employeeId)
        else attendanceRepository.findAll()
        return entities.map { toAttendanceView(it) }
    }

    @Transactional(readOnly = true)
    fun myCommissions(employeeUserId: UUID): List<PayrollLineView> {
        val employee = requireEmployeeByUser(employeeUserId)
        return payrollLineRepository.findByEmployeeId(employee.id!!).map { toLineView(it) }
    }

    @Transactional(readOnly = true)
    fun myPayslips(employeeUserId: UUID): List<PayrollLineView> {
        val employee = requireEmployeeByUser(employeeUserId)
        return payrollLineRepository.findByEmployeeId(employee.id!!).map { toLineView(it) }
    }

    // ---- Views ----

    private fun toView(e: EmployeeJpaEntity) = EmployeeView(
        e.id, e.userId, e.branchId, e.jobTitle, e.hireDate,
        e.baseSalary, e.commissionRuleId, e.isActive,
    )

    private fun toRuleView(e: CommissionRuleJpaEntity) = CommissionRuleView(
        e.id, e.name, e.kind, e.value, e.appliesToCategory,
    )

    private fun toLeaveView(e: LeaveRequestJpaEntity) = LeaveView(
        e.id, e.employeeId, e.type, e.fromDate, e.toDate, e.substitute, e.status,
    )

    private fun toAdvanceView(e: AdvanceJpaEntity) = AdvanceView(
        e.id, e.employeeId, e.amount, e.remaining, e.status,
    )

    private fun toDeductionView(e: DeductionJpaEntity) = DeductionView(
        e.id, e.employeeId, e.amount, e.reason, e.payrollId,
    )

    private fun toLineView(e: PayrollLineJpaEntity) = PayrollLineView(
        e.id, e.runId, e.employeeId, e.baseAmount, e.commissionAmount,
        e.advanceDeduction, e.otherDeductions, e.netAmount,
    )

    private fun toRunView(run: PayrollRunJpaEntity, lines: List<PayrollLineView>) = PayrollRunView(
        run.id, run.branchId, run.month, run.status, lines,
    )

    private fun toAttendanceView(e: AttendanceLogJpaEntity) = AttendanceView(
        e.id, e.employeeId, e.type, e.at,
    )
}
