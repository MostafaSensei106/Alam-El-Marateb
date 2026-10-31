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

/**
 * Physical stocking location.
 *
 * Required: [id] (always assigned, never null), [name], [code].
 * Optional: [branchId]; [isActive] defaults to true.
 */
data class Warehouse(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Optional.** Owning branch. */
    val branchId: UUID? = null,
    /** **Required.** Display name. */
    val name: String,
    /** **Required.** Short unique code. */
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

/**
 * Stock transfer between two warehouses.
 *
 * Required: [id] (always assigned, never null), [fromWarehouseId], [toWarehouseId], [status].
 * Optional: [note]; [items] defaults to empty.
 */
data class Transfer(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Required.** Source warehouse. */
    val fromWarehouseId: UUID,
    /** **Required.** Destination warehouse. */
    val toWarehouseId: UUID,
    /** **Required.** Lifecycle status. */
    val status: TransferStatus,
    /** **Optional.** Free-text note. */
    val note: String? = null,
    val items: List<TransferItem> = emptyList(),
)
