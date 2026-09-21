package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import jakarta.persistence.CascadeType
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.OneToMany
import jakarta.persistence.OrderBy
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "product_categories")
class ProductCategoryJpaEntity(
    @Column(name = "name", nullable = false, length = 100)
    var name: String = "",

    @Column(name = "slug", nullable = false, unique = true, length = 120)
    var slug: String = "",

    @Column(name = "description", columnDefinition = "TEXT")
    var description: String? = null,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,

    @OneToMany(mappedBy = "category", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
    @OrderBy("sortOrder ASC")
    var categoryAttributes: MutableList<CategoryAttributeJpaEntity> = mutableListOf()
) : EntityBase<UUID>() {

    fun toDomain(): ProductCategory =
        ProductCategory(
            id = this.id,
            name = this.name,
            slug = this.slug,
            description = this.description,
            isActive = this.isActive,
            attributes = this.categoryAttributes.map { it.toDomain() },
            createdAt = this.createdAt,
            updatedAt = this.updatedAt
        )

    companion object {
        fun fromDomain(domain: ProductCategory): ProductCategoryJpaEntity {
            val entity = ProductCategoryJpaEntity(
                name = domain.name,
                slug = domain.slug,
                description = domain.description,
                isActive = domain.isActive
            )
            entity.id = domain.id
            entity.categoryAttributes = domain.attributes.map { link ->
                CategoryAttributeJpaEntity(
                    category = entity,
                    attribute = AttributeDefinitionJpaEntity.fromDomain(link.attribute),
                    required = link.required,
                    sortOrder = link.sortOrder
                )
            }.toMutableList()
            return entity
        }
    }
}
