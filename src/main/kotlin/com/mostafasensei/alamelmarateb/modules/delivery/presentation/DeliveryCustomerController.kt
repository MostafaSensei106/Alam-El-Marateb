package com.mostafasensei.alamelmarateb.modules.delivery.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PortalRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.delivery.application.DeliveryService
import com.mostafasensei.alamelmarateb.modules.delivery.application.DriverRatingView
import com.mostafasensei.alamelmarateb.modules.delivery.application.TripLocationView
import com.mostafasensei.alamelmarateb.modules.delivery.presentation.dto.RateDriverRequest
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

/**
 * Customer delivery experience, CUSTOMER role. Uses portal and shop paths,
 * which bypass the driver-only delivery HTTP matcher.
 */
@Tag(name = "Delivery (customer)", description = "Live location + driver rating — CUSTOMER")
@RestController
@PreAuthorize("hasAnyRole('CUSTOMER', 'SUPER_ADMIN')")
class DeliveryCustomerController(
    private val deliveryService: DeliveryService,
    private val orderService: OrderService,
) : BaseController() {

    @Operation(summary = "Live courier location for my order")
    @GetMapping("/api/v1/shop/orders/track/{trackingNumber}/location")
    fun liveLocation(@PathVariable trackingNumber: String): ResponseEntity<ApiResponse<TripLocationView>> {
        val order = orderService.track(trackingNumber)
        return ok(deliveryService.latestLocationForOrder(order.id!!))
    }

    @Operation(summary = "Rate my driver (delivered orders only)")
    @PostMapping(PortalRoutes.DELIVERY_RATING)
    fun rate(
        @PathVariable orderId: UUID,
        @Valid @RequestBody request: RateDriverRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<DriverRatingView>> =
        created(deliveryService.rateDriver(orderId, principal.id, request.rating, request.note))
}
