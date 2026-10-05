package com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto

import jakarta.validation.constraints.NotNull
import java.util.UUID

data class BatchListRequest(
    val warehouseId: UUID? = null,
    val variantId: UUID? = null,
)
