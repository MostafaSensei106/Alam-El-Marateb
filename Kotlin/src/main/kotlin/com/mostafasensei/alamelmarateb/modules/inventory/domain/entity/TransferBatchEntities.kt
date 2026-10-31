package com.mostafasensei.alamelmarateb.modules.inventory.domain.entity

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.math.BigDecimal
import java.time.Instant
import java.util.UUID

/** Staged source layers consumed at dispatch, mirrored into dest batches at receive. */
@Entity
@Table(name = "transfer_dispatch_layers")
class TransferDispatchLayerJpaEntity(
    @Column(name = "transfer_id", nullable = false, columnDefinition = "UUID")
    var transferId: UUID,

    @Column(name = "src_batch_id", nullable = false, columnDefinition = "UUID")
    var srcBatchId: UUID,

    @Column(name = "qty", nullable = false)
    var qty: Int = 0,

    @Column(name = "unit_cost", nullable = false, precision = 12, scale = 2)
    var unitCost: BigDecimal = BigDecimal.ZERO,

    @Column(name = "landed_unit_cost", nullable = false, precision = 12, scale = 2)
    var landedUnitCost: BigDecimal = BigDecimal.ZERO,

    @Column(name = "mirrored_qty", nullable = false)
    var mirroredQty: Int = 0,
) {
    @Id
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID = UUID.randomUUID()

    @Column(name = "created_at", nullable = false, updatable = false)
    var createdAt: Instant = Instant.now()
}

/** Immutable audit: which source layer became which destination batch. */
@Entity
@Table(name = "transfer_batch_links")
class TransferBatchLinkJpaEntity(
    @Column(name = "transfer_id", nullable = false, columnDefinition = "UUID")
    var transferId: UUID,

    @Column(name = "src_batch_id", nullable = false, columnDefinition = "UUID")
    var srcBatchId: UUID,

    @Column(name = "dst_batch_id", nullable = false, columnDefinition = "UUID")
    var dstBatchId: UUID,

    @Column(name = "qty", nullable = false)
    var qty: Int = 0,

    @Column(name = "unit_cost", nullable = false, precision = 12, scale = 2)
    var unitCost: BigDecimal = BigDecimal.ZERO,

    @Column(name = "landed_unit_cost", nullable = false, precision = 12, scale = 2)
    var landedUnitCost: BigDecimal = BigDecimal.ZERO,
) {
    @Id
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID = UUID.randomUUID()

    @Column(name = "created_at", nullable = false, updatable = false)
    var createdAt: Instant = Instant.now()
}
