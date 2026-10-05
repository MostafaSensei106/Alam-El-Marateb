package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierFinanceService
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.InvoiceAllocateRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Purchasing (distributor finance)", description = "Price sheets, shipments, invoices — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class AllocateInvoiceController(
    private val financeService: SupplierFinanceService,
) : BaseController() {

    @Operation(summary = "Allocate invoice amount to a shipment")
    @PostMapping(PurchasingRoutes.SUPPLIER_INVOICE_ALLOCATE)
    fun allocate(
        @PathVariable id: UUID,
        @Valid @RequestBody request: InvoiceAllocateRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<Map<String, String>>> {
        financeService.allocate(id, request.shipmentId, request.amount, principal.fullName)
        return ok(mapOf("status" to "allocated"))
    }
}
