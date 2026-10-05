package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchasingService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Purchasing (suppliers)", description = "Suppliers, supplier payments — BRANCH_MANAGER")
@RestController
@ManagerApi
class GetSupplierController(
    private val purchasingService: PurchasingService,
) : BaseController() {

    @Operation(summary = "Get supplier by id")
    @GetMapping(PurchasingRoutes.SUPPLIER_BY_ID)
    fun get(@PathVariable id: UUID): ResponseEntity<ApiResponse<SupplierView>> =
        ok(purchasingService.getSupplier(id))
}
