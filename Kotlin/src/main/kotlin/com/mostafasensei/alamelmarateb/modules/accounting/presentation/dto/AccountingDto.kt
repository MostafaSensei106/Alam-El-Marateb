package com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto

import jakarta.validation.Valid
import jakarta.validation.constraints.DecimalMin
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotEmpty
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Pattern
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID

data class CreateAccountRequest(
    @field:NotBlank val code: String,
    @field:NotBlank val nameAr: String,
    val nameEn: String? = null,
    @field:Pattern(regexp = "ASSET|LIABILITY|EQUITY|REVENUE|EXPENSE") val type: String,
    val parentCode: String? = null,
    val branchId: UUID? = null,
)

data class UpdateAccountRequest(
    val nameAr: String? = null,
    val nameEn: String? = null,
    @field:Pattern(regexp = "ASSET|LIABILITY|EQUITY|REVENUE|EXPENSE") val type: String? = null,
    val parentCode: String? = null,
)

data class JournalLineRequest(
    @field:NotBlank val accountCode: String,
    @field:NotNull @field:DecimalMin("0.00") val debit: BigDecimal = BigDecimal.ZERO,
    @field:NotNull @field:DecimalMin("0.00") val credit: BigDecimal = BigDecimal.ZERO,
)

data class PostJournalRequest(
    val branchId: UUID? = null,
    @field:NotNull val entryDate: LocalDate,
    @field:NotBlank val source: String,
    val ref: String? = null,
    val memo: String? = null,
    @field:NotEmpty @field:Valid val lines: List<JournalLineRequest>,
)

data class CreateTreasuryRequest(
    val branchId: UUID? = null,
    @field:NotBlank val name: String,
    @field:DecimalMin("0.00") val openingBalance: BigDecimal? = null,
)

data class UpdateTreasuryRequest(
    val name: String? = null,
)

data class TransferRequest(
    @field:NotNull val fromId: UUID,
    @field:NotNull val toId: UUID,
    @field:NotNull @field:DecimalMin("0.01") val amount: BigDecimal,
)

data class ExpenseRequest(
    val branchId: UUID? = null,
    @field:NotBlank val category: String,
    @field:NotNull @field:DecimalMin("0.01") val amount: BigDecimal,
    val receiptPhoto: String? = null,
    val approvedBy: String? = null,
)

data class UpdateExpenseRequest(
    val category: String? = null,
    @field:DecimalMin("0.01") val amount: BigDecimal? = null,
    val receiptPhoto: String? = null,
    val approvedBy: String? = null,
)

data class CheckRequest(
    @field:Pattern(regexp = "in|out") val direction: String,
    @field:NotNull @field:DecimalMin("0.01") val amount: BigDecimal,
    val dueDate: LocalDate? = null,
    val party: String? = null,
)

data class UpdateCheckRequest(
    val dueDate: LocalDate? = null,
    val party: String? = null,
)

data class CheckStatusRequest(
    @field:NotBlank val status: String,
)
