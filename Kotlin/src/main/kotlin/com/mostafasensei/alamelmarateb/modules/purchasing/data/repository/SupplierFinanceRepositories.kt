package com.mostafasensei.alamelmarateb.modules.purchasing.data.repository

import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.InvoiceShipmentAllocationJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierInstallmentJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierInvoiceJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierPaymentJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierShipmentJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface SupplierShipmentRepository : JpaRepository<SupplierShipmentJpaEntity, UUID> {
    fun findBySupplierId(supplierId: UUID): List<SupplierShipmentJpaEntity>
}

@Repository
interface SupplierInvoiceRepository : JpaRepository<SupplierInvoiceJpaEntity, UUID> {
    fun findBySupplierId(supplierId: UUID): List<SupplierInvoiceJpaEntity>
}

@Repository
interface InvoiceShipmentAllocationRepository : JpaRepository<InvoiceShipmentAllocationJpaEntity, UUID> {
    fun findByInvoiceId(invoiceId: UUID): List<InvoiceShipmentAllocationJpaEntity>
    fun findByShipmentId(shipmentId: UUID): List<InvoiceShipmentAllocationJpaEntity>
}

@Repository
interface SupplierInstallmentRepository : JpaRepository<SupplierInstallmentJpaEntity, UUID> {
    fun findByInvoiceId(invoiceId: UUID): List<SupplierInstallmentJpaEntity>
}

@Repository
interface SupplierPaymentRepository : JpaRepository<SupplierPaymentJpaEntity, UUID> {
    fun findBySupplierId(supplierId: UUID): List<SupplierPaymentJpaEntity>
    fun findByInvoiceId(invoiceId: UUID): List<SupplierPaymentJpaEntity>
}
