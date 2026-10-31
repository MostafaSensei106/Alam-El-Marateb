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

/**
 * Selectable value of an attribute definition (e.g. colour "Red").
 *
 * Required: [id] (always assigned, never null), [value], [label].
 * Optional: [attributeId] (set once attached to a definition), [sortOrder], [translations].
 */
data class ProductAttributeOption(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Optional.** Owning definition; `null` only before attachment. */
    val attributeId: UUID? = null,
    /** **Required.** Machine value. */
    val value: String,
    /** **Required.** Human label. */
    val label: String,
    val sortOrder: Int = 0,
    @get:JsonIgnore
    val translations: Map<String, Map<String, String?>> = emptyMap(),
)

/**
 * Attribute definition (e.g. "Colour", "Fabric").
 *
 * Required: [id] (always assigned, never null), [name], [key], [type], [createdAt], [updatedAt].
 * Optional: [options], [translations]; [isActive] defaults to true.
 */
data class ProductAttributeDefinition(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Required.** Display name. */
    val name: String,
    /** **Required.** Stable machine key. */
    val key: String,
    /** **Required.** Value type. */
    val type: AttributeType,
    val options: List<ProductAttributeOption> = emptyList(),
    val isActive: Boolean = true,
    @get:JsonIgnore
    val translations: Map<String, Map<String, String?>> = emptyMap(),
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now(),
)
