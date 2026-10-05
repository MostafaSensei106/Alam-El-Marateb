package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PriceSheetService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PriceSheetView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Purchasing (distributor finance)", description = "Price sheets, shipments, invoices — BRANCH_MANAGER")
@RestController
@ManagerApi
class GetPriceSheetController(
    private val priceSheetService: PriceSheetService,
) : BaseController() {

    @Operation(summary = "Get price sheet with lines")
    @GetMapping(CatalogAdminRoutes.PRICE_SHEET_BY_ID)
    fun getSheet(@PathVariable id: UUID): ResponseEntity<ApiResponse<PriceSheetView>> =
        ok(priceSheetService.getSheet(id))
}
