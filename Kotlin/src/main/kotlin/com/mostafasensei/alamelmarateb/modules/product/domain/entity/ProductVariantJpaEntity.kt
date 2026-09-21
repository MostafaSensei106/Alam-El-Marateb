package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.math.BigDecimal
import java.util.UUID

@Entity
@Table(name = "product_variants")
class ProductVariantJpaEntity(
    @Column(name = "product_id", nullable = false, columnDefinition = "UUID")
    var productId: UUID? = null,

    @Column(name = "sku", nullable = false, unique = true, length = 60)
    var sku: String = "",

    @Column(name = "barcode", unique = true, length = 60)
    var barcode: String? = null,

    @Column(name = "width_cm", nullable = false)
    var widthCm: Int = 0,

    @Column(name = "length_cm", nullable = false)
    var lengthCm: Int = 0,

    @Column(name = "height_cm", nullable = false)
    var heightCm: Int = 0,

    @Column(name = "cost_price", nullable = false, precision = 12, scale = 2)
    var costPrice: BigDecimal = BigDecimal.ZERO,

    @Column(name = "selling_price", nullable = false, precision = 12, scale = 2)
    var sellingPrice: BigDecimal = BigDecimal.ZERO,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true
) : EntityBase<UUID>() {

    fun toDomain(): ProductVariant =
        ProductVariant(
            id = this.id,
            productId = this.productId,
            sku = this.sku,
            barcode = this.barcode,
            widthCm = this.widthCm,
            lengthCm = this.lengthCm,
            heightCm = this.heightCm,
            costPrice = this.costPrice,
            sellingPrice = this.sellingPrice,
            isActive = this.isActive,
            createdAt = this.createdAt,
            updatedAt = this.updatedAt
        )

    companion object {
        fun fromDomain(domain: ProductVariant): ProductVariantJpaEntity {
            val entity = ProductVariantJpaEntity(
                productId = domain.productId,
                sku = domain.sku,
                barcode = domain.barcode,
                widthCm = domain.widthCm,
                lengthCm = domain.lengthCm,
                heightCm = domain.heightCm,
                costPrice = domain.costPrice,
                sellingPrice = domain.sellingPrice,
                isActive = domain.isActive
            )
            entity.id = domain.id
            return entity
        }
    }
}
