package com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto

import jakarta.validation.Valid
import jakarta.validation.constraints.NotNull
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID

data class SheetLineRequest(
    @field:NotNull val variantId: UUID,
    @field:NotNull val listCost: BigDecimal,
    @field:NotNull val suggestedSelling: BigDecimal,
)

data class PriceSheetRequest(
    @field:NotNull val supplierId: UUID,
    val sheetNo: String? = null,
    @field:NotNull val validFrom: LocalDate,
    val validUntil: LocalDate? = null,
    @field:Valid val lines: List<SheetLineRequest> = emptyList(),
)

data class ApplySheetRequest(
    val channels: List<String> = emptyList(),
)

data class AllocationResultView(val status: String)

data class ApplySheetResultView(val rows: Int)

data class ShipmentRequest(
    @field:NotNull val supplierId: UUID,
    val shipmentNo: String? = null,
    val arrivedAt: LocalDate? = null,
    val note: String? = null,
)

data class SupplierInstallmentRequest(
    @field:NotNull val amount: BigDecimal,
    @field:NotNull val dueDate: LocalDate,
)

data class SupplierInvoiceRequest(
    @field:NotNull val supplierId: UUID,
    val invoiceNo: String? = null,
    @field:NotNull val total: BigDecimal,
    val issuedAt: LocalDate? = null,
    @field:Valid val installments: List<SupplierInstallmentRequest> = emptyList(),
)

data class InvoiceAllocateRequest(
    @field:NotNull val shipmentId: UUID,
    @field:NotNull val amount: BigDecimal,
)

data class InvoicePayRequest(
    @field:NotNull val amount: BigDecimal,
    val method: String? = null,
    val installmentId: UUID? = null,
    val ref: String? = null,
)
