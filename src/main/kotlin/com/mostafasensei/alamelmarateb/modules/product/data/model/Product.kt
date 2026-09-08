package com.mostafasensei.alamelmarateb.modules.product.data.model

import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

data class Product(
    val id: UUID? = null,
    val categoryId: UUID,
    val name: String,
    val slug: String,
    val brand: String,
    val description: String? = null,
    val warrantyYears: Int? = null,
    val attributes: List<ProductAttributeValue> = emptyList(),
    val variants: List<ProductVariant> = emptyList(),
    val isActive: Boolean = true,
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now(),
)
