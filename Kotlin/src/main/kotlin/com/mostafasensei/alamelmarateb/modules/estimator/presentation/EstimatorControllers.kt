package com.mostafasensei.alamelmarateb.modules.estimator.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.EstimatorRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.modules.estimator.application.CampaignView
import com.mostafasensei.alamelmarateb.modules.estimator.application.EstimateBreakdown
import com.mostafasensei.alamelmarateb.modules.estimator.application.EstimatorModel
import com.mostafasensei.alamelmarateb.modules.estimator.application.EstimatorService
import com.mostafasensei.alamelmarateb.modules.estimator.application.PrizeView
import com.mostafasensei.alamelmarateb.modules.estimator.application.SpinResult
import com.mostafasensei.alamelmarateb.modules.estimator.application.SpinService
import com.mostafasensei.alamelmarateb.modules.estimator.presentation.dto.CampaignCreateRequest
import com.mostafasensei.alamelmarateb.modules.estimator.presentation.dto.EstimateQuoteRequest
import com.mostafasensei.alamelmarateb.modules.estimator.presentation.dto.PrizeCreateRequest
import com.mostafasensei.alamelmarateb.modules.estimator.presentation.dto.SpinRequest
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
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

/**
 * Public estimator — catalog picker + automatic price quote.
 * Same flow serves the storefront and in-store staff (channel=pos).
 */
@Tag(name = "Estimator", description = "Catalog picker + automatic price — public")
@RestController
@RequestMapping(EstimatorRoutes.BASE)
class EstimatorController(
    private val estimatorService: EstimatorService,
) : BaseController() {

    @Operation(summary = "Step 1: catalog models with types, heights, meter-price support")
    @GetMapping("/catalog")
    fun catalog(@RequestParam(required = false) categoryId: UUID?): ResponseEntity<ApiResponse<List<EstimatorModel>>> =
        ok(estimatorService.catalog(categoryId))

    @Operation(summary = "Steps 2+3: send ids + shape + height, get automatic price")
    @PostMapping("/quote")
    fun quote(
        @Valid @RequestBody request: EstimateQuoteRequest,
        @AuthenticationPrincipal principal: UserPrincipal?,
    ): ResponseEntity<ApiResponse<EstimateBreakdown>> =
        created(
            estimatorService.quote(
                userId = principal?.id, branchId = request.branchId,
                channel = request.channel, productId = request.productId,
                shape = request.shape, widthCm = request.widthCm, lengthCm = request.lengthCm,
                heightCm = request.heightCm, governorate = request.governorate, area = request.area,
                floor = request.floor, qty = request.qty,
            ),
        )
}

/**
 * Spin management — BRANCH_MANAGER (dashboard defines the 6 prizes + windows).
 */
@Tag(name = "Spin (management)", description = "Campaigns + prizes — BRANCH_MANAGER")
@RestController
@RequestMapping(EstimatorRoutes.BASE)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class SpinManagerController(
    private val spinService: SpinService,
) : BaseController() {

    @Operation(summary = "List campaigns")
    @GetMapping("/spin/campaigns")
    fun campaigns(): ResponseEntity<ApiResponse<List<CampaignView>>> =
        ok(spinService.campaigns())

    @Operation(summary = "Create campaign (active window + spins per customer)")
    @PostMapping("/spin/campaigns")
    fun createCampaign(@Valid @RequestBody request: CampaignCreateRequest): ResponseEntity<ApiResponse<CampaignView>> =
        created(
            spinService.createCampaign(
                request.name, request.startsAt, request.endsAt,
                request.isActive, request.spinsPerCustomer,
            ),
        )

    @Operation(summary = "Toggle campaign on/off")
    @PostMapping("/spin/campaigns/{id}/toggle")
    fun toggle(@PathVariable id: UUID): ResponseEntity<ApiResponse<CampaignView>> =
        ok(spinService.toggleCampaign(id))

    @Operation(summary = "Add prize (max 6 per campaign)")
    @PostMapping("/spin/campaigns/{campaignId}/prizes")
    fun addPrize(
        @PathVariable campaignId: UUID,
        @Valid @RequestBody request: PrizeCreateRequest,
    ): ResponseEntity<ApiResponse<PrizeView>> =
        created(
            spinService.addPrize(
                campaignId, request.label, request.kind, request.value,
                request.giftVariantId, request.weight, request.maxWins, request.sortOrder,
            ),
        )

    @Operation(summary = "Delete prize")
    @DeleteMapping("/spin/prizes/{id}")
    fun deletePrize(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        spinService.deletePrize(id)
        return deleted(MessageService.t("success.deleted"))
    }
}

/**
 * Customer spin — CUSTOMER, one spin per campaign (spins_per_customer).
 */
@Tag(name = "Spin (customer)", description = "Spin the wheel — CUSTOMER")
@RestController
@RequestMapping(EstimatorRoutes.BASE)
@PreAuthorize("hasAnyRole('CUSTOMER', 'SUPER_ADMIN')")
class SpinCustomerController(
    private val spinService: SpinService,
) : BaseController() {

    @Operation(summary = "Spin the wheel (single spin wins a promo code)")
    @PostMapping("/spin")
    fun spin(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: SpinRequest,
    ): ResponseEntity<ApiResponse<SpinResult>> =
        created(spinService.spin(principal.id, request.campaignId))
}
