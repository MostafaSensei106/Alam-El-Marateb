package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.InstallmentInput
import com.mostafasensei.alamelmarateb.modules.purchasing.application.InvoiceView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PriceSheetService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PriceSheetView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SheetLineInput
import com.mostafasensei.alamelmarateb.modules.purchasing.application.ShipmentView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierFinanceService
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.ApplySheetRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.InvoiceAllocateRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.InvoicePayRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.PriceSheetRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.ShipmentRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.SupplierInvoiceRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

/**
 * Distributor economics — price sheets, shipments, supplier invoices + installments.
 * Branch managers only.
 */
@Tag(name = "Purchasing (distributor finance)", description = "Price sheets, shipments, invoices — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class SupplierFinanceController(
    private val priceSheetService: PriceSheetService,
    private val financeService: SupplierFinanceService,
) : BaseController() {

    @Operation(summary = "Create supplier price sheet (official costs per period)")
    @PostMapping(CatalogAdminRoutes.PRICE_SHEETS)
    fun createSheet(
        @Valid @RequestBody request: PriceSheetRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<PriceSheetView>> =
        created(
            priceSheetService.createSheet(
                request.supplierId,
                request.sheetNo ?: "",
                request.validFrom,
                request.validUntil,
                request.lines.map { SheetLineInput(it.variantId, it.listCost, it.suggestedSelling) },
                principal.fullName,
            ),
        )

    @Operation(summary = "Get price sheet with lines")
    @GetMapping(CatalogAdminRoutes.PRICE_SHEET_BY_ID)
    fun getSheet(@PathVariable id: UUID): ResponseEntity<ApiResponse<PriceSheetView>> =
        ok(priceSheetService.getSheet(id))

    @Operation(summary = "List supplier price sheets")
    @GetMapping(CatalogAdminRoutes.PRICE_SHEETS)
    fun listSheets(@RequestParam supplierId: UUID): ResponseEntity<ApiResponse<List<PriceSheetView>>> =
        ok(priceSheetService.listSheets(supplierId))

    @Operation(summary = "Apply sheet -> new channel prices (old batches keep their cost)")
    @PostMapping(CatalogAdminRoutes.PRICE_SHEET_APPLY)
    fun applySheet(
        @PathVariable id: UUID,
        @Valid @RequestBody request: ApplySheetRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<Map<String, Int>>> =
        ok(mapOf("rows" to priceSheetService.applySheet(id, request.channels, principal.fullName)))

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

    @Operation(summary = "Supplier statement: invoices, overdue installments, total owed")
    @GetMapping(PurchasingRoutes.SUPPLIER_STATEMENT)
    fun statement(@PathVariable id: UUID): ResponseEntity<ApiResponse<Map<String, Any>>> =
        ok(financeService.statement(id))
}
