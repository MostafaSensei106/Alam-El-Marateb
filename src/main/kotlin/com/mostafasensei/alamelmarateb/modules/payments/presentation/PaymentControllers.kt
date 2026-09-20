package com.mostafasensei.alamelmarateb.modules.payments.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.ShopRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.payments.application.PaymentIntentView
import com.mostafasensei.alamelmarateb.modules.payments.application.PaymentService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.servlet.http.HttpServletRequest
import jakarta.validation.Valid
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

data class PaymentIntentRequest(
    @field:NotNull val orderId: UUID,
    @field:NotBlank val gateway: String,
    val guestPhone: String? = null,
)

@Tag(name = "Shop payments", description = "Gateway intents — CUSTOMER")
@RestController
@RequestMapping(ShopRoutes.CHECKOUT_BASE)
@PreAuthorize("hasAnyRole('CUSTOMER', 'CASHIER', 'BRANCH_MANAGER', 'SUPER_ADMIN')")
class PaymentIntentController(
    private val paymentService: PaymentService,
) : BaseController() {

    @Operation(summary = "Create payment intent (fake/paymob/fawry)")
    @PostMapping("/payment-intent")
    fun create(
        @Valid @RequestBody request: PaymentIntentRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<PaymentIntentView>> {
        // Guests pay with matching phone; customers with ownership.
        val customerId = if (request.guestPhone != null) null else principal.id
        return created(paymentService.createIntent(request.orderId, request.gateway, customerId, request.guestPhone))
    }

    @Operation(summary = "My order payment intents")
    @GetMapping("/payment-intents")
    fun myIntents(@RequestParam orderId: UUID): ResponseEntity<ApiResponse<List<PaymentIntentView>>> =
        ok(paymentService.intentsForOrder(orderId))
}

/**
 * Provider callbacks — PUBLIC (no JWT) + HMAC verified. Always precise codes.
 */
@Tag(name = "Payment callbacks", description = "Gateway webhooks — public, signature-verified")
@RestController
@RequestMapping(ShopRoutes.CHECKOUT_BASE)
class PaymentCallbackController(
    private val paymentService: PaymentService,
) : BaseController() {

    @Operation(summary = "Gateway webhook (signature required)")
    @PostMapping("/payment-callback/{gateway}")
    fun callback(
        @PathVariable gateway: String,
        request: HttpServletRequest,
        @RequestBody(required = false) body: String?,
    ): ResponseEntity<ApiResponse<PaymentIntentView>> {
        val headers = request.headerNames.toList().associateWith { request.getHeader(it) }
        return ok(paymentService.handleCallback(gateway, headers, body ?: ""))
    }
}
