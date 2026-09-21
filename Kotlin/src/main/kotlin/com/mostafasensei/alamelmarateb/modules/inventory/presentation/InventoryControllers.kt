package com.mostafasensei.alamelmarateb.modules.inventory.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.InventoryAdminRoutes
import com.mostafasensei.alamelmarateb.core.router.WarehouseOpsRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.inventory.application.AuditResult
import com.mostafasensei.alamelmarateb.modules.inventory.application.AuditService
import com.mostafasensei.alamelmarateb.modules.inventory.application.AuditVariance
import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.application.TransferItemRequest
import com.mostafasensei.alamelmarateb.modules.inventory.application.TransferService
import com.mostafasensei.alamelmarateb.modules.inventory.application.WarehouseService
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.StockLevel
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.Transfer
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.Warehouse
import com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto.AdjustStockRequest
import com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto.AuditCountRequest
import com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto.AuditOpenRequest
import com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto.ReceiveBatchRequest
import com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto.SetThresholdRequest
import com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto.TransferCreateRequest
import com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto.WarehouseCreateRequest
import com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto.WarehouseUpdateRequest
import com.mostafasensei.alamelmarateb.modules.inventory.presentation.dto.toItems
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

/**
 * Inventory MANAGEMENT — /api/v1/inventory/...
 * Branch managers only. See docs/modules/inventory.md for flows.
 */
@Tag(name = "Inventory (management)", description = "Warehouses, stocks, transfers, audits — BRANCH_MANAGER")
@RestController
@RequestMapping(InventoryAdminRoutes.BASE)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class InventoryAdminController(
    private val warehouseService: WarehouseService,
    private val stockService: StockService,
    private val transferService: TransferService,
    private val auditService: AuditService,
) : BaseController() {

    @Operation(summary = "List warehouses")
    @GetMapping("/warehouses")
    fun warehouses(): ResponseEntity<ApiResponse<List<Warehouse>>> =
        ok(warehouseService.list())

    @Operation(summary = "Create warehouse")
    @PostMapping("/warehouses")
    fun createWarehouse(@Valid @RequestBody request: WarehouseCreateRequest): ResponseEntity<ApiResponse<Warehouse>> =
        created(warehouseService.create(request.branchId, request.name, request.code))

    @Operation(summary = "Get warehouse by id")
    @GetMapping("/warehouses/{warehouseId}")
    fun warehouse(@PathVariable warehouseId: UUID): ResponseEntity<ApiResponse<Warehouse>> =
        ok(warehouseService.get(warehouseId))

    @Operation(summary = "Update warehouse")
    @PatchMapping("/warehouses/{warehouseId}")
    fun patchUpdateWarehouse(
        @PathVariable warehouseId: UUID,
        @Valid @RequestBody request: WarehouseUpdateRequest,
    ): ResponseEntity<ApiResponse<Warehouse>> =
        updateWarehouse(warehouseId, request)

    @PutMapping("/warehouses/{warehouseId}")
    fun updateWarehouse(
        @PathVariable warehouseId: UUID,
        @Valid @RequestBody request: WarehouseUpdateRequest,
    ): ResponseEntity<ApiResponse<Warehouse>> =
        ok(warehouseService.update(warehouseId, request.name, request.isActive))

    @Operation(summary = "Stock overview per warehouse")
    @GetMapping("/stocks")
    fun stocks(@RequestParam warehouseId: UUID): ResponseEntity<ApiResponse<List<StockLevel>>> =
        ok(stockService.levels(warehouseId))

    @Operation(summary = "Low-stock alerts (below dynamic threshold)")
    @GetMapping("/stocks/low-alerts")
    fun lowAlerts(): ResponseEntity<ApiResponse<List<StockLevel>>> =
        ok(stockService.lowStockAlerts())

    @Operation(summary = "Set min-qty threshold for a variant")
    @PutMapping("/stocks/threshold")
    fun setThreshold(@Valid @RequestBody request: SetThresholdRequest): ResponseEntity<ApiResponse<StockLevel>> =
        ok(stockService.setThreshold(request.warehouseId, request.variantId, request.minQty))

    @Operation(summary = "Create transfer (draft)")
    @PostMapping("/transfers")
    fun createTransfer(@Valid @RequestBody request: TransferCreateRequest): ResponseEntity<ApiResponse<Transfer>> =
        created(transferService.create(request.fromWarehouseId, request.toWarehouseId, request.note, request.toItems()))

    @Operation(summary = "Dispatch transfer (draft → in_transit, deducts source)")
    @PostMapping("/transfers/{transferId}/dispatch")
    fun dispatch(
        @PathVariable transferId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<Transfer>> =
        ok(transferService.dispatch(transferId, principal.fullName))

    @Operation(summary = "Get transfer by id")
    @GetMapping("/transfers/{transferId}")
    fun transfer(@PathVariable transferId: UUID): ResponseEntity<ApiResponse<Transfer>> =
        ok(transferService.get(transferId))

    @Operation(summary = "Approve transfer (final, deducts approved damage)")
    @PostMapping("/transfers/{transferId}/approve")
    fun approve(
        @PathVariable transferId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<Transfer>> =
        ok(transferService.approve(transferId, principal.fullName))

    @Operation(summary = "Open stock audit (snapshots system qty)")
    @PostMapping("/audits")
    fun openAudit(@Valid @RequestBody request: AuditOpenRequest): ResponseEntity<ApiResponse<AuditResult>> =
        created(auditService.open(request.warehouseId, request.note))

    @Operation(summary = "Reconcile audit (variances become moves, final)")
    @PostMapping("/audits/{auditId}/reconcile")
    fun reconcile(
        @PathVariable auditId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<AuditResult>> =
        ok(auditService.reconcile(auditId, principal.fullName))
}

/**
 * Warehouse OPERATIONS — /api/v1/warehouse/...
 * Keepers (daily floor work). See docs/modules/inventory.md for flows.
 */
@Tag(name = "Warehouse (operations)", description = "Lookup, adjustments, receipts, counts — WAREHOUSE_KEEPER")
@RestController
@RequestMapping(WarehouseOpsRoutes.BASE)
@PreAuthorize("hasAnyRole('WAREHOUSE_KEEPER', 'BRANCH_MANAGER', 'SUPER_ADMIN')")
class WarehouseOpsController(
    private val stockService: StockService,
    private val transferService: TransferService,
    private val auditService: AuditService,
) : BaseController() {

    @Operation(summary = "Stock lookup by barcode or SKU")
    @GetMapping("/stocks/lookup/{barcodeOrSku}")
    fun lookup(
        @RequestParam warehouseId: UUID,
        @PathVariable barcodeOrSku: String,
    ): ResponseEntity<ApiResponse<StockLevel>> =
        ok(stockService.lookup(warehouseId, barcodeOrSku))

    @Operation(summary = "Quick stock adjustment (reason required, logged)")
    @PostMapping("/stocks/adjustment")
    fun adjust(
        @Valid @RequestBody request: AdjustStockRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<StockLevel>> =
        ok(stockService.adjust(request.warehouseId, request.variantId, request.qtyDelta, request.note, principal.fullName))

    @Operation(summary = "Pending incoming transfers for my warehouse")
    @GetMapping("/transfers/pending")
    fun pending(@RequestParam warehouseId: UUID): ResponseEntity<ApiResponse<List<Transfer>>> =
        ok(transferService.pendingFor(warehouseId))

    @Operation(summary = "Receive one batch (partial allowed, damage recorded pending)")
    @PostMapping("/transfers/{transferId}/confirm-receipt")
    fun receiveBatch(
        @PathVariable transferId: UUID,
        @Valid @RequestBody request: ReceiveBatchRequest,
    ): ResponseEntity<ApiResponse<Transfer>> =
        ok(
            transferService.receiveBatch(
                transferId,
                request.lines.map { TransferItemRequest(it.variantId, it.qty) },
                request.damaged,
            ),
        )

    @Operation(summary = "Submit audit count line by scan")
    @PostMapping("/audits/{auditId}/count")
    fun submitCount(
        @PathVariable auditId: UUID,
        @Valid @RequestBody request: AuditCountRequest,
    ): ResponseEntity<ApiResponse<AuditVariance>> {
        val result = auditService.submitCount(auditId, request.variantId, request.countedQty)
        val row = result.variances.first { it.variantId == request.variantId }
        return ok(row)
    }
}
