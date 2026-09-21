package com.mostafasensei.alamelmarateb.modules.inventory.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.StockLevelRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.StockMoveRepository
import com.mostafasensei.alamelmarateb.modules.inventory.data.repository.WarehouseRepository
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.StockLevelJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.StockMoveJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.entity.WarehouseJpaEntity
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.MoveType
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.StockLevel
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.Warehouse
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Service
class WarehouseService(
    private val warehouseRepository: WarehouseRepository,
) {
    @Transactional(readOnly = true)
    fun list(): List<Warehouse> = warehouseRepository.findAll().map { toDomain(it) }

    @Transactional(readOnly = true)
    fun get(id: UUID): Warehouse =
        warehouseRepository.findById(id).map { toDomain(it) }
            .orElseThrow { NotFoundException("error.inventory.warehouse_not_found") }

    @Transactional
    fun create(branchId: UUID?, name: String, code: String): Warehouse {
        if (name.isBlank()) throw BadRequestException("error.inventory.warehouse_name_required")
        if (warehouseRepository.existsByCode(code.trim().uppercase())) {
            throw ConflictException("error.inventory.warehouse_code_exists", listOf(code))
        }
        val saved = warehouseRepository.save(
            WarehouseJpaEntity(branchId = branchId, name = name.trim(), code = code.trim().uppercase()),
        )
        return toDomain(saved)
    }

    @Transactional
    fun update(id: UUID, name: String?, isActive: Boolean?): Warehouse {
        val entity = warehouseRepository.findById(id)
            .orElseThrow { NotFoundException("error.inventory.warehouse_not_found") }
        if (name != null) {
            if (name.isBlank()) throw BadRequestException("error.inventory.warehouse_name_required")
            entity.name = name.trim()
        }
        if (isActive != null) entity.isActive = isActive
        return toDomain(warehouseRepository.save(entity))
    }

    private fun toDomain(e: WarehouseJpaEntity) = Warehouse(
        id = e.id, branchId = e.branchId, name = e.name, code = e.code, isActive = e.isActive,
    )
}

/**
 * Single place that mutates stock: every change writes a stock_moves row
 * and upserts the stock_levels row. Nothing else touches levels directly.
 */
@Service
class StockService(
    private val stockLevelRepository: StockLevelRepository,
    private val stockMoveRepository: StockMoveRepository,
    private val warehouseRepository: WarehouseRepository,
    // One-directional link: inventory reads variants from catalog.
    private val variantRepository: ProductVariantRepository,
    private val auditLog: AuditLogService,
) {

    @Transactional(readOnly = true)
    fun levels(warehouseId: UUID): List<StockLevel> {
        requireWarehouse(warehouseId)
        return stockLevelRepository.findByWarehouseId(warehouseId).map { toDomain(it) }
    }

    @Transactional(readOnly = true)
    fun lookup(warehouseId: UUID, barcodeOrSku: String): StockLevel {
        requireWarehouse(warehouseId)
        val variant = variantRepository.findByBarcode(barcodeOrSku)
            ?: throw NotFoundException("error.inventory.no_variant_for", listOf(barcodeOrSku))
        val id = variant.id ?: throw NotFoundException("error.inventory.variant_no_id")
        return stockLevelRepository.findByWarehouseIdAndVariantId(warehouseId, id)
            .map { toDomain(it) }
            .orElse(StockLevel(warehouseId, id, 0, 0, null))
    }

    @Transactional
    fun adjust(warehouseId: UUID, variantId: UUID, qtyDelta: Int, note: String?, by: String? = null): StockLevel {
        val warehouse = warehouseRepository.findById(warehouseId)
            .orElseThrow { NotFoundException("error.inventory.warehouse_not_found") }
        requireVariant(variantId)
        if (qtyDelta == 0) throw BadRequestException("error.inventory.adjust_zero")
        if (note.isNullOrBlank()) throw BadRequestException("error.inventory.adjust_reason_required")
        applyMove(warehouseId, variantId, qtyDelta, MoveType.ADJUST, null, null, note)
        auditLog.record("ADJUST", "stock_level", variantId, warehouse.branchId, by, "delta=$qtyDelta note=$note warehouse=$warehouseId")
        return levelOf(warehouseId, variantId)
    }

    @Transactional
    fun setThreshold(warehouseId: UUID, variantId: UUID, minQty: Int?): StockLevel {
        requireWarehouse(warehouseId)
        requireVariant(variantId)
        if (minQty != null && minQty < 0) throw BadRequestException("error.inventory.threshold_negative")
        val level = levelEntity(warehouseId, variantId)
        level.minQty = minQty
        return toDomain(stockLevelRepository.save(level))
    }

    @Transactional(readOnly = true)
    fun lowStockAlerts(): List<StockLevel> =
        stockLevelRepository.findBelowThreshold().map { toDomain(it) }

    /** Used by transfers/audits/sales: fails when available stock is insufficient. */
    @Transactional
    fun applyMove(
        warehouseId: UUID,
        variantId: UUID,
        qtySigned: Int,
        type: MoveType,
        refType: String?,
        refId: UUID?,
        note: String?,
    ) {
        if (qtySigned == 0) throw BadRequestException("error.inventory.move_zero")
        val level = levelEntity(warehouseId, variantId)
        val newQty = level.qty + qtySigned
        if (newQty < 0) {
            throw ConflictException(
                "error.inventory.stock_insufficient",
                listOf(level.qty - level.reservedQty, -qtySigned),
            )
        }
        level.qty = newQty
        stockLevelRepository.save(level)
        stockMoveRepository.save(
            StockMoveJpaEntity(
                warehouseId = warehouseId,
                variantId = variantId,
                qtySigned = qtySigned,
                moveType = type.name,
                refType = refType,
                refId = refId,
                note = note,
            ),
        )
    }

    /** Used by future orders: hold qty without deducting. */
    @Transactional
    fun reserve(warehouseId: UUID, variantId: UUID, qty: Int) {
        if (qty <= 0) throw BadRequestException("error.inventory.reserve_positive")
        val level = levelEntity(warehouseId, variantId)
        if (level.qty - level.reservedQty < qty) {
            throw ConflictException("error.inventory.available_insufficient", listOf(level.qty - level.reservedQty))
        }
        level.reservedQty += qty
        stockLevelRepository.save(level)
    }

    @Transactional
    fun release(warehouseId: UUID, variantId: UUID, qty: Int) {
        if (qty <= 0) throw BadRequestException("error.inventory.release_positive")
        val level = levelEntity(warehouseId, variantId)
        level.reservedQty = (level.reservedQty - qty).coerceAtLeast(0)
        stockLevelRepository.save(level)
    }

    private fun levelOf(warehouseId: UUID, variantId: UUID): StockLevel =
        stockLevelRepository.findByWarehouseIdAndVariantId(warehouseId, variantId)
            .map { toDomain(it) }
            .orElse(StockLevel(warehouseId, variantId, 0, 0, null))

    private fun levelEntity(warehouseId: UUID, variantId: UUID): StockLevelJpaEntity =
        stockLevelRepository.findByWarehouseIdAndVariantId(warehouseId, variantId)
            .orElseGet {
                stockLevelRepository.save(
                    StockLevelJpaEntity(warehouseId = warehouseId, variantId = variantId),
                )
            }

    private fun requireWarehouse(warehouseId: UUID) {
        if (!warehouseRepository.existsById(warehouseId)) throw NotFoundException("error.inventory.warehouse_not_found")
    }

    private fun requireVariant(variantId: UUID) {
        variantRepository.findById(variantId) ?: throw NotFoundException("error.inventory.unknown_variant", listOf(variantId))
    }

    private fun toDomain(e: StockLevelJpaEntity) = StockLevel(
        warehouseId = e.warehouseId!!,
        variantId = e.variantId!!,
        qty = e.qty,
        reservedQty = e.reservedQty,
        minQty = e.minQty,
    )
}
