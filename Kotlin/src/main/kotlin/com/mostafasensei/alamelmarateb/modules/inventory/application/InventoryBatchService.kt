package com.mostafasensei.alamelmarateb.modules.inventory.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.InventoryBatchRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.StockLevelRepository
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.InventoryBatchJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.MoveType
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.SellingPriceRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.Instant
import java.util.UUID

data class BatchConsumption(val batchId: UUID, val qty: Int, val unitCost: BigDecimal)

data class BatchView(
    val id: UUID?,
    val batchNo: String,
    val variantId: UUID?,
    val warehouseId: UUID?,
    val qtyReceived: Int,
    val qtyRemaining: Int,
    val unitCost: BigDecimal,
    val landedUnitCost: BigDecimal,
    val receivedAt: Instant,
    val costValue: BigDecimal,
    val netCostValue: BigDecimal,
    val currentSelling: BigDecimal?,
    val potentialRevenue: BigDecimal?,
    val potentialProfit: BigDecimal?,
)

/**
 * FIFO cost layers. Sales never pick a batch — they ask for qty and this
 * service consumes the oldest available layers, returning per-batch COGS.
 * Old inventory keeps its own cost; only new receipts create new layers.
 */
@Service
class InventoryBatchService(
    private val batchRepository: InventoryBatchRepository,
    private val stockLevelRepository: StockLevelRepository,
    private val stockService: StockService,
    private val variantRepository: ProductVariantRepository,
    private val sellingPriceRepository: SellingPriceRepository,
    private val auditLog: AuditLogService,
) {
    @Transactional
    fun createBatch(
        variantId: UUID,
        warehouseId: UUID,
        receiptId: UUID?,
        qty: Int,
        unitCost: BigDecimal,
        by: String? = null,
    ): InventoryBatchJpaEntity {
        if (qty <= 0) throw BadRequestException("error.inventory.reserve_positive")
        if (unitCost.compareTo(BigDecimal.ZERO) < 0) throw BadRequestException("error.pricing.price_negative")
        variantRepository.findById(variantId)
            ?: throw NotFoundException("error.inventory.unknown_variant", listOf(variantId))
        val batch = InventoryBatchJpaEntity(
            batchNo = "B-${Instant.now().toEpochMilli()}-${(1000..9999).random()}",
            variantId = variantId,
            warehouseId = warehouseId,
            receiptId = receiptId,
            qtyReceived = qty,
            qtyRemaining = qty,
            unitCost = unitCost.money(),
            landedUnitCost = unitCost.money(),
        )
        batch.createdBy = by
        return batchRepository.save(batch)
    }

    /** Consume [qty] from oldest layers; posts one SALE move per batch slice. */
    @Transactional
    fun consumeFifo(
        warehouseId: UUID,
        variantId: UUID,
        qty: Int,
        refType: String?,
        refId: UUID?,
        note: String?,
    ): List<BatchConsumption> =
        consumeLayers(warehouseId, variantId, qty, MoveType.SALE, refType, refId, note)

    /**
     * Generic FIFO layer consumption (sales, transfers, ...). The seller —
     * or the transfer clerk — never picks a batch; oldest layers go first.
     */
    @Transactional
    fun consumeLayers(
        warehouseId: UUID,
        variantId: UUID,
        qty: Int,
        moveType: MoveType,
        refType: String?,
        refId: UUID?,
        note: String?,
    ): List<BatchConsumption> {
        if (qty <= 0) throw BadRequestException("error.order.qty_positive")
        val layers = batchRepository
            .findByWarehouseIdAndVariantIdOrderByReceivedAtAsc(warehouseId, variantId)
            .filter { it.qtyRemaining > 0 }
            .toMutableList()
        val available = layers.sumOf { it.qtyRemaining }
        if (available < qty) {
            // Self-heal: stock entered without a batch (adjust/transfer/legacy).
            // Physical levels still guard the sale; book the gap at variant cost.
            val onHand = stockLevelRepository.findByWarehouseIdAndVariantId(warehouseId, variantId)
                .map { it.qty }.orElse(0)
            if (onHand < qty) {
                throw ConflictException("error.inventory.stock_insufficient", listOf(onHand, qty))
            }
            val variant = variantRepository.findById(variantId)
                ?: throw NotFoundException("error.inventory.unknown_variant", listOf(variantId))
            val shortfall = qty - available
            layers.add(
                batchRepository.save(
                    InventoryBatchJpaEntity(
                        batchNo = "B-${Instant.now().toEpochMilli()}-${(1000..9999).random()}",
                        variantId = variantId,
                        warehouseId = warehouseId,
                        receiptId = null,
                        qtyReceived = shortfall,
                        qtyRemaining = shortfall,
                        unitCost = variant.costPrice.money(),
                        landedUnitCost = variant.costPrice.money(),
                    ),
                ),
            )
        }
        var rest = qty
        val out = mutableListOf<BatchConsumption>()
        for (layer in layers) {
            if (rest <= 0) break
            val take = minOf(rest, layer.qtyRemaining)
            layer.qtyRemaining -= take
            batchRepository.save(layer)
            stockService.applyMove(
                warehouseId = warehouseId,
                variantId = variantId,
                qtySigned = -take,
                type = moveType,
                refType = refType,
                refId = refId,
                note = note,
                batchId = layer.id,
            )
            out.add(BatchConsumption(layer.id!!, take, layer.landedUnitCost))
            rest -= take
        }
        return out
    }

    /** Mirror a source layer into another warehouse: same costs, no recalculation. */
    @Transactional
    fun createMirror(
        variantId: UUID,
        warehouseId: UUID,
        qty: Int,
        unitCost: BigDecimal,
        landedUnitCost: BigDecimal,
        by: String? = null,
    ): InventoryBatchJpaEntity {
        if (qty <= 0) throw BadRequestException("error.inventory.reserve_positive")
        val batch = InventoryBatchJpaEntity(
            batchNo = "B-${Instant.now().toEpochMilli()}-${(1000..9999).random()}",
            variantId = variantId,
            warehouseId = warehouseId,
            receiptId = null,
            qtyReceived = qty,
            qtyRemaining = qty,
            unitCost = unitCost.money(),
            landedUnitCost = landedUnitCost.money(),
        )
        batch.createdBy = by
        return batchRepository.save(batch)
    }

    /** Read-only layer lookup for mirroring and audits. */
    @Transactional(readOnly = true)
    fun layerOf(batchId: UUID): InventoryBatchJpaEntity =
        batchRepository.findById(batchId)
            .orElseThrow { NotFoundException("error.inventory.batch_not_found", listOf(batchId)) }

    /** Write off qty from one exact layer (damage, expiry, ...). */
    @Transactional
    fun writeOff(
        batchId: UUID,
        qty: Int,
        moveType: MoveType,
        refType: String?,
        refId: UUID?,
        note: String?,
    ) {
        if (qty <= 0) throw BadRequestException("error.order.qty_positive")
        val layer = layerOf(batchId)
        if (layer.qtyRemaining < qty) {
            throw ConflictException("error.inventory.stock_insufficient", listOf(layer.qtyRemaining, qty))
        }
        layer.qtyRemaining -= qty
        batchRepository.save(layer)
        stockService.applyMove(
            warehouseId = layer.warehouseId!!,
            variantId = layer.variantId!!,
            qtySigned = -qty,
            type = moveType,
            refType = refType,
            refId = refId,
            note = note,
            batchId = batchId,
        )
    }

    /** Estimate FIFO cost without mutating (analytics preview at invoice time). */
    @Transactional(readOnly = true)
    fun peekCost(warehouseId: UUID, variantId: UUID, qty: Int): BigDecimal {
        var rest = qty
        var total = BigDecimal.ZERO
        batchRepository
            .findByWarehouseIdAndVariantIdOrderByReceivedAtAsc(warehouseId, variantId)
            .filter { it.qtyRemaining > 0 }
            .forEach { layer ->
                if (rest <= 0) return@forEach
                val take = minOf(rest, layer.qtyRemaining)
                total = total.add(layer.landedUnitCost.multiply(take.toBigDecimal()))
                rest -= take
            }
        if (rest > 0) {
            val fallback = variantRepository.findById(variantId)?.costPrice ?: BigDecimal.ZERO
            total = total.add(fallback.multiply(rest.toBigDecimal()))
        }
        return total.money()
    }

    /** Customer return: put qty back onto the exact batches it was taken from. */
    @Transactional
    fun restock(consumptions: List<BatchConsumption>, by: String? = null) {
        consumptions.forEach { c ->
            val layer = batchRepository.findById(c.batchId)
                .orElseThrow { NotFoundException("error.inventory.batch_not_found", listOf(c.batchId)) }
            layer.qtyRemaining += c.qty
            batchRepository.save(layer)
            stockService.applyMove(
                warehouseId = layer.warehouseId!!,
                variantId = layer.variantId!!,
                qtySigned = c.qty,
                type = MoveType.RETURN,
                refType = "RETURN",
                refId = null,
                note = "Customer return to batch ${layer.batchNo}",
                batchId = layer.id,
            )
        }
        auditLog.record("BATCH_RESTOCK", "inventory_batch", null, null, by, "layers=${consumptions.size}")
    }

    @Transactional(readOnly = true)
    fun listBatches(warehouseId: UUID?, variantId: UUID?): List<BatchView> {
        val rows = when {
            warehouseId != null && variantId != null ->
                batchRepository.findByWarehouseIdAndVariantIdOrderByReceivedAtAsc(warehouseId, variantId)
            warehouseId != null -> batchRepository.findByWarehouseIdOrderByReceivedAtAsc(warehouseId)
            else -> batchRepository.findAll().sortedBy { it.receivedAt }
        }.filter { variantId == null || it.variantId == variantId }
        return rows.map { toView(it) }
    }

    @Transactional(readOnly = true)
    fun valuation(warehouseId: UUID?, variantId: UUID?): Map<String, BigDecimal> {
        val rows = listBatches(warehouseId, variantId)
        val cost = rows.fold(BigDecimal.ZERO) { acc, b -> acc.add(b.costValue) }.money()
        val net = rows.fold(BigDecimal.ZERO) { acc, b -> acc.add(b.netCostValue) }.money()
        val revenue = rows.fold(BigDecimal.ZERO) { acc, b -> acc.add(b.potentialRevenue ?: BigDecimal.ZERO) }.money()
        return mapOf(
            "inventoryCost" to cost,
            "inventoryNetCost" to net,
            "landedAdded" to cost.subtract(net).money(),
            "potentialRevenue" to revenue,
            "potentialProfit" to revenue.subtract(cost).money(),
            "potentialProfitNet" to revenue.subtract(net).money(),
        )
    }

    private fun toView(e: InventoryBatchJpaEntity): BatchView {
        val costValue = e.landedUnitCost.multiply(e.qtyRemaining.toBigDecimal()).money()
        val netCostValue = e.unitCost.multiply(e.qtyRemaining.toBigDecimal()).money()
        val now = Instant.now()
        val selling = e.variantId?.let { vid ->
            sellingPriceRepository.findByVariantIdAndChannelOrderByEffectiveFromDesc(vid, "STAFF")
                .firstOrNull { !it.effectiveFrom.isAfter(now) }?.price
                ?: variantRepository.findById(vid)?.sellingPrice
        }
        val revenue = selling?.multiply(e.qtyRemaining.toBigDecimal())?.money()
        return BatchView(
            id = e.id,
            batchNo = e.batchNo,
            variantId = e.variantId,
            warehouseId = e.warehouseId,
            qtyReceived = e.qtyReceived,
            qtyRemaining = e.qtyRemaining,
            unitCost = e.unitCost,
            landedUnitCost = e.landedUnitCost,
            receivedAt = e.receivedAt,
            costValue = costValue,
            netCostValue = netCostValue,
            currentSelling = selling,
            potentialRevenue = revenue,
            potentialProfit = revenue?.subtract(costValue)?.money(),
        )
    }

    private fun BigDecimal.money(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
