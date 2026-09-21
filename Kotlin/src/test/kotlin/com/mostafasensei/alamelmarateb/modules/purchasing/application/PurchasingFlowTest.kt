package com.mostafasensei.alamelmarateb.modules.purchasing.application

import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.annotation.Transactional
import org.springframework.transaction.support.TransactionTemplate
import java.math.BigDecimal
import java.util.UUID
import kotlin.test.assertEquals

@SpringBootTest
@Transactional
class PurchasingFlowTest {

    @Autowired
    private lateinit var purchasingService: PurchasingService

    @Autowired
    private lateinit var stockService: StockService

    @Autowired
    private lateinit var jdbc: JdbcTemplate

    @Autowired
    private lateinit var txManager: PlatformTransactionManager

    private fun committed(sql: String, vararg args: Any?) {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        template.execute { jdbc.update(sql, *args) }
    }

    @Test
    fun `supplier, PO draft-send, partial then full receipt closes, payment reduces balance`() {
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "Purchasing Branch", "PUB-${System.nanoTime()}", "Cairo", "St",
        )
        val warehouseId = UUID.randomUUID()
        committed(
            "INSERT INTO warehouses (id, branch_id, name, code) VALUES (?, ?, ?, ?)",
            warehouseId, branchId, "Purchasing WH", "PWH-${System.nanoTime()}",
        )
        val categoryId = UUID.randomUUID()
        committed(
            "INSERT INTO product_categories (id, name, slug) VALUES (?, ?, ?)",
            categoryId, "Purchasing Cat", "pur-cat-${System.nanoTime()}",
        )
        val productId = UUID.randomUUID()
        committed(
            "INSERT INTO products (id, category_id, name, slug, brand) VALUES (?, ?, ?, ?, ?)",
            productId, categoryId, "Purchasing Mattress", "pur-mattress-${System.nanoTime()}", "B",
        )
        val variantId = UUID.randomUUID()
        committed(
            "INSERT INTO product_variants (id, product_id, sku, width_cm, length_cm, height_cm, cost_price, selling_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            variantId, productId, "PUR-${System.nanoTime()}", 120, 195, 25, BigDecimal("4000"), BigDecimal("7000"),
        )

        // Supplier + draft PO of 10 units @ 100.
        val supplier = purchasingService.createSupplier("Foam Co", "01000000001", "Cairo", "TAX-1", "test")
        val order = purchasingService.createOrder(
            supplier.id!!, branchId, listOf(PoItemInput(variantId, 10, BigDecimal("100"))), "test",
        )
        assertEquals("draft", order.status)
        assertEquals(BigDecimal("1000.00"), order.total)

        // Send then receive a partial batch: 6 good + 1 damaged.
        assertEquals("sent", purchasingService.sendOrder(order.id!!, "test").status)
        val first = purchasingService.receive(
            order.id, warehouseId, listOf(ReceiveLineInput(variantId, 6, 1)), "keeper",
        )
        assertEquals(6, first.items.single().actualQty)
        assertEquals("partial", purchasingService.getOrder(order.id).status)
        assertEquals(6, stockService.levels(warehouseId).single().qty)
        assertEquals(BigDecimal("600.00"), purchasingService.getSupplier(supplier.id).balance)

        // Receive the rest: 3 good -> 9 actual + 1 damaged >= 10 ordered -> closed.
        purchasingService.receive(order.id, warehouseId, listOf(ReceiveLineInput(variantId, 3, 0)), "keeper")
        assertEquals("closed", purchasingService.getOrder(order.id).status)
        assertEquals(9, stockService.levels(warehouseId).single().qty)
        assertEquals(BigDecimal("900.00"), purchasingService.getSupplier(supplier.id).balance)

        // Payment reduces what we owe.
        assertEquals(BigDecimal("700.00"), purchasingService.paySupplier(supplier.id, BigDecimal("200"), "test").balance)
    }
}
