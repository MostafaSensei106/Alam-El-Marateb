package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.InvoiceView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierFinanceService
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.InvoicePayRequest
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
class PaySupplierInvoiceController(
    private val financeService: SupplierFinanceService,
) : BaseController() {

    @Operation(summary = "Pay supplier invoice (optionally against an installment)")
    @PostMapping(PurchasingRoutes.SUPPLIER_INVOICE_PAY)
    fun payInvoice(
        @PathVariable id: UUID,
        @Valid @RequestBody request: InvoicePayRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<InvoiceView>> =
        ok(
            financeService.payInvoice(
                id, request.amount, request.method ?: "CASH", request.installmentId, request.ref, principal.fullName,
            ),
        )
}
