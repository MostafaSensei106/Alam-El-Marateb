package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import jakarta.persistence.UniqueConstraint
import java.math.BigDecimal
import java.util.UUID

@Entity
@Table(
    name = "meter_prices",
    uniqueConstraints = [UniqueConstraint(columnNames = ["product_id", "shape"])],
)
class MeterPriceJpaEntity(
    @Column(name = "product_id", nullable = false, columnDefinition = "UUID")
    var productId: UUID? = null,

    @Column(name = "shape", nullable = false, length = 20)
    var shape: String = "RECT",

    @Column(name = "price", nullable = false, precision = 12, scale = 2)
    var price: BigDecimal = BigDecimal.ZERO,
) : EntityBase<UUID>()

@Entity
@Table(name = "operating_brackets")
class OperatingBracketJpaEntity(
    @Column(name = "product_id", columnDefinition = "UUID")
    var productId: UUID? = null,

    @Column(name = "width_from", nullable = false)
    var widthFrom: Int = 0,

    @Column(name = "width_to", nullable = false)
    var widthTo: Int = 0,

    @Column(name = "pct", nullable = false)
    var pct: Int = 0,
) : EntityBase<UUID>()
