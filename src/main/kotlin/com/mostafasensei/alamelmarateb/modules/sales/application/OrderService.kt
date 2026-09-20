package com.mostafasensei.alamelmarateb.modules.sales.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.events.InvoicedLine
import com.mostafasensei.alamelmarateb.core.events.OrderInvoicedEvent
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.WarehouseRepository
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.MoveType
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.InstallmentPlanRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.InvoiceRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.OrderItemRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.OrderRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.ReservationRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.ReturnRepository
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.InstallmentJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.InstallmentPlanJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.InvoiceJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.OrderItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.OrderJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.ReservationJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.ReturnJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.Order
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.OrderLine
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.OrderStatus
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentMethod
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentStatus
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.context.ApplicationEventPublisher
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.LocalDate
import java.util.UUID

data class OrderItemInput(val variantId: UUID, val qty: Int)

data class PlaceOrderInput(
    val branchId: UUID,
    val customerId: UUID? = null,
    val guestPhone: String? = null,
    val channel: String = "pos",
    val items: List<OrderItemInput> = emptyList(),
    val paymentMethod: PaymentMethod,
    val deliveryZoneId: UUID? = null,
    val floorNumber: Int? = null,
    val collectFromBranch: Boolean = false,
    val salesRepId: UUID? = null,
    val idempotencyKey: String? = null,
    val downPayment: BigDecimal? = null,
    val months: Int? = null,
    val by: String? = null,
)

data class PlacedOrder(val order: Order, val replayed: Boolean)

@Service
class OrderService(
    private val orderRepository: OrderRepository,
    private val orderItemRepository: OrderItemRepository,
    private val invoiceRepository: InvoiceRepository,
    private val returnRepository: ReturnRepository,
    private val reservationRepository: ReservationRepository,
    private val installmentPlanRepository: InstallmentPlanRepository,
    private val promotionService: PromotionService,
    private val stockService: StockService,
    private val warehouseRepository: WarehouseRepository,
    private val variantRepository: ProductVariantRepository,
    private val auditLog: AuditLogService,
    private val shippingRates: ShippingRates,
    private val events: ApplicationEventPublisher,
) {

    @Transactional
    fun place(input: PlaceOrderInput): PlacedOrder {
        validateIdentity(input)
        if (input.items.isEmpty()) throw UnprocessableException("error.order.empty_items")
        if (input.channel != "pos" && input.channel != "shop") throw BadRequestException("error.order.unknown_channel")

        input.idempotencyKey?.let { key ->
            val existing = orderRepository.findByIdempotencyKey(key).orElse(null)
            if (existing != null) return PlacedOrder(toDomain(existing), replayed = true)
        }

        val order = orderRepository.save(
            OrderJpaEntity(
                branchId = input.branchId, customerId = input.customerId, guestPhone = input.guestPhone,
                channel = input.channel, status = OrderStatus.draft.name,
                idempotencyKey = input.idempotencyKey, salesRepId = input.salesRepId,
            ),
        )
        return PlacedOrder(finalize(order.id!!, input), replayed = false)
    }

    /** POS ticket: saved with list prices, no stock hold, no invoice — completed later. */
    @Transactional
    fun saveDraft(input: PlaceOrderInput): Order {
        validateIdentity(input)
        if (input.items.isEmpty()) throw UnprocessableException("error.order.empty_items")
        val order = OrderJpaEntity(
            branchId = input.branchId, customerId = input.customerId, guestPhone = input.guestPhone,
            channel = input.channel, status = OrderStatus.draft.name, salesRepId = input.salesRepId,
        )
        promotionService.resolveLines(input.items.map { it.variantId to it.qty }).forEach { line ->
            val gross = line.unitPrice.multiply(line.qty.toBigDecimal())
            order.lines.add(
                OrderItemJpaEntity(
                    order = order, variantId = line.variantId, qty = line.qty,
                    unitPrice = line.unitPrice, discount = BigDecimal.ZERO, net = gross,
                ),
            )
        }
        order.subtotal = order.lines.fold(BigDecimal.ZERO) { acc, l -> acc.add(l.net) }.scaled()
        order.grandTotal = order.subtotal
        return toDomain(orderRepository.save(order))
    }

    /** Complete a draft: fresh pricing + promos + stock hold + invoice. */
    @Transactional
    fun completeDraft(
        id: UUID, paymentMethod: PaymentMethod, deliveryZoneId: UUID?, floorNumber: Int?,
        collect: Boolean, downPayment: BigDecimal?, months: Int?, by: String?,
    ): Order {
        val order = load(id)
        if (order.status != OrderStatus.draft.name) throw ConflictException("error.order.draft_only", listOf(order.status))
        val items = order.lines.map { OrderItemInput(it.variantId!!, it.qty) }
        return finalize(
            id,
            PlaceOrderInput(
                branchId = order.branchId!!, customerId = order.customerId, guestPhone = order.guestPhone,
                channel = order.channel, items = items, paymentMethod = paymentMethod,
                deliveryZoneId = deliveryZoneId, floorNumber = floorNumber, collectFromBranch = collect,
                salesRepId = order.salesRepId, downPayment = downPayment, months = months, by = by,
            ),
        )
    }

    private fun validateIdentity(input: PlaceOrderInput) {
        if (input.customerId == null && input.guestPhone.isNullOrBlank()) {
            throw BadRequestException("error.order.identity_required")
        }
    }

    private fun finalize(orderId: UUID, input: PlaceOrderInput): Order {
        val order = load(orderId)
        val warehouseId = warehouseFor(input.branchId)
        val preview = promotionService.priceAndConsume(
            promotionService.resolveLines(input.items.map { it.variantId to it.qty }),
        )
        val fees = feesOf(input.deliveryZoneId, input.floorNumber, input.collectFromBranch)
        val grand = preview.total.add(fees.first).add(fees.second).scaled()

        val paymentStatus = when (input.paymentMethod) {
            PaymentMethod.CASH, PaymentMethod.CARD -> if (input.channel == "pos") PaymentStatus.paid else PaymentStatus.pending_confirmation
            PaymentMethod.COD -> PaymentStatus.unpaid
            PaymentMethod.TRANSFER, PaymentMethod.WALLET -> PaymentStatus.pending_confirmation
            PaymentMethod.INSTALLMENT -> PaymentStatus.partial
        }
        if (input.paymentMethod == PaymentMethod.INSTALLMENT) {
            if ((input.months ?: 0) <= 0) throw UnprocessableException("error.order.months_positive")
        }

        order.status = OrderStatus.confirmed.name
        order.paymentMethod = input.paymentMethod.name
        order.paymentStatus = paymentStatus.name
        order.subtotal = preview.subtotal
        order.discountTotal = preview.totalDiscount
        order.deliveryFee = fees.first
        order.carryUpFee = fees.second
        order.grandTotal = grand
        order.deliveryZoneId = input.deliveryZoneId
        order.floorNumber = input.floorNumber
        order.collectFromBranch = input.collectFromBranch
        order.trackingNumber = order.trackingNumber
            ?: "TRK-${UUID.randomUUID().toString().take(8).uppercase()}"
        order.lines.clear()
        preview.lines.forEach { line ->
            order.lines.add(
                OrderItemJpaEntity(
                    order = order, variantId = line.variantId, qty = line.qty,
                    unitPrice = line.unitPrice, discount = line.discount, net = line.net,
                    appliedPromoCodes = line.appliedCodes.joinToString(","),
                    isGift = line.isGift,
                ),
            )
        }
        val saved = orderRepository.save(order)

        // Hold stock for every line including gifts.
        saved.lines.forEach { stockService.reserve(warehouseId, it.variantId!!, it.qty) }

        if (invoiceRepository.findAll().none { it.orderId == saved.id }) {
            invoiceRepository.save(InvoiceJpaEntity(orderId = saved.id, serial = nextSerial(input.branchId)))
        }

        events.publishEvent(
            OrderInvoicedEvent(
                orderId = saved.id!!,
                branchId = input.branchId,
                day = LocalDate.now(),
                lines = preview.lines.mapNotNull { line ->
                    val variantId = line.variantId ?: return@mapNotNull null
                    InvoicedLine(
                        variantId = variantId,
                        qty = line.qty,
                        net = line.net,
                        costPrice = variantRepository.findById(variantId)?.costPrice ?: BigDecimal.ZERO,
                    )
                },
            ),
        )

        if (input.paymentMethod == PaymentMethod.INSTALLMENT) {
            createPlan(saved.id!!, grand, input.downPayment ?: BigDecimal.ZERO, input.months!!)
        }
        auditLog.record("PLACE", "order", saved.id, input.branchId, input.by, "channel=${input.channel} total=$grand")
        return toDomain(saved)
    }

    /** POS immediate sale: paid + delivered, stock deducted now. */
    @Transactional
    fun completeSale(input: PlaceOrderInput, by: String?): Order {
        if (input.channel != "pos") throw UnprocessableException("error.order.pos_only")
        if (input.paymentMethod != PaymentMethod.CASH && input.paymentMethod != PaymentMethod.CARD) {
            throw UnprocessableException("error.order.immediate_payment")
        }
        val placed = place(input.copy(by = by))
        deductReserved(placed.order)
        val entity = orderRepository.findById(placed.order.id!!).orElseThrow()
        entity.status = OrderStatus.delivered.name
        auditLog.record("COMPLETE", "order", entity.id, entity.branchId, by, "paid on spot")
        return toDomain(orderRepository.save(entity))
    }

    @Transactional
    fun confirmPayment(id: UUID, by: String?): Order {
        val order = load(id)
        if (order.paymentStatus != PaymentStatus.pending_confirmation.name) {
            throw ConflictException("error.order.nothing_to_confirm", listOf(order.paymentStatus))
        }
        order.paymentStatus = PaymentStatus.paid.name
        auditLog.record("CONFIRM_PAYMENT", "order", id, order.branchId, by, null)
        return toDomain(orderRepository.save(order))
    }

    @Transactional
    fun cancel(id: UUID, by: String?): Order {
        val order = load(id)
        if (order.status != OrderStatus.draft.name && order.status != OrderStatus.confirmed.name) {
            throw ConflictException("error.order.cannot_cancel", listOf(order.status))
        }
        releaseAll(order)
        order.status = OrderStatus.cancelled.name
        auditLog.record("CANCEL", "order", id, order.branchId, by, null)
        return toDomain(orderRepository.save(order))
    }

    /** Delivery module (later) calls this on successful handover. */
    @Transactional
    fun markDelivered(id: UUID, by: String?): Order {
        val order = load(id)
        if (order.status == OrderStatus.delivered.name) return toDomain(order)
        if (order.status != OrderStatus.confirmed.name && order.status != OrderStatus.preparing.name &&
            order.status != OrderStatus.delivering.name
        ) {
            throw ConflictException("error.order.cannot_deliver", listOf(order.status))
        }
        deductReserved(toDomain(order))
        order.status = OrderStatus.delivered.name
        auditLog.record("DELIVER", "order", id, order.branchId, by, null)
        return toDomain(orderRepository.save(order))
    }

    @Transactional
    fun requestReturn(orderId: UUID, reason: String, lines: List<OrderItemInput>, by: String?): Order {
        val order = load(orderId)
        if (order.status != OrderStatus.delivered.name) throw ConflictException("error.order.delivered_only", listOf(order.status))
        if (reason.isBlank()) throw BadRequestException("error.order.return_reason_required")
        var refund = BigDecimal.ZERO
        lines.forEach { req ->
            val line = order.lines.firstOrNull { it.variantId == req.variantId }
                ?: throw UnprocessableException("error.order.variant_not_in_order", listOf(req.variantId))
            if (req.qty != line.qty) throw UnprocessableException("error.order.full_line_only", listOf(req.variantId))
            refund = refund.add(line.net)
        }
        returnRepository.save(
            ReturnJpaEntity(orderId = orderId, status = "requested", reason = reason, refundAmount = refund.scaled()),
        )
        auditLog.record("RETURN_REQUEST", "order", orderId, order.branchId, by, "refund=$refund")
        return toDomain(order)
    }

    @Transactional
    fun approveReturn(orderId: UUID, by: String?): Order {
        val order = load(orderId)
        val returns = returnRepository.findAll().filter { it.orderId == orderId && it.status == "requested" }
        if (returns.isEmpty()) throw ConflictException("error.order.no_requested_returns")
        val warehouseId = warehouseFor(order.branchId!!)
        returns.forEach { ret ->
            order.lines.forEach { line ->
                stockService.applyMove(
                    warehouseId, line.variantId!!, line.qty, MoveType.RETURN,
                    "RETURN", ret.id, "Return approved",
                )
            }
            ret.status = "approved"
            returnRepository.save(ret)
        }
        order.status = OrderStatus.returned.name
        auditLog.record("RETURN_APPROVE", "order", orderId, order.branchId, by, null)
        return toDomain(orderRepository.save(order))
    }

    @Transactional(readOnly = true)
    fun track(tracking: String): Order {
        val order = orderRepository.findByTrackingNumber(tracking)
            .orElseThrow { NotFoundException("error.order.not_found") }
        return toDomain(order)
    }

    /** POS scan: barcode (or SKU fallback listing candidates is client-side via lookup). */
    @Transactional(readOnly = true)
    fun scanVariant(barcode: String): Map<String, Any?> {
        val variant = variantRepository.findByBarcode(barcode)
            ?: throw NotFoundException("error.order.no_variant_barcode", listOf(barcode))
        return mapOf(
            "variantId" to variant.id,
            "productId" to variant.productId,
            "sku" to variant.sku,
            "barcode" to variant.barcode,
            "dimensions" to variant.dimensionsLabel,
            "sellingPrice" to variant.sellingPrice,
            "isActive" to variant.isActive,
        )
    }

    @Transactional(readOnly = true)
    fun myOrders(customerId: UUID): List<Order> =
        orderRepository.findByCustomerIdOrderByCreatedAtDesc(customerId).map { toDomain(it) }

    @Transactional(readOnly = true)
    fun estimate(governorate: String, area: String, floor: Int?): Pair<BigDecimal, BigDecimal> =
        feesOf(shippingRates.zoneId(governorate, area), floor, false)

    // ---- reservations ----

    @Transactional
    fun reserve(
        branchId: UUID, customerId: UUID?, guestPhone: String?,
        variantId: UUID, qty: Int, deposit: BigDecimal, deliverAt: LocalDate?, by: String?,
    ): UUID {
        if (customerId == null && guestPhone.isNullOrBlank()) throw BadRequestException("error.order.identity_required")
        if (qty <= 0) throw BadRequestException("error.order.qty_positive")
        variantRepository.findById(variantId) ?: throw NotFoundException("error.order.unknown_variant", listOf(variantId))
        val warehouseId = warehouseFor(branchId)
        stockService.reserve(warehouseId, variantId, qty)
        val saved = reservationRepository.save(
            ReservationJpaEntity(
                branchId = branchId, customerId = customerId, guestPhone = guestPhone,
                variantId = variantId, qty = qty, deposit = deposit, deliverAt = deliverAt, status = "active",
            ),
        )
        auditLog.record("RESERVE", "reservation", saved.id, branchId, by, "qty=$qty deposit=$deposit")
        return saved.id!!
    }

    // ---- internals ----

    private fun deductReserved(order: Order) {
        val warehouseId = warehouseFor(order.branchId!!)
        order.lines.forEach { line ->
            stockService.release(warehouseId, line.variantId, line.qty)
            stockService.applyMove(
                warehouseId, line.variantId, -line.qty,
                MoveType.SALE,
                "ORDER", order.id, "Sale ${order.trackingNumber}",
            )
        }
    }

    private fun releaseAll(order: OrderJpaEntity) {
        val warehouseId = warehouseFor(order.branchId!!)
        order.lines.forEach { stockService.release(warehouseId, it.variantId!!, it.qty) }
    }

    private fun warehouseFor(branchId: UUID): UUID =
        warehouseRepository.findByBranchId(branchId).firstOrNull()?.id
            ?: throw ConflictException("error.order.no_warehouse")

    private fun feesOf(zoneId: UUID?, floor: Int?, collect: Boolean): Pair<BigDecimal, BigDecimal> {
        if (collect == true) return BigDecimal.ZERO to BigDecimal.ZERO
        val delivery = zoneId?.let { shippingRates.zoneFee(it) } ?: BigDecimal.ZERO
        val carry = shippingRates.carryFee(floor)
        return delivery to carry
    }

    private fun nextSerial(branchId: UUID): String {
        val year = LocalDate.now().year
        val prefix = "INV-$year-${branchId.toString().take(8).uppercase()}"
        val seq = invoiceRepository.countBySerialStartingWith(prefix) + 1
        return "$prefix-${seq.toString().padStart(4, '0')}"
    }

    private fun createPlan(orderId: UUID, total: BigDecimal, down: BigDecimal, months: Int) {
        if (down < BigDecimal.ZERO || down > total) throw UnprocessableException("error.order.down_payment_invalid")
        val financed = total.minus(down)
        val monthly = financed.divide(months.toBigDecimal(), 2, RoundingMode.HALF_EVEN)
        val plan = InstallmentPlanJpaEntity(
            orderId = orderId, total = total, downPayment = down,
            months = months, monthlyAmount = monthly,
        )
        repeat(months) { i ->
            plan.installments.add(
                InstallmentJpaEntity(
                    plan = plan, dueDate = LocalDate.now().plusMonths((i + 1).toLong()), amount = monthly,
                ),
            )
        }
        installmentPlanRepository.save(plan)
    }

    private fun load(id: UUID): OrderJpaEntity =
        orderRepository.findById(id).orElseThrow { NotFoundException("error.order.not_found") }

    private fun toDomain(e: OrderJpaEntity): Order = Order(
        id = e.id, branchId = e.branchId, customerId = e.customerId, guestPhone = e.guestPhone,
        channel = e.channel, status = OrderStatus.valueOf(e.status),
        paymentMethod = e.paymentMethod?.let { PaymentMethod.valueOf(it) },
        paymentStatus = PaymentStatus.valueOf(e.paymentStatus),
        subtotal = e.subtotal, discountTotal = e.discountTotal,
        deliveryFee = e.deliveryFee, carryUpFee = e.carryUpFee, grandTotal = e.grandTotal,
        deliveryZoneId = e.deliveryZoneId, floorNumber = e.floorNumber,
        collectFromBranch = e.collectFromBranch, trackingNumber = e.trackingNumber,
        salesRepId = e.salesRepId,
        lines = e.lines.map {
            OrderLine(
                variantId = it.variantId!!, productId = variantRepository.findById(it.variantId!!)?.productId!!,
                qty = it.qty, unitPrice = it.unitPrice, discount = it.discount, net = it.net,
                appliedPromoCodes = it.appliedPromoCodes.split(",").filter { c -> c.isNotBlank() },
                isGift = it.isGift,
            )
        },
    )

    private fun BigDecimal.scaled(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
