package com.mostafasensei.alamelmarateb.modules.loyalty.application

import com.mostafasensei.alamelmarateb.core.events.OrderDeliveredEvent
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.application.WarehouseService
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
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
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class LoyaltyFlowTest {

    @Autowired private lateinit var loyaltyService: LoyaltyService
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

    @Test
    fun `earn on delivery, quote, redeem as discount, ledger`() {
        val suffix = System.nanoTime()
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "Loyalty Branch", "LY-$suffix", "Cairo", "St",
        )
        val customerId = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            customerId, "Loyal", "010" + UUID.randomUUID().toString().replace("-", "").take(8), "hash",
        )
        val warehouse = warehouseService.create(branchId, "Loy WH", "LWH-$suffix")
        val category = catalogService.createCategory(ProductCategory(name = "Loy Cat", slug = "loy-cat-$suffix"))
        val product = catalogService.createProduct(
            Product(categoryId = category.id!!, name = "Loy Mattress", slug = "loy-mattress-$suffix", brand = "B"),
        )
        val variantId = catalogService.createVariant(
            ProductVariant(productId = product.id, sku = "LOY-$suffix", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("8000")),
        ).id!!
        stockService.adjust(warehouse.id!!, variantId, 10, "Opening", by = "test")

        // Earn needs a real order row (ledger FK): place first, then fire the event.
        val realOrderId = orderService.place(
            PlaceOrderInput(
                branchId = branchId, customerId = customerId, channel = "shop",
                items = listOf(OrderItemInput(variantId, 1)), paymentMethod = PaymentMethod.COD, by = "test",
            ),
        ).order.id!!
        // Earn: 8000 EGP delivered -> 800 pts (10 EGP/pt), idempotent per order.
        val orderId = realOrderId
        loyaltyService.onOrderDelivered(OrderDeliveredEvent(orderId, customerId, BigDecimal("8000.00")))
        loyaltyService.onOrderDelivered(OrderDeliveredEvent(orderId, customerId, BigDecimal("8000.00")))
        assertEquals(800, loyaltyService.balance(customerId).points)
        assertEquals(1, loyaltyService.ledger(customerId).count { it.reason == "EARN" })

        // Quote + redeem inside place-order: 100 pts -> 100 EGP off 8000.
        assertEquals(BigDecimal("100.00"), loyaltyService.quoteRedemption(customerId, 100))
        assertFailsWith<ConflictException> { loyaltyService.quoteRedemption(customerId, 99999) }
        val placed = orderService.place(
            PlaceOrderInput(
                branchId = branchId, customerId = customerId, channel = "shop",
                items = listOf(OrderItemInput(variantId, 1)), paymentMethod = PaymentMethod.COD,
                redeemPoints = 100, by = "test",
            ),
        )
        assertEquals(BigDecimal("7900.00"), placed.order.grandTotal)
        assertEquals(700, loyaltyService.balance(customerId).points)
        assertTrue(loyaltyService.ledger(customerId).any { it.reason == "REDEEM" && it.orderId == placed.order.id })
    }
}
