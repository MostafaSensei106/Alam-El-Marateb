package com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto

import jakarta.validation.Valid
import jakarta.validation.constraints.NotNull
import java.math.BigDecimal
import java.util.UUID

data class SupplierRequest(
    val name: String? = null,
    val phone: String? = null,
    val address: String? = null,
    val taxId: String? = null,
)

data class SupplierUpdateRequest(
    val name: String? = null,
    val phone: String? = null,
    val address: String? = null,
    val taxId: String? = null,
    val isActive: Boolean? = null,
)

data class PoItemRequest(
    @field:NotNull val variantId: UUID,
    val qty: Int = 0,
    @field:NotNull val unitCost: BigDecimal,
)

data class PurchaseOrderRequest(
    @field:NotNull val supplierId: UUID,
    val branchId: UUID? = null,
    @field:Valid val items: List<PoItemRequest> = emptyList(),
)

data class PoActionRequest(
    val action: String? = null,
)

data class ReceiveLineRequest(
    @field:NotNull val variantId: UUID,
    val actualQty: Int = 0,
    val damagedQty: Int = 0,
)

data class ReceiveGoodsRequest(
    @field:NotNull val warehouseId: UUID,
    @field:Valid val lines: List<ReceiveLineRequest> = emptyList(),
)

data class SupplierPaymentRequest(
    @field:NotNull val supplierId: UUID,
    @field:NotNull val amount: BigDecimal,
)
