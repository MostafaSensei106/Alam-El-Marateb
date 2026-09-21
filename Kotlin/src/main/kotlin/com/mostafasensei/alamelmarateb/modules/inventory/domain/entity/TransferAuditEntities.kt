package com.mostafasensei.alamelmarateb.modules.inventory.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.CascadeType
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.JoinColumn
import jakarta.persistence.ManyToOne
import jakarta.persistence.OneToMany
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "stock_transfers")
class StockTransferJpaEntity(
    @Column(name = "from_warehouse_id", nullable = false, columnDefinition = "UUID")
    var fromWarehouseId: UUID? = null,

    @Column(name = "to_warehouse_id", nullable = false, columnDefinition = "UUID")
    var toWarehouseId: UUID? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "draft",

    @Column(name = "note", columnDefinition = "TEXT")
    var note: String? = null,

    @OneToMany(mappedBy = "transfer", cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    var items: MutableList<TransferItemJpaEntity> = mutableListOf(),
) : EntityBase<UUID>()

@Entity
@Table(name = "transfer_items")
class TransferItemJpaEntity(
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "transfer_id", nullable = false)
    var transfer: StockTransferJpaEntity? = null,

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "sent_qty", nullable = false)
    var sentQty: Int = 0,

    @Column(name = "received_qty", nullable = false)
    var receivedQty: Int = 0,

    @Column(name = "damaged_qty", nullable = false)
    var damagedQty: Int = 0,
) : EntityBase<UUID>()

@Entity
@Table(name = "stock_audits")
class StockAuditJpaEntity(
    @Column(name = "warehouse_id", nullable = false, columnDefinition = "UUID")
    var warehouseId: UUID? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "open",

    @Column(name = "note", columnDefinition = "TEXT")
    var note: String? = null,

    @OneToMany(mappedBy = "audit", cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    var counts: MutableList<AuditCountJpaEntity> = mutableListOf(),
) : EntityBase<UUID>()

@Entity
@Table(name = "audit_counts")
class AuditCountJpaEntity(
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "audit_id", nullable = false)
    var audit: StockAuditJpaEntity? = null,

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "system_qty", nullable = false)
    var systemQty: Int = 0,

    @Column(name = "counted_qty", nullable = false)
    var countedQty: Int = 0,
) : EntityBase<UUID>()
