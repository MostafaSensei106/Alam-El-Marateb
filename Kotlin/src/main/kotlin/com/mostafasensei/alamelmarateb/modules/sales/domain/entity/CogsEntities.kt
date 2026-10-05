package com.mostafasensei.alamelmarateb.modules.sales.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.math.BigDecimal
import java.util.UUID

@Entity
@Table(name = "order_item_batches")
class OrderItemBatchJpaEntity(
    @Column(name = "order_item_id", nullable = false, columnDefinition = "UUID")
    var orderItemId: UUID? = null,

    @Column(name = "batch_id", nullable = false, columnDefinition = "UUID")
    var batchId: UUID? = null,

    @Column(name = "qty", nullable = false)
    var qty: Int = 0,

    @Column(name = "unit_cost", nullable = false, precision = 12, scale = 2)
    var unitCost: BigDecimal = BigDecimal.ZERO,
) : EntityBase<UUID>()
