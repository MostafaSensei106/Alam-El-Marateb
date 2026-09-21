package com.mostafasensei.alamelmarateb.modules.product.data.model

import java.math.BigDecimal
import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

data class ProductVariant(
    val id: UUID? = null,
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
