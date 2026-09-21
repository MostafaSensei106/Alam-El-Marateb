package com.mostafasensei.alamelmarateb.modules.analytics.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.AnalyticsRoutes
import com.mostafasensei.alamelmarateb.modules.analytics.application.AnalyticsService
import com.mostafasensei.alamelmarateb.modules.analytics.application.BeaconService
import com.mostafasensei.alamelmarateb.modules.analytics.application.BranchPerformance
import com.mostafasensei.alamelmarateb.modules.analytics.application.DrilldownRow
import com.mostafasensei.alamelmarateb.modules.analytics.application.DrilldownService
import com.mostafasensei.alamelmarateb.modules.analytics.application.GeoCell
import com.mostafasensei.alamelmarateb.modules.analytics.application.InquiryService
import com.mostafasensei.alamelmarateb.modules.analytics.application.InquiryView
import com.mostafasensei.alamelmarateb.modules.analytics.application.RevenueService
import com.mostafasensei.alamelmarateb.modules.analytics.application.RevenueSummary
import com.mostafasensei.alamelmarateb.modules.analytics.application.RfmRow
import com.mostafasensei.alamelmarateb.modules.analytics.application.TopVariant
import com.mostafasensei.alamelmarateb.modules.analytics.domain.model.AuditEntry
import com.mostafasensei.alamelmarateb.modules.analytics.domain.model.DashboardSummary
import com.mostafasensei.alamelmarateb.modules.analytics.domain.model.ProductVelocity
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import jakarta.validation.constraints.NotBlank
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
import java.time.LocalDate
import java.util.UUID
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal

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

/**
 * Revenue + customers + branches — BRANCH_MANAGER.
 */
@Tag(name = "Analytics revenue", description = "Revenue, RFM, branches, geo — BRANCH_MANAGER")
@RestController
@RequestMapping(AnalyticsRoutes.BASE)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class RevenueController(
    private val revenueService: RevenueService,
    private val inquiryService: InquiryService,
    private val drilldownService: DrilldownService,
) : BaseController() {

    @Operation(summary = "Revenue + profit from daily facts")
    @GetMapping("/revenue")
    fun revenue(
        @RequestParam from: LocalDate,
        @RequestParam to: LocalDate,
        @RequestParam(required = false) branchId: UUID?,
    ): ResponseEntity<ApiResponse<RevenueSummary>> =
        ok(revenueService.revenue(from, to, branchId))

    @Operation(summary = "Revenue + profit (alias)")
    @GetMapping("/revenue-profit")
    fun revenueProfit(
        @RequestParam from: LocalDate,
        @RequestParam to: LocalDate,
        @RequestParam(required = false) branchId: UUID?,
    ): ResponseEntity<ApiResponse<RevenueSummary>> =
        ok(revenueService.revenue(from, to, branchId))

    @Operation(summary = "Top variants by quantity")
    @GetMapping("/products/top")
    fun topVariants(
        @RequestParam from: LocalDate,
        @RequestParam to: LocalDate,
        @RequestParam(defaultValue = "10") limit: Int,
    ): ResponseEntity<ApiResponse<List<TopVariant>>> =
        ok(revenueService.topVariants(from, to, limit))

    @Operation(summary = "RFM segmentation (recency/frequency/monetary)")
    @GetMapping("/customers/rfm")
    fun rfm(): ResponseEntity<ApiResponse<List<RfmRow>>> =
        ok(revenueService.rfm())

    @Operation(summary = "Branch performance")
    @GetMapping("/performance/branches")
    fun branches(
        @RequestParam from: LocalDate,
        @RequestParam to: LocalDate,
    ): ResponseEntity<ApiResponse<List<BranchPerformance>>> =
        ok(revenueService.branchPerformance(from, to))

    @Operation(summary = "Geo heatmap by governorate")
    @GetMapping("/geo-heatmap")
    fun geo(
        @RequestParam from: LocalDate,
        @RequestParam to: LocalDate,
    ): ResponseEntity<ApiResponse<List<GeoCell>>> =
        ok(revenueService.geoHeatmap(from, to))

    @Operation(summary = "Heavy sales drilldown (ClickHouse when enabled, else Postgres facts)")
    @GetMapping("/sales-drilldown")
    fun drilldown(
        @RequestParam from: LocalDate,
        @RequestParam to: LocalDate,
        @RequestParam(required = false) branchId: UUID?,
        @RequestParam(defaultValue = "100") limit: Int,
    ): ResponseEntity<ApiResponse<List<DrilldownRow>>> =
        ok(drilldownService.drilldown(from, to, branchId, limit))

    @Operation(summary = "Showroom inquiries")
    @GetMapping("/inquiries")
    fun inquiries(@RequestParam(required = false) branchId: UUID?): ResponseEntity<ApiResponse<List<InquiryView>>> =
        ok(inquiryService.list(branchId))

    @Operation(summary = "Most-asked products never bought (pricing/stock signal)")
    @GetMapping("/inquiries/top-asked")
    fun topAsked(
        @RequestParam from: LocalDate,
        @RequestParam(defaultValue = "10") limit: Int,
    ): ResponseEntity<ApiResponse<List<Map<String, Any?>>>> =
        ok(inquiryService.topAsked(from, limit))
}

data class InquiryLogRequest(
    val branchId: UUID? = null,
    val productId: UUID? = null,
    val variantId: UUID? = null,
    val note: String? = null,
    @field:NotBlank val outcome: String = "just_asking",
    val customerPhone: String? = null,
)

data class BeaconBatchRequest(
    @field:NotBlank val type: String = "PageViewed",
    val anonymousId: String? = null,
    val payload: Map<String, Any?> = emptyMap(),
    val consent: Boolean = false,
)

/**
 * Showroom quick-question + behavior beacon. Beacon is ALWAYS 202.
 */
@Tag(name = "Analytics ingest", description = "Inquiries + behavior beacon")
@RestController
@RequestMapping(AnalyticsRoutes.BASE)
class IngestController(
    private val inquiryService: InquiryService,
    private val beaconService: BeaconService,
) : BaseController() {

    @Operation(summary = "Log showroom question (staff)")
    @PostMapping("/inquiries")
    @PreAuthorize("hasAnyRole('CASHIER', 'BRANCH_MANAGER', 'SUPER_ADMIN')")
    fun logInquiry(
        @Valid @RequestBody request: InquiryLogRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<InquiryView>> =
        created(
            inquiryService.log(
                request.branchId ?: principal.branchId, principal.id,
                request.productId, request.variantId, request.note, request.outcome,
                request.customerPhone, principal.fullName,
            ),
        )

    @Operation(summary = "Behavior beacon (always 202, consent-gated)")
    @PostMapping("/events")
    fun beacon(
        @Valid @RequestBody request: BeaconBatchRequest,
        @AuthenticationPrincipal principal: UserPrincipal?,
    ): ResponseEntity<ApiResponse<Nothing>> {
        beaconService.ingest(request.type, principal?.id, request.anonymousId, request.payload, request.consent)
        return ResponseEntity.status(202).body(
            ApiResponse.messageWithoutData(com.mostafasensei.alamelmarateb.core.i18n.MessageService.t("success.operation")),
        )
    }
}
