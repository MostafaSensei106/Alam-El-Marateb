package com.mostafasensei.alamelmarateb.modules.product.domain.model

import java.util.UUID

data class ProductPresetCreateRequest(
    val categoryId: UUID,
    val name: String,
    val brand: String,
    val description: String? = null,
    val warrantyYears: Int? = null,
    val attributes: List<ProductAttributeCreateRequest> = emptyList(),
    val variants: List<ProductPresetVariantCreateRequest> = emptyList(),
)

data class ProductAttributeCreateRequest(
    val attributeId: UUID,
    val value: AttributeValueCreateRequest,
)

sealed interface AttributeValueCreateRequest {
    data class Text(val value: String) : AttributeValueCreateRequest
    data class Number(val value: Double) : AttributeValueCreateRequest
    data class Boolean(val value: Boolean) : AttributeValueCreateRequest
    data class Option(val optionId: UUID) : AttributeValueCreateRequest
    data class MultiOption(val optionIds: List<UUID>) : AttributeValueCreateRequest
}

data class ProductPresetUpdateRequest(
    val name: String? = null,
    val brand: String? = null,
    val description: String? = null,
    val warrantyYears: Int? = null,
    val isActive: Boolean? = null,
    val attributes: List<ProductAttributeCreateRequest>? = null,
    val variants: List<ProductPresetVariantCreateRequest>? = null,
)

data class ProductPresetVariantCreateRequest(
    val widthCm: Int,
    val lengthCm: Int,
    val heightCm: Int,
    val costPrice: Double,
    val sellingPrice: Double,
)
