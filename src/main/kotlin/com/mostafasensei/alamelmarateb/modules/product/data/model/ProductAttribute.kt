package com.mostafasensei.alamelmarateb.modules.product.data.model
import com.fasterxml.jackson.annotation.JsonIgnore

import java.math.BigDecimal
import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

sealed interface AttributeValue {

    data class Text(
        val value: String
    ) : AttributeValue

    data class Number(
        val value: BigDecimal
    ) : AttributeValue

    data class Boolean(
        val value: kotlin.Boolean
    ) : AttributeValue

    data class Option(
        val optionId: UUID
    ) : AttributeValue

    data class MultiOption(
        val optionIds: Set<UUID>
    ) : AttributeValue
}

data class ProductAttributeValue(
    val attributeId: UUID,
    val value: AttributeValue
)

data class ProductAttributeOption(
    val id: UUID? = null,
    val value: String,
    val label: String,
    val sortOrder: Int = 0,
    @get:JsonIgnore
    val translations: Map<String, Map<String, String?>> = emptyMap(),
)

data class ProductAttributeDefinition(
    val id: UUID? = null,
    val name: String,
    val key: String,
    val type: AttributeType,
    val options: List<ProductAttributeOption> = emptyList(),
    val isActive: Boolean = true,
    @get:JsonIgnore
    val translations: Map<String, Map<String, String?>> = emptyMap(),
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now(),
)
