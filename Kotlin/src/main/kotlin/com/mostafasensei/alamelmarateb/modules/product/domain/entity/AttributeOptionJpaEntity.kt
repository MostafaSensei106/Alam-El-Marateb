package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeOption
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import jakarta.persistence.UniqueConstraint
import java.util.UUID

@Entity
@Table(
    name = "product_attribute_options",
    uniqueConstraints = [UniqueConstraint(columnNames = ["attribute_id", "option_value"])]
)
class AttributeOptionJpaEntity(
    @Column(name = "attribute_id", nullable = false, columnDefinition = "UUID")
    var attributeId: UUID? = null,

    @Column(name = "option_value", nullable = false, length = 100)
    var value: String = "",

    @Column(name = "label", nullable = false, length = 150)
    var label: String = "",

    @Column(name = "sort_order", nullable = false)
    var sortOrder: Int = 0
) : EntityBase<UUID>() {

    fun toDomain(): ProductAttributeOption =
        ProductAttributeOption(
            id = this.id,
            value = this.value,
            label = this.label,
            sortOrder = this.sortOrder
        )

    companion object {
        fun fromDomain(domain: ProductAttributeOption): AttributeOptionJpaEntity {
            val entity = AttributeOptionJpaEntity(
                value = domain.value,
                label = domain.label,
                sortOrder = domain.sortOrder
            )
            entity.id = domain.id
            return entity
        }
    }
}
