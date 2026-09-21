package com.mostafasensei.alamelmarateb.modules.crm.presentation.dto

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import java.time.Instant
import java.time.LocalDate
import java.util.UUID

data class ProfileRequest(
    val governorate: String? = null,
    val city: String? = null,
    val referralSource: String? = null,
    val birthDate: LocalDate? = null,
)

data class AddressRequest(
    val label: String = "home",
    @field:NotBlank val phone: String,
    @field:NotBlank val governorate: String,
    @field:NotBlank val addressText: String,
    val isDefault: Boolean = false,
)

data class FavoriteRequest(
    @field:NotNull val productId: UUID,
)

data class WarrantyRegisterRequest(
    @field:NotNull val invoiceId: UUID,
)

data class ClaimFileRequest(
    @field:NotNull val warrantyId: UUID,
    @field:NotBlank val description: String,
    val photos: String? = null,
)

data class InspectionRequest(
    @field:NotNull val inspectionAt: Instant,
)

data class ResolveRequest(
    @field:NotBlank val resolution: String,
)
