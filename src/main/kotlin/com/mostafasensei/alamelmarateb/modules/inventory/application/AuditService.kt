package com.mostafasensei.alamelmarateb.modules.inventory.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.StockAuditRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.WarehouseRepository
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.AuditCountJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.StockAuditJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.AuditStatus
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.MoveType
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

data class AuditVariance(
    val variantId: UUID,
    val systemQty: Int,
    val countedQty: Int,
    val variance: Int,
)

data class AuditResult(
    val id: UUID?,
    val warehouseId: UUID,
    val status: AuditStatus,
    val variances: List<AuditVariance>,
)

@Service
class AuditService(
    private val auditRepository: StockAuditRepository,
    private val stockService: StockService,
    private val variantRepository: ProductVariantRepository,
    private val warehouseRepository: WarehouseRepository,
    private val auditLog: AuditLogService,
) {

    /** Manager: open audit, snapshotting current system qty per stocked variant. */
    @Transactional
    fun open(warehouseId: UUID, note: String?): AuditResult {
        val open = auditRepository.findByWarehouseIdAndStatusIn(
            warehouseId, listOf(AuditStatus.open.name, AuditStatus.counting.name),
        )
        if (open.isNotEmpty()) throw ConflictException("Warehouse already has an open audit")
        val levels = stockService.levels(warehouseId)
        val audit = StockAuditJpaEntity(
            warehouseId = warehouseId,
            status = AuditStatus.open.name,
            note = note,
        )
        audit.counts = levels.map {
            AuditCountJpaEntity(audit = audit, variantId = it.variantId, systemQty = it.qty, countedQty = it.qty)
        }.toMutableList()
        val saved = auditRepository.save(audit)
        return toResult(saved)
    }

    /** Keeper: submit a count line by scan. */
    @Transactional
    fun submitCount(auditId: UUID, variantId: UUID, countedQty: Int): AuditResult {
        if (countedQty < 0) throw BadRequestException("Counted quantity cannot be negative")
        val audit = load(auditId)
        if (audit.status != AuditStatus.open.name && audit.status != AuditStatus.counting.name) {
            throw ConflictException("Audit is not countable in status ${audit.status}")
        }
        variantRepository.findById(variantId) ?: throw BadRequestException("Unknown variant: $variantId")
        val row = audit.counts.firstOrNull { it.variantId == variantId }
        if (row == null) {
            // Variant never stocked here: system qty is 0.
            audit.counts.add(AuditCountJpaEntity(audit = audit, variantId = variantId, systemQty = 0, countedQty = countedQty))
        } else {
            row.countedQty = countedQty
        }
        audit.status = AuditStatus.counting.name
        return toResult(auditRepository.save(audit))
    }

    /** Manager: reconcile — variances become AUDIT moves, audit is final. */
    @Transactional
    fun reconcile(auditId: UUID, by: String? = null): AuditResult {
        val audit = load(auditId)
        if (audit.status != AuditStatus.counting.name && audit.status != AuditStatus.open.name) {
            throw ConflictException("Audit cannot be reconciled in status ${audit.status}")
        }
        val warehouseId = audit.warehouseId!!
        audit.counts.forEach { row ->
            val diff = row.countedQty - row.systemQty
            if (diff != 0) {
                stockService.applyMove(
                    warehouseId = warehouseId,
                    variantId = row.variantId!!,
                    qtySigned = diff,
                    type = MoveType.AUDIT,
                    refType = "AUDIT",
                    refId = audit.id,
                    note = "Reconciled: system=${row.systemQty} counted=${row.countedQty}",
                )
            }
        }
        audit.status = AuditStatus.reconciled.name
        val result = toResult(auditRepository.save(audit))
        val branch = warehouseRepository.findById(audit.warehouseId!!).map { it.branchId }.orElse(null)
        auditLog.record("RECONCILE", "audit", audit.id, branch, by, "warehouse=${audit.warehouseId} variances=${result.variances.count { it.variance != 0 }}")
        return result
    }

    private fun load(auditId: UUID): StockAuditJpaEntity =
        auditRepository.findById(auditId).orElseThrow { NotFoundException("Audit not found") }

    private fun toResult(e: StockAuditJpaEntity) = AuditResult(
        id = e.id,
        warehouseId = e.warehouseId!!,
        status = AuditStatus.valueOf(e.status),
        variances = e.counts.map {
            AuditVariance(it.variantId!!, it.systemQty, it.countedQty, it.countedQty - it.systemQty)
        },
    )
}
