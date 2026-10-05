package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchasingService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@Tag(name = "Purchasing (suppliers)", description = "Suppliers, supplier payments — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class ListSuppliersController(
    private val purchasingService: PurchasingService,
) : BaseController() {

    @Operation(summary = "List suppliers")
    @GetMapping(PurchasingRoutes.SUPPLIERS)
    fun list(@RequestParam(required = false) activeOnly: Boolean?): ResponseEntity<ApiResponse<List<SupplierView>>> =
        ok(purchasingService.listSuppliers(activeOnly))
}
