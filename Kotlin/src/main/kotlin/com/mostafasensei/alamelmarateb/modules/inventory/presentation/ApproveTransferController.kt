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
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
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

@Tag(name = "Inventory (management)", description = "Warehouses, stocks, transfers, audits — BRANCH_MANAGER")
@RestController
@RequestMapping(InventoryAdminRoutes.BASE)
@ManagerApi
class ApproveTransferController(
    private val warehouseService: WarehouseService,
    private val stockService: StockService,
    private val transferService: TransferService,
    private val auditService: AuditService,
) : BaseController() {

    @Operation(summary = "Approve transfer (final, deducts approved damage)")
    @PostMapping("/transfers/{transferId}/approve")
    fun approve(
        @PathVariable transferId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<Transfer>> =
        ok(transferService.approve(transferId, principal.fullName))

}
