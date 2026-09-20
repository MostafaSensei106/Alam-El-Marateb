package com.mostafasensei.alamelmarateb.modules.estimator.presentation.dto

import jakarta.validation.Valid
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Positive
import jakarta.validation.constraints.PositiveOrZero
import java.math.BigDecimal
import java.time.LocalDateTime
import java.util.UUID

data class EstimateQuoteRequest(
    @field:NotNull val productId: UUID,
    @field:NotBlank val shape: String,
    @field:Positive val widthCm: Int,
    @field:Positive val lengthCm: Int,
    @field:Positive val heightCm: Int? = null,
    val governorate: String? = null,
    val area: String? = null,
    @field:PositiveOrZero val floor: Int? = null,
    @field:Positive val qty: Int = 1,
    val channel: String = "shop",
    val branchId: UUID? = null,
)

data class CampaignCreateRequest(
    @field:NotBlank val name: String,
    val startsAt: LocalDateTime? = null,
    val endsAt: LocalDateTime? = null,
    val isActive: Boolean = true,
    @field:Positive val spinsPerCustomer: Int = 1,
)

data class PrizeCreateRequest(
    @field:NotBlank val label: String,
    @field:NotBlank val kind: String,
    @field:PositiveOrZero val value: BigDecimal? = null,
    val giftVariantId: UUID? = null,
    @field:Positive val weight: Int = 1,
    @field:Positive val maxWins: Int? = null,
    @field:PositiveOrZero val sortOrder: Int = 0,
)

data class SpinRequest(
    val campaignId: UUID? = null,
)
