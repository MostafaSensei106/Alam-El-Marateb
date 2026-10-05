package com.mostafasensei.alamelmarateb.modules.purchasing.application

import com.mostafasensei.alamelmarateb.modules.inventory.application.InventoryBatchService
import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.SellingPriceService
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderService
import com.mostafasensei.alamelmarateb.modules.sales.application.PlaceOrderInput
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderItemInput
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentMethod
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.annotation.Transactional
import org.springframework.transaction.support.TransactionTemplate
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID
import kotlin.test.assertEquals

/**
 * Distributor economics: old batches keep old cost, sales use the NEW price,
 * FIFO consumes the oldest layer first, supplier invoices split into installments.
 */
@SpringBootTest
@Transactional
class DistributorEconomicsTest {

    @Autowired
    private lateinit var purchasingService: PurchasingService

    @Autowired
    private lateinit var priceSheetService: PriceSheetService

    @Autowired
    private lateinit var financeService: SupplierFinanceService

    @Autowired
    private lateinit var sellingPriceService: SellingPriceService

    @Autowired
    private lateinit var batchService: InventoryBatchService

    @Autowired
    private lateinit var stockService: StockService

    @Autowired
    private lateinit var orderService: OrderService

    @Autowired
    private lateinit var jdbc: JdbcTemplate

    @Autowired
    private lateinit var txManager: PlatformTransactionManager

    @jakarta.persistence.PersistenceContext
    private lateinit var em: jakarta.persistence.EntityManager

    private fun committed(sql: String, vararg args: Any?) {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        template.execute { jdbc.update(sql, *args) }
    }

    private fun seedVariant(): Triple<UUID, UUID, UUID> {
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "Dist Branch", "DIST-${System.nanoTime()}", "Cairo", "St",
        )
        val warehouseId = UUID.randomUUID()
        committed(
            "INSERT INTO warehouses (id, branch_id, name, code) VALUES (?, ?, ?, ?)",
            warehouseId, branchId, "Dist WH", "DWH-${System.nanoTime()}",
        )
        val categoryId = UUID.randomUUID()
        committed(
            "INSERT INTO product_categories (id, name, slug) VALUES (?, ?, ?)",
            categoryId, "Dist Cat", "dist-cat-${System.nanoTime()}",
        )
        val productId = UUID.randomUUID()
        committed(
            "INSERT INTO products (id, category_id, name, slug, brand) VALUES (?, ?, ?, ?, ?)",
            productId, categoryId, "Dist Mattress", "dist-mattress-${System.nanoTime()}", "Habitat",
        )
        val variantId = UUID.randomUUID()
        committed(
            "INSERT INTO product_variants (id, product_id, sku, width_cm, length_cm, height_cm, cost_price, selling_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            variantId, productId, "DIST-${System.nanoTime()}", 160, 195, 25, BigDecimal("1000"), BigDecimal("1500"),
        )
        return Triple(branchId, warehouseId, variantId)
    }

    @Test
    fun `old batch keeps old cost while sales use new price, FIFO consumes oldest first`() {
        val (branchId, warehouseId, variantId) = seedVariant()
        val supplier = purchasingService.createSupplier("Habitat", "01000000002", "Cairo", "TAX-H", "test")

        // Sheet #1: cost 1000, selling 1500.
        val sheet1 = priceSheetService.createSheet(
            supplier.id!!, "SHEET-2024", LocalDate.of(2024, 1, 1), LocalDate.of(2026, 3, 9),
            listOf(SheetLineInput(variantId, BigDecimal("1000"), BigDecimal("1500"))), "test",
        )
        priceSheetService.applySheet(sheet1.id!!, listOf("STAFF"), "test")
        assertEquals(BigDecimal("1500.00"), sellingPriceService.current(variantId, "STAFF"))

        // Batch A: 20 units @ 1000.
        val po = purchasingService.createOrder(
            supplier.id, branchId, listOf(PoItemInput(variantId, 20, BigDecimal("1000"))), "test",
        )
        purchasingService.sendOrder(po.id!!, "test")
        purchasingService.receive(po.id, warehouseId, listOf(ReceiveLineInput(variantId, 20, 0)), "keeper")

        // Sheet #2 raises prices: cost 1600, selling 2500.
        val sheet2 = priceSheetService.createSheet(
            supplier.id, "SHEET-2026-03", LocalDate.of(2026, 3, 10), null,
            listOf(SheetLineInput(variantId, BigDecimal("1600"), BigDecimal("2500"))), "test",
        )
        priceSheetService.applySheet(sheet2.id!!, listOf("STAFF"), "test")
        assertEquals(BigDecimal("2500.00"), sellingPriceService.current(variantId, "STAFF"))

        // Old batch still costs 1000.
        val batches = batchService.listBatches(warehouseId, variantId)
        assertEquals(1, batches.size)
        assertEquals(BigDecimal("1000.00"), batches.single().unitCost)
        assertEquals(20, batches.single().qtyRemaining)

        // Sell 1 at the NEW price: revenue 2500, COGS 1000 (old batch), profit 1500.
        val placed = orderService.completeSale(
            PlaceOrderInput(
                branchId = branchId, guestPhone = "01011111111", channel = "pos",
                items = listOf(OrderItemInput(variantId, 1)),
                paymentMethod = PaymentMethod.CASH,
            ),
            "cashier",
        )
        val orderId = placed.id!!
        em.flush()
        val cogs = jdbc.queryForObject(
            "SELECT cogs_total FROM order_items WHERE order_id = ?", BigDecimal::class.java, orderId,
        )!!
        assertEquals(BigDecimal("1000.00"), cogs.setScale(2))

        // Batch B: 20 units @ 1600. Sell 25 more -> 19 from A @1000, 6 from B @1600.
        val po2 = purchasingService.createOrder(
            supplier.id, branchId, listOf(PoItemInput(variantId, 20, BigDecimal("1600"))), "test",
        )
        purchasingService.sendOrder(po2.id!!, "test")
        purchasingService.receive(po2.id, warehouseId, listOf(ReceiveLineInput(variantId, 20, 0)), "keeper")

        val placed2 = orderService.completeSale(
            PlaceOrderInput(
                branchId = branchId, guestPhone = "01022222222", channel = "pos",
                items = listOf(OrderItemInput(variantId, 25)),
                paymentMethod = PaymentMethod.CASH,
            ),
            "cashier",
        )
        val cogs2 = jdbc.queryForObject(
            "SELECT cogs_total FROM order_items WHERE order_id = ?", BigDecimal::class.java, run { em.flush(); placed2.id!! },
        )!!.setScale(2)
        // 19*1000 + 6*1600 = 28600.
        assertEquals(BigDecimal("28600.00"), cogs2)

        // Remaining: A=0, B=14.
        val remaining = batchService.listBatches(warehouseId, variantId).associate { it.unitCost.setScale(2) to it.qtyRemaining }
        assertEquals(0, remaining[BigDecimal("1000.00")])
        assertEquals(14, remaining[BigDecimal("1600.00")])

        // Valuation: cost 14*1600=22400, revenue 14*2500=35000, profit 12600.
        val valuation = batchService.valuation(warehouseId, variantId)
        assertEquals(BigDecimal("22400.00"), valuation["inventoryCost"]!!.setScale(2))
        assertEquals(BigDecimal("35000.00"), valuation["potentialRevenue"]!!.setScale(2))
        assertEquals(BigDecimal("12600.00"), valuation["potentialProfit"]!!.setScale(2))
    }

    @Test
    fun `supplier invoice splits into installments, payments track balance, allocation links shipment`() {
        val supplier = purchasingService.createSupplier("Habitat Fin", "01000000003", "Cairo", "TAX-HF", "test")

        val shipment = financeService.createShipment(supplier.id!!, "CNT-2026-001", LocalDate.of(2026, 4, 1), null, "test")
        val invoice = financeService.createInvoice(
            supplier.id, "INV-001", BigDecimal("100000"), LocalDate.of(2026, 4, 2),
            listOf(
                InstallmentInput(BigDecimal("20000"), LocalDate.of(2026, 4, 2)),
                InstallmentInput(BigDecimal("30000"), LocalDate.of(2026, 5, 1)),
                InstallmentInput(BigDecimal("50000"), LocalDate.of(2026, 12, 1)),
            ),
            "test",
        )
        assertEquals("confirmed", invoice.status)
        assertEquals(BigDecimal("100000.00"), purchasingService.getSupplier(supplier.id).balance)

        financeService.allocate(invoice.id!!, shipment.id!!, BigDecimal("100000"), "test")

        val afterFirst = financeService.payInvoice(invoice.id, BigDecimal("20000"), "CASH", null, null, "test")
        assertEquals("partial", afterFirst.status)
        assertEquals(BigDecimal("20000.00"), afterFirst.paid)
        assertEquals(BigDecimal("80000.00"), afterFirst.remaining)
        assertEquals(BigDecimal("80000.00"), purchasingService.getSupplier(supplier.id).balance)

        val statement = financeService.statement(supplier.id)
        assertEquals(BigDecimal("80000.00"), (statement["totalOwed"] as BigDecimal).setScale(2))
    }
}
