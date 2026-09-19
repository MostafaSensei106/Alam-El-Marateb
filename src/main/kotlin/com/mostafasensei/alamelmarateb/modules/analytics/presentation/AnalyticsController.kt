package com.mostafasensei.alamelmarateb.modules.analytics.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.AnalyticsRoutes
import com.mostafasensei.alamelmarateb.modules.analytics.application.AnalyticsService
import com.mostafasensei.alamelmarateb.modules.analytics.domain.model.AuditEntry
import com.mostafasensei.alamelmarateb.modules.analytics.domain.model.DashboardSummary
import com.mostafasensei.alamelmarateb.modules.analytics.domain.model.ProductVelocity
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

/**
 * Management dashboard — /api/v1/analytics/...
 * BRANCH_MANAGER only. Revenue/RFM arrive with the sales module.
 */
@Tag(name = "Analytics (dashboard)", description = "Executive overview, velocity, audit trail — BRANCH_MANAGER")
@RestController
@RequestMapping(AnalyticsRoutes.BASE)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class AnalyticsController(
    private val analyticsService: AnalyticsService,
) : BaseController() {

    @Operation(summary = "Executive summary: counts + stock valuation + alerts")
    @GetMapping("/summary")
    fun summary(): ResponseEntity<ApiResponse<DashboardSummary>> =
        ok(analyticsService.summary())

    @Operation(summary = "Product velocity (30d outbound) + days of cover")
    @GetMapping("/product-velocity")
    fun velocity(@RequestParam(required = false) warehouseId: UUID?): ResponseEntity<ApiResponse<List<ProductVelocity>>> =
        ok(analyticsService.velocity(warehouseId))

    @Operation(summary = "Audit trail for one entity (who did what)")
    @GetMapping("/audit-trail/{entity}/{entityId}")
    fun auditTrail(
        @PathVariable entity: String,
        @PathVariable entityId: UUID,
    ): ResponseEntity<ApiResponse<List<AuditEntry>>> =
        ok(analyticsService.auditTrail(entity, entityId))
}
