package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.product.data.model.AttributeType
import com.mostafasensei.alamelmarateb.modules.product.data.model.AttributeValue
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeValue
import jakarta.persistence.CollectionTable
import jakarta.persistence.Column
import jakarta.persistence.ElementCollection
import jakarta.persistence.Entity
import jakarta.persistence.EnumType
import jakarta.persistence.Enumerated
import jakarta.persistence.FetchType
import jakarta.persistence.JoinColumn
import jakarta.persistence.Table
import jakarta.persistence.UniqueConstraint
import java.math.BigDecimal
import java.util.UUID

@Entity
@Table(
    name = "product_attribute_values",
    uniqueConstraints = [UniqueConstraint(columnNames = ["product_id", "attribute_id"])]
)
class ProductAttributeValueJpaEntity(
    @Column(name = "product_id", nullable = false, columnDefinition = "UUID", insertable = false, updatable = false)
    var productId: UUID? = null,

    @Column(name = "attribute_id", nullable = false, columnDefinition = "UUID")
    var attributeId: UUID? = null,

    @Enumerated(EnumType.STRING)
    @Column(name = "value_type", nullable = false, length = 20)
    var valueType: AttributeType = AttributeType.TEXT,

    @Column(name = "value_text", columnDefinition = "TEXT")
    var valueText: String? = null,

    @Column(name = "value_number", precision = 19, scale = 4)
    var valueNumber: BigDecimal? = null,

    @Column(name = "value_boolean")
    var valueBoolean: Boolean? = null,

    @Column(name = "value_option_id", columnDefinition = "UUID")
    var valueOptionId: UUID? = null,

    @ElementCollection(fetch = FetchType.LAZY)
    @CollectionTable(name = "product_attribute_value_options", joinColumns = [JoinColumn(name = "value_id")])
    @Column(name = "option_id", columnDefinition = "UUID")
    var selectedOptionIds: MutableSet<UUID> = mutableSetOf()
) : EntityBase<UUID>() {

    fun toDomain(): ProductAttributeValue =
        ProductAttributeValue(
            attributeId = this.attributeId
                ?: throw IllegalStateException("AttributeId cannot be null"),
            value = when (valueType) {
                AttributeType.TEXT -> AttributeValue.Text(valueText ?: "")
                AttributeType.NUMBER -> AttributeValue.Number(valueNumber ?: BigDecimal.ZERO)
                AttributeType.BOOLEAN -> AttributeValue.Boolean(valueBoolean ?: false)
                AttributeType.SELECT -> AttributeValue.Option(
                    valueOptionId ?: throw IllegalStateException("OptionId cannot be null")
                )
                AttributeType.MULTI_SELECT -> AttributeValue.MultiOption(selectedOptionIds.toSet())
            }
        )

    companion object {
        fun fromDomain(domain: ProductAttributeValue): ProductAttributeValueJpaEntity =
            when (val value = domain.value) {
                is AttributeValue.Text ->
                    ProductAttributeValueJpaEntity(
                        attributeId = domain.attributeId,
                        valueType = AttributeType.TEXT,
                        valueText = value.value
                    )
                is AttributeValue.Number ->
                    ProductAttributeValueJpaEntity(
                        attributeId = domain.attributeId,
                        valueType = AttributeType.NUMBER,
                        valueNumber = value.value
                    )
                is AttributeValue.Boolean ->
                    ProductAttributeValueJpaEntity(
                        attributeId = domain.attributeId,
                        valueType = AttributeType.BOOLEAN,
                        valueBoolean = value.value
                    )
                is AttributeValue.Option ->
                    ProductAttributeValueJpaEntity(
                        attributeId = domain.attributeId,
                        valueType = AttributeType.SELECT,
                        valueOptionId = value.optionId
                    )
                is AttributeValue.MultiOption ->
                    ProductAttributeValueJpaEntity(
                        attributeId = domain.attributeId,
                        valueType = AttributeType.MULTI_SELECT,
                        selectedOptionIds = value.optionIds.toMutableSet()
                    )
            }
    }
}
