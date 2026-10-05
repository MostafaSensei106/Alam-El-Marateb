package com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.math.BigDecimal
import java.time.Instant
import java.time.LocalDate
import java.util.UUID

@Entity
@Table(name = "supplier_shipments")
class SupplierShipmentJpaEntity(
    @Column(name = "supplier_id", nullable = false, columnDefinition = "UUID")
    var supplierId: UUID? = null,

    @Column(name = "shipment_no", nullable = false, length = 60)
    var shipmentNo: String = "",

    @Column(name = "arrived_at")
    var arrivedAt: LocalDate? = null,

    @Column(name = "note", columnDefinition = "TEXT")
    var note: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "supplier_invoices")
class SupplierInvoiceJpaEntity(
    @Column(name = "supplier_id", nullable = false, columnDefinition = "UUID")
    var supplierId: UUID? = null,

    @Column(name = "invoice_no", nullable = false, length = 60)
    var invoiceNo: String = "",

    @Column(name = "total", nullable = false, precision = 12, scale = 2)
    var total: BigDecimal = BigDecimal.ZERO,

    @Column(name = "issued_at", nullable = false)
    var issuedAt: LocalDate = LocalDate.now(),

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "confirmed",
) : EntityBase<UUID>()

@Entity
@Table(name = "invoice_shipment_allocations")
class InvoiceShipmentAllocationJpaEntity(
    @Column(name = "invoice_id", nullable = false, columnDefinition = "UUID")
    var invoiceId: UUID? = null,

    @Column(name = "shipment_id", nullable = false, columnDefinition = "UUID")
    var shipmentId: UUID? = null,

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,
) {
    @jakarta.persistence.Id
    @jakarta.persistence.GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID? = null

    @Column(name = "created_at", nullable = false, updatable = false)
    var createdAt: Instant = Instant.now()
}

@Entity
@Table(name = "supplier_installments")
class SupplierInstallmentJpaEntity(
    @Column(name = "invoice_id", nullable = false, columnDefinition = "UUID")
    var invoiceId: UUID? = null,

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "due_date", nullable = false)
    var dueDate: LocalDate? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "pending",

    @Column(name = "paid_amount", nullable = false, precision = 12, scale = 2)
    var paidAmount: BigDecimal = BigDecimal.ZERO,
) : EntityBase<UUID>()

@Entity
@Table(name = "supplier_payments")
class SupplierPaymentJpaEntity(
    @Column(name = "supplier_id", nullable = false, columnDefinition = "UUID")
    var supplierId: UUID? = null,

    @Column(name = "invoice_id", columnDefinition = "UUID")
    var invoiceId: UUID? = null,

    @Column(name = "installment_id", columnDefinition = "UUID")
    var installmentId: UUID? = null,

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "method", nullable = false, length = 20)
    var method: String = "CASH",

    @Column(name = "paid_at", nullable = false)
    var paidAt: Instant = Instant.now(),

    @Column(name = "ref", length = 120)
    var ref: String? = null,
) : EntityBase<UUID>()
