package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductPreset
import jakarta.persistence.CascadeType
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.JoinColumn
import jakarta.persistence.OneToMany
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "product_presets")
class ProductPresetJpaEntity(
    @Column(name = "category_id", nullable = false, columnDefinition = "UUID")
    var categoryId: UUID? = null,

    @Column(name = "name", nullable = false, length = 150)
    var name: String = "",

    @Column(name = "brand", nullable = false, length = 100)
    var brand: String = "",

    @Column(name = "warranty_years")
    var warrantyYears: Int? = null,

    @Column(name = "description", columnDefinition = "TEXT")
    var description: String? = null,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,

    @OneToMany(cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    @JoinColumn(name = "preset_id")
    var attributeValues: MutableList<PresetAttributeValueJpaEntity> = mutableListOf(),

    @OneToMany(cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    @JoinColumn(name = "preset_id")
    var variants: MutableList<ProductPresetVariantJpaEntity> = mutableListOf()
) : EntityBase<UUID>() {

    fun toDomain(): ProductPreset =
        ProductPreset(
            id = this.id,
            categoryId = this.categoryId ?: throw IllegalStateException("CategoryId cannot be null"),
            name = this.name,
            brand = this.brand,
            description = this.description,
            warrantyYears = this.warrantyYears,
            isActive = this.isActive,
            attributes = this.attributeValues.map { it.toDomain() },
            variants = this.variants.map { it.toDomain() },
            createdAt = this.createdAt,
            updatedAt = this.updatedAt
        )

    companion object {
        fun fromDomain(domain: ProductPreset): ProductPresetJpaEntity {
            val entity = ProductPresetJpaEntity(
                categoryId = domain.categoryId,
                name = domain.name,
                brand = domain.brand,
                warrantyYears = domain.warrantyYears,
                description = domain.description,
                isActive = domain.isActive,
                attributeValues = domain.attributes
                    .map { PresetAttributeValueJpaEntity.fromDomain(it) }
                    .toMutableList(),
                variants = domain.variants
                    .map { ProductPresetVariantJpaEntity.fromDomain(it) }
                    .toMutableList()
            )
            entity.id = domain.id
            return entity
        }
    }
}
