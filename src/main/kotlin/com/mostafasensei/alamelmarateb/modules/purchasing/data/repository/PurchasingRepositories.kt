package com.mostafasensei.alamelmarateb.modules.purchasing.data.repository

import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.GoodsReceiptJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.PurchaseOrderItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.PurchaseOrderJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.ReceiptItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface SupplierRepository : JpaRepository<SupplierJpaEntity, UUID> {
    fun findByIsActive(isActive: Boolean): List<SupplierJpaEntity>
}

@Repository
interface PurchaseOrderRepository : JpaRepository<PurchaseOrderJpaEntity, UUID> {
    fun findBySupplierId(supplierId: UUID): List<PurchaseOrderJpaEntity>
    fun findByStatus(status: String): List<PurchaseOrderJpaEntity>
    fun findBySupplierIdAndStatus(supplierId: UUID, status: String): List<PurchaseOrderJpaEntity>
}

@Repository
interface PoItemRepository : JpaRepository<PurchaseOrderItemJpaEntity, UUID> {
    fun findByOrderId(orderId: UUID): List<PurchaseOrderItemJpaEntity>
}

@Repository
interface GoodsReceiptRepository : JpaRepository<GoodsReceiptJpaEntity, UUID> {
    fun findByPoId(poId: UUID): List<GoodsReceiptJpaEntity>
}

@Repository
interface ReceiptItemRepository : JpaRepository<ReceiptItemJpaEntity, UUID> {
    fun findByReceiptId(receiptId: UUID): List<ReceiptItemJpaEntity>
}
