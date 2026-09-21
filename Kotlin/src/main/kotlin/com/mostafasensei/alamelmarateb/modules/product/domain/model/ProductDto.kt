package com.mostafasensei.alamelmarateb.modules.product.domain.model

import jakarta.validation.Valid
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Positive
import jakarta.validation.constraints.PositiveOrZero
import java.util.UUID

data class ProductCreateRequest(
    @field:NotNull val categoryId: UUID,
    @field:NotBlank val name: String,
    @field:NotBlank val slug: String,
    @field:NotBlank val brand: String,
    val description: String? = null,
    @field:PositiveOrZero val warrantyYears: Int? = null,
    @field:PositiveOrZero val pricePerMeter: java.math.BigDecimal? = null,
    @field:Valid val attributes: List<ProductAttributeValueRequest> = emptyList(),
    @field:Valid val variants: List<ProductVariantCreateRequest> = emptyList(),
    val translations: Map<String, Map<String, String>>? = null,
)

data class ProductUpdateRequest(
    val name: String? = null,
    val slug: String? = null,
    val brand: String? = null,
    val brandId: UUID? = null,
    val description: String? = null,
    @field:PositiveOrZero val warrantyYears: Int? = null,
    @field:PositiveOrZero val pricePerMeter: java.math.BigDecimal? = null,
    @field:Valid val attributes: List<ProductAttributeValueRequest>? = null,
    val isActive: Boolean? = null,
    val isFeatured: Boolean? = null,
    val translations: Map<String, Map<String, String>>? = null,
)

data class ProductVariantCreateRequest(
    @field:NotBlank val sku: String,
    val barcode: String? = null,
    @field:Positive val widthCm: Int,
    @field:Positive val lengthCm: Int,
    @field:Positive val heightCm: Int,
    @field:PositiveOrZero val costPrice: Double,
    @field:PositiveOrZero val sellingPrice: Double,
)

data class ProductAttributeValueRequest(
    @field:NotNull val attributeId: UUID,
    @field:NotNull @field:Valid val value: AttributeValueRequest,
)

sealed interface AttributeValueRequest {
    data class Text(@field:NotBlank val value: String) : AttributeValueRequest
    data class Number(val value: Double) : AttributeValueRequest
    data class Boolean(val value: kotlin.Boolean) : AttributeValueRequest
    data class Option(@field:NotNull val optionId: UUID) : AttributeValueRequest
    data class MultiOption(val optionIds: List<UUID>) : AttributeValueRequest
}

data class CreateProductFromPresetRequest(
    @field:NotBlank val slug: String,
    @field:NotNull val presetId: UUID,
)
