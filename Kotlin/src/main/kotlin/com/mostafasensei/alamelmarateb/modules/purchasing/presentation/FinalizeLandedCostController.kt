package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.LandedCostService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.LandedCostView
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.FinalizeLandedCostRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Purchasing (landed cost)", description = "Shipment landed costs + allocation — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class FinalizeLandedCostController(
    private val landedCostService: LandedCostService,
) : BaseController() {

    @Operation(summary = "Finalize landed cost: remaining stock adjusted, sold share goes to variance")
    @PostMapping(PurchasingRoutes.LANDED_COST_FINALIZE)
    fun finalize(
        @PathVariable id: UUID,
        @Valid @RequestBody request: FinalizeLandedCostRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<LandedCostView>> =
        ok(landedCostService.finalizeCost(id, request.finalAmount, principal.fullName))
}
