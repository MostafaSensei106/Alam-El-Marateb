package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.ReceiveLineInput
import com.mostafasensei.alamelmarateb.modules.purchasing.application.ReceiptView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchasingService
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.ReceiveGoodsRequest
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

@Tag(name = "Purchasing (orders)", description = "Purchase orders, goods receipt — BRANCH_MANAGER")
@RestController
@ManagerApi
class ReceiveGoodsController(
    private val purchasingService: PurchasingService,
) : BaseController() {

    @Operation(summary = "Receive one batch (partial allowed, damage recorded)")
    @PostMapping(PurchasingRoutes.RECEIVE_GOODS)
    fun receive(
        @PathVariable id: UUID,
        @Valid @RequestBody request: ReceiveGoodsRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<ReceiptView>> =
        created(
            purchasingService.receive(
                id,
                request.warehouseId,
                request.lines.map { ReceiveLineInput(it.variantId, it.actualQty, it.damagedQty) },
                request.shipmentId,
                principal.fullName,
            ),
        )
}
