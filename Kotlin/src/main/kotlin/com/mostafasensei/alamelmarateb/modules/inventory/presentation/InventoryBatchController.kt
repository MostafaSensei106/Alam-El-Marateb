package com.mostafasensei.alamelmarateb.modules.inventory.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.InventoryAdminRoutes
import com.mostafasensei.alamelmarateb.modules.inventory.application.BatchView
import com.mostafasensei.alamelmarateb.modules.inventory.application.InventoryBatchService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.math.BigDecimal
import java.util.UUID

/**
 * Batch inventory — per-receipt cost layers (FIFO) + valuation.
 * Branch managers only.
 */
@Tag(name = "Inventory (batches)", description = "Per-batch stock layers + valuation — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class InventoryBatchController(
    private val batchService: InventoryBatchService,
) : BaseController() {

    @Operation(summary = "List batches (one row per receipt — batch_no, remaining, unit_cost)")
    @GetMapping(InventoryAdminRoutes.BATCHES)
    fun batches(
        @RequestParam(required = false) warehouseId: UUID?,
        @RequestParam(required = false) variantId: UUID?,
    ): ResponseEntity<ApiResponse<List<BatchView>>> =
        ok(batchService.listBatches(warehouseId, variantId))

    @Operation(summary = "Valuation: inventory cost vs potential revenue/profit at current prices")
    @GetMapping(InventoryAdminRoutes.BATCH_VALUATION)
    fun valuation(
        @RequestParam(required = false) warehouseId: UUID?,
        @RequestParam(required = false) variantId: UUID?,
    ): ResponseEntity<ApiResponse<Map<String, BigDecimal>>> =
        ok(batchService.valuation(warehouseId, variantId))
}
