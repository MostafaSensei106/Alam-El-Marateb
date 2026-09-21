package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.product.data.model.AttributeType
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeDefinition
import jakarta.persistence.CascadeType
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.EnumType
import jakarta.persistence.Enumerated
import jakarta.persistence.FetchType
import jakarta.persistence.JoinColumn
import jakarta.persistence.OneToMany
import jakarta.persistence.OrderBy
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "product_attribute_definitions")
class AttributeDefinitionJpaEntity(
    @Column(name = "name", nullable = false, length = 100)
    var name: String = "",

    @Column(name = "attribute_key", nullable = false, unique = true, length = 100)
    var key: String = "",

    @Enumerated(EnumType.STRING)
    @Column(name = "attribute_type", nullable = false, length = 20)
    var type: AttributeType = AttributeType.TEXT,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,

    @OneToMany(cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
    @JoinColumn(name = "attribute_id")
    @OrderBy("sortOrder ASC")
    var options: MutableList<AttributeOptionJpaEntity> = mutableListOf()
) : EntityBase<UUID>() {

    fun toDomain(): ProductAttributeDefinition =
        ProductAttributeDefinition(
            id = this.id,
            name = this.name,
            key = this.key,
            type = this.type,
            options = this.options.map { it.toDomain() },
            isActive = this.isActive,
            createdAt = this.createdAt,
            updatedAt = this.updatedAt
        )

    companion object {
        fun fromDomain(domain: ProductAttributeDefinition): AttributeDefinitionJpaEntity {
            val entity = AttributeDefinitionJpaEntity(
                name = domain.name,
                key = domain.key,
                type = domain.type,
                isActive = domain.isActive,
                options = domain.options
                    .map { AttributeOptionJpaEntity.fromDomain(it) }
                    .toMutableList()
            )
            entity.id = domain.id
            return entity
        }
    }
}
