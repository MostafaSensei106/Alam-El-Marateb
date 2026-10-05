package com.mostafasensei.alamelmarateb.modules.purchasing.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.InvoiceShipmentAllocationRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.SupplierInstallmentRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.SupplierInvoiceRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.SupplierPaymentRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.SupplierRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.SupplierShipmentRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierInstallmentJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierInvoiceJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierPaymentJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierShipmentJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.LocalDate
import java.util.UUID

data class ShipmentView(val id: UUID?, val supplierId: UUID?, val shipmentNo: String, val arrivedAt: LocalDate?)
data class InvoiceView(
    val id: UUID?,
    val supplierId: UUID?,
    val invoiceNo: String,
    val total: BigDecimal,
    val status: String,
    val paid: BigDecimal,
    val remaining: BigDecimal,
)
data class InstallmentView(
    val id: UUID?,
    val invoiceId: UUID?,
    val amount: BigDecimal,
    val dueDate: LocalDate?,
    val status: String,
    val paidAmount: BigDecimal,
)
data class InstallmentInput(val amount: BigDecimal, val dueDate: LocalDate)

data class SupplierStatementView(
    val invoices: List<InvoiceView>,
    val overdue: List<InstallmentView>,
    val totalOwed: BigDecimal,
)

/**
 * Shipment (what arrived) vs invoice (what we owe) vs installments (when to pay).
 * Payments attach to invoice/installment; one invoice may cover many shipments.
 */
@Service
class SupplierFinanceService(
    private val shipmentRepository: SupplierShipmentRepository,
    private val invoiceRepository: SupplierInvoiceRepository,
    private val allocationRepository: InvoiceShipmentAllocationRepository,
    private val installmentRepository: SupplierInstallmentRepository,
    private val paymentRepository: SupplierPaymentRepository,
    private val supplierRepository: SupplierRepository,
    private val auditLog: AuditLogService,
) {
    @Transactional
    fun createShipment(supplierId: UUID, shipmentNo: String, arrivedAt: LocalDate?, note: String?, by: String?): ShipmentView {
        requireSupplier(supplierId)
        if (shipmentNo.isBlank()) throw BadRequestException("error.purchasing.shipment_no_required")
        if (shipmentRepository.findBySupplierId(supplierId).any { it.shipmentNo == shipmentNo.trim() }) {
            throw ConflictException("error.purchasing.shipment_exists", listOf(shipmentNo))
        }
        val saved = shipmentRepository.save(
            SupplierShipmentJpaEntity(supplierId = supplierId, shipmentNo = shipmentNo.trim(), arrivedAt = arrivedAt, note = note),
        )
        auditLog.record("SHIPMENT_CREATE", "supplier_shipment", saved.id, null, by, "no=$shipmentNo")
        return ShipmentView(saved.id, saved.supplierId, saved.shipmentNo, saved.arrivedAt)
    }

    @Transactional
    fun createInvoice(
        supplierId: UUID,
        invoiceNo: String,
        total: BigDecimal,
        issuedAt: LocalDate?,
        installments: List<InstallmentInput>,
        by: String?,
    ): InvoiceView {
        val supplier = requireSupplier(supplierId)
        if (invoiceNo.isBlank()) throw BadRequestException("error.purchasing.invoice_no_required")
        if (total.compareTo(BigDecimal.ZERO) <= 0) throw BadRequestException("error.purchasing.invoice_total_positive")
        if (invoiceRepository.findBySupplierId(supplierId).any { it.invoiceNo == invoiceNo.trim() }) {
            throw ConflictException("error.purchasing.invoice_exists", listOf(invoiceNo))
        }
        val sum = installments.fold(BigDecimal.ZERO) { acc, i -> acc.add(i.amount) }.money()
        if (installments.isNotEmpty() && sum.compareTo(total.money()) != 0) {
            throw BadRequestException("error.purchasing.installments_mismatch", listOf(sum, total))
        }
        val saved = invoiceRepository.save(
            SupplierInvoiceJpaEntity(
                supplierId = supplierId,
                invoiceNo = invoiceNo.trim(),
                total = total.money(),
                issuedAt = issuedAt ?: LocalDate.now(),
                status = "confirmed",
            ),
        )
        installments.forEach {
            if (it.amount.compareTo(BigDecimal.ZERO) <= 0) throw BadRequestException("error.purchasing.invoice_total_positive")
            installmentRepository.save(
                SupplierInstallmentJpaEntity(invoiceId = saved.id, amount = it.amount.money(), dueDate = it.dueDate),
            )
        }
        supplier.balance = supplier.balance.add(total.money()).money()
        supplierRepository.save(supplier)
        auditLog.record("SINVOICE_CREATE", "supplier_invoice", saved.id, null, by, "no=$invoiceNo total=$total")
        return toInvoiceView(saved)
    }

    @Transactional
    fun allocate(invoiceId: UUID, shipmentId: UUID, amount: BigDecimal, by: String?) {
        val invoice = loadInvoice(invoiceId)
        shipmentRepository.findById(shipmentId)
            .orElseThrow { NotFoundException("error.purchasing.shipment_not_found", listOf(shipmentId)) }
        if (amount.compareTo(BigDecimal.ZERO) <= 0) throw BadRequestException("error.purchasing.invoice_total_positive")
        val allocated = allocationRepository.findByInvoiceId(invoiceId).fold(BigDecimal.ZERO) { acc, a -> acc.add(a.amount) }
        if (allocated.add(amount).compareTo(invoice.total) > 0) {
            throw BadRequestException("error.purchasing.allocation_exceeds", listOf(invoice.total))
        }
        allocationRepository.save(
            com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.InvoiceShipmentAllocationJpaEntity(
                invoiceId = invoiceId, shipmentId = shipmentId, amount = amount.money(),
            ),
        )
        auditLog.record("SINVOICE_ALLOC", "supplier_invoice", invoiceId, null, by, "shipment=$shipmentId amount=$amount")
    }

    @Transactional
    fun payInvoice(invoiceId: UUID, amount: BigDecimal, method: String, installmentId: UUID?, ref: String?, by: String?): InvoiceView {
        val invoice = loadInvoice(invoiceId)
        if (invoice.status == "paid" || invoice.status == "cancelled") {
            throw ConflictException("error.purchasing.invoice_closed", listOf(invoice.status))
        }
        if (amount.compareTo(BigDecimal.ZERO) <= 0) throw BadRequestException("error.purchasing.invoice_total_positive")
        val paid = paymentRepository.findByInvoiceId(invoiceId).fold(BigDecimal.ZERO) { acc, p -> acc.add(p.amount) }
        if (paid.add(amount).compareTo(invoice.total) > 0) {
            throw BadRequestException("error.purchasing.pay_exceeds", listOf(invoice.total.subtract(paid)))
        }
        val installment = installmentId?.let {
            installmentRepository.findById(it)
                .orElseThrow { NotFoundException("error.purchasing.installment_not_found", listOf(it)) }
        }
        paymentRepository.save(
            SupplierPaymentJpaEntity(
                supplierId = invoice.supplierId,
                invoiceId = invoiceId,
                installmentId = installmentId,
                amount = amount.money(),
                method = method.ifBlank { "CASH" },
                ref = ref,
            ),
        )
        installment?.let {
            it.paidAmount = it.paidAmount.add(amount.money()).money()
            it.status = if (it.paidAmount.compareTo(it.amount) >= 0) "paid" else "pending"
            installmentRepository.save(it)
        }
        val supplier = requireSupplier(invoice.supplierId!!)
        supplier.balance = supplier.balance.subtract(amount.money()).money()
        supplierRepository.save(supplier)
        val newPaid = paid.add(amount.money())
        invoice.status = if (newPaid.compareTo(invoice.total) >= 0) "paid" else "partial"
        auditLog.record("SINVOICE_PAY", "supplier_invoice", invoiceId, null, by, "amount=$amount")
        return toInvoiceView(invoiceRepository.save(invoice))
    }

    @Transactional(readOnly = true)
    fun statement(supplierId: UUID): SupplierStatementView {
        requireSupplier(supplierId)
        val invoices = invoiceRepository.findBySupplierId(supplierId).map { toInvoiceView(it) }
        val overdue = invoices.flatMap { inv ->
            installmentRepository.findByInvoiceId(inv.id!!).filter {
                it.status != "paid" && it.dueDate!!.isBefore(LocalDate.now())
            }.map { InstallmentView(it.id, it.invoiceId, it.amount, it.dueDate, "overdue", it.paidAmount) }
        }
        val totalOwed = invoices.fold(BigDecimal.ZERO) { acc, i -> acc.add(i.remaining) }.money()
        return SupplierStatementView(invoices, overdue, totalOwed)
    }

    private fun requireSupplier(id: UUID) =
        supplierRepository.findById(id).orElseThrow { NotFoundException("error.purchasing.supplier_not_found", listOf(id)) }

    private fun loadInvoice(id: UUID) =
        invoiceRepository.findById(id).orElseThrow { NotFoundException("error.purchasing.invoice_not_found", listOf(id)) }

    private fun toInvoiceView(e: SupplierInvoiceJpaEntity): InvoiceView {
        val paid = try {
            paymentRepository.findByInvoiceId(e.id!!).fold(BigDecimal.ZERO) { acc, p -> acc.add(p.amount) }.money()
        } catch (_: Exception) {
            BigDecimal.ZERO
        }
        return InvoiceView(e.id, e.supplierId, e.invoiceNo, e.total, e.status, paid, e.total.subtract(paid).money())
    }

    private fun BigDecimal.money(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
