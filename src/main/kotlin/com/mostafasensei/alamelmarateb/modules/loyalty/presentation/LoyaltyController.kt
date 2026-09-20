package com.mostafasensei.alamelmarateb.modules.loyalty.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PortalRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.loyalty.application.LoyaltyBalance
import com.mostafasensei.alamelmarateb.modules.loyalty.application.LoyaltyEntry
import com.mostafasensei.alamelmarateb.modules.loyalty.application.LoyaltyService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import jakarta.validation.constraints.Positive
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.math.BigDecimal

data class LoyaltyQuoteRequest(
    @field:Positive val points: Int,
)

data class LoyaltyQuoteResponse(val points: Int, val discount: BigDecimal)

/**
 * Customer loyalty — CUSTOMER. Earn is automatic on delivery;
 * redemption flows through place-order (redeemPoints).
 */
@Tag(name = "Loyalty (customer)", description = "Points balance, ledger, quote — CUSTOMER")
@RestController
@RequestMapping(PortalRoutes.LOYALTY)
@PreAuthorize("hasAnyRole('CUSTOMER', 'SUPER_ADMIN')")
class LoyaltyController(
    private val loyaltyService: LoyaltyService,
) : BaseController() {

    @Operation(summary = "My points balance")
    @GetMapping
    fun balance(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<LoyaltyBalance>> =
        ok(loyaltyService.balance(principal.id))

    @Operation(summary = "My points ledger")
    @GetMapping("/ledger")
    fun ledger(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<List<LoyaltyEntry>>> =
        ok(loyaltyService.ledger(principal.id))

    @Operation(summary = "Quote redemption value (validates balance)")
    @PostMapping("/quote")
    fun quote(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: LoyaltyQuoteRequest,
    ): ResponseEntity<ApiResponse<LoyaltyQuoteResponse>> =
        ok(LoyaltyQuoteResponse(request.points, loyaltyService.quoteRedemption(principal.id, request.points)))
}
