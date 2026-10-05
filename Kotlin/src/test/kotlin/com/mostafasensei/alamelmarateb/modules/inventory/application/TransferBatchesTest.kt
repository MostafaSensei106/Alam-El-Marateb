package com.mostafasensei.alamelmarateb.modules.inventory.application

import com.mostafasensei.alamelmarateb.modules.purchasing.application.LandedCostService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PoItemInput
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchasingService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.ReceiveLineInput
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
import kotlin.test.assertTrue

/**
 * Batch-preserving transfers: FIFO dispatch, 1:1 mirroring with identical
 * costs (landed included, never recalculated), immutable links, damage
 * write-off from mirrored layers, return-to-source-layers, atomicity.
 */
@SpringBootTest
@Transactional
class TransferBatchesTest {

    @Autowired
    private lateinit var transferService: TransferService

    @Autowired
    private lateinit var warehouseService: WarehouseService

    @Autowired
    private lateinit var stockService: StockService

    @Autowired
    private lateinit var batchService: InventoryBatchService

    @Autowired
    private lateinit var purchasingService: PurchasingService

    @Autowired
    private lateinit var landedCostService: LandedCostService

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

    private data class Fixture(
        val branchA: UUID,
        val branchB: UUID,
        val whA: UUID,
        val whB: UUID,
        val variant: UUID,
    )

    /** Two branches (one warehouse each so sales resolve to the right one). */
    private fun seed(): Fixture {
        val branchA = UUID.randomUUID()
        val branchB = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchA, "Transfer A", "TFA-${System.nanoTime()}", "Cairo", "St",
        )
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchB, "Transfer B", "TFB-${System.nanoTime()}", "Giza", "St",
        )
        val whA = UUID.randomUUID()
        val whB = UUID.randomUUID()
        committed(
            "INSERT INTO warehouses (id, branch_id, name, code) VALUES (?, ?, ?, ?)",
            whA, branchA, "WH A", "TWA-${System.nanoTime()}",
        )
        committed(
            "INSERT INTO warehouses (id, branch_id, name, code) VALUES (?, ?, ?, ?)",
            whB, branchB, "WH B", "TWB-${System.nanoTime()}",
        )
        val categoryId = UUID.randomUUID()
        committed(
            "INSERT INTO product_categories (id, name, slug) VALUES (?, ?, ?)",
            categoryId, "Transfer Cat", "tfc-${System.nanoTime()}",
        )
        val productId = UUID.randomUUID()
        committed(
            "INSERT INTO products (id, category_id, name, slug, brand) VALUES (?, ?, ?, ?, ?)",
            productId, categoryId, "Transfer Mattress", "tfm-${System.nanoTime()}", "Habitat",
        )
        val variant = UUID.randomUUID()
        committed(
            "INSERT INTO product_variants (id, product_id, sku, width_cm, length_cm, height_cm, cost_price, selling_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            variant, productId, "TF-${System.nanoTime()}", 160, 195, 25, BigDecimal("1000"), BigDecimal("3000"),
        )
        return Fixture(branchA, branchB, whA, whB, variant)
    }

    /** Batch1: 10 @ landed 1200. Batch2: 10 @ landed 1800. */
    private fun stockA(f: Fixture) {
        val supplier = purchasingService.createSupplier("TF Supplier", "01000000021", "Cairo", "TAX-TF", "test")
        val ship1 = financeShipment(supplier.id!!, "CNT-TF-1")
        val po1 = purchasingService.createOrder(
            supplier.id, f.branchA, listOf(PoItemInput(f.variant, 10, BigDecimal("1000"))), "test",
        )
        purchasingService.sendOrder(po1.id!!, "test")
        purchasingService.receive(
            po1.id, f.whA, listOf(ReceiveLineInput(f.variant, 10, 0)), ship1, by = "keeper",
        )
        landedCostService.addCost(ship1, "FREIGHT", BigDecimal("2000"), by = "test")

        val ship2 = financeShipment(supplier.id, "CNT-TF-2")
        val po2 = purchasingService.createOrder(
            supplier.id, f.branchA, listOf(PoItemInput(f.variant, 10, BigDecimal("1600"))), "test",
        )
        purchasingService.sendOrder(po2.id!!, "test")
        purchasingService.receive(
            po2.id, f.whA, listOf(ReceiveLineInput(f.variant, 10, 0)), ship2, by = "keeper",
        )
        landedCostService.addCost(ship2, "FREIGHT", BigDecimal("2000"), by = "test")
    }

    private fun financeShipment(supplierId: UUID, no: String): UUID {
        val repo = getShipmentRepo()
        val saved = repo.save(
            com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.SupplierShipmentJpaEntity(
                supplierId = supplierId, shipmentNo = "$no-${System.nanoTime()}", arrivedAt = LocalDate.now(),
            ),
        )
        return saved.id!!
    }

    @Autowired
    private lateinit var shipmentRepo: com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.SupplierShipmentRepository

    private fun getShipmentRepo() = shipmentRepo

    private fun landedOf(wh: UUID, variant: UUID): Map<BigDecimal, Int> =
        batchService.listBatches(wh, variant)
            .groupBy { it.landedUnitCost.setScale(2) }
            .mapValues { (_, rows) -> rows.sumOf { it.qtyRemaining } }

    @Test
    fun `transfer mirrors FIFO layers, sale from dest uses mirrored costs, return restores layers`() {
        val f = seed()
        stockA(f)
        assertEquals(mapOf(BigDecimal("1200.00") to 10, BigDecimal("1800.00") to 10), landedOf(f.whA, f.variant))

        val transfer = transferService.create(f.whA, f.whB, "Restock B", listOf(TransferItemRequest(f.variant, 15)))
        transferService.dispatch(transfer.id!!, "manager")
        assertEquals(mapOf(BigDecimal("1200.00") to 0, BigDecimal("1800.00") to 5), landedOf(f.whA, f.variant))

        transferService.receiveBatch(transfer.id, listOf(TransferItemRequest(f.variant, 15)), emptyMap(), "keeper")
        assertEquals(mapOf(BigDecimal("1200.00") to 10, BigDecimal("1800.00") to 5), landedOf(f.whB, f.variant))

        // Immutable links: 10 from batch1 + 5 from batch2, costs preserved.
        val links = transferService.linksOf(transfer.id)
        assertEquals(2, links.size)
        assertEquals(15, links.sumOf { it.qty })
        assertTrue(links.all { it.landedUnitCost.setScale(2) == BigDecimal("1200.00") || it.landedUnitCost.setScale(2) == BigDecimal("1800.00") })

        // Sell 12 from B: 10x1200 + 2x1800 = 15600.
        val placed = orderService.completeSale(
            PlaceOrderInput(
                branchId = f.branchB, guestPhone = "01055555555", channel = "pos",
                items = listOf(OrderItemInput(f.variant, 12)), paymentMethod = PaymentMethod.CASH,
            ),
            "cashier",
        )
        em.flush()
        val cogs = jdbc.queryForObject(
            "SELECT cogs_total FROM order_items WHERE order_id = ?", BigDecimal::class.java, placed.id!!,
        )!!.setScale(2)
        assertEquals(BigDecimal("15600.00"), cogs)
        assertEquals(mapOf(BigDecimal("1200.00") to 0, BigDecimal("1800.00") to 3), landedOf(f.whB, f.variant))

        // Full return restores the exact mirrored layers.
        orderService.requestReturn(placed.id, "defect", listOf(OrderItemInput(f.variant, 12)), "cashier")
        orderService.approveReturn(placed.id, "manager")
        assertEquals(mapOf(BigDecimal("1200.00") to 10, BigDecimal("1800.00") to 5), landedOf(f.whB, f.variant))
    }

    @Test
    fun `damaged on receive is written off the mirrored layers at approve`() {
        val f = seed()
        stockA(f)
        val transfer = transferService.create(f.whA, f.whB, "With damage", listOf(TransferItemRequest(f.variant, 5)))
        transferService.dispatch(transfer.id!!, "manager")
        val received = transferService.receiveBatch(
            transfer.id, listOf(TransferItemRequest(f.variant, 4)), mapOf(f.variant to 1), "keeper",
        )
        assertEquals("received", received.status.name.lowercase())
        assertEquals(5, stockService.levels(f.whB).single().qty)

        transferService.approve(transfer.id, "manager")
        assertEquals(4, stockService.levels(f.whB).single().qty)
        // Damaged unit came off the mirrored 1200 layer.
        assertEquals(mapOf(BigDecimal("1200.00") to 4), landedOf(f.whB, f.variant))
    }

    @Test
    fun `failed receive rolls back everything, failed dispatch touches nothing`() {
        val f = seed()
        isolatedSuccess { stockA(f) }
        val before = stockService.levels(f.whA).single().qty

        // Dispatch beyond stock: whole dispatch fails, source untouched.
        val badId = isolatedSuccess {
            transferService.create(f.whA, f.whB, "Too big", listOf(TransferItemRequest(f.variant, 9999))).id!!
        }
        assertFailsAlone<com.mostafasensei.alamelmarateb.core.exceptions.ConflictException> {
            transferService.dispatch(badId, "manager")
        }
        assertEquals(before, stockService.levels(f.whA).single().qty)
        assertEquals("draft", transferService.get(badId).status.name.lowercase())
        assertTrue(transferService.linksOf(badId).isEmpty())

        // Valid dispatch, then receive with an unknown variant: dest untouched,
        // transfer still in_transit, no links written.
        val okId = isolatedSuccess {
            val t = transferService.create(f.whA, f.whB, "Partial fail", listOf(TransferItemRequest(f.variant, 3)))
            transferService.dispatch(t.id!!, "manager")
            t.id!!
        }
        assertFailsAlone<com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException> {
            transferService.receiveBatch(
                okId, listOf(TransferItemRequest(f.variant, 2)), mapOf(UUID.randomUUID() to 1), "keeper",
            )
        }
        assertTrue(stockService.levels(f.whB).isEmpty())
        assertEquals("in_transit", transferService.get(okId).status.name.lowercase())
        assertTrue(transferService.linksOf(okId).isEmpty())
    }

    /** Run [block] in an isolated transaction that COMMITS. */
    private fun <T> isolatedSuccess(block: () -> T): T {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        return template.execute { block() }!!
    }

    /**
     * Run [block] in an isolated transaction: on failure that tx rolls back
     * alone, so the test transaction keeps observing committed state only.
     */
    private inline fun <reified T : Throwable> assertFailsAlone(noinline block: () -> Unit) {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        try {
            template.execute { block() }
        } catch (e: Exception) {
            if (e is T) return
            throw e
        }
        throw AssertionError("Expected ${T::class.simpleName} but nothing was thrown")
    }
}
