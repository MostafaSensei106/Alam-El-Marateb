package com.mostafasensei.alamelmarateb.modules.inventory.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "stock_levels")
class StockLevelJpaEntity(
    @Column(name = "warehouse_id", nullable = false, columnDefinition = "UUID")
    var warehouseId: UUID? = null,

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "qty", nullable = false)
    var qty: Int = 0,

    @Column(name = "reserved_qty", nullable = false)
    var reservedQty: Int = 0,

    @Column(name = "min_qty")
    var minQty: Int? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "stock_moves")
class StockMoveJpaEntity(
    @Column(name = "warehouse_id", nullable = false, columnDefinition = "UUID")
    var warehouseId: UUID? = null,

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "qty_signed", nullable = false)
    var qtySigned: Int = 0,

    @Column(name = "move_type", nullable = false, length = 20)
    var moveType: String = "",

    @Column(name = "ref_type", length = 40)
    var refType: String? = null,

    @Column(name = "ref_id", columnDefinition = "UUID")
    var refId: UUID? = null,

    @Column(name = "note", columnDefinition = "TEXT")
    var note: String? = null,
) : EntityBase<UUID>()
