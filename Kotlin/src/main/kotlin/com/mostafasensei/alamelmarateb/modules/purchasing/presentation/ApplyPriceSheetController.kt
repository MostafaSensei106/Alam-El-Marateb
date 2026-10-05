package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PriceSheetService
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.ApplySheetRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.ApplySheetResultView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Purchasing (distributor finance)", description = "Price sheets, shipments, invoices — BRANCH_MANAGER")
@RestController
@ManagerApi
class ApplyPriceSheetController(
    private val priceSheetService: PriceSheetService,
) : BaseController() {

    @Operation(summary = "Apply sheet -> new channel prices (old batches keep their cost)")
    @PostMapping(CatalogAdminRoutes.PRICE_SHEET_APPLY)
    fun applySheet(
        @PathVariable id: UUID,
        @Valid @RequestBody request: ApplySheetRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<ApplySheetResultView>> =
        ok(ApplySheetResultView(priceSheetService.applySheet(id, request.channels, principal.fullName)))
}
