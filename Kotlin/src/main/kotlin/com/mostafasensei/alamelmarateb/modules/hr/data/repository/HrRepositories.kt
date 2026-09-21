package com.mostafasensei.alamelmarateb.modules.hr.data.repository

import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.AdvanceJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.CommissionRuleJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.DeductionJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.EmployeeJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.LeaveRequestJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.PayrollLineJpaEntity
import com.mostafasensei.alamelmarateb.modules.hr.domain.entity.PayrollRunJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface EmployeeRepository : JpaRepository<EmployeeJpaEntity, UUID> {
    fun findByUserId(userId: UUID): Optional<EmployeeJpaEntity>
    fun existsByUserId(userId: UUID): Boolean
    fun findByBranchId(branchId: UUID): List<EmployeeJpaEntity>
    fun findByBranchIdAndIsActiveTrue(branchId: UUID): List<EmployeeJpaEntity>
}

@Repository
interface CommissionRuleRepository : JpaRepository<CommissionRuleJpaEntity, UUID>

@Repository
interface LeaveRequestRepository : JpaRepository<LeaveRequestJpaEntity, UUID> {
    fun findByEmployeeId(employeeId: UUID): List<LeaveRequestJpaEntity>
}

@Repository
interface AdvanceRepository : JpaRepository<AdvanceJpaEntity, UUID> {
    fun findByEmployeeId(employeeId: UUID): List<AdvanceJpaEntity>
    fun findByEmployeeIdAndStatusOrderByCreatedAtAsc(employeeId: UUID, status: String): List<AdvanceJpaEntity>
}

@Repository
interface DeductionRepository : JpaRepository<DeductionJpaEntity, UUID> {
    fun findByEmployeeId(employeeId: UUID): List<DeductionJpaEntity>
    fun findByEmployeeIdAndPayrollIdIsNull(employeeId: UUID): List<DeductionJpaEntity>
}

@Repository
interface PayrollRunRepository : JpaRepository<PayrollRunJpaEntity, UUID> {
    fun findByBranchIdAndMonth(branchId: UUID, month: String): Optional<PayrollRunJpaEntity>
}

@Repository
interface PayrollLineRepository : JpaRepository<PayrollLineJpaEntity, UUID> {
    fun findByRunId(runId: UUID): List<PayrollLineJpaEntity>
    fun findByEmployeeId(employeeId: UUID): List<PayrollLineJpaEntity>
    fun deleteByRunId(runId: UUID)
}
