package com.mostafasensei.alamelmarateb.modules.purchasing.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.application.WarehouseService
import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.MoveType
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.GoodsReceiptRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.PurchaseOrderRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.ReceiptItemRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.SupplierRepository
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.GoodsReceiptJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.PurchaseOrderItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.PurchaseOrderJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.ReceiptItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.UUID

enum class PoStatus {
    draft,
    sent,
    partial,
    closed,
    cancelled,
}

data class SupplierView(
    val id: UUID?,
    val name: String,
    val phone: String?,
    val address: String?,
    val taxId: String?,
    val balance: BigDecimal,
    val isActive: Boolean,
)

data class PoItemView(
    val variantId: UUID,
    val qty: Int,
    val unitCost: BigDecimal,
)

data class PurchaseOrderView(
    val id: UUID?,
    val supplierId: UUID?,
    val branchId: UUID?,
    val status: String,
    val total: BigDecimal,
    val items: List<PoItemView>,
)

data class ReceiptItemView(
    val variantId: UUID,
    val expectedQty: Int,
    val actualQty: Int,
    val damagedQty: Int,
)

data class ReceiptView(
    val id: UUID?,
    val poId: UUID?,
    val warehouseId: UUID?,
    val receivedBy: String?,
    val items: List<ReceiptItemView>,
)

data class PoItemInput(val variantId: UUID, val qty: Int, val unitCost: BigDecimal)

data class ReceiveLineInput(val variantId: UUID, val actualQty: Int, val damagedQty: Int)

@Service
class PurchasingService(
    private val supplierRepository: SupplierRepository,
    private val orderRepository: PurchaseOrderRepository,
    private val receiptRepository: GoodsReceiptRepository,
    private val receiptItemRepository: ReceiptItemRepository,
    private val stockService: StockService,
    private val warehouseService: WarehouseService,
    private val variantRepository: ProductVariantRepository,
    private val auditLog: AuditLogService,
) {

    // ---- suppliers ----

    @Transactional
    fun createSupplier(name: String?, phone: String?, address: String?, taxId: String?, by: String? = null): SupplierView {
        if (name.isNullOrBlank()) throw BadRequestException("error.purchasing.supplier_name_required")
        val saved = supplierRepository.save(
            SupplierJpaEntity(name = name.trim(), phone = phone, address = address, taxId = taxId),
        )
        auditLog.record("SUPPLIER_CREATE", "supplier", saved.id, null, by, "name=${saved.name}")
        return toSupplierView(saved)
    }

    @Transactional(readOnly = true)
    fun getSupplier(id: UUID): SupplierView = toSupplierView(loadSupplier(id))

    @Transactional(readOnly = true)
    fun listSuppliers(activeOnly: Boolean?): List<SupplierView> {
        val entities = if (activeOnly == true) supplierRepository.findByIsActive(true) else supplierRepository.findAll()
        return entities.map { toSupplierView(it) }
    }

    @Transactional
    fun updateSupplier(
        id: UUID, name: String?, phone: String?, address: String?,
        taxId: String?, isActive: Boolean?, by: String? = null,
    ): SupplierView {
        val entity = loadSupplier(id)
        if (name != null) {
            if (name.isBlank()) throw BadRequestException("error.purchasing.supplier_name_required")
            entity.name = name.trim()
        }
        if (phone != null) entity.phone = phone
        if (address != null) entity.address = address
        if (taxId != null) entity.taxId = taxId
        if (isActive != null) entity.isActive = isActive
        return toSupplierView(supplierRepository.save(entity))
    }

    /** Soft delete: deactivate so purchase history (RESTRICT) stays intact. */
    @Transactional
    fun deactivateSupplier(id: UUID, by: String? = null): SupplierView {
        val entity = loadSupplier(id)
        entity.isActive = false
        val saved = supplierRepository.save(entity)
        auditLog.record("SUPPLIER_DEACTIVATE", "supplier", saved.id, null, by, null)
        return toSupplierView(saved)
    }

    /** Supplier payment: amount must be positive; reduces what we owe. */
    @Transactional
    fun paySupplier(supplierId: UUID, amount: BigDecimal?, by: String? = null): SupplierView {
        val supplier = loadSupplier(supplierId)
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw BadRequestException("error.purchasing.po_item_positive")
        }
        supplier.balance = supplier.balance.subtract(amount).money()
        val saved = supplierRepository.save(supplier)
        auditLog.record("SUPPLIER_PAY", "supplier", saved.id, null, by, "amount=$amount")
        return toSupplierView(saved)
    }

    // ---- purchase orders ----

    @Transactional
    fun createOrder(supplierId: UUID, branchId: UUID?, items: List<PoItemInput>, by: String? = null): PurchaseOrderView {
        loadSupplier(supplierId)
        if (items.isEmpty()) throw BadRequestException("error.purchasing.po_empty_items")
        items.forEach {
            if (it.qty <= 0) throw BadRequestException("error.purchasing.po_item_positive", listOf(it.variantId))
            if (it.unitCost.compareTo(BigDecimal.ZERO) < 0) {
                throw BadRequestException("error.purchasing.po_item_positive", listOf(it.variantId))
            }
            variantRepository.findById(it.variantId)
                ?: throw NotFoundException("error.purchasing.unknown_variant", listOf(it.variantId))
        }
        val order = PurchaseOrderJpaEntity(supplierId = supplierId, branchId = branchId, status = PoStatus.draft.name)
        order.items = items.map {
            PurchaseOrderItemJpaEntity(order = order, variantId = it.variantId, qty = it.qty, unitCost = it.unitCost.money())
        }.toMutableList()
        order.total = order.items.fold(BigDecimal.ZERO) { acc, item ->
            acc.add(item.unitCost.multiply(item.qty.toBigDecimal()))
        }.money()
        val saved = orderRepository.save(order)
        auditLog.record("PO_CREATE", "purchase_order", saved.id, branchId, by, "supplier=$supplierId total=${saved.total}")
        return toOrderView(saved)
    }

    @Transactional(readOnly = true)
    fun getOrder(id: UUID): PurchaseOrderView = toOrderView(loadOrder(id))

    @Transactional(readOnly = true)
    fun listOrders(supplierId: UUID?, status: String?): List<PurchaseOrderView> {
        val entities = when {
            supplierId != null && status != null -> orderRepository.findBySupplierIdAndStatus(supplierId, status)
            supplierId != null -> orderRepository.findBySupplierId(supplierId)
            status != null -> orderRepository.findByStatus(status)
            else -> orderRepository.findAll()
        }
        return entities.map { toOrderView(it) }
    }

    @Transactional
    fun transition(id: UUID, action: String?, by: String? = null): PurchaseOrderView {
        return when (action?.trim()?.lowercase()) {
            "send" -> sendOrder(id, by)
            "cancel" -> cancelOrder(id, by)
            else -> throw BadRequestException("error.purchasing.po_status", listOf(action ?: ""))
        }
    }

    @Transactional
    fun sendOrder(id: UUID, by: String? = null): PurchaseOrderView {
        val order = loadOrder(id)
        requireStatus(order, PoStatus.draft, "error.purchasing.po_status")
        order.status = PoStatus.sent.name
        val saved = orderRepository.save(order)
        auditLog.record("PO_SEND", "purchase_order", saved.id, saved.branchId, by, null)
        return toOrderView(saved)
    }

    @Transactional
    fun cancelOrder(id: UUID, by: String? = null): PurchaseOrderView {
        val order = loadOrder(id)
        requireStatus(order, PoStatus.draft, "error.purchasing.po_status")
        order.status = PoStatus.cancelled.name
        val saved = orderRepository.save(order)
        auditLog.record("PO_CANCEL", "purchase_order", saved.id, saved.branchId, by, null)
        return toOrderView(saved)
    }

    /**
     * Receive one batch against a sent/partial PO: writes a goods_receipt +
     * receipt_items, posts PURCHASE stock moves for good qty, accrues
     * supplier.balance by actual*unit_cost, then moves PO to partial/closed.
     * Closed only when every item has received+damaged >= ordered.
     */
    @Transactional
    fun receive(poId: UUID, warehouseId: UUID, lines: List<ReceiveLineInput>, by: String? = null): ReceiptView {
        val order = loadOrder(poId)
        if (order.status != PoStatus.sent.name && order.status != PoStatus.partial.name) {
            throw ConflictException("error.purchasing.po_status", listOf(order.status))
        }
        try {
            warehouseService.get(warehouseId)
        } catch (e: NotFoundException) {
            throw NotFoundException("error.purchasing.warehouse_not_found", listOf(warehouseId))
        }
        if (lines.isEmpty()) throw BadRequestException("error.purchasing.po_empty_items")
        val grouped = lines.groupBy { it.variantId }
            .mapValues { (_, group) -> group.sumOf { it.actualQty } to group.sumOf { it.damagedQty } }
        grouped.forEach { (variantId, quantities) ->
            val (actual, damaged) = quantities
            val item = order.items.firstOrNull { it.variantId == variantId }
                ?: throw NotFoundException("error.purchasing.receive_not_found", listOf(variantId))
            if (actual < 0 || damaged < 0 || actual + damaged <= 0) {
                throw BadRequestException("error.purchasing.po_item_positive", listOf(variantId))
            }
            val settled = settledQty(poId, variantId)
            if (settled.first + settled.second + actual + damaged > item.qty) {
                throw UnprocessableException("error.purchasing.receive_exceeds", listOf(variantId))
            }
        }
        val receipt = GoodsReceiptJpaEntity(poId = poId, warehouseId = warehouseId, receivedBy = by)
        receipt.items = grouped.map { (variantId, quantities) ->
            val (actual, damaged) = quantities
            val item = order.items.first { it.variantId == variantId }
            val settled = settledQty(poId, variantId)
            ReceiptItemJpaEntity(
                receipt = receipt,
                variantId = variantId,
                expectedQty = item.qty - settled.first - settled.second,
                actualQty = actual,
                damagedQty = damaged,
            )
        }.toMutableList()
        val saved = receiptRepository.save(receipt)
        var accrual = BigDecimal.ZERO
        grouped.forEach { (variantId, quantities) ->
            val (actual, _) = quantities
            if (actual > 0) {
                val item = order.items.first { it.variantId == variantId }
                stockService.applyMove(
                    warehouseId = warehouseId,
                    variantId = variantId,
                    qtySigned = actual,
                    type = MoveType.PURCHASE,
                    refType = "PO",
                    refId = poId,
                    note = "Goods receipt for PO $poId",
                )
                accrual = accrual.add(item.unitCost.multiply(actual.toBigDecimal()))
            }
        }
        val supplier = loadSupplier(order.supplierId!!)
        supplier.balance = supplier.balance.add(accrual).money()
        supplierRepository.save(supplier)
        val complete = order.items.all { item ->
            val settled = settledQty(poId, item.variantId!!)
            settled.first + settled.second >= item.qty
        }
        order.status = if (complete) PoStatus.closed.name else PoStatus.partial.name
        orderRepository.save(order)
        auditLog.record(
            "PO_RECEIVE", "purchase_order", poId, order.branchId, by,
            "warehouse=$warehouseId receipt=${saved.id} status=${order.status}",
        )
        return toReceiptView(saved)
    }

    // ---- internals ----

    private fun loadSupplier(id: UUID): SupplierJpaEntity =
        supplierRepository.findById(id).orElseThrow { NotFoundException("error.purchasing.supplier_not_found", listOf(id)) }

    private fun loadOrder(id: UUID): PurchaseOrderJpaEntity =
        orderRepository.findById(id).orElseThrow { NotFoundException("error.purchasing.po_not_found", listOf(id)) }

    private fun requireStatus(order: PurchaseOrderJpaEntity, expected: PoStatus, errorKey: String) {
        if (order.status != expected.name) throw ConflictException(errorKey, listOf(order.status))
    }

    /** Cumulative (actual, damaged) already settled for a PO item across all receipts. */
    private fun settledQty(poId: UUID, variantId: UUID): Pair<Int, Int> {
        val receiptIds = receiptRepository.findByPoId(poId).mapNotNull { it.id }
        if (receiptIds.isEmpty()) return 0 to 0
        var actual = 0
        var damaged = 0
        receiptIds.forEach { receiptId ->
            receiptItemRepository.findByReceiptId(receiptId)
                .filter { it.variantId == variantId }
                .forEach {
                    actual += it.actualQty
                    damaged += it.damagedQty
                }
        }
        return actual to damaged
    }

    private fun BigDecimal.money(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)

    private fun toSupplierView(e: SupplierJpaEntity) = SupplierView(
        id = e.id,
        name = e.name,
        phone = e.phone,
        address = e.address,
        taxId = e.taxId,
        balance = e.balance,
        isActive = e.isActive,
    )

    private fun toOrderView(e: PurchaseOrderJpaEntity) = PurchaseOrderView(
        id = e.id,
        supplierId = e.supplierId,
        branchId = e.branchId,
        status = e.status,
        total = e.total,
        items = e.items.map { PoItemView(it.variantId!!, it.qty, it.unitCost) },
    )

    private fun toReceiptView(e: GoodsReceiptJpaEntity) = ReceiptView(
        id = e.id,
        poId = e.poId,
        warehouseId = e.warehouseId,
        receivedBy = e.receivedBy,
        items = e.items.map { ReceiptItemView(it.variantId!!, it.expectedQty, it.actualQty, it.damagedQty) },
    )
}
