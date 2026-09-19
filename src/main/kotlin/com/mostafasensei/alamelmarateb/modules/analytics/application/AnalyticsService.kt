package com.mostafasensei.alamelmarateb.modules.analytics.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogRepository
import com.mostafasensei.alamelmarateb.modules.analytics.domain.model.AuditEntry
import com.mostafasensei.alamelmarateb.modules.analytics.domain.model.DashboardSummary
import com.mostafasensei.alamelmarateb.modules.analytics.domain.model.ProductVelocity
import com.mostafasensei.alamelmarateb.modules.analytics.domain.model.WarehouseStockValue
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.StockAuditRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.StockLevelRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.StockMoveRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.StockTransferRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.WarehouseRepository
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.AuditStatus
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.MoveType
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.TransferStatus
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Duration.Companion.days

/**
 * Read-model over inventory + catalog. Revenue/RFM endpoints arrive
 * with the sales module; facts tables stay the long-term store.
 */
@Service
class AnalyticsService(
    private val warehouseRepository: WarehouseRepository,
    private val stockLevelRepository: StockLevelRepository,
    private val stockMoveRepository: StockMoveRepository,
    private val transferRepository: StockTransferRepository,
    private val auditRepository: StockAuditRepository,
    private val productRepository: ProductRepository,
    private val variantRepository: ProductVariantRepository,
    private val auditLogRepository: AuditLogRepository,
) {

    @Transactional(readOnly = true)
    fun summary(): DashboardSummary {
        val warehouses = warehouseRepository.findAll()
        val levels = warehouses.flatMap { w ->
            stockLevelRepository.findByWarehouseId(w.id!!).map { w to it }
        }
        val costs = mutableMapOf<UUID, BigDecimal>()
        fun costOf(variantId: UUID): BigDecimal =
            costs.getOrPut(variantId) {
                variantRepository.findById(variantId)?.costPrice ?: BigDecimal.ZERO
            }

        val perWarehouse = warehouses.map { w ->
            val mine = levels.filter { it.first.id == w.id }
            val qty = mine.sumOf { it.second.qty }
            val value = mine.fold(BigDecimal.ZERO) { acc, (_, l) ->
                acc.add(costOf(l.variantId!!).multiply(l.qty.toBigDecimal()))
            }.setScale(2, RoundingMode.HALF_EVEN)
            WarehouseStockValue(w.id!!, w.name, qty, value)
        }
        val total = perWarehouse.fold(BigDecimal.ZERO) { acc, v -> acc.add(v.value) }
            .setScale(2, RoundingMode.HALF_EVEN)

        val pending = transferRepository.findByStatus(TransferStatus.in_transit.name).size +
            transferRepository.findByStatus(TransferStatus.partially_received.name).size
        val openAudits = auditRepository.findAll()
            .count { it.status == AuditStatus.open.name || it.status == AuditStatus.counting.name }

        return DashboardSummary(
            warehouses = warehouses.size,
            activeProducts = productRepository.findAllActive().size,
            lowStockCount = stockLevelRepository.findBelowThreshold().size,
            pendingTransfers = pending,
            openAudits = openAudits,
            stockValueByWarehouse = perWarehouse,
            totalStockValue = total,
        )
    }

    /**
     * Demand velocity from outbound moves (SALE + TRANSFER_OUT) over the
     * last 30 days. Days-of-cover = current stock / daily average.
     */
    @Transactional(readOnly = true)
    fun velocity(warehouseId: UUID?): List<ProductVelocity> {
        val since = Clock.System.now().minus(30.days)
        val outbound = setOf(MoveType.SALE.name, MoveType.TRANSFER_OUT.name)
        val moves = stockMoveRepository.findByCreatedAtAfter(since)
            .filter { it.moveType in outbound }
            .filter { warehouseId == null || it.warehouseId == warehouseId }

        val soldByVariant = moves.groupBy { it.variantId!! }
            .mapValues { (_, rows) -> rows.sumOf { -it.qtySigned } }

        val levels = if (warehouseId == null) {
            warehouseRepository.findAll().flatMap { w -> stockLevelRepository.findByWarehouseId(w.id!!) }
        } else {
            stockLevelRepository.findByWarehouseId(warehouseId)
        }
        val qtyByVariant = levels.groupBy { it.variantId!! }
            .mapValues { (_, rows) -> rows.sumOf { it.qty } }

        return (soldByVariant.keys + qtyByVariant.keys).distinct().map { variantId ->
            val sold = soldByVariant[variantId] ?: 0
            val qty = qtyByVariant[variantId] ?: 0
            val daily = BigDecimal(sold).divide(BigDecimal(30), 4, RoundingMode.HALF_EVEN)
            ProductVelocity(
                variantId = variantId,
                sold30d = sold,
                currentQty = qty,
                dailyAverage = daily.setScale(2, RoundingMode.HALF_EVEN),
                daysOfCover = if (daily > BigDecimal.ZERO) {
                    BigDecimal(qty).divide(daily, 0, RoundingMode.DOWN).toInt()
                } else {
                    null
                },
            )
        }.sortedByDescending { it.sold30d }
    }

    @Transactional(readOnly = true)
    fun auditTrail(entity: String, entityId: UUID): List<AuditEntry> =
        auditLogRepository.findByEntityAndEntityIdOrderByCreatedAtDesc(entity, entityId).map {
            AuditEntry(
                actor = it.actor,
                action = it.action,
                entity = it.entity,
                entityId = it.entityId,
                details = it.details,
                at = it.createdAt.toString(),
            )
        }
}
