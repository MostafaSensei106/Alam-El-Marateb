package com.mostafasensei.alamelmarateb.modules.inventory.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.math.BigDecimal
import java.time.Instant
import java.util.UUID

@Entity
@Table(name = "inventory_batches")
class InventoryBatchJpaEntity(
    @Column(name = "batch_no", nullable = false, unique = true, length = 60)
    var batchNo: String = "",

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "warehouse_id", nullable = false, columnDefinition = "UUID")
    var warehouseId: UUID? = null,

    @Column(name = "receipt_id", columnDefinition = "UUID")
    var receiptId: UUID? = null,

    @Column(name = "qty_received", nullable = false)
    var qtyReceived: Int = 0,

    @Column(name = "qty_remaining", nullable = false)
    var qtyRemaining: Int = 0,

    @Column(name = "unit_cost", nullable = false, precision = 12, scale = 2)
    var unitCost: BigDecimal = BigDecimal.ZERO,

    @Column(name = "received_at", nullable = false)
    var receivedAt: Instant = Instant.now(),
) : EntityBase<UUID>()
