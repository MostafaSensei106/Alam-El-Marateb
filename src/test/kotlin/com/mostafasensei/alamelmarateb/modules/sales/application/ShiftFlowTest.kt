package com.mostafasensei.alamelmarateb.modules.sales.application

import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
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
import kotlin.test.assertNotNull

@SpringBootTest
@Transactional
class ShiftFlowTest {

    @Autowired private lateinit var shiftService: ShiftService
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
    fun `open, drop, sell, close computes expected and variance`() {
        val suffix = System.nanoTime()
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "Shift Branch", "SB-$suffix", "Cairo", "St",
        )
        val cashierId = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            cashierId, "Cashier", "01088$suffix".take(11), "hash",
        )
        val warehouse = warehouseService.create(branchId, "Shift WH", "SWH-$suffix")
        val category = catalogService.createCategory(ProductCategory(name = "Shift Cat", slug = "shift-cat-$suffix"))
        val product = catalogService.createProduct(
            Product(categoryId = category.id!!, name = "Shift Mattress", slug = "shift-mattress-$suffix", brand = "B"),
        )
        val variantId = catalogService.createVariant(
            ProductVariant(productId = product.id, sku = "SHF-$suffix", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("8000")),
        ).id!!
        stockService.adjust(warehouse.id!!, variantId, 5, "Opening", by = "test")

        val shift = shiftService.open(branchId, cashierId, BigDecimal("1000"), "test")
        assertFailsWith<ConflictException> { shiftService.open(branchId, cashierId, BigDecimal.ZERO, "test") }
        assertEquals(shift.id, shiftService.current(cashierId).id)

        shiftService.drop(shift.id!!, BigDecimal("200"), "test")

        // One cash sale of 8000 during the shift.
        orderService.completeSale(
            PlaceOrderInput(
                branchId = branchId, guestPhone = "01000000001", channel = "pos",
                items = listOf(OrderItemInput(variantId, 1)), paymentMethod = PaymentMethod.CASH, by = "test",
            ),
            by = "test",
        )

        val closed = shiftService.close(shift.id!!, BigDecimal("8800"), "test")
        // expected = 1000 opening + 8000 cash - 200 drop = 8800, variance 0.
        assertEquals(BigDecimal("8800.00"), closed.expectedCash)
        assertEquals(BigDecimal("0.00"), closed.variance)
        assertFailsWith<ConflictException> { shiftService.close(shift.id!!, BigDecimal.ZERO, "test") }
        assertFailsWith<NotFoundException> { shiftService.current(cashierId) }
        assertNotNull(closed.closedAt)
    }

    @Test
    fun `receipt shows serial and totals`() {
        val suffix = System.nanoTime()
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "Receipt Branch", "RB-$suffix", "Cairo", "St",
        )
        val warehouse = warehouseService.create(branchId, "Receipt WH", "RWH-$suffix")
        val category = catalogService.createCategory(ProductCategory(name = "Rc Cat", slug = "rc-cat-$suffix"))
        val product = catalogService.createProduct(
            Product(categoryId = category.id!!, name = "Rc Mattress", slug = "rc-mattress-$suffix", brand = "B"),
        )
        val variantId = catalogService.createVariant(
            ProductVariant(productId = product.id, sku = "RCP-$suffix", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("8000")),
        ).id!!
        stockService.adjust(warehouse.id!!, variantId, 5, "Opening", by = "test")
        val order = orderService.completeSale(
            PlaceOrderInput(
                branchId = branchId, guestPhone = "01000000002", channel = "pos",
                items = listOf(OrderItemInput(variantId, 1)), paymentMethod = PaymentMethod.CASH, by = "test",
            ),
            by = "test",
        )
        val receipt = shiftService.receipt(order.id!!)
        assertNotNull(receipt.serial)
        assertEquals(BigDecimal("8000.00"), receipt.grandTotal)
        assertEquals(1, receipt.lines.size)
    }
}
