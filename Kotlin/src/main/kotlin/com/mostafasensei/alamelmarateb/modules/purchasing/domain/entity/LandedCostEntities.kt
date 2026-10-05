package com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.math.BigDecimal
import java.time.Instant
import java.util.UUID

object LandedKind {
    const val FREIGHT = "FREIGHT"
    const val CUSTOMS = "CUSTOMS"
    const val INSURANCE = "INSURANCE"
    const val HANDLING = "HANDLING"
    const val OTHER = "OTHER"

    fun isKnown(kind: String): Boolean =
        kind == FREIGHT || kind == CUSTOMS || kind == INSURANCE || kind == HANDLING || kind == OTHER
}

object LandedAllocationMethod {
    const val BY_VALUE = "BY_VALUE"
    const val BY_QTY = "BY_QTY"

    fun isKnown(method: String): Boolean = method == BY_VALUE || method == BY_QTY
}

object LandedStatus {
    const val ESTIMATED = "ESTIMATED"
    const val FINAL = "FINAL"
}

@Entity
@Table(name = "shipment_landed_costs")
class ShipmentLandedCostJpaEntity(
    @Column(name = "shipment_id", nullable = false, columnDefinition = "UUID")
    var shipmentId: UUID? = null,

    @Column(name = "kind", nullable = false, length = 20)
    var kind: String = LandedKind.FREIGHT,

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "allocation_method", nullable = false, length = 10)
    var allocationMethod: String = LandedAllocationMethod.BY_VALUE,

    @Column(name = "status", nullable = false, length = 10)
    var status: String = LandedStatus.ESTIMATED,

    @Column(name = "variance_amount", nullable = false, precision = 12, scale = 2)
    var varianceAmount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "finalized_at")
    var finalizedAt: Instant? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "shipment_landed_cost_allocations")
class ShipmentLandedCostAllocationJpaEntity(
    @Column(name = "landed_cost_id", nullable = false, columnDefinition = "UUID")
    var landedCostId: UUID? = null,

    @Column(name = "batch_id", nullable = false, columnDefinition = "UUID")
    var batchId: UUID? = null,

    @Column(name = "allocated_qty", nullable = false)
    var allocatedQty: Int = 0,

    @Column(name = "allocated_amount", nullable = false, precision = 12, scale = 2)
    var allocatedAmount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "allocated_unit_cost", nullable = false, precision = 12, scale = 2)
    var allocatedUnitCost: BigDecimal = BigDecimal.ZERO,
) {
    @jakarta.persistence.Id
    @jakarta.persistence.GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID? = null

    @Column(name = "created_at", nullable = false, updatable = false)
    var createdAt: Instant = Instant.now()
}
