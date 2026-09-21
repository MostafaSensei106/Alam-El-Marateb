package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PoItemInput
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchaseOrderView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.ReceiptView
import com.mostafasensei.alamelmarateb.modules.purchasing.application.ReceiveLineInput
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchasingService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierView
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.PoActionRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.PurchaseOrderRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.ReceiveGoodsRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.SupplierPaymentRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.SupplierRequest
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.SupplierUpdateRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

/**
 * Purchasing — suppliers + supplier payments.
 * Branch managers only. See docs/modules/inventory.md §6 for the flow.
 */
@Tag(name = "Purchasing (suppliers)", description = "Suppliers, supplier payments — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class SupplierController(
    private val purchasingService: PurchasingService,
) : BaseController() {

    @Operation(summary = "List suppliers")
    @GetMapping(PurchasingRoutes.SUPPLIERS)
    fun list(@RequestParam(required = false) activeOnly: Boolean?): ResponseEntity<ApiResponse<List<SupplierView>>> =
        ok(purchasingService.listSuppliers(activeOnly))

    @Operation(summary = "Create supplier")
    @PostMapping(PurchasingRoutes.SUPPLIERS)
    fun create(
        @Valid @RequestBody request: SupplierRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<SupplierView>> =
        created(
            purchasingService.createSupplier(
                request.name, request.phone, request.address, request.taxId, principal.fullName,
            ),
        )

    @Operation(summary = "Get supplier by id")
    @GetMapping(PurchasingRoutes.SUPPLIER_BY_ID)
    fun get(@PathVariable id: UUID): ResponseEntity<ApiResponse<SupplierView>> =
        ok(purchasingService.getSupplier(id))

    @Operation(summary = "Update supplier")
    @PatchMapping(PurchasingRoutes.SUPPLIER_BY_ID)
    fun patchUpdate(
        @PathVariable id: UUID,
        @Valid @RequestBody request: SupplierUpdateRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<SupplierView>> =
        update(id, request, principal)

    @PutMapping(PurchasingRoutes.SUPPLIER_BY_ID)
    fun update(
        @PathVariable id: UUID,
        @Valid @RequestBody request: SupplierUpdateRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<SupplierView>> =
        ok(
            purchasingService.updateSupplier(
                id, request.name, request.phone, request.address,
                request.taxId, request.isActive, principal.fullName,
            ),
        )

    @Operation(summary = "Deactivate supplier (history preserved)")
    @DeleteMapping(PurchasingRoutes.SUPPLIER_BY_ID)
    fun deactivate(
        @PathVariable id: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<Nothing>> {
        purchasingService.deactivateSupplier(id, principal.fullName)
        return deleted(MessageService.t("success.deleted"))
    }

    @Operation(summary = "Record supplier payment (reduces balance)")
    @PostMapping(PurchasingRoutes.SUPPLIER_PAYMENTS)
    fun pay(
        @Valid @RequestBody request: SupplierPaymentRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<SupplierView>> =
        ok(purchasingService.paySupplier(request.supplierId, request.amount, principal.fullName))
}

/**
 * Purchasing — purchase orders + goods receipt.
 * Branch managers only. See docs/modules/inventory.md §6 for the flow.
 */
@Tag(name = "Purchasing (orders)", description = "Purchase orders, goods receipt — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class PurchaseOrderController(
    private val purchasingService: PurchasingService,
) : BaseController() {

    @Operation(summary = "List purchase orders (optional supplier/status filter)")
    @GetMapping(PurchasingRoutes.PURCHASE_ORDERS)
    fun list(
        @RequestParam(required = false) supplierId: UUID?,
        @RequestParam(required = false) status: String?,
    ): ResponseEntity<ApiResponse<List<PurchaseOrderView>>> =
        ok(purchasingService.listOrders(supplierId, status))

    @Operation(summary = "Create purchase order (draft)")
    @PostMapping(PurchasingRoutes.PURCHASE_ORDERS)
    fun create(
        @Valid @RequestBody request: PurchaseOrderRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<PurchaseOrderView>> =
        created(
            purchasingService.createOrder(
                request.supplierId,
                request.branchId,
                request.items.map { PoItemInput(it.variantId, it.qty, it.unitCost) },
                principal.fullName,
            ),
        )

    @Operation(summary = "Get purchase order by id")
    @GetMapping(PurchasingRoutes.PURCHASE_ORDER_BY_ID)
    fun get(@PathVariable id: UUID): ResponseEntity<ApiResponse<PurchaseOrderView>> =
        ok(purchasingService.getOrder(id))

    @Operation(summary = "Send or cancel purchase order (draft → sent/cancelled)")
    @PostMapping(PurchasingRoutes.PURCHASE_ORDER_BY_ID)
    fun transition(
        @PathVariable id: UUID,
        @Valid @RequestBody request: PoActionRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<PurchaseOrderView>> =
        ok(purchasingService.transition(id, request.action, principal.fullName))

    @Operation(summary = "Receive one batch (partial allowed, damage recorded)")
    @PostMapping(PurchasingRoutes.RECEIVE_GOODS)
    fun receive(
        @PathVariable id: UUID,
        @Valid @RequestBody request: ReceiveGoodsRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<ReceiptView>> =
        created(
            purchasingService.receive(
                id,
                request.warehouseId,
                request.lines.map { ReceiveLineInput(it.variantId, it.actualQty, it.damagedQty) },
                principal.fullName,
            ),
        )
}
