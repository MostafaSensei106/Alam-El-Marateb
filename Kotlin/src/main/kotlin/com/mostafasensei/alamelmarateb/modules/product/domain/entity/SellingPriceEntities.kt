package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.math.BigDecimal
import java.time.Instant
import java.util.UUID

@Entity
@Table(name = "supplier_price_sheets")
class SupplierPriceSheetJpaEntity(
    @Column(name = "supplier_id", nullable = false, columnDefinition = "UUID")
    var supplierId: UUID? = null,

    @Column(name = "sheet_no", nullable = false, length = 60)
    var sheetNo: String = "",

    @Column(name = "valid_from", nullable = false)
    var validFrom: java.time.LocalDate? = null,

    @Column(name = "valid_until")
    var validUntil: java.time.LocalDate? = null,

    @Column(name = "notes", columnDefinition = "TEXT")
    var notes: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "price_sheet_lines")
class PriceSheetLineJpaEntity(
    @Column(name = "sheet_id", nullable = false, columnDefinition = "UUID")
    var sheetId: UUID? = null,

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "list_cost", nullable = false, precision = 12, scale = 2)
    var listCost: BigDecimal = BigDecimal.ZERO,

    @Column(name = "suggested_selling", nullable = false, precision = 12, scale = 2)
    var suggestedSelling: BigDecimal = BigDecimal.ZERO,
) : EntityBase<UUID>()

@Entity
@Table(name = "selling_prices")
class SellingPriceJpaEntity(
    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "channel", nullable = false, length = 20)
    var channel: String = "STAFF",

    @Column(name = "price", nullable = false, precision = 12, scale = 2)
    var price: BigDecimal = BigDecimal.ZERO,

    @Column(name = "effective_from", nullable = false)
    var effectiveFrom: Instant = Instant.now(),
) : EntityBase<UUID>()
