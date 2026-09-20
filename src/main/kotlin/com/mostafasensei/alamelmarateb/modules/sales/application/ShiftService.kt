package com.mostafasensei.alamelmarateb.modules.sales.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.CashDropRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.CashShiftRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.InvoiceRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.OrderRepository
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.CashDropJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.CashShiftJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.OrderStatus
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentMethod
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.Instant
import java.util.UUID

data class ShiftView(
    val id: UUID?,
    val branchId: UUID?,
    val cashierId: UUID?,
    val openedAt: String?,
    val openingBalance: BigDecimal,
    val closedAt: String?,
    val expectedCash: BigDecimal?,
    val actualCash: BigDecimal?,
    val variance: BigDecimal?,
    val dropsTotal: BigDecimal,
    val status: String,
)

data class ReceiptView(
    val orderId: UUID?,
    val serial: String?,
    val trackingNumber: String?,
    val status: String,
    val paymentMethod: String?,
    val paymentStatus: String,
    val lines: List<ReceiptLine>,
    val subtotal: BigDecimal,
    val discountTotal: BigDecimal,
    val deliveryFee: BigDecimal,
    val carryUpFee: BigDecimal,
    val grandTotal: BigDecimal,
    val issuedAt: String?,
)

data class ReceiptLine(
    val variantId: UUID?,
    val qty: Int,
    val unitPrice: BigDecimal,
    val discount: BigDecimal,
    val net: BigDecimal,
    val isGift: Boolean,
)

@Service
class ShiftService(
    private val shiftRepository: CashShiftRepository,
    private val dropRepository: CashDropRepository,
    private val orderRepository: OrderRepository,
    private val invoiceRepository: InvoiceRepository,
    private val auditLog: AuditLogService,
) {

    @Transactional
    fun open(branchId: UUID, cashierId: UUID, openingBalance: BigDecimal, by: String?): ShiftView {
        if (openingBalance < BigDecimal.ZERO) throw BadRequestException("error.shift.amount_negative")
        if (shiftRepository.findByCashierIdAndStatus(cashierId, "open").isPresent) {
            throw ConflictException("error.shift.open_exists")
        }
        val saved = shiftRepository.save(
            CashShiftJpaEntity(branchId = branchId, cashierId = cashierId, openingBalance = openingBalance.scaled()),
        )
        auditLog.record("SHIFT_OPEN", "cash_shift", saved.id, branchId, by, "opening=$openingBalance")
        return toView(saved)
    }

    @Transactional(readOnly = true)
    fun current(cashierId: UUID): ShiftView {
        val shift = shiftRepository.findByCashierIdAndStatus(cashierId, "open")
            .orElseThrow { NotFoundException("error.shift.no_open_shift") }
        return toView(shift)
    }

    @Transactional
    fun drop(shiftId: UUID, amount: BigDecimal, by: String?): ShiftView {
        if (amount <= BigDecimal.ZERO) throw BadRequestException("error.shift.amount_negative")
        val shift = shiftRepository.findById(shiftId)
            .orElseThrow { NotFoundException("error.shift.shift_not_found") }
        if (shift.status != "open") throw ConflictException("error.shift.already_closed")
        dropRepository.save(CashDropJpaEntity(shiftId = shiftId, amount = amount.scaled(), createdBy = by))
        auditLog.record("CASH_DROP", "cash_shift", shiftId, shift.branchId, by, "amount=$amount")
        return toView(shift)
    }

    @Transactional
    fun close(shiftId: UUID, actualCash: BigDecimal, by: String?): ShiftView {
        if (actualCash < BigDecimal.ZERO) throw BadRequestException("error.shift.amount_negative")
        val shift = shiftRepository.findById(shiftId)
            .orElseThrow { NotFoundException("error.shift.shift_not_found") }
        if (shift.status != "open") throw ConflictException("error.shift.already_closed")
        val expected = expectedCash(shift)
        shift.expectedCash = expected
        shift.actualCash = actualCash.scaled()
        shift.closedAt = Instant.now()
        shift.status = "closed"
        val saved = shiftRepository.save(shift)
        auditLog.record("SHIFT_CLOSE", "cash_shift", shiftId, shift.branchId, by, "expected=$expected actual=$actualCash")
        return toView(saved)
    }

    @Transactional(readOnly = true)
    fun receipt(orderId: UUID): ReceiptView {
        val order = orderRepository.findById(orderId)
            .orElseThrow { NotFoundException("error.order.not_found") }
        val invoice = invoiceRepository.findAll().firstOrNull { it.orderId == orderId }
        return ReceiptView(
            orderId = order.id,
            serial = invoice?.serial,
            trackingNumber = order.trackingNumber,
            status = order.status,
            paymentMethod = order.paymentMethod,
            paymentStatus = order.paymentStatus,
            lines = order.lines.map {
                ReceiptLine(it.variantId, it.qty, it.unitPrice, it.discount, it.net, it.isGift)
            },
            subtotal = order.subtotal,
            discountTotal = order.discountTotal,
            deliveryFee = order.deliveryFee,
            carryUpFee = order.carryUpFee,
            grandTotal = order.grandTotal,
            issuedAt = invoice?.issuedAt?.toString(),
        )
    }

    private fun expectedCash(shift: CashShiftJpaEntity): BigDecimal {
        val openedAt = shift.createdAt
        val cashSales = orderRepository.findByBranchIdAndStatusIn(
            shift.branchId!!,
            listOf(OrderStatus.confirmed.name, OrderStatus.delivered.name),
        ).filter { order ->
            order.channel == "pos" && order.paymentMethod == PaymentMethod.CASH.name &&
                order.createdAt >= openedAt
        }.fold(BigDecimal.ZERO) { acc, order -> acc.add(order.grandTotal) }
        val drops = dropRepository.findByShiftId(shift.id!!)
            .fold(BigDecimal.ZERO) { acc, drop -> acc.add(drop.amount) }
        return shift.openingBalance.add(cashSales).subtract(drops).scaled()
    }

    private fun toView(e: CashShiftJpaEntity): ShiftView {
        val drops = if (e.id == null) BigDecimal.ZERO else {
            dropRepository.findByShiftId(e.id!!).fold(BigDecimal.ZERO) { acc, d -> acc.add(d.amount) }
        }
        val variance = if (e.expectedCash != null && e.actualCash != null) {
            e.actualCash!!.subtract(e.expectedCash!!).scaled()
        } else null
        return ShiftView(
            e.id, e.branchId, e.cashierId, e.createdAt.toString(), e.openingBalance,
            e.closedAt?.toString(), e.expectedCash, e.actualCash, variance, drops.scaled(), e.status,
        )
    }

    private fun BigDecimal.scaled(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
