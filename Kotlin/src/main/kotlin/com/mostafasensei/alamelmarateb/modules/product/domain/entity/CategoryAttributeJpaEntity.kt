package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.product.data.model.CategoryAttribute
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.JoinColumn
import jakarta.persistence.ManyToOne
import jakarta.persistence.Table
import jakarta.persistence.UniqueConstraint
import java.util.UUID

@Entity
@Table(
    name = "category_attributes",
    uniqueConstraints = [UniqueConstraint(columnNames = ["category_id", "attribute_id"])]
)
class CategoryAttributeJpaEntity(
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    var category: ProductCategoryJpaEntity? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "attribute_id", nullable = false)
    var attribute: AttributeDefinitionJpaEntity? = null,

    @Column(name = "is_required", nullable = false)
    var required: Boolean = false,

    @Column(name = "sort_order", nullable = false)
    var sortOrder: Int = 0
) : EntityBase<UUID>() {

    fun toDomain(): CategoryAttribute =
        CategoryAttribute(
            attribute = this.attribute?.toDomain()
                ?: throw IllegalStateException("Attribute cannot be null"),
            required = this.required,
            sortOrder = this.sortOrder
        )
}
