package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierFinanceService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierStatementView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Purchasing (distributor finance)", description = "Price sheets, shipments, invoices — BRANCH_MANAGER")
@RestController
@ManagerApi
class SupplierStatementController(
    private val financeService: SupplierFinanceService,
) : BaseController() {

    @Operation(summary = "Supplier statement: invoices, overdue installments, total owed")
    @GetMapping(PurchasingRoutes.SUPPLIER_STATEMENT)
    fun statement(@PathVariable id: UUID): ResponseEntity<ApiResponse<SupplierStatementView>> =
        ok(financeService.statement(id))
}
