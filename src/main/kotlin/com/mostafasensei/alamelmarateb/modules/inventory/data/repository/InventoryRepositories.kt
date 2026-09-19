package com.mostafasensei.alamelmarateb.modules.inventory.data.repository

import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.AuditCountJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.StockAuditJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.StockLevelJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.StockMoveJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.StockTransferJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.TransferItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.WarehouseJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface WarehouseRepository : JpaRepository<WarehouseJpaEntity, UUID> {
    fun existsByCode(code: String): Boolean
    fun findByBranchId(branchId: UUID): List<WarehouseJpaEntity>
}

@Repository
interface StockLevelRepository : JpaRepository<StockLevelJpaEntity, UUID> {
    fun findByWarehouseId(warehouseId: UUID): List<StockLevelJpaEntity>
    fun findByWarehouseIdAndVariantId(warehouseId: UUID, variantId: UUID): Optional<StockLevelJpaEntity>

    @Query(
        "SELECT l FROM StockLevelJpaEntity l WHERE l.minQty IS NOT NULL " +
            "AND (l.qty - l.reservedQty) <= l.minQty",
    )
    fun findBelowThreshold(): List<StockLevelJpaEntity>
}

@Repository
interface StockMoveRepository : JpaRepository<StockMoveJpaEntity, UUID> {
    fun findByWarehouseIdAndVariantIdOrderByCreatedAtDesc(warehouseId: UUID, variantId: UUID): List<StockMoveJpaEntity>
    fun findByCreatedAtAfter(since: kotlin.time.Instant): List<StockMoveJpaEntity>
}

@Repository
interface StockTransferRepository : JpaRepository<StockTransferJpaEntity, UUID> {
    fun findByStatus(status: String): List<StockTransferJpaEntity>
    fun findByToWarehouseIdAndStatusIn(toWarehouseId: UUID, statuses: List<String>): List<StockTransferJpaEntity>
}

@Repository
interface TransferItemRepository : JpaRepository<TransferItemJpaEntity, UUID>

@Repository
interface StockAuditRepository : JpaRepository<StockAuditJpaEntity, UUID> {
    fun findByWarehouseIdAndStatusIn(warehouseId: UUID, statuses: List<String>): List<StockAuditJpaEntity>
}

@Repository
interface AuditCountRepository : JpaRepository<AuditCountJpaEntity, UUID>
