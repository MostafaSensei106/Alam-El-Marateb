package com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto

import com.mostafasensei.alamelmarateb.modules.inventory.application.TransferItemRequest
import jakarta.validation.Valid
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Positive
import jakarta.validation.constraints.PositiveOrZero
import java.util.UUID

data class WarehouseCreateRequest(
    val branchId: UUID? = null,
    @field:NotBlank val name: String,
    @field:NotBlank val code: String,
)

data class WarehouseUpdateRequest(
    val name: String? = null,
    val isActive: Boolean? = null,
)

data class AdjustStockRequest(
    @field:NotNull val warehouseId: UUID,
    @field:NotNull val variantId: UUID,
    val qtyDelta: Int,
    @field:NotBlank val note: String,
)

data class SetThresholdRequest(
    @field:NotNull val warehouseId: UUID,
    @field:NotNull val variantId: UUID,
    @field:PositiveOrZero val minQty: Int?,
)

data class TransferCreateRequest(
    @field:NotNull val fromWarehouseId: UUID,
    @field:NotNull val toWarehouseId: UUID,
    val note: String? = null,
    @field:Valid @field:NotNull val items: List<TransferLineRequest>,
)

data class TransferLineRequest(
    @field:NotNull val variantId: UUID,
    @field:Positive val qty: Int,
)

data class ReceiveBatchRequest(
    @field:Valid @field:NotNull val lines: List<TransferLineRequest>,
    val damaged: Map<UUID, Int> = emptyMap(),
)

data class AuditOpenRequest(
    @field:NotNull val warehouseId: UUID,
    val note: String? = null,
)

data class AuditCountRequest(
    @field:NotNull val variantId: UUID,
    @field:PositiveOrZero val countedQty: Int,
)

fun TransferCreateRequest.toItems(): List<TransferItemRequest> =
    items.map { TransferItemRequest(it.variantId, it.qty) }
