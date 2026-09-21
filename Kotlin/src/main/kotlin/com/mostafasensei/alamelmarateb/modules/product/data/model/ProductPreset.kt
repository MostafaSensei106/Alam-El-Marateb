package com.mostafasensei.alamelmarateb.modules.product.data.model

import java.math.BigDecimal
import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

data class ProductPresetVariant(
    val id: UUID? = null,
    val widthCm: Int,
    val lengthCm: Int,
    val heightCm: Int,
    val costPrice: BigDecimal,
    val sellingPrice: BigDecimal,
    val isActive: Boolean = true,
)

data class ProductPreset(
    val id: UUID? = null,
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
