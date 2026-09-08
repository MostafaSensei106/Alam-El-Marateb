package com.mostafasensei.alamelmarateb.modules.product.domain.model

import com.mostafasensei.alamelmarateb.modules.product.data.model.*
import java.util.UUID

data class ProductResponse(
    val id: UUID? = null,
    val categoryId: UUID,
    val name: String,
    val slug: String,
    val brand: String,
    val description: String? = null,
    val warrantyYears: Int? = null,
    val attributes: List<ProductAttributeResponse> = emptyList(),
    val variants: List<ProductVariantResponse> = emptyList(),
    val isActive: Boolean = true,
)

data class ProductAttributeResponse(
    val attributeId: UUID,
    val value: AttributeValueResponse,
)

sealed interface AttributeValueResponse {
    data class Text(val value: String) : AttributeValueResponse
    data class Number(val value: Double) : AttributeValueResponse
    data class Boolean(val value: Boolean) : AttributeValueResponse
    data class Option(val optionId: UUID) : AttributeValueResponse
    data class MultiOption(val optionIds: List<UUID>) : AttributeValueResponse
}

data class ProductVariantResponse(
    val id: UUID? = null,
    val sku: String,
    val barcode: String? = null,
    val widthCm: Int,
    val lengthCm: Int,
    val heightCm: Int,
    val costPrice: Double,
    val sellingPrice: Double,
    val isActive: Boolean = true,
)
