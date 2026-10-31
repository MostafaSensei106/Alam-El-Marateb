package com.mostafasensei.alamelmarateb.modules.product.data.model

import java.math.BigDecimal
import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

/**
 * Dimension/pricing row of a [ProductPreset].
 *
 * Required: [id] (always assigned, never null), [widthCm], [lengthCm], [heightCm], [costPrice], [sellingPrice].
 */
data class ProductPresetVariant(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Required.** Width in centimetres. */
    val widthCm: Int,
    val lengthCm: Int,
    val heightCm: Int,
    val costPrice: BigDecimal,
    val sellingPrice: BigDecimal,
    val isActive: Boolean = true,
)

/**
 * Template used to pre-fill a product form.
 *
 * Required: [id] (always assigned, never null), [categoryId], [name], [brand], [createdAt], [updatedAt].
 * Optional: [description], [warrantyYears]; lists default to empty.
 */
data class ProductPreset(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Required.** Owning category. */
    val categoryId: UUID,
    val name: String,
    val brand: String,
    val description: String? = null,
    val warrantyYears: Int? = null,
    val isActive: Boolean = true,
    val attributes: List<ProductAttributeValue> = emptyList(),
    val variants: List<ProductPresetVariant> = emptyList(),
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now(),
)
