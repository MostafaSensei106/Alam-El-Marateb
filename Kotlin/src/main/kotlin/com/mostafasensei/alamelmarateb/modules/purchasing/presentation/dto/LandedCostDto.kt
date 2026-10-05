package com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto

import jakarta.validation.constraints.NotNull
import java.math.BigDecimal

data class LandedCostRequest(
    val kind: String? = null,
    @field:NotNull val amount: BigDecimal,
    val allocationMethod: String? = null,
    val final: Boolean = false,
)

data class FinalizeLandedCostRequest(
    @field:NotNull val finalAmount: BigDecimal,
)
