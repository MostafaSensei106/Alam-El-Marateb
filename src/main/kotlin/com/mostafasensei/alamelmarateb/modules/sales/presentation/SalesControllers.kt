package com.mostafasensei.alamelmarateb.modules.sales.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.router.PromotionRoutes
import com.mostafasensei.alamelmarateb.core.router.SalesPosRoutes
import com.mostafasensei.alamelmarateb.core.router.ShopRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.sales.application.CartService
import com.mostafasensei.alamelmarateb.modules.sales.application.CartView
import com.mostafasensei.alamelmarateb.modules.sales.application.ShiftService
import com.mostafasensei.alamelmarateb.modules.sales.application.ShiftView
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderItemInput
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderService
import com.mostafasensei.alamelmarateb.modules.sales.application.PlaceOrderInput
import com.mostafasensei.alamelmarateb.modules.sales.application.ReceiptView
import com.mostafasensei.alamelmarateb.modules.sales.application.PromotionService
import com.mostafasensei.alamelmarateb.modules.sales.application.PromotionView
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.Order
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.CartItemRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.CartMergeRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.CartSetQtyRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.CompleteDraftRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.EstimateRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.EstimateResponse
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.OrderResponse
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.PlaceOrderRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.PricePreviewRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.PricePreviewResponse
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.PromotionCreateRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.ReservationRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.ReturnRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.ShiftCloseRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.ShiftDropRequest
import com.mostafasensei.alamelmarateb.modules.sales.presentation.dto.ShiftOpenRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.Parameter
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

private fun PlaceOrderRequest.toInput(channel: String, by: String?) = PlaceOrderInput(
    branchId = branchId, customerId = customerId, guestPhone = guestPhone, channel = channel,
    items = items.map { OrderItemInput(it.variantId, it.qty) }, paymentMethod = paymentMethod,
    deliveryZoneId = deliveryZoneId, floorNumber = floorNumber, collectFromBranch = collectFromBranch,
    salesRepId = salesRepId, idempotencyKey = idempotencyKey,
    downPayment = downPayment, months = months, by = by,
)

/**
 * Promotion MANAGEMENT — /api/v1/sales/promotions. Managers only.
 */
@Tag(name = "Promotions (management)", description = "Discounts, bundles, gifts — BRANCH_MANAGER")
@RestController
@RequestMapping(PromotionRoutes.BASE)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class PromotionController(
    private val promotionService: PromotionService,
) : BaseController() {

    @Operation(summary = "List promotions")
    @GetMapping
    fun list(): ResponseEntity<ApiResponse<List<PromotionView>>> =
        ok(promotionService.listAll())

    @Operation(summary = "Create promotion")
    @PostMapping
    fun create(@Valid @RequestBody request: PromotionCreateRequest): ResponseEntity<ApiResponse<PromotionView>> =
        created(promotionService.create(request.toInput()))

    @Operation(summary = "Enable/disable promotion")
    @PostMapping("/{id}/toggle")
    fun toggle(@PathVariable id: UUID): ResponseEntity<ApiResponse<PromotionView>> =
        ok(promotionService.toggle(id))
}

/**
 * POS — /api/v1/sales/pos + /api/v1/sales/orders. Cashiers and managers.
 */
@Tag(name = "Sales POS", description = "In-store selling, drafts, returns, shifts — CASHIER")
@RestController
@RequestMapping(SalesPosRoutes.BASE)
@PreAuthorize("hasAnyRole('CASHIER', 'BRANCH_MANAGER', 'SUPER_ADMIN')")
class PosOrderController(
    private val orderService: OrderService,
) : BaseController() {

    @Operation(summary = "Scan barcode/SKU (variant info for the ticket)")
    @GetMapping("/scan/{barcode}")
    fun scan(@PathVariable barcode: String): ResponseEntity<ApiResponse<Map<String, Any?>>> =
        ok(orderService.scanVariant(barcode))

    @Operation(summary = "Save draft ticket (no stock hold)")
    @PostMapping("/orders/draft")
    fun draft(
        @Valid @RequestBody request: PlaceOrderRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<OrderResponse>> =
        created(OrderResponse.fromDomain(orderService.saveDraft(request.toInput("pos", principal.fullName))))

    @Operation(summary = "Complete a draft (pricing + stock hold + invoice)")
    @PostMapping("/orders/{orderId}/complete")
    fun completeDraft(
        @PathVariable orderId: UUID,
        @Valid @RequestBody request: CompleteDraftRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<OrderResponse>> =
        ok(
            OrderResponse.fromDomain(
                orderService.completeDraft(
                    orderId, request.paymentMethod, request.deliveryZoneId,
                    request.floorNumber, request.collectFromBranch,
                    request.downPayment, request.months, principal.fullName,
                ),
            ),
        )

    @Operation(summary = "Immediate sale: paid + delivered now")
    @PostMapping("/complete-sale")
    fun completeSale(
        @Valid @RequestBody request: PlaceOrderRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<OrderResponse>> =
        created(OrderResponse.fromDomain(orderService.completeSale(request.toInput("pos", principal.fullName), principal.fullName)))

    @Operation(summary = "Place order for later delivery/pickup")
    @PostMapping("/place-order", "/custom-order")
    fun placeOrder(
        @Valid @RequestBody request: PlaceOrderRequest,
        @Parameter(description = "Idempotency key — same key returns the original order + Idempotent-Replay: true")
        @RequestHeader(value = "Idempotency-Key", required = false) key: String?,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<OrderResponse>> {
        val placed = orderService.place(request.toInput("pos", principal.fullName).copy(idempotencyKey = key ?: request.idempotencyKey))
        val body = ApiResponse.success(OrderResponse.fromDomain(placed.order), MessageService.t("success.created"))
        return if (placed.replayed) ResponseEntity.ok().header("Idempotent-Replay", "true").body(body)
        else ResponseEntity.status(201).body(body)
    }

    @Operation(summary = "Request return (full lines)")
    @PostMapping("/orders/{orderId}/return")
    fun requestReturn(
        @PathVariable orderId: UUID,
        @Valid @RequestBody request: ReturnRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<OrderResponse>> =
        ok(
            OrderResponse.fromDomain(
                orderService.requestReturn(
                    orderId, request.reason,
                    request.lines.map { OrderItemInput(it.variantId, it.qty) }, principal.fullName,
                ),
            ),
        )

    @Operation(summary = "Create reservation (holds stock)")
    @PostMapping("/reservations")
    fun reserve(
        @Valid @RequestBody request: ReservationRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<UUID>> =
        created(
            orderService.reserve(
                request.branchId, request.customerId, request.guestPhone,
                request.variantId, request.qty, request.deposit, request.deliverAt, principal.fullName,
            ),
        )
}

/**
 * Staff order management — /api/v1/sales/orders.
 */
@Tag(name = "Sales orders", description = "Order lookup, payment confirmation, returns approval")
@RestController
@RequestMapping(SalesPosRoutes.ORDER_LIST)
@PreAuthorize("hasAnyRole('CASHIER', 'BRANCH_MANAGER', 'SUPER_ADMIN')")
class SalesOrderController(
    private val orderService: OrderService,
) : BaseController() {

    @Operation(summary = "Confirm manual payment (transfer/wallet)")
    @PostMapping("/{orderId}/confirm-payment")
    @PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
    fun confirmPayment(
        @PathVariable orderId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<OrderResponse>> =
        ok(OrderResponse.fromDomain(orderService.confirmPayment(orderId, principal.fullName)))

    @Operation(summary = "Approve return (stock back)")
    @PostMapping("/{orderId}/approve-return")
    @PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
    fun approveReturn(
        @PathVariable orderId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<OrderResponse>> =
        ok(OrderResponse.fromDomain(orderService.approveReturn(orderId, principal.fullName)))

    @Operation(summary = "Cancel draft/confirmed order (releases hold)")
    @PostMapping("/{orderId}/cancel")
    fun cancel(
        @PathVariable orderId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<OrderResponse>> =
        ok(OrderResponse.fromDomain(orderService.cancel(orderId, principal.fullName)))
}

/**
 * Cash drawer shifts + receipts — /api/v1/sales/pos. Cashiers and managers.
 */
@Tag(name = "Sales shifts", description = "Drawer open/drop/close + receipts — CASHIER")
@RestController
@RequestMapping(SalesPosRoutes.BASE)
@PreAuthorize("hasAnyRole('CASHIER', 'BRANCH_MANAGER', 'SUPER_ADMIN')")
class PosShiftController(
    private val shiftService: ShiftService,
) : BaseController() {

    @Operation(summary = "Open drawer shift")
    @PostMapping("/drawer/shift/open")
    fun open(
        @Valid @RequestBody request: ShiftOpenRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<ShiftView>> =
        created(shiftService.open(request.branchId, principal.id, request.openingBalance, principal.fullName))

    @Operation(summary = "Current open shift")
    @GetMapping("/drawer/shift/current")
    fun current(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<ShiftView>> =
        ok(shiftService.current(principal.id))

    @Operation(summary = "Cash drop (safe)")
    @PostMapping("/drawer/shift/drop")
    fun drop(
        @Valid @RequestBody request: ShiftDropRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<ShiftView>> =
        ok(shiftService.drop(request.shiftId, request.amount, principal.fullName))

    @Operation(summary = "Close shift (expected vs actual + variance)")
    @PostMapping("/drawer/shift/close")
    fun close(
        @Valid @RequestBody request: ShiftCloseRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<ShiftView>> =
        ok(shiftService.close(request.shiftId, request.actualCash, principal.fullName))

    @Operation(summary = "Printable receipt (JSON)")
    @GetMapping("/orders/{orderId}/receipt")
    fun receipt(@PathVariable orderId: UUID): ResponseEntity<ApiResponse<ReceiptView>> =
        ok(shiftService.receipt(orderId))

    @Operation(summary = "Invoice (print-ready HTML, RTL Arabic)")
    @GetMapping("/orders/{orderId}/invoice-pdf", produces = ["text/html"])
    fun invoice(@PathVariable orderId: UUID): ResponseEntity<String> {
        val r = shiftService.receipt(orderId)
        val rows = r.lines.joinToString("") {
            "<tr><td>${it.qty}</td><td>${it.unitPrice}</td><td>${it.discount}</td><td>${it.net}</td></tr>"
        }
        val html = """
            <!DOCTYPE html><html dir="rtl" lang="ar"><head><meta charset="utf-8">
            <title>فاتورة ${r.serial ?: r.orderId}</title></head><body>
            <h1>فاتورة ${r.serial ?: ""}</h1>
            <p>التتبع: ${r.trackingNumber ?: ""} — الحالة: ${r.status} — الدفع: ${r.paymentMethod ?: ""}</p>
            <table border="1" cellpadding="6"><tr><th>الكمية</th><th>السعر</th><th>الخصم</th><th>الصافي</th></tr>$rows</table>
            <p>الإجمالي الفرعي: ${r.subtotal} — الخصم: ${r.discountTotal}</p>
            <p>التوصيل: ${r.deliveryFee} — التطليع: ${r.carryUpFee}</p>
            <h2>الإجمالي: ${r.grandTotal} ج.م</h2>
            </body></html>
        """.trimIndent()
        return ResponseEntity.ok()
            .header("Content-Disposition", "inline; filename=\"invoice-${r.serial ?: orderId}.html\"")
            .body(html)
    }
}

/**
 * Customer shop — /api/v1/shop. Customers (+ staff preview).
 */
@Tag(name = "Shop (customer)", description = "Cart, checkout, tracking — CUSTOMER")
@RestController
@RequestMapping(ShopRoutes.CART_BASE)
@PreAuthorize("hasAnyRole('CUSTOMER', 'SUPER_ADMIN')")
class ShopCartController(
    private val cartService: CartService,
) : BaseController() {

    @Operation(summary = "My cart")
    @GetMapping
    fun get(
        @AuthenticationPrincipal principal: UserPrincipal,
        @RequestParam(required = false) guestKey: String?,
    ): ResponseEntity<ApiResponse<CartView>> =
        ok(cartService.getOrCreate(principal.id, guestKey))

    @Operation(summary = "Add item")
    @PostMapping("/items")
    fun add(
        @AuthenticationPrincipal principal: UserPrincipal,
        @RequestParam(required = false) guestKey: String?,
        @Valid @RequestBody request: CartItemRequest,
    ): ResponseEntity<ApiResponse<CartView>> =
        created(cartService.add(principal.id, guestKey, request.variantId, request.qty))

    @Operation(summary = "Set item qty (0 removes)")
    @PutMapping("/items")
    fun setQty(
        @AuthenticationPrincipal principal: UserPrincipal,
        @RequestParam(required = false) guestKey: String?,
        @Valid @RequestBody request: CartSetQtyRequest,
    ): ResponseEntity<ApiResponse<CartView>> =
        ok(cartService.setQty(principal.id, guestKey, request.variantId, request.qty))

    @Operation(summary = "Clear cart")
    @PostMapping("/clear")
    fun clear(
        @AuthenticationPrincipal principal: UserPrincipal,
        @RequestParam(required = false) guestKey: String?,
    ): ResponseEntity<ApiResponse<CartView>> =
        ok(cartService.clear(principal.id, guestKey))

    @Operation(summary = "Merge guest cart on login")
    @PostMapping("/merge")
    fun merge(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: CartMergeRequest,
    ): ResponseEntity<ApiResponse<CartView>> =
        ok(cartService.merge(request.guestKey, principal.id))
}

@Tag(name = "Shop checkout", description = "Estimate, preview, place")
@RestController
@RequestMapping(ShopRoutes.CHECKOUT_BASE)
@PreAuthorize("hasAnyRole('CUSTOMER', 'CASHIER', 'BRANCH_MANAGER', 'SUPER_ADMIN')")
class ShopCheckoutController(
    private val orderService: OrderService,
    private val promotionService: PromotionService,
) : BaseController() {

    @Operation(summary = "Estimate delivery + carry-up fees")
    @PostMapping("/estimate-shipping")
    fun estimate(@Valid @RequestBody request: EstimateRequest): ResponseEntity<ApiResponse<EstimateResponse>> {
        val (delivery, carry) = orderService.estimate(request.governorate, request.area, request.floor)
        return ok(EstimateResponse(delivery, carry))
    }

    @Operation(summary = "Price preview (non-binding invoice math)")
    @PostMapping("/price-preview")
    fun preview(@Valid @RequestBody request: PricePreviewRequest): ResponseEntity<ApiResponse<PricePreviewResponse>> {
        val lines = promotionService.resolveLines(request.lines.map { it.variantId to it.qty })
        return ok(PricePreviewResponse.fromDomain(promotionService.preview(lines)))
    }

    @Operation(summary = "Place order")
    @PostMapping("/place-order")
    fun place(
        @Valid @RequestBody request: PlaceOrderRequest,
        @Parameter(description = "Idempotency key — same key returns the original order + Idempotent-Replay: true")
        @RequestHeader(value = "Idempotency-Key", required = false) key: String?,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<OrderResponse>> {
        val placed = orderService.place(
            request.toInput("shop", principal.fullName).copy(
                customerId = request.customerId ?: principal.id,
                idempotencyKey = key ?: request.idempotencyKey,
            ),
        )
        val body = ApiResponse.success(OrderResponse.fromDomain(placed.order), MessageService.t("success.created"))
        return if (placed.replayed) ResponseEntity.ok().header("Idempotent-Replay", "true").body(body)
        else ResponseEntity.status(201).body(body)
    }
}

/**
 * Customer orders — /api/v1/shop/orders. Owner views own orders.
 */
@Tag(name = "Shop orders", description = "My orders — CUSTOMER")
@RestController
@RequestMapping(ShopRoutes.MY_ORDERS)
@PreAuthorize("hasAnyRole('CUSTOMER', 'SUPER_ADMIN')")
class ShopOrderController(
    private val orderService: OrderService,
) : BaseController() {

    @Operation(summary = "My orders")
    @GetMapping
    fun myOrders(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<List<OrderResponse>>> =
        ok(orderService.myOrders(principal.id).map { OrderResponse.fromDomain(it) })

    @Operation(summary = "My order details")
    @GetMapping("/{orderId}")
    fun myOrder(
        @PathVariable orderId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<OrderResponse>> {
        val order = orderService.myOrders(principal.id).firstOrNull { it.id == orderId }
            ?: throw com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException("Order not found")
        return ok(OrderResponse.fromDomain(order))
    }

    @Operation(summary = "Track by tracking number")
    @GetMapping("/track/{trackingNumber}")
    fun track(@PathVariable trackingNumber: String): ResponseEntity<ApiResponse<OrderResponse>> =
        ok(OrderResponse.fromDomain(orderService.track(trackingNumber)))
}
