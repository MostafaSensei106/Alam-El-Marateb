package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchaseOrderView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchasingService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Purchasing (orders)", description = "Purchase orders, goods receipt — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class GetPurchaseOrderController(
    private val purchasingService: PurchasingService,
) : BaseController() {

    @Operation(summary = "Get purchase order by id")
    @GetMapping(PurchasingRoutes.PURCHASE_ORDER_BY_ID)
    fun get(@PathVariable id: UUID): ResponseEntity<ApiResponse<PurchaseOrderView>> =
        ok(purchasingService.getOrder(id))
}
