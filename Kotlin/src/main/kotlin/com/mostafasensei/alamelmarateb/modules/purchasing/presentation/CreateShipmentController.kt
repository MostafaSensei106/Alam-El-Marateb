package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.ShipmentView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierFinanceService
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.ShipmentRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@Tag(name = "Purchasing (distributor finance)", description = "Price sheets, shipments, invoices — BRANCH_MANAGER")
@RestController
@ManagerApi
class CreateShipmentController(
    private val financeService: SupplierFinanceService,
) : BaseController() {

    @Operation(summary = "Create shipment (container/truck arrival)")
    @PostMapping(PurchasingRoutes.SHIPMENTS)
    fun createShipment(
        @Valid @RequestBody request: ShipmentRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<ShipmentView>> =
        created(
            financeService.createShipment(
                request.supplierId, request.shipmentNo ?: "", request.arrivedAt, request.note, principal.fullName,
            ),
        )
}
