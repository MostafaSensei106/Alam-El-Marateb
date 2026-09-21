package com.mostafasensei.alamelmarateb.modules.product.domain.model

import java.util.UUID

data class ProductPresetResponse(
    val id: UUID? = null,
    val categoryId: UUID,
    val name: String,
    val brand: String,
    val description: String? = null,
    val warrantyYears: Int? = null,
    val isActive: Boolean = true,
    val attributes: List<ProductAttributeResponse> = emptyList(),
    val variants: List<ProductPresetVariantResponse> = emptyList(),
)

data class ProductPresetVariantResponse(
    val id: UUID? = null,
    val widthCm: Int,
    val lengthCm: Int,
    val heightCm: Int,
    val costPrice: Double,
    val sellingPrice: Double,
    val isActive: Boolean = true,
)
