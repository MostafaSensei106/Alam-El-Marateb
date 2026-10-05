package com.mostafasensei.alamelmarateb.modules.purchasing.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.InventoryBatchRepository
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.InventoryBatchJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.ShipmentLandedCostAllocationRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.ShipmentLandedCostRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.SupplierShipmentRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.LandedAllocationMethod
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.LandedKind
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.LandedStatus
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.ShipmentLandedCostAllocationJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.ShipmentLandedCostJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.Instant
import java.util.UUID

data class LandedAllocationView(
    val batchId: UUID?,
    val allocatedQty: Int,
    val allocatedAmount: BigDecimal,
    val allocatedUnitCost: BigDecimal,
)

data class LandedCostView(
    val id: UUID?,
    val shipmentId: UUID?,
    val kind: String,
    val amount: BigDecimal,
    val allocationMethod: String,
    val status: String,
    val varianceAmount: BigDecimal,
    val allocatedTotal: BigDecimal,
    val allocations: List<LandedAllocationView> = emptyList(),
)

/**
 * Landed cost per shipment (freight/customs/insurance/handling).
 * - Allocation rows are INSERT-ONLY: every estimate/finalize run appends,
 *   so the full reconciliation history is auditable.
 * - Remaining stock absorbs its batch share (landed_unit_cost grows);
 *   sold stock is never restated — its delta lands in variance_amount.
 * - BY_VALUE (default): share ∝ purchase value; BY_QTY: share ∝ units.
 */
@Service
class LandedCostService(
    private val costRepository: ShipmentLandedCostRepository,
    private val allocationRepository: ShipmentLandedCostAllocationRepository,
    private val batchRepository: InventoryBatchRepository,
    private val shipmentRepository: SupplierShipmentRepository,
    private val auditLog: AuditLogService,
) {
    @Transactional
    fun addCost(
        shipmentId: UUID,
        kind: String,
        amount: BigDecimal,
        method: String = LandedAllocationMethod.BY_VALUE,
        final: Boolean = false,
        by: String? = null,
    ): LandedCostView {
        requireShipment(shipmentId)
        if (!LandedKind.isKnown(kind)) throw BadRequestException("error.landed.unknown_kind", listOf(kind))
        if (!LandedAllocationMethod.isKnown(method)) throw BadRequestException("error.landed.unknown_method", listOf(method))
        if (amount.compareTo(BigDecimal.ZERO) <= 0) throw BadRequestException("error.landed.amount_positive")
        val cost = costRepository.save(
            ShipmentLandedCostJpaEntity(
                shipmentId = shipmentId,
                kind = kind,
                amount = amount.money(),
                allocationMethod = method,
                status = if (final) LandedStatus.FINAL else LandedStatus.ESTIMATED,
                finalizedAt = if (final) Instant.now() else null,
            ),
        )
        allocate(cost)
        auditLog.record("LANDED_ADD", "landed_cost", cost.id, null, by, "shipment=$shipmentId kind=$kind amount=$amount")
        return view(cost.id!!, true)
    }

    @Transactional
    fun finalizeCost(id: UUID, finalAmount: BigDecimal, by: String? = null): LandedCostView {
        val cost = load(id)
        if (cost.status == LandedStatus.FINAL) throw ConflictException("error.landed.already_final")
        if (finalAmount.compareTo(BigDecimal.ZERO) <= 0) throw BadRequestException("error.landed.amount_positive")
        cost.amount = finalAmount.money()
        cost.status = LandedStatus.FINAL
        cost.finalizedAt = Instant.now()
        costRepository.save(cost)
        allocate(cost)
        auditLog.record("LANDED_FINALIZE", "landed_cost", id, null, by, "final=$finalAmount")
        return view(id, true)
    }

    @Transactional(readOnly = true)
    fun listCosts(shipmentId: UUID): List<LandedCostView> {
        requireShipment(shipmentId)
        return costRepository.findByShipmentId(shipmentId).map { view(it.id!!, true) }
    }

    // ---- internals ----

    private fun allocate(cost: ShipmentLandedCostJpaEntity) {
        val batches = batchRepository.findByShipmentId(cost.shipmentId!!)
        if (batches.isEmpty()) throw UnprocessableException("error.landed.nothing_received")
        val bases = batches.map { baseOf(it, cost.allocationMethod) }
        if (bases.all { it.compareTo(BigDecimal.ZERO) == 0 }) {
            throw UnprocessableException("error.landed.nothing_received")
        }
        val shares = splitShares(cost.amount, bases)
        var varianceDelta = BigDecimal.ZERO
        batches.forEachIndexed { i, batch ->
            val share = shares[i]
            val old = allocationRepository.findByLandedCostId(cost.id!!)
                .filter { it.batchId == batch.id }
                .fold(BigDecimal.ZERO) { acc, a -> acc.add(a.allocatedAmount) }
            val delta = share.subtract(old)
            if (delta.compareTo(BigDecimal.ZERO) == 0) return@forEachIndexed
            // Delta splits pro-rata: remaining units absorb theirs into landed
            // cost, sold units' part is locked COGS -> tracked as variance.
            val perUnit = delta.divide(batch.qtyReceived.toBigDecimal(), 4, RoundingMode.HALF_EVEN)
            val remainingPart = perUnit.multiply(batch.qtyRemaining.toBigDecimal()).money()
            val soldPart = delta.subtract(remainingPart)
            if (batch.qtyRemaining > 0) {
                val perUnitMoney = remainingPart.divide(batch.qtyRemaining.toBigDecimal(), 2, RoundingMode.HALF_EVEN)
                batch.landedUnitCost = batch.landedUnitCost.add(perUnitMoney).money()
                batchRepository.save(batch)
                allocationRepository.save(
                    ShipmentLandedCostAllocationJpaEntity(
                        landedCostId = cost.id,
                        batchId = batch.id,
                        allocatedQty = batch.qtyRemaining,
                        allocatedAmount = remainingPart,
                        allocatedUnitCost = perUnitMoney,
                    ),
                )
            }
            if (soldPart.compareTo(BigDecimal.ZERO) != 0) {
                varianceDelta = varianceDelta.add(soldPart)
                allocationRepository.save(
                    ShipmentLandedCostAllocationJpaEntity(
                        landedCostId = cost.id,
                        batchId = batch.id,
                        allocatedQty = 0,
                        allocatedAmount = soldPart.money(),
                        allocatedUnitCost = perUnit.setScale(2, RoundingMode.HALF_EVEN),
                    ),
                )
            }
        }
        if (varianceDelta.compareTo(BigDecimal.ZERO) != 0) {
            cost.varianceAmount = cost.varianceAmount.add(varianceDelta).money()
            costRepository.save(cost)
        }
    }

    private fun baseOf(batch: InventoryBatchJpaEntity, method: String): BigDecimal =
        when (method) {
            LandedAllocationMethod.BY_QTY -> batch.qtyReceived.toBigDecimal()
            else -> batch.unitCost.multiply(batch.qtyReceived.toBigDecimal())
        }

    /**
     * Largest-remainder split: every share exact to cents, residual dust
     * goes to the largest fractional parts so Σ shares == total exactly.
     */
    private fun splitShares(total: BigDecimal, bases: List<BigDecimal>): List<BigDecimal> {
        val sum = bases.fold(BigDecimal.ZERO) { acc, b -> acc.add(b) }
        val totalCents = total.multiply(BigDecimal(100)).setScale(0, RoundingMode.HALF_EVEN).toLong()
        data class Slot(val index: Int, var cents: Long, val frac: BigDecimal)
        val slots = bases.mapIndexed { i, base ->
            val raw = total.multiply(base).divide(sum, 10, RoundingMode.HALF_EVEN)
            val floor = raw.setScale(2, RoundingMode.DOWN)
            Slot(i, floor.multiply(BigDecimal(100)).toLong(), raw.subtract(floor))
        }
        var rest = totalCents - slots.sumOf { it.cents }
        slots.sortedByDescending { it.frac }.forEach { slot ->
            if (rest <= 0) return@forEach
            slot.cents += 1
            rest -= 1
        }
        return slots.sortedBy { it.index }.map { BigDecimal(it.cents).movePointLeft(2).money() }
    }

    private fun view(id: UUID, withAllocations: Boolean): LandedCostView {
        val cost = load(id)
        val rows = allocationRepository.findByLandedCostId(id)
        // Absorbed into stock only; variance rows (qty=0) live in varianceAmount.
        val allocated = rows.filter { it.allocatedQty > 0 }
            .fold(BigDecimal.ZERO) { acc, a -> acc.add(a.allocatedAmount) }.money()
        return LandedCostView(
            id = cost.id,
            shipmentId = cost.shipmentId,
            kind = cost.kind,
            amount = cost.amount,
            allocationMethod = cost.allocationMethod,
            status = cost.status,
            varianceAmount = cost.varianceAmount,
            allocatedTotal = allocated,
            allocations = if (withAllocations) {
                rows.map { LandedAllocationView(it.batchId, it.allocatedQty, it.allocatedAmount, it.allocatedUnitCost) }
            } else emptyList(),
        )
    }

    private fun requireShipment(id: UUID) {
        if (!shipmentRepository.existsById(id)) throw NotFoundException("error.landed.shipment_not_found", listOf(id))
    }

    private fun load(id: UUID): ShipmentLandedCostJpaEntity =
        costRepository.findById(id).orElseThrow { NotFoundException("error.landed.cost_not_found", listOf(id)) }

    private fun BigDecimal.money(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
