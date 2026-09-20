package com.mostafasensei.alamelmarateb.modules.product.domain.model

import jakarta.validation.Valid
import jakarta.validation.constraints.Max
import jakarta.validation.constraints.Min
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Positive
import jakarta.validation.constraints.PositiveOrZero
import java.math.BigDecimal
import java.util.UUID

data class QuickCreateRequest(
    @field:NotNull val presetId: UUID,
    @field:NotBlank val slug: String,
    val name: String? = null,
    @field:Positive val widthCm: Int,
    @field:Positive val lengthCm: Int,
    @field:Positive val heightCm: Int? = null,
    val sku: String? = null,
    @field:PositiveOrZero val costPrice: BigDecimal? = null,
    @field:PositiveOrZero val sellingPrice: BigDecimal? = null,
    val brandId: UUID? = null,
)

data class BrandCreateRequest(
    @field:NotBlank val name: String,
    @field:NotBlank val slug: String,
    val logoUrl: String? = null,
    val description: String? = null,
    @field:PositiveOrZero val sortOrder: Int = 0,
    val translations: Map<String, Map<String, String>>? = null,
)

data class BrandUpdateRequest(
    val name: String? = null,
    val slug: String? = null,
    val logoUrl: String? = null,
    val description: String? = null,
    @field:PositiveOrZero val sortOrder: Int? = null,
    val isActive: Boolean? = null,
    val translations: Map<String, Map<String, String>>? = null,
)

data class ReviewCreateRequest(
    @field:NotNull val productId: UUID,
    @field:Min(1) @field:Max(5) val rating: Int,
    val title: String? = null,
    val body: String? = null,
    val photos: List<String> = emptyList(),
)

data class QaAskRequest(
    @field:NotNull val productId: UUID,
    @field:NotBlank val question: String,
)

data class QaAnswerRequest(
    @field:NotBlank val answer: String,
)

data class ReviewModerateRequest(
    val approve: Boolean = true,
)

data class QuizRecommendRequest(
    @field:Valid @field:NotNull val answers: List<QuizAnswerRequest>,
    val categoryId: UUID? = null,
    @field:PositiveOrZero val maxPrice: BigDecimal? = null,
    @field:Positive val limit: Int = 3,
)

data class QuizAnswerRequest(
    @field:NotNull val questionId: UUID,
    @field:NotNull val optionId: UUID,
)

data class CustomQuoteRequest(
    @field:NotBlank val shape: String,
    @field:Positive val widthCm: Int,
    @field:Positive val lengthCm: Int,
)

data class VariantAttributeRequest(
    @field:NotNull val attributeId: UUID,
    @field:NotNull @field:Valid val value: AttributeValueRequest,
)

data class VariantAttributeDto(
    val id: UUID?,
    val variantId: UUID?,
    val attributeId: UUID?,
    val valueType: String,
    val valueText: String?,
    val valueNumber: BigDecimal?,
    val valueBoolean: Boolean?,
    val valueOptionId: UUID?,
)
