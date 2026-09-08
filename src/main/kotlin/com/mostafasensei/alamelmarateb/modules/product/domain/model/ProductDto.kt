package com.mostafasensei.alamelmarateb.modules.product.domain.model

import com.mostafasensei.alamelmarateb.modules.product.data.model.*
import java.util.UUID

data class ProductCreateRequest(
    val categoryId: UUID,
    val name: String,
    val slug: String,
    val brand: String,
    val description: String? = null,
    val warrantyYears: Int? = null,
    val attributes: List<ProductAttributeValueRequest> = emptyList(),
    val variants: List<ProductVariantCreateRequest> = emptyList(),
)

data class ProductUpdateRequest(
    val name: String? = null,
    val slug: String? = null,
    val brand: String? = null,
    val description: String? = null,
    val warrantyYears: Int? = null,
    val attributes: List<ProductAttributeValueRequest>? = null,
    val isActive: Boolean? = null,
)

data class ProductVariantCreateRequest(
    val sku: String,
    val barcode: String? = null,
    val widthCm: Int,
    val lengthCm: Int,
    val heightCm: Int,
    val costPrice: Double,
    val sellingPrice: Double,
)

data class ProductAttributeValueRequest(
    val attributeId: UUID,
    val value: AttributeValueRequest,
)

sealed interface AttributeValueRequest {
    data class Text(val value: String) : AttributeValueRequest
    data class Number(val value: Double) : AttributeValueRequest
    data class Boolean(val value: Boolean) : AttributeValueRequest
    data class Option(val optionId: UUID) : AttributeValueRequest
    data class MultiOption(val optionIds: List<UUID>) : AttributeValueRequest
}

data class CreateProductFromPresetRequest(
    val slug: String,
    val presetId: UUID,
)
