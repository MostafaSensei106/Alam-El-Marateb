package com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.CascadeType
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.JoinColumn
import jakarta.persistence.ManyToOne
import jakarta.persistence.OneToMany
import jakarta.persistence.Table
import java.math.BigDecimal
import java.time.Instant
import java.util.UUID

@Entity
@Table(name = "suppliers")
class SupplierJpaEntity(
    @Column(name = "name", nullable = false, length = 150)
    var name: String = "",

    @Column(name = "phone", length = 30)
    var phone: String? = null,

    @Column(name = "address", columnDefinition = "TEXT")
    var address: String? = null,

    @Column(name = "tax_id", length = 50)
    var taxId: String? = null,

    @Column(name = "balance", nullable = false, precision = 12, scale = 2)
    var balance: BigDecimal = BigDecimal.ZERO,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,
) : EntityBase<UUID>()

@Entity
@Table(name = "purchase_orders")
class PurchaseOrderJpaEntity(
    @Column(name = "supplier_id", nullable = false, columnDefinition = "UUID")
    var supplierId: UUID? = null,

    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "draft",

    @Column(name = "total", nullable = false, precision = 12, scale = 2)
    var total: BigDecimal = BigDecimal.ZERO,

    @OneToMany(mappedBy = "order", cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    var items: MutableList<PurchaseOrderItemJpaEntity> = mutableListOf(),
) : EntityBase<UUID>()

@Entity
@Table(name = "po_items")
class PurchaseOrderItemJpaEntity(
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "po_id", nullable = false)
    var order: PurchaseOrderJpaEntity? = null,

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "qty", nullable = false)
    var qty: Int = 0,

    @Column(name = "unit_cost", nullable = false, precision = 12, scale = 2)
    var unitCost: BigDecimal = BigDecimal.ZERO,
) : EntityBase<UUID>()

@Entity
@Table(name = "goods_receipts")
class GoodsReceiptJpaEntity(
    @Column(name = "po_id", nullable = false, columnDefinition = "UUID")
    var poId: UUID? = null,

    @Column(name = "warehouse_id", nullable = false, columnDefinition = "UUID")
    var warehouseId: UUID? = null,

    @Column(name = "received_at", nullable = false)
    var receivedAt: Instant = Instant.now(),

    @Column(name = "received_by", length = 100)
    var receivedBy: String? = null,

    @OneToMany(mappedBy = "receipt", cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    var items: MutableList<ReceiptItemJpaEntity> = mutableListOf(),
) : EntityBase<UUID>()

@Entity
@Table(name = "receipt_items")
class ReceiptItemJpaEntity(
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receipt_id", nullable = false)
    var receipt: GoodsReceiptJpaEntity? = null,

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "expected_qty", nullable = false)
    var expectedQty: Int = 0,

    @Column(name = "actual_qty", nullable = false)
    var actualQty: Int = 0,

    @Column(name = "damaged_qty", nullable = false)
    var damagedQty: Int = 0,
) : EntityBase<UUID>()
