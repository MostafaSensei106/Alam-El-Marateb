package com.mostafasensei.alamelmarateb.modules.inventory.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.InventoryAdminRoutes
import com.mostafasensei.alamelmarateb.modules.inventory.application.BatchValuationView
import com.mostafasensei.alamelmarateb.modules.inventory.application.BatchView
import com.mostafasensei.alamelmarateb.modules.inventory.application.InventoryBatchService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Inventory (batches)", description = "Per-batch stock layers + valuation — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class ListBatchesController(
    private val batchService: InventoryBatchService,
) : BaseController() {

    @Operation(summary = "List batches (one row per receipt — batch_no, remaining, unit_cost)")
    @GetMapping(InventoryAdminRoutes.BATCHES)
    fun batches(
        @RequestParam(required = false) warehouseId: UUID?,
        @RequestParam(required = false) variantId: UUID?,
    ): ResponseEntity<ApiResponse<List<BatchView>>> =
        ok(batchService.listBatches(warehouseId, variantId))

}
