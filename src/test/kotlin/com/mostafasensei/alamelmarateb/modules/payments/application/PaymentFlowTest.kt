package com.mostafasensei.alamelmarateb.modules.payments.application

import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.application.WarehouseService
import com.mostafasensei.alamelmarateb.modules.payments.application.gateway.FakePaymentGateway
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderItemInput
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderService
import com.mostafasensei.alamelmarateb.modules.sales.application.PlaceOrderInput
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentMethod
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentStatus
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.annotation.Transactional
import org.springframework.transaction.support.TransactionTemplate
import tools.jackson.databind.ObjectMapper
import java.math.BigDecimal
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

@SpringBootTest
@Transactional
class PaymentFlowTest {

    @Autowired private lateinit var paymentService: PaymentService
    @Autowired private lateinit var fakeGateway: FakePaymentGateway
    @Autowired private lateinit var orderService: OrderService
    @Autowired private lateinit var warehouseService: WarehouseService
    @Autowired private lateinit var stockService: StockService
    @Autowired private lateinit var catalogService: ProductCatalogService
    @Autowired private lateinit var objectMapper: ObjectMapper
    @Autowired private lateinit var jdbc: JdbcTemplate
    @Autowired private lateinit var txManager: PlatformTransactionManager

    private fun committed(sql: String, vararg args: Any?) {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        template.execute { jdbc.update(sql, *args) }
    }

    private fun seedOrder(suffix: Long, customerId: UUID): UUID {
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "Pay Branch", "PB-$suffix", "Cairo", "St",
        )
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            customerId, "Payer", "010" + UUID.randomUUID().toString().replace("-", "").take(8), "hash",
        )
        val warehouse = warehouseService.create(branchId, "Pay WH", "PWH-$suffix")
        val category = catalogService.createCategory(ProductCategory(name = "Pay Cat", slug = "pay-cat-$suffix"))
        val product = catalogService.createProduct(
            Product(categoryId = category.id!!, name = "Pay Mattress", slug = "pay-mattress-$suffix", brand = "B"),
        )
        val variantId = catalogService.createVariant(
            ProductVariant(productId = product.id, sku = "PAY-$suffix", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("8000")),
        ).id!!
        stockService.adjust(warehouse.id!!, variantId, 5, "Opening", by = "test")
        return orderService.place(
            PlaceOrderInput(
                branchId = branchId, customerId = customerId, channel = "shop",
                items = listOf(OrderItemInput(variantId, 1)), paymentMethod = PaymentMethod.TRANSFER, by = "test",
            ),
        ).order.id!!
    }

    private fun callbackBody(ref: String, success: Boolean, amount: BigDecimal) =
        objectMapper.writeValueAsString(mapOf("provider_ref" to ref, "success" to success, "amount" to amount))

    @Test
    fun `fake intent, signed callback captures and pays, replay idempotent`() {
        val customerId = UUID.randomUUID()
        val orderId = seedOrder(System.nanoTime(), customerId)

        val intent = paymentService.createIntent(orderId, "fake", customerId, null)
        assertEquals("pending", intent.status)
        val ref = intent.providerRef!!

        // Bad signature rejected before any state change.
        val body = callbackBody(ref, true, BigDecimal("8000.00"))
        assertFailsWith<UnprocessableException> {
            paymentService.handleCallback("fake", mapOf("X-Fake-Signature" to "nope"), body)
        }

        // Unknown gateway rejected.
        assertFailsWith<NotFoundException> {
            paymentService.handleCallback("nope-pay", emptyMap(), body)
        }

        // Good callback captures + pays the order.
        val signed = mapOf("X-Fake-Signature" to fakeGateway.sign(ref))
        val captured = paymentService.handleCallback("fake", signed, body)
        assertEquals("captured", captured.status)
        assertEquals(PaymentStatus.paid, orderService.trackById(orderId).paymentStatus)

        // Replay returns the same captured intent (no double pay).
        val replayed = paymentService.handleCallback("fake", signed, body)
        assertEquals("captured", replayed.status)
        assertEquals(intent.id, replayed.id)
    }

    @Test
    fun `failed and mismatched callbacks`() {
        val customerId = UUID.randomUUID()
        val orderId = seedOrder(System.nanoTime(), customerId)
        val intent = paymentService.createIntent(orderId, "fake", customerId, null)
        val ref = intent.providerRef!!
        val signed = mapOf("X-Fake-Signature" to fakeGateway.sign(ref))

        val failed = paymentService.handleCallback("fake", signed, callbackBody(ref, false, BigDecimal("8000.00")))
        assertEquals("failed", failed.status)
        // Terminal state rejects further transitions.
        assertFailsWith<ConflictException> {
            paymentService.handleCallback("fake", signed, callbackBody(ref, true, BigDecimal("8000.00")))
        }

        val intent2 = paymentService.createIntent(orderId, "fake", customerId, null)
        val ref2 = intent2.providerRef!!
        val signed2 = mapOf("X-Fake-Signature" to fakeGateway.sign(ref2))
        assertFailsWith<UnprocessableException> {
            paymentService.handleCallback("fake", signed2, callbackBody(ref2, true, BigDecimal("1.00")))
        }
    }
}
