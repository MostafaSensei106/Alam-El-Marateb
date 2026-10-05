package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.LandedCostService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.LandedCostView
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.LandedAllocationMethod
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.LandedKind
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.LandedCostRequest
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
class AddLandedCostController(
    private val landedCostService: LandedCostService,
) : BaseController() {

    @Operation(summary = "Add landed cost to a shipment (ESTIMATED by default, allocates to batches)")
    @PostMapping(PurchasingRoutes.LANDED_COSTS)
    fun addCost(
        @PathVariable id: UUID,
        @Valid @RequestBody request: LandedCostRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<LandedCostView>> =
        created(
            landedCostService.addCost(
                shipmentId = id,
                kind = request.kind ?: LandedKind.FREIGHT,
                amount = request.amount,
                method = request.allocationMethod ?: LandedAllocationMethod.BY_VALUE,
                final = request.final,
                by = principal.fullName,
            ),
        )
}
