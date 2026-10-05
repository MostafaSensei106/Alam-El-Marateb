package com.mostafasensei.alamelmarateb.modules.inventory.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.StockTransferRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.TransferBatchLinkRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.TransferDispatchLayerRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.WarehouseRepository
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.StockTransferJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.TransferBatchLinkJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.TransferDispatchLayerJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.TransferItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.MoveType
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.Transfer
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.TransferItem
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.TransferStatus
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

data class TransferItemRequest(val variantId: UUID, val qty: Int)

data class TransferBatchLinkView(
    val srcBatchId: UUID?,
    val dstBatchId: UUID?,
    val qty: Int,
    val unitCost: java.math.BigDecimal,
    val landedUnitCost: java.math.BigDecimal,
)

@Service
class TransferService(
    private val transferRepository: StockTransferRepository,
    private val dispatchLayerRepository: TransferDispatchLayerRepository,
    private val linkRepository: TransferBatchLinkRepository,
    private val batchService: InventoryBatchService,
    private val stockService: StockService,
    private val variantRepository: ProductVariantRepository,
    private val warehouseRepository: WarehouseRepository,
    private val auditLog: AuditLogService,
) {

    @Transactional
    fun create(fromWarehouseId: UUID, toWarehouseId: UUID, note: String?, items: List<TransferItemRequest>): Transfer {
        if (fromWarehouseId == toWarehouseId) throw BadRequestException("error.transfer.diff_warehouses")
        if (items.isEmpty()) throw UnprocessableException("error.transfer.empty_items")
        items.forEach {
            if (it.qty <= 0) throw BadRequestException("error.transfer.item_positive")
            variantRepository.findById(it.variantId) ?: throw NotFoundException("error.transfer.unknown_variant", listOf(it.variantId))
        }
        val transfer = StockTransferJpaEntity(
            fromWarehouseId = fromWarehouseId,
            toWarehouseId = toWarehouseId,
            status = TransferStatus.draft.name,
            note = note,
        )
        transfer.items = items.map {
            TransferItemJpaEntity(transfer = transfer, variantId = it.variantId, sentQty = it.qty)
        }.toMutableList()
        val saved = transferRepository.save(transfer)
        return toDomain(saved)
    }

    @Transactional(readOnly = true)
    fun get(id: UUID): Transfer = toDomain(load(id))

    @Transactional(readOnly = true)
    fun pendingFor(toWarehouseId: UUID): List<Transfer> =
        transferRepository.findByToWarehouseIdAndStatusIn(
            toWarehouseId,
            listOf(TransferStatus.in_transit.name, TransferStatus.partially_received.name),
        ).map { toDomain(it) }

    /**
     * Manager: move from draft to in_transit. Consumes source FIFO layers
     * (clerk never picks batches) and stages them for exact mirroring
     * at receive. Zero profit, zero cost change — a location move only.
     */
    @Transactional
    fun dispatch(id: UUID, by: String? = null): Transfer {
        val transfer = load(id)
        requireStatus(transfer, TransferStatus.draft, "error.transfer.dispatch_draft_only")
        val from = transfer.fromWarehouseId!!
        transfer.items.forEach { item ->
            val slices = batchService.consumeLayers(
                warehouseId = from,
                variantId = item.variantId!!,
                qty = item.sentQty,
                moveType = MoveType.TRANSFER_OUT,
                refType = "TRANSFER",
                refId = transfer.id,
                note = "Dispatch to ${transfer.toWarehouseId}",
            )
            slices.forEach { slice ->
                val src = batchService.layerOf(slice.batchId)
                dispatchLayerRepository.save(
                    TransferDispatchLayerJpaEntity(
                        transferId = transfer.id,
                        srcBatchId = slice.batchId,
                        qty = slice.qty,
                        unitCost = src.unitCost,
                        landedUnitCost = src.landedUnitCost,
                    ),
                )
            }
        }
        transfer.status = TransferStatus.in_transit.name
        val result = toDomain(transferRepository.save(transfer))
        val branch = warehouseRepository.findById(transfer.fromWarehouseId!!).map { it.branchId }.orElse(null)
        auditLog.record("DISPATCH", "transfer", transfer.id, branch, by, "from=${transfer.fromWarehouseId} to=${transfer.toWarehouseId}")
        return result
    }

    /**
     * Keeper: receive one batch (partial allowed). Mirrors the exact staged
     * source layers into destination batches (same costs, no recalculation)
     * and records immutable transfer_batch_links. Damaged qty physically
     * arrives as pending — deducted back at manager approve().
     */
    @Transactional
    fun receiveBatch(id: UUID, lines: List<TransferItemRequest>, damaged: Map<UUID, Int>, by: String? = null): Transfer {
        val transfer = load(id)
        requireStatusIn(
            transfer,
            setOf(TransferStatus.in_transit, TransferStatus.partially_received),
            "error.transfer.not_receivable",
        )
        if (lines.isEmpty()) throw UnprocessableException("error.transfer.batch_empty")
        val to = transfer.toWarehouseId!!
        lines.forEach { line ->
            val item = transfer.items.firstOrNull { it.variantId == line.variantId }
                ?: throw UnprocessableException("error.transfer.variant_not_in_transfer", listOf(line.variantId))
            if (line.qty <= 0) throw BadRequestException("error.transfer.batch_positive")
            if (item.receivedQty + line.qty > item.sentQty) {
                throw UnprocessableException("error.transfer.batch_exceeds", listOf(line.variantId))
            }
            item.receivedQty += line.qty
            mirrorStaged(transfer.id!!, to, line.variantId, line.qty, "Batch receipt", by)
        }
        damaged.forEach { (variantId, qty) ->
            val item = transfer.items.firstOrNull { it.variantId == variantId }
                ?: throw UnprocessableException("error.transfer.variant_not_in_transfer", listOf(variantId))
            if (qty < 0 || item.receivedQty + item.damagedQty + qty > item.sentQty) {
                throw UnprocessableException("error.transfer.damaged_invalid", listOf(variantId))
            }
            item.damagedQty += qty
            // Damaged goods physically arrive: enter stock as pending,
            // deducted back at manager approve() (DAMAGE move).
            mirrorStaged(transfer.id!!, to, variantId, qty, "Damaged on arrival — pending manager approval", by)
        }
        val allReceived = transfer.items.all { it.receivedQty + it.damagedQty >= it.sentQty }
        transfer.status = if (allReceived) TransferStatus.received.name else TransferStatus.partially_received.name
        return toDomain(transferRepository.save(transfer))
    }

    /** Mirror [qty] units of staged source layers into [to] warehouse batches. */
    private fun mirrorStaged(
        transferId: UUID,
        to: UUID,
        variantId: UUID,
        qty: Int,
        note: String,
        by: String?,
    ) {
        var rest = qty
        val staged = dispatchLayerRepository.findByTransferIdOrderByCreatedAtAsc(transferId)
            .filter { batchService.layerOf(it.srcBatchId!!).variantId == variantId && it.mirroredQty < it.qty }
        for (layer in staged) {
            if (rest <= 0) break
            val take = minOf(rest, layer.qty - layer.mirroredQty)
            val dst = batchService.createMirror(
                variantId = variantId,
                warehouseId = to,
                qty = take,
                unitCost = layer.unitCost,
                landedUnitCost = layer.landedUnitCost,
                by = by,
            )
            stockService.applyMove(
                warehouseId = to,
                variantId = variantId,
                qtySigned = take,
                type = MoveType.TRANSFER_IN,
                refType = "TRANSFER",
                refId = transferId,
                note = note,
                batchId = dst.id,
            )
            linkRepository.save(
                TransferBatchLinkJpaEntity(
                    transferId = transferId,
                    srcBatchId = layer.srcBatchId,
                    dstBatchId = dst.id,
                    qty = take,
                    unitCost = layer.unitCost,
                    landedUnitCost = layer.landedUnitCost,
                ),
            )
            layer.mirroredQty += take
            dispatchLayerRepository.save(layer)
            rest -= take
        }
        if (rest > 0) throw UnprocessableException("error.transfer.mirror_shortage", listOf(variantId))
    }

    /**
     * Manager: final approval. Recorded damage is deducted from the mirrored
     * destination batches (this approval IS the damage authorization).
     */
    @Transactional
    fun approve(id: UUID, by: String? = null): Transfer {
        val transfer = load(id)
        requireStatusIn(
            transfer,
            setOf(TransferStatus.received, TransferStatus.partially_received),
            "error.transfer.approve_status",
        )
        transfer.items.filter { it.damagedQty > 0 }.forEach { item ->
            var rest = item.damagedQty
            val dstBatchIds = linkRepository.findByTransferIdOrderByCreatedAtAsc(transfer.id!!)
                .filter { batchService.layerOf(it.dstBatchId!!).variantId == item.variantId }
                .mapNotNull { it.dstBatchId }
            for (dstId in dstBatchIds) {
                if (rest <= 0) break
                val available = batchService.layerOf(dstId).qtyRemaining
                if (available <= 0) continue
                val take = minOf(rest, available)
                batchService.writeOff(
                    dstId, take, MoveType.DAMAGE, "TRANSFER", transfer.id,
                    "Damaged on receipt — manager approved",
                )
                rest -= take
            }
            if (rest > 0) throw UnprocessableException("error.transfer.damage_shortage", listOf(item.variantId!!))
        }
        transfer.status = TransferStatus.confirmed.name
        val result = toDomain(transferRepository.save(transfer))
        val branch = warehouseRepository.findById(transfer.toWarehouseId!!).map { it.branchId }.orElse(null)
        auditLog.record("APPROVE", "transfer", transfer.id, branch, by, "warehouse=${transfer.toWarehouseId} confirmed")
        return result
    }

    @Transactional
    fun cancel(id: UUID): Transfer {
        val transfer = load(id)
        requireStatus(transfer, TransferStatus.draft, "error.transfer.cancel_draft_only")
        transfer.status = TransferStatus.cancelled.name
        return toDomain(transferRepository.save(transfer))
    }

    @Transactional(readOnly = true)
    fun linksOf(transferId: UUID): List<TransferBatchLinkView> {
        load(transferId)
        return linkRepository.findByTransferIdOrderByCreatedAtAsc(transferId).map {
            TransferBatchLinkView(it.srcBatchId, it.dstBatchId, it.qty, it.unitCost, it.landedUnitCost)
        }
    }

    private fun load(id: UUID): StockTransferJpaEntity =
        transferRepository.findById(id).orElseThrow { NotFoundException("error.transfer.not_found") }

    private fun requireStatus(entity: StockTransferJpaEntity, expected: TransferStatus, errorKey: String) {
        if (entity.status != expected.name) throw ConflictException(errorKey, listOf(entity.status))
    }

    private fun requireStatusIn(entity: StockTransferJpaEntity, expected: Set<TransferStatus>, errorKey: String) {
        if (TransferStatus.valueOf(entity.status) !in expected) throw ConflictException(errorKey, listOf(entity.status))
    }

    private fun toDomain(e: StockTransferJpaEntity) = Transfer(
        id = e.id,
        fromWarehouseId = e.fromWarehouseId!!,
        toWarehouseId = e.toWarehouseId!!,
        status = TransferStatus.valueOf(e.status),
        note = e.note,
        items = e.items.map {
            TransferItem(variantId = it.variantId!!, sentQty = it.sentQty, receivedQty = it.receivedQty, damagedQty = it.damagedQty)
        },
    )
}
