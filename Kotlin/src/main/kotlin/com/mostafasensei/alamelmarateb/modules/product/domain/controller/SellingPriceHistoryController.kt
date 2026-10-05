package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.product.domain.service.SellingPriceService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.SellingPriceView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import jakarta.validation.constraints.NotNull
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.math.BigDecimal
import java.util.UUID

@Tag(name = "Catalog (selling prices)", description = "Channel prices + history — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class SellingPriceHistoryController(
    private val sellingPriceService: SellingPriceService,
) : BaseController() {

    @Operation(summary = "Price history for a variant")
    @GetMapping(CatalogAdminRoutes.SELLING_PRICES)
    fun history(
        @RequestParam variantId: UUID,
        @RequestParam(required = false) channel: String?,
    ): ResponseEntity<ApiResponse<List<SellingPriceView>>> =
        ok(sellingPriceService.history(variantId, channel))

}
