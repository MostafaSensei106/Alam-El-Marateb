package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductPresetVariant
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import jakarta.persistence.UniqueConstraint
import java.math.BigDecimal
import java.util.UUID

@Entity
@Table(
    name = "product_preset_variants",
    uniqueConstraints = [UniqueConstraint(columnNames = ["preset_id", "width_cm", "length_cm", "height_cm"])]
)
class ProductPresetVariantJpaEntity(
    @Column(name = "preset_id", nullable = false, columnDefinition = "UUID", insertable = false, updatable = false)
    var presetId: UUID? = null,

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

    fun toDomain(): ProductPresetVariant =
        ProductPresetVariant(
            id = this.id,
            widthCm = this.widthCm,
            lengthCm = this.lengthCm,
            heightCm = this.heightCm,
            costPrice = this.costPrice,
            sellingPrice = this.sellingPrice,
            isActive = this.isActive
        )

    companion object {
        fun fromDomain(domain: ProductPresetVariant): ProductPresetVariantJpaEntity {
            val entity = ProductPresetVariantJpaEntity(
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
