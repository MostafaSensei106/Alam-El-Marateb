package com.mostafasensei.alamelmarateb.modules.delivery.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.router.DeliveryRoutes
import com.mostafasensei.alamelmarateb.core.router.IdentityAdminRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.delivery.application.DeliveryService
import com.mostafasensei.alamelmarateb.modules.delivery.application.StopView
import com.mostafasensei.alamelmarateb.modules.delivery.application.TripView
import com.mostafasensei.alamelmarateb.modules.delivery.application.VehicleView
import com.mostafasensei.alamelmarateb.modules.delivery.presentation.dto.ConfirmDeliverRequest
import com.mostafasensei.alamelmarateb.modules.delivery.presentation.dto.CreateTripRequest
import com.mostafasensei.alamelmarateb.modules.delivery.presentation.dto.ReportFailedRequest
import com.mostafasensei.alamelmarateb.modules.delivery.presentation.dto.UpdateStopRequest
import com.mostafasensei.alamelmarateb.modules.delivery.presentation.dto.VehicleRequest
import com.mostafasensei.alamelmarateb.modules.delivery.presentation.dto.VehicleUpdateRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

/**
 * Delivery DRIVER — /api/v1/delivery/... Own trips only.
 */
@Tag(name = "Delivery (driver)", description = "My trips, stops, proof of delivery — DELIVERY_DRIVER")
@RestController
@PreAuthorize("hasAnyRole('DELIVERY_DRIVER', 'SUPER_ADMIN')")
class DeliveryDriverController(
    private val deliveryService: DeliveryService,
) : BaseController() {

    @Operation(summary = "My delivery trips")
    @GetMapping(DeliveryRoutes.MY_TRIPS)
    fun myTrips(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<List<TripView>>> =
        ok(deliveryService.myTrips(principal.id))

    @Operation(summary = "Stops of a trip")
    @GetMapping(DeliveryRoutes.TRIP_STOPS)
    fun tripStops(@PathVariable tripId: UUID): ResponseEntity<ApiResponse<List<StopView>>> =
        ok(deliveryService.tripStops(tripId))

    @Operation(summary = "Update stop status (delivered needs proof, failed needs reason)")
    @PostMapping(DeliveryRoutes.UPDATE_STOP_STATUS)
    fun updateStop(
        @PathVariable stopId: UUID,
        @Valid @RequestBody request: UpdateStopRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<StopView>> =
        ok(deliveryService.updateStop(stopId, request.status, request.proofPhoto, request.failReason, principal))

    @Operation(summary = "Confirm handover for an order (closes the sales order)")
    @PostMapping(DeliveryRoutes.CONFIRM_DELIVER)
    fun confirmDeliver(
        @PathVariable orderId: UUID,
        @Valid @RequestBody request: ConfirmDeliverRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<StopView>> =
        ok(deliveryService.confirmDeliver(orderId, request.proofPhoto, principal))

    @Operation(summary = "Report failed delivery for an order")
    @PostMapping(DeliveryRoutes.REPORT_FAILED_DELIVERY)
    fun reportFailed(
        @PathVariable orderId: UUID,
        @Valid @RequestBody request: ReportFailedRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<StopView>> =
        ok(deliveryService.reportFailed(orderId, request.failReason, principal))
}

/**
 * Delivery MANAGEMENT — fleet vehicles (identity prefix) + trip lifecycle.
 * Vehicles sit under the identity prefix so they are SUPER_ADMIN-only (SecurityConfig);
 * trip management under the delivery prefix is likewise SUPER_ADMIN-only.
 */


@Tag(name = "Delivery (management)", description = "Fleet vehicles, trip lifecycle — SUPER_ADMIN")
@RestController
class DeliveryManagerController(
    private val deliveryService: DeliveryService,
) : BaseController() {

    @Operation(summary = "List fleet vehicles")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN')")
    @GetMapping(IdentityAdminRoutes.VEHICLES)
    fun vehicles(): ResponseEntity<ApiResponse<List<VehicleView>>> =
        ok(deliveryService.vehicles())

    @Operation(summary = "Register vehicle (plate is uppercased)")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN')")
    @PostMapping(IdentityAdminRoutes.VEHICLES)
    fun createVehicle(
        @Valid @RequestBody request: VehicleRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<VehicleView>> =
        created(
            deliveryService.createVehicle(
                request.branchId, request.plate, request.kind,
                request.capacityKg, request.status, principal.fullName,
            ),
        )

    @Operation(summary = "Get vehicle")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN')")
    @GetMapping(IdentityAdminRoutes.VEHICLE_BY_ID)
    fun vehicle(@PathVariable id: UUID): ResponseEntity<ApiResponse<VehicleView>> =
        ok(deliveryService.vehicle(id))

    @Operation(summary = "Update vehicle")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN')")
    @PutMapping(IdentityAdminRoutes.VEHICLE_BY_ID)
    fun updateVehicle(
        @PathVariable id: UUID,
        @Valid @RequestBody request: VehicleUpdateRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<VehicleView>> =
        ok(
            deliveryService.updateVehicle(
                id, request.branchId, request.plate, request.kind,
                request.capacityKg, request.status, principal.fullName,
            ),
        )

    @Operation(summary = "Remove vehicle")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN')")
    @DeleteMapping(IdentityAdminRoutes.VEHICLE_BY_ID)
    fun deleteVehicle(
        @PathVariable id: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<Nothing>> {
        deliveryService.deleteVehicle(id, principal.fullName)
        return deleted(MessageService.t("success.deleted"))
    }

    @Operation(summary = "Create trip with stops (seq 1..n, status draft)")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN')")
    @PostMapping(DeliveryRoutes.TRIPS)
    fun createTrip(
        @Valid @RequestBody request: CreateTripRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<TripView>> =
        created(
            deliveryService.createTrip(
                request.driverId, request.vehicleId, request.branchId,
                request.tripDate, request.orderIds, request.windows, principal.fullName,
            ),
        )

    @Operation(summary = "Dispatch trip (draft -> in_transit)")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN')")
    @PostMapping(DeliveryRoutes.TRIP_DISPATCH)
    fun dispatch(
        @PathVariable tripId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<TripView>> =
        ok(deliveryService.dispatch(tripId, principal.fullName))

    @Operation(summary = "Cancel draft trip (draft -> cancelled)")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN')")
    @PostMapping(DeliveryRoutes.TRIP_CANCEL)
    fun cancel(
        @PathVariable tripId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<TripView>> =
        ok(deliveryService.cancelTrip(tripId, principal.fullName))

    @Operation(summary = "Complete trip when all stops are terminal (-> done)")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN')")
    @PostMapping(DeliveryRoutes.TRIP_COMPLETE)
    fun complete(
        @PathVariable tripId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<TripView>> =
        ok(deliveryService.completeTrip(tripId, principal.fullName))
}
