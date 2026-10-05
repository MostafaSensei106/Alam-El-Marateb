package com.mostafasensei.alamelmarateb.modules.purchasing.application

import com.mostafasensei.alamelmarateb.modules.inventory.application.InventoryBatchService
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderItemInput
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderService
import com.mostafasensei.alamelmarateb.modules.sales.application.PlaceOrderInput
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
import kotlin.test.assertFailsWith
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException

/**
 * Landed cost: BY_VALUE default, BY_QTY support, append-only allocations,
 * Estimated -> Final with locked COGS + variance, conservation of totals.
 */
@SpringBootTest
@Transactional
class DistributorLandedCostTest {

    @Autowired
    private lateinit var purchasingService: PurchasingService

    @Autowired
    private lateinit var financeService: SupplierFinanceService

    @Autowired
    private lateinit var landedCostService: LandedCostService

    @Autowired
    private lateinit var batchService: InventoryBatchService

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

    private fun seedVariant(sku: String, cost: BigDecimal, selling: BigDecimal): Triple<UUID, UUID, UUID> {
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "Landed Branch", "LB-${System.nanoTime()}", "Cairo", "St",
        )
        val warehouseId = UUID.randomUUID()
        committed(
            "INSERT INTO warehouses (id, branch_id, name, code) VALUES (?, ?, ?, ?)",
            warehouseId, branchId, "Landed WH", "LWH-${System.nanoTime()}",
        )
        val categoryId = UUID.randomUUID()
        committed(
            "INSERT INTO product_categories (id, name, slug) VALUES (?, ?, ?)",
            categoryId, "Landed Cat", "landed-cat-${System.nanoTime()}",
        )
        val productId = UUID.randomUUID()
        committed(
            "INSERT INTO products (id, category_id, name, slug, brand) VALUES (?, ?, ?, ?, ?)",
            productId, categoryId, "Landed Item", "landed-${System.nanoTime()}", "Habitat",
        )
        val variantId = UUID.randomUUID()
        committed(
            "INSERT INTO product_variants (id, product_id, sku, width_cm, length_cm, height_cm, cost_price, selling_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            variantId, productId, "$sku-${System.nanoTime()}", 160, 195, 25, cost, selling,
        )
        return Triple(branchId, warehouseId, variantId)
    }

    @Test
    fun `BY_VALUE default splits freight fairly across mixed container`() {
        val (branchId, warehouseId, mattress) = seedVariant("MAT", BigDecimal("1600"), BigDecimal("2500"))
        val (_, _, pillow) = seedVariant("PIL", BigDecimal("200"), BigDecimal("350"))
        val (_, _, cover) = seedVariant("COV", BigDecimal("300"), BigDecimal("500"))
        val supplier = purchasingService.createSupplier("Habitat LC", "01000000011", "Cairo", "TAX-LC", "test")
        val shipment = financeService.createShipment(supplier.id!!, "CNT-LC-1", LocalDate.now(), null, "test")

        // 20x1600=32000 + 100x200=20000 + 50x300=15000 = 67000.
        val po = purchasingService.createOrder(
            supplier.id, branchId,
            listOf(
                PoItemInput(mattress, 20, BigDecimal("1600")),
                PoItemInput(pillow, 100, BigDecimal("200")),
                PoItemInput(cover, 50, BigDecimal("300")),
            ),
            "test",
        )
        purchasingService.sendOrder(po.id!!, "test")
        purchasingService.receive(
            po.id, warehouseId,
            listOf(
                ReceiveLineInput(mattress, 20, 0),
                ReceiveLineInput(pillow, 100, 0),
                ReceiveLineInput(cover, 50, 0),
            ),
            shipment.id, "keeper",
        )

        // Freight 13400 BY_VALUE (default): 6400 / 4000 / 3000.
        val cost = landedCostService.addCost(shipment.id!!, "FREIGHT", BigDecimal("13400"), by = "test")
        assertEquals("BY_VALUE", cost.allocationMethod)
        assertEquals("ESTIMATED", cost.status)
        assertEquals(BigDecimal("13400.00"), cost.allocatedTotal.setScale(2))
        assertEquals(BigDecimal("0.00"), cost.varianceAmount.setScale(2))

        val byVariant = batchService.listBatches(warehouseId, null).associateBy { it.variantId }
        // 6400/20=320 -> landed 1920; 4000/100=40 -> 240; 3000/50=60 -> 360.
        assertEquals(BigDecimal("1920.00"), byVariant[mattress]!!.landedUnitCost.setScale(2))
        assertEquals(BigDecimal("240.00"), byVariant[pillow]!!.landedUnitCost.setScale(2))
        assertEquals(BigDecimal("360.00"), byVariant[cover]!!.landedUnitCost.setScale(2))

        // Sale uses landed COGS: mattress 1920.
        val placed = orderService.completeSale(
            PlaceOrderInput(
                branchId = branchId, guestPhone = "01033333333", channel = "pos",
                items = listOf(OrderItemInput(mattress, 1)), paymentMethod = PaymentMethod.CASH,
            ),
            "cashier",
        )
        em.flush()
        val cogs = jdbc.queryForObject(
            "SELECT cogs_total FROM order_items WHERE order_id = ?", BigDecimal::class.java, placed.id!!,
        )!!.setScale(2)
        assertEquals(BigDecimal("1920.00"), cogs)
    }

    @Test
    fun `BY_QTY splits per piece regardless of value`() {
        val (branchId, warehouseId, mattress) = seedVariant("MATQ", BigDecimal("1600"), BigDecimal("2500"))
        val (_, _, pillow) = seedVariant("PILQ", BigDecimal("200"), BigDecimal("350"))
        val supplier = purchasingService.createSupplier("Habitat LQ", "01000000012", "Cairo", "TAX-LQ", "test")
        val shipment = financeService.createShipment(supplier.id!!, "CNT-LC-2", LocalDate.now(), null, "test")

        val po = purchasingService.createOrder(
            supplier.id, branchId,
            listOf(
                PoItemInput(mattress, 20, BigDecimal("1600")),
                PoItemInput(pillow, 100, BigDecimal("200")),
            ),
            "test",
        )
        purchasingService.sendOrder(po.id!!, "test")
        purchasingService.receive(
            po.id, warehouseId,
            listOf(ReceiveLineInput(mattress, 20, 0), ReceiveLineInput(pillow, 100, 0)),
            shipment.id, "keeper",
        )

        // 120 units, 1200 handling -> 10/piece each.
        val cost = landedCostService.addCost(shipment.id!!, "HANDLING", BigDecimal("1200"), "BY_QTY", by = "test")
        assertEquals(BigDecimal("1200.00"), cost.allocatedTotal.setScale(2))
        val byVariant = batchService.listBatches(warehouseId, null).associateBy { it.variantId }
        assertEquals(BigDecimal("1610.00"), byVariant[mattress]!!.landedUnitCost.setScale(2))
        assertEquals(BigDecimal("210.00"), byVariant[pillow]!!.landedUnitCost.setScale(2))
    }

    @Test
    fun `estimated then final locks sold COGS and tracks variance`() {
        val (branchId, warehouseId, variant) = seedVariant("EST", BigDecimal("1000"), BigDecimal("2500"))
        val supplier = purchasingService.createSupplier("Habitat LE", "01000000013", "Cairo", "TAX-LE", "test")
        val shipment = financeService.createShipment(supplier.id!!, "CNT-LC-3", LocalDate.now(), null, "test")

        val po = purchasingService.createOrder(
            supplier.id, branchId, listOf(PoItemInput(variant, 10, BigDecimal("1000"))), "test",
        )
        purchasingService.sendOrder(po.id!!, "test")
        purchasingService.receive(po.id, warehouseId, listOf(ReceiveLineInput(variant, 10, 0)), shipment.id, "keeper")

        // Estimated customs 1000 -> 100/unit -> landed 1100.
        val est = landedCostService.addCost(shipment.id!!, "CUSTOMS", BigDecimal("1000"), by = "test")
        assertEquals("ESTIMATED", est.status)
        assertEquals(
            BigDecimal("1100.00"),
            batchService.listBatches(warehouseId, variant).single().landedUnitCost.setScale(2),
        )

        // Sell 4 at landed 1100 -> COGS 4400 (locked forever).
        val placed = orderService.completeSale(
            PlaceOrderInput(
                branchId = branchId, guestPhone = "01044444444", channel = "pos",
                items = listOf(OrderItemInput(variant, 4)), paymentMethod = PaymentMethod.CASH,
            ),
            "cashier",
        )
        em.flush()
        val cogsBefore = jdbc.queryForObject(
            "SELECT cogs_total FROM order_items WHERE order_id = ?", BigDecimal::class.java, placed.id!!,
        )!!.setScale(2)
        assertEquals(BigDecimal("4400.00"), cogsBefore)

        // Final customs 1500: delta 500 -> 6 remaining absorb 300 (50/unit -> 1150),
        // 4 sold units' 200 goes to variance. Old sale untouched.
        val fin = landedCostService.finalizeCost(est.id!!, BigDecimal("1500"), "test")
        assertEquals("FINAL", fin.status)
        assertEquals(BigDecimal("200.00"), fin.varianceAmount.setScale(2))
        assertEquals(
            BigDecimal("1150.00"),
            batchService.listBatches(warehouseId, variant).single().landedUnitCost.setScale(2),
        )
        em.flush()
        val cogsAfter = jdbc.queryForObject(
            "SELECT cogs_total FROM order_items WHERE order_id = ?", BigDecimal::class.java, placed.id!!,
        )!!.setScale(2)
        assertEquals(BigDecimal("4400.00"), cogsAfter)

        // Conservation: allocated (1300) + variance (200) == final 1500.
        assertEquals(
            BigDecimal("1500.00"),
            fin.allocatedTotal.add(fin.varianceAmount).setScale(2),
        )

        // Double finalize rejected.
        assertFailsWith<ConflictException> { landedCostService.finalizeCost(est.id, BigDecimal("1600"), "test") }
    }
}
