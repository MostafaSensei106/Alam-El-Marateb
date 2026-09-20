package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import jakarta.persistence.CascadeType
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.JoinColumn
import jakarta.persistence.OneToMany
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "products")
class ProductJpaEntity(
    @Column(name = "category_id", nullable = false, columnDefinition = "UUID")
    var categoryId: UUID? = null,

    @Column(name = "name", nullable = false, length = 150)
    var name: String = "",

    @Column(name = "slug", nullable = false, unique = true, length = 180)
    var slug: String = "",

    @Column(name = "brand", nullable = false, length = 100)
    var brand: String = "",

    @Column(name = "brand_id", columnDefinition = "UUID")
    var brandId: UUID? = null,

    @Column(name = "warranty_years")
    var warrantyYears: Int? = null,

    @Column(name = "description", columnDefinition = "TEXT")
    var description: String? = null,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,

    @Column(name = "is_featured", nullable = false)
    var isFeatured: Boolean = false,

    @OneToMany(cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    @JoinColumn(name = "product_id")
    var attributeValues: MutableList<ProductAttributeValueJpaEntity> = mutableListOf(),

    @OneToMany(cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    var variants: MutableList<ProductVariantJpaEntity> = mutableListOf()
) : EntityBase<UUID>() {

    fun toDomain(): Product =
        Product(
            id = this.id,
            categoryId = this.categoryId ?: throw IllegalStateException("CategoryId cannot be null"),
            name = this.name,
            slug = this.slug,
            brand = this.brand,
            brandId = this.brandId,
            warrantyYears = this.warrantyYears,
            description = this.description,
            isActive = this.isActive,
            isFeatured = this.isFeatured,
            attributes = this.attributeValues.map { it.toDomain() },
            variants = this.variants.map { it.toDomain() },
            createdAt = this.createdAt,
            updatedAt = this.updatedAt
        )

    companion object {
        fun fromDomain(domain: Product): ProductJpaEntity {
            val entity = ProductJpaEntity(
                categoryId = domain.categoryId,
                name = domain.name,
                slug = domain.slug,
                brand = domain.brand,
                brandId = domain.brandId,
                warrantyYears = domain.warrantyYears,
                description = domain.description,
                isActive = domain.isActive,
                isFeatured = domain.isFeatured,
                attributeValues = domain.attributes
                    .map { ProductAttributeValueJpaEntity.fromDomain(it) }
                    .toMutableList(),
                variants = domain.variants.map { ProductVariantJpaEntity.fromDomain(it) }.toMutableList()
            )
            entity.id = domain.id
            return entity
        }
    }
}
