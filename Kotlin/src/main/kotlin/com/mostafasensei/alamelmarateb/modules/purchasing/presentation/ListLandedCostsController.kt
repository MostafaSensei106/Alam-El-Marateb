package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.modules.purchasing.application.LandedCostService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.LandedCostView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Purchasing (landed cost)", description = "Shipment landed costs + allocation — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class ListLandedCostsController(
    private val landedCostService: LandedCostService,
) : BaseController() {

    @Operation(summary = "List shipment landed costs with per-batch allocations")
    @GetMapping(PurchasingRoutes.LANDED_COSTS)
    fun list(@PathVariable id: UUID): ResponseEntity<ApiResponse<List<LandedCostView>>> =
        ok(landedCostService.listCosts(id))
}
