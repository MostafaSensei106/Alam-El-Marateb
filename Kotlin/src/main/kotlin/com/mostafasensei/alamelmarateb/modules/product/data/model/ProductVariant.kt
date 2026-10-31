package com.mostafasensei.alamelmarateb.modules.product.data.model

import java.math.BigDecimal
import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

/**
 * Sellable unit of a product.
 *
 * Required: [id] (always assigned, never null), [sku], [widthCm], [lengthCm], [heightCm], [costPrice],
 * [sellingPrice], [createdAt], [updatedAt].
 * Optional: [productId] (set once the variant is attached to a parent), [barcode].
 */
data class ProductVariant(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Optional.** Parent product; `null` only for a detached/new variant. */
    val productId: UUID? = null,
    val sku: String,
    val barcode: String?,
    val widthCm: Int,
    val lengthCm: Int,
    val heightCm: Int,
    val costPrice: BigDecimal,
    val sellingPrice: BigDecimal,
    val isActive: Boolean = true,
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now(),
) {
    val dimensionsLabel: String get() = "${widthCm}x${lengthCm}x${heightCm} cm"
}
