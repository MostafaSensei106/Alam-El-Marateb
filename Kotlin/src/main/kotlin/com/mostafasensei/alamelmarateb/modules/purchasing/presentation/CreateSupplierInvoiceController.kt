package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.InstallmentInput
import com.mostafasensei.alamelmarateb.modules.purchasing.application.InvoiceView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierFinanceService
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.SupplierInvoiceRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@Tag(name = "Purchasing (distributor finance)", description = "Price sheets, shipments, invoices — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class CreateSupplierInvoiceController(
    private val financeService: SupplierFinanceService,
) : BaseController() {

    @Operation(summary = "Create supplier invoice with payment installments")
    @PostMapping(PurchasingRoutes.SUPPLIER_INVOICES)
    fun createInvoice(
        @Valid @RequestBody request: SupplierInvoiceRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<InvoiceView>> =
        created(
            financeService.createInvoice(
                request.supplierId,
                request.invoiceNo ?: "",
                request.total,
                request.issuedAt,
                request.installments.map { InstallmentInput(it.amount, it.dueDate) },
                principal.fullName,
            ),
        )
}
