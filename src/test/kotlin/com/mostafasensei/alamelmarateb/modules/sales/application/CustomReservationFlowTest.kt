package com.mostafasensei.alamelmarateb.modules.sales.application

import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.application.WarehouseService
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
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
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class CustomReservationFlowTest {

    @Autowired private lateinit var orderService: OrderService
    @Autowired private lateinit var warehouseService: WarehouseService
    @Autowired private lateinit var stockService: StockService
    @Autowired private lateinit var catalogService: ProductCatalogService
    @Autowired private lateinit var jdbc: JdbcTemplate
    @Autowired private lateinit var txManager: PlatformTransactionManager

    private fun committed(sql: String, vararg args: Any?) {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        template.execute { jdbc.update(sql, *args) }
    }

    private fun seedBase(suffix: Long): Triple<UUID, UUID, UUID> {
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "Custom Branch", "CB-$suffix", "Cairo", "St",
        )
        val customerId = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            customerId, "Custom Client", "01033$suffix".take(11), "hash",
        )
        val warehouse = warehouseService.create(branchId, "Custom WH", "CWH-$suffix")
        val category = catalogService.createCategory(ProductCategory(name = "Custom Cat", slug = "cust-cat-$suffix"))
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!, name = "Custom Base", slug = "cust-base-$suffix", brand = "B",
                pricePerMeter = BigDecimal("5000"),
            ),
        )
        val variantId = catalogService.createVariant(
            ProductVariant(productId = product.id, sku = "CST-$suffix", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("8000")),
        ).id!!
        stockService.adjust(warehouse.id!!, variantId, 10, "Opening", by = "test")
        return Triple(branchId, customerId, variantId)
    }

    @Test
    fun `reserve, pay in parts, fulfill on the set day`() {
        val (branchId, customerId, variantId) = seedBase(System.nanoTime())

        // Book 1x8000 with 2000 deposit for a later date.
        val reservationId = orderService.reserve(
            branchId, customerId, null, variantId, 1, BigDecimal("2000"), null, "test",
        )
        var view = orderService.getReservation(reservationId)
        assertEquals(BigDecimal("8000.00"), view.total)
        assertEquals(BigDecimal("2000.00"), view.paidAmount)
        assertEquals(BigDecimal("6000.00"), view.remaining)
        assertEquals(1, view.payments.size)

        // Overpaying is rejected.
        assertFailsWith<UnprocessableException> {
            orderService.payReservation(reservationId, BigDecimal("7000"), "CASH", "test")
        }
        // Pay the rest, then fulfill (stock deducted, no phantom hold left).
        view = orderService.payReservation(reservationId, BigDecimal("6000"), "TRANSFER", "test")
        assertEquals(BigDecimal("0.00"), view.remaining)
        assertEquals(2, view.payments.size)
        val fulfilled = orderService.fulfillReservation(reservationId, "test")
        assertEquals("fulfilled", fulfilled.status)
        // Double fulfill rejected.
        assertFailsWith<ConflictException> { orderService.fulfillReservation(reservationId, "test") }
    }

    @Test
    fun `custom oval order skips stock and supports balance payments`() {
        val (branchId, customerId, _) = seedBase(System.nanoTime())
        val productId = jdbc.queryForObject(
            "SELECT id FROM products WHERE slug LIKE 'cust-base-%' ORDER BY created_at DESC LIMIT 1",
            String::class.java,
        )!!.let { UUID.fromString(it) }

        // Oval 160x210 @5000/m2: base 13194.50 + 8% = 14250.06, no stock touched.
        val placed = orderService.placeCustomOrder(
            branchId = branchId, customerId = customerId, guestPhone = null,
            productId = productId, shape = "oval", widthCm = 160, lengthCm = 210, heightCm = 25,
            qty = 1, paymentMethod = PaymentMethod.TRANSFER, downPayment = BigDecimal("4000"),
            deliverAt = null, salesRepId = null, idempotencyKey = "cust-${System.nanoTime()}", by = "test",
        )
        assertEquals(BigDecimal("14250.06"), placed.order.grandTotal)
        assertEquals(BigDecimal("4000.00"), placed.order.paidAmount)
        assertTrue(placed.order.lines.single().isCustom)

        // Overpaying the balance is rejected; exact remainder closes it.
        assertFailsWith<UnprocessableException> {
            orderService.payOrderBalance(placed.order.id!!, BigDecimal("99999"), "CASH", "test")
        }
        val paid = orderService.payOrderBalance(placed.order.id!!, BigDecimal("10250.06"), "CASH", "test")
        assertEquals("paid", paid.paymentStatus.name)
        assertEquals(BigDecimal("14250.06"), paid.paidAmount)
    }
}
