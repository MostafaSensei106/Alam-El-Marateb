package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PriceSheetService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PriceSheetView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SheetLineInput
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.PriceSheetRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@Tag(name = "Purchasing (distributor finance)", description = "Price sheets, shipments, invoices — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class CreatePriceSheetController(
    private val priceSheetService: PriceSheetService,
) : BaseController() {

    @Operation(summary = "Create supplier price sheet (official costs per period)")
    @PostMapping(CatalogAdminRoutes.PRICE_SHEETS)
    fun createSheet(
        @Valid @RequestBody request: PriceSheetRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<PriceSheetView>> =
        created(
            priceSheetService.createSheet(
                request.supplierId,
                request.sheetNo ?: "",
                request.validFrom,
                request.validUntil,
                request.lines.map { SheetLineInput(it.variantId, it.listCost, it.suggestedSelling) },
                principal.fullName,
            ),
        )
}
