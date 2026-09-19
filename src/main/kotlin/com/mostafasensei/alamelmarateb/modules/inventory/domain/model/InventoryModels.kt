package com.mostafasensei.alamelmarateb.modules.inventory.domain.model

import java.util.UUID

enum class TransferStatus {
    draft,
    in_transit,
    partially_received,
    received,
    confirmed,
    cancelled,
}

enum class AuditStatus {
    open,
    counting,
    reconciled,
    cancelled,
}

enum class MoveType {
    SALE,
    PURCHASE,
    TRANSFER_OUT,
    TRANSFER_IN,
    ADJUST,
    AUDIT,
    DAMAGE,
    RETURN,
}

data class Warehouse(
    val id: UUID? = null,
    val branchId: UUID? = null,
    val name: String,
    val code: String,
    val isActive: Boolean = true,
)

data class StockLevel(
    val warehouseId: UUID,
    val variantId: UUID,
    val qty: Int,
    val reservedQty: Int,
    val minQty: Int? = null,
) {
    val available: Int get() = qty - reservedQty
}

data class StockMove(
    val warehouseId: UUID,
    val variantId: UUID,
    val qtySigned: Int,
    val type: MoveType,
    val refType: String? = null,
    val refId: UUID? = null,
    val note: String? = null,
)

data class TransferItem(
    val variantId: UUID,
    val sentQty: Int,
    val receivedQty: Int = 0,
    val damagedQty: Int = 0,
) {
    val remaining: Int get() = sentQty - receivedQty
}

data class Transfer(
    val id: UUID? = null,
    val fromWarehouseId: UUID,
    val toWarehouseId: UUID,
    val status: TransferStatus,
    val note: String? = null,
    val items: List<TransferItem> = emptyList(),
)
