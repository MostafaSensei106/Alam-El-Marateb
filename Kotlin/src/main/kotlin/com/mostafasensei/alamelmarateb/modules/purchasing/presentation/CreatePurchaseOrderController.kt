package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PoItemInput
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchaseOrderView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchasingService
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.PurchaseOrderRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@Tag(name = "Purchasing (orders)", description = "Purchase orders, goods receipt — BRANCH_MANAGER")
@RestController
@ManagerApi
class CreatePurchaseOrderController(
    private val purchasingService: PurchasingService,
) : BaseController() {

    @Operation(summary = "Create purchase order (draft)")
    @PostMapping(PurchasingRoutes.PURCHASE_ORDERS)
    fun create(
        @Valid @RequestBody request: PurchaseOrderRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<PurchaseOrderView>> =
        created(
            purchasingService.createOrder(
                request.supplierId,
                request.branchId,
                request.items.map { PoItemInput(it.variantId, it.qty, it.unitCost) },
                principal.fullName,
            ),
        )
}
