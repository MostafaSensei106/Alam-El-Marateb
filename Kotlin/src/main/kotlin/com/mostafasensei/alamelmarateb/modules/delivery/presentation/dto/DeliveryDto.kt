package com.mostafasensei.alamelmarateb.modules.delivery.presentation.dto

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotEmpty
import jakarta.validation.constraints.NotNull
import java.time.LocalDate
import java.util.UUID

data class VehicleRequest(
    val branchId: UUID? = null,
    @field:NotBlank val plate: String,
    val kind: String? = null,
    val capacityKg: Int? = null,
    val status: String = "active",
)

data class VehicleUpdateRequest(
    val branchId: UUID? = null,
    val plate: String? = null,
    val kind: String? = null,
    val capacityKg: Int? = null,
    val status: String? = null,
)

data class CreateTripRequest(
    @field:NotNull val driverId: UUID,
    @field:NotNull val vehicleId: UUID,
    val branchId: UUID? = null,
    @field:NotNull val tripDate: LocalDate,
    @field:NotEmpty val orderIds: List<UUID>,
    val windows: List<String?> = emptyList(),
)

data class UpdateStopRequest(
    @field:NotBlank val status: String,
    val proofPhoto: String? = null,
    val failReason: String? = null,
)

data class ConfirmDeliverRequest(
    @field:NotBlank val proofPhoto: String,
)

data class ReportFailedRequest(
    @field:NotBlank val failReason: String,
)

data class LocationRequest(
    val lat: Double,
    val lng: Double,
)

data class PinStopRequest(
    val lat: Double,
    val lng: Double,
)

data class RateDriverRequest(
    @field:jakarta.validation.constraints.Min(1) @field:jakarta.validation.constraints.Max(5) val rating: Int,
    val note: String? = null,
)
