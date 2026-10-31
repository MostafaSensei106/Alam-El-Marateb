package com.mostafasensei.alamelmarateb.modules.product.data.model
import com.fasterxml.jackson.annotation.JsonIgnore

import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

/**
 * Product aggregate as seen by the domain layer.
 *
 * Required: [id] (always assigned, never null), [categoryId], [name], [slug], [brand], [createdAt], [updatedAt].
 * Optional: [brandId], [pricePerMeter], [description], [warrantyYears], [translations]; lists default to empty.
 */
data class Product(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Required.** Owning category. */
    val categoryId: UUID,
    val name: String,
    val slug: String,
    val brand: String,
    val brandId: UUID? = null,
    val pricePerMeter: java.math.BigDecimal? = null,
    val description: String? = null,
    val warrantyYears: Int? = null,
    val attributes: List<ProductAttributeValue> = emptyList(),
    val variants: List<ProductVariant> = emptyList(),
    val isActive: Boolean = true,
    val isFeatured: Boolean = false,
    @get:JsonIgnore
    val translations: Map<String, Map<String, String?>> = emptyMap(),
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now(),
)
