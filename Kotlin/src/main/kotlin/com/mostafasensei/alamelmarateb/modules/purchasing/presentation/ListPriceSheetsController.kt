package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PriceSheetService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PriceSheetView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Purchasing (distributor finance)", description = "Price sheets, shipments, invoices — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class ListPriceSheetsController(
    private val priceSheetService: PriceSheetService,
) : BaseController() {

    @Operation(summary = "List supplier price sheets")
    @GetMapping(CatalogAdminRoutes.PRICE_SHEETS)
    fun listSheets(@RequestParam supplierId: UUID): ResponseEntity<ApiResponse<List<PriceSheetView>>> =
        ok(priceSheetService.listSheets(supplierId))
}
