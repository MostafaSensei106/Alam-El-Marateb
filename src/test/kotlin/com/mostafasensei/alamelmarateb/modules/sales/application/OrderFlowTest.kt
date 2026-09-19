package com.mostafasensei.alamelmarateb.modules.sales.application

import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.application.WarehouseService
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.OrderStatus
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentMethod
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.PromoType
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class OrderFlowTest {

    @Autowired
    private lateinit var orderService: OrderService

    @Autowired
    private lateinit var promotionService: PromotionService

    @Autowired
    private lateinit var cartService: CartService

    @Autowired
    private lateinit var warehouseService: WarehouseService

    @Autowired
    private lateinit var stockService: StockService

    @Autowired
    private lateinit var catalogService: ProductCatalogService

    private fun seedVariant(suffix: String): UUID {
        val category = catalogService.createCategory(
            ProductCategory(name = "Sales Cat", slug = "sales-cat-$suffix-${System.nanoTime()}"),
        )
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!, name = "Sales Mattress",
                slug = "sales-mattress-$suffix-${System.nanoTime()}", brand = "TestBrand",
            ),
        )
        return catalogService.createVariant(
            ProductVariant(
                productId = product.id, sku = "SALES-$suffix-${System.nanoTime()}", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("5000"), sellingPrice = BigDecimal("8000"),
            ),
        ).id!!
    }

    @Test
    fun `place with promo reserves, complete deducts, idempotency replays`() {
        val variantId = seedVariant("a")
        val branchId = UUID.randomUUID()
        val warehouse = warehouseService.create(branchId, "Sales WH", "SWH-${System.nanoTime()}")
        stockService.adjust(warehouse.id!!, variantId, 10, "Opening", by = "test")

        promotionService.create(
            PromotionInput(code = "T10-${System.nanoTime()}", name = "10%", type = PromoType.CART_PERCENT,
                valuePercent = BigDecimal(10)),
        )

        val input = PlaceOrderInput(
            branchId = branchId, guestPhone = "01000000001", channel = "shop",
            items = listOf(OrderItemInput(variantId, 1)),
            paymentMethod = PaymentMethod.COD, idempotencyKey = "key-${System.nanoTime()}", by = "test",
        )
        val placed = orderService.place(input)
        // 8000 - 10% = 7200
        assertEquals(BigDecimal("7200.00"), placed.order.grandTotal)
        assertEquals(OrderStatus.confirmed, placed.order.status)
        // Reserved: available drops to 9.
        assertEquals(9, stockService.levels(warehouse.id!!).first().available)

        // Replay same key → same order, no double reserve.
        val replay = orderService.place(input)
        assertTrue(replay.replayed)
        assertEquals(placed.order.id, replay.order.id)
        assertEquals(9, stockService.levels(warehouse.id!!).first().available)

        // Deliver deducts.
        orderService.markDelivered(placed.order.id!!, by = "test")
        assertEquals(9, stockService.levels(warehouse.id!!).first().qty)
    }

    @Test
    fun `complete sale is paid and delivered immediately`() {
        val variantId = seedVariant("b")
        val branchId = UUID.randomUUID()
        val warehouse = warehouseService.create(branchId, "POS WH", "PWH-${System.nanoTime()}")
        stockService.adjust(warehouse.id!!, variantId, 5, "Opening", by = "test")

        val order = orderService.completeSale(
            PlaceOrderInput(
                branchId = branchId, guestPhone = "01000000002", channel = "pos",
                items = listOf(OrderItemInput(variantId, 2)),
                paymentMethod = PaymentMethod.CASH, by = "test",
            ),
            by = "test",
        )
        assertEquals(OrderStatus.delivered, order.status)
        assertEquals(BigDecimal("16000.00"), order.grandTotal)
        assertEquals(3, stockService.levels(warehouse.id!!).first().qty)
    }

    @Test
    fun `cart add merge and clear`() {
        val variantId = seedVariant("c")
        val customer = UUID.randomUUID()
        var cart = cartService.add(customer, null, variantId, 2)
        assertEquals(1, cart.lines.size)
        assertEquals(BigDecimal("16000.00"), cart.subtotal)
        cart = cartService.setQty(customer, null, variantId, 1)
        assertEquals(BigDecimal("8000.00"), cart.subtotal)
        val guest = "guest-${System.nanoTime()}"
        cartService.add(null, guest, variantId, 3)
        cart = cartService.merge(guest, customer)
        assertEquals(4, cart.lines.first().qty)
        cart = cartService.clear(customer, null)
        assertTrue(cart.lines.isEmpty())
    }

    @Test
    fun `estimate uses seeded zones and carry fees`() {
        val (delivery, carry) = orderService.estimate("الجيزة", "فيصل", 3)
        assertEquals(BigDecimal("80.00"), delivery)
        assertEquals(BigDecimal("100.00"), carry)
    }
}
