package com.mostafasensei.alamelmarateb.modules.crm.application

import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.application.WarehouseService
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderItemInput
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderService
import com.mostafasensei.alamelmarateb.modules.sales.application.PlaceOrderInput
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.InvoiceRepository
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
import java.time.Instant
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class CrmFlowTest {

    @Autowired
    private lateinit var crmService: CrmService

    @Autowired
    private lateinit var warrantyService: WarrantyService

    @Autowired
    private lateinit var orderService: OrderService

    @Autowired
    private lateinit var warehouseService: WarehouseService

    @Autowired
    private lateinit var stockService: StockService

    @Autowired
    private lateinit var catalogService: ProductCatalogService

    @Autowired
    private lateinit var invoiceRepository: InvoiceRepository

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
    fun `profile, addresses, favorites, warranty and claim lifecycle`() {
        val customerId = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            customerId, "CRM Customer", "02${System.nanoTime().toString().takeLast(9)}", "hash",
        )
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "CRM Branch", "CRMB-${System.nanoTime()}", "Cairo", "St",
        )

        // Profile + addresses.
        val profile = crmService.profile(customerId, "الجيزة", "فيصل", null, null)
        assertEquals("الجيزة", profile.governorate)
        val address = crmService.addAddress(customerId, "home", "01011111111", "الجيزة", "شارع 1", true, "test")
        assertTrue(address.isDefault)
        assertEquals(1, crmService.addresses(customerId).size)

        // Product with warranty + stock + delivered order.
        val category = catalogService.createCategory(
            ProductCategory(name = "CRM Cat", slug = "crm-cat-${System.nanoTime()}"),
        )
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!, name = "CRM Mattress",
                slug = "crm-mattress-${System.nanoTime()}", brand = "B", warrantyYears = 5,
            ),
        )
        val variant = catalogService.createVariant(
            ProductVariant(
                productId = product.id, sku = "CRM-${System.nanoTime()}", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("7000"),
            ),
        )
        val warehouse = warehouseService.create(branchId, "CRM WH", "CWH-${System.nanoTime()}")
        stockService.adjust(warehouse.id!!, variant.id!!, 3, "Opening", by = "test")

        // Favorites.
        crmService.addFavorite(customerId, product.id!!)
        assertEquals(listOf(product.id), crmService.favorites(customerId))
        crmService.removeFavorite(customerId, product.id!!)
        assertTrue(crmService.favorites(customerId).isEmpty())

        val order = orderService.completeSale(
            PlaceOrderInput(
                branchId = branchId, customerId = customerId, channel = "pos",
                items = listOf(OrderItemInput(variant.id!!, 1)),
                paymentMethod = PaymentMethod.CASH, by = "test",
            ),
            by = "test",
        )
        val invoiceId = invoiceRepository.findAll().first { it.orderId == order.id }.id!!

        // Warranty: 5-year coverage, verify, claim lifecycle.
        val warranty = warrantyService.register(invoiceId, "test")
        assertTrue(warrantyService.verify(warranty.id!!).valid)
        assertEquals(1, warrantyService.myWarranties(customerId).size)

        val claim = warrantyService.fileClaim(warranty.id!!, "Sagging middle", null, "test")
        assertEquals("reported", claim.status)
        val inspecting = warrantyService.scheduleInspection(claim.id!!, Instant.now().plusSeconds(86400), "manager")
        assertEquals("inspecting", inspecting.status)
        val resolved = warrantyService.resolve(claim.id!!, "replace", "manager")
        assertEquals("replaced", resolved.status)
        assertEquals("closed", warrantyService.close(claim.id!!, "manager").status)
        assertEquals(1, warrantyService.myClaims(customerId).size)
    }
}
