package com.mostafasensei.alamelmarateb.modules.hr.presentation.dto

import jakarta.validation.constraints.DecimalMin
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID

data class EmployeeCreateRequest(
    @field:NotNull val userId: UUID,
    val branchId: UUID? = null,
    val jobTitle: String? = null,
    val hireDate: LocalDate? = null,
    @field:NotNull @field:DecimalMin("0.00") val baseSalary: BigDecimal,
    val commissionRuleId: UUID? = null,
)

data class EmployeeUpdateRequest(
    val branchId: UUID? = null,
    val jobTitle: String? = null,
    val hireDate: LocalDate? = null,
    val baseSalary: BigDecimal? = null,
    val commissionRuleId: UUID? = null,
    val isActive: Boolean? = null,
)

data class LeaveRequestBody(
    @field:NotNull val employeeId: UUID,
    @field:NotBlank val type: String,
    @field:NotNull val fromDate: LocalDate,
    @field:NotNull val toDate: LocalDate,
    val substitute: String? = null,
)

data class LeaveActionRequest(
    @field:NotBlank val action: String,
)

data class SelfLeaveRequestBody(
    @field:NotBlank val type: String,
    @field:NotNull val fromDate: LocalDate,
    @field:NotNull val toDate: LocalDate,
    val substitute: String? = null,
)

data class CommissionRuleRequest(
    @field:NotBlank val name: String,
    @field:NotBlank val kind: String,
    @field:NotNull val value: BigDecimal,
    val appliesToCategory: UUID? = null,
)

data class AdvanceCreateRequest(
    @field:NotNull val employeeId: UUID,
    @field:NotNull val amount: BigDecimal,
)

data class DeductionCreateRequest(
    @field:NotNull val employeeId: UUID,
    @field:NotNull val amount: BigDecimal,
    val reason: String? = null,
)

data class PayrollCalculateRequest(
    @field:NotNull val branchId: UUID,
    @field:NotBlank val month: String,
)
