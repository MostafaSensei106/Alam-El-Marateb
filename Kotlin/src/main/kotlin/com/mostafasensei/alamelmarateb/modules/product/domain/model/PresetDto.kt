package com.mostafasensei.alamelmarateb.modules.product.domain.model

import jakarta.validation.Valid
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Positive
import jakarta.validation.constraints.PositiveOrZero
import java.util.UUID

data class ProductPresetCreateRequest(
    @field:NotNull val categoryId: UUID,
    @field:NotBlank val name: String,
    @field:NotBlank val brand: String,
    val description: String? = null,
    @field:PositiveOrZero val warrantyYears: Int? = null,
    @field:Valid val attributes: List<ProductAttributeCreateRequest> = emptyList(),
    @field:Valid val variants: List<ProductPresetVariantCreateRequest> = emptyList(),
)

data class ProductAttributeCreateRequest(
    @field:NotNull val attributeId: UUID,
    @field:NotNull @field:Valid val value: AttributeValueCreateRequest,
)

sealed interface AttributeValueCreateRequest {
    data class Text(@field:NotBlank val value: String) : AttributeValueCreateRequest
    data class Number(val value: Double) : AttributeValueCreateRequest
    data class Boolean(val value: kotlin.Boolean) : AttributeValueCreateRequest
    data class Option(@field:NotNull val optionId: UUID) : AttributeValueCreateRequest
    data class MultiOption(val optionIds: List<UUID>) : AttributeValueCreateRequest
}

data class ProductPresetUpdateRequest(
    val name: String? = null,
    val brand: String? = null,
    val description: String? = null,
    @field:PositiveOrZero val warrantyYears: Int? = null,
    val isActive: Boolean? = null,
    @field:Valid val attributes: List<ProductAttributeCreateRequest>? = null,
    @field:Valid val variants: List<ProductPresetVariantCreateRequest>? = null,
)

data class ProductPresetVariantCreateRequest(
    @field:Positive val widthCm: Int,
    @field:Positive val lengthCm: Int,
    @field:Positive val heightCm: Int,
    @field:PositiveOrZero val costPrice: Double,
    @field:PositiveOrZero val sellingPrice: Double,
)
