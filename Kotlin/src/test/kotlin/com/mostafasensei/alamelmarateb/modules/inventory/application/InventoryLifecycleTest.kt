package com.mostafasensei.alamelmarateb.modules.inventory.application

import com.mostafasensei.alamelmarateb.modules.inventory.domain.model.TransferStatus
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import kotlin.test.assertEquals
import kotlin.test.assertNotNull

@SpringBootTest
@Transactional
class InventoryLifecycleTest {

    @Autowired
    private lateinit var warehouseService: WarehouseService

    @Autowired
    private lateinit var stockService: StockService

    @Autowired
    private lateinit var transferService: TransferService

    @Autowired
    private lateinit var auditService: AuditService

    @Autowired
    private lateinit var catalogService: ProductCatalogService

    private fun seedVariant(): ProductVariant {
        val category = catalogService.createCategory(
            ProductCategory(name = "Test Cat", slug = "test-cat-${System.nanoTime()}"),
        )
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!,
                name = "Test Mattress",
                slug = "test-mattress-${System.nanoTime()}",
                brand = "TestBrand",
            ),
        )
        return catalogService.createVariant(
            ProductVariant(
                productId = product.id,
                sku = "SKU-${System.nanoTime()}",
                barcode = null,
                widthCm = 120,
                lengthCm = 195,
                heightCm = 25,
                costPrice = BigDecimal("5000"),
                sellingPrice = BigDecimal("8000"),
            ),
        )
    }

    @Test
    fun `full lifecycle - adjust, transfer with damage, audit`() {
        val variant = seedVariant()
        val variantId = variant.id!!
        val cairo = warehouseService.create(null, "Cairo WH", "CAI-${System.nanoTime()}")
        val giza = warehouseService.create(null, "Giza WH", "GIZ-${System.nanoTime()}")

        // 1. Opening stock.
        stockService.adjust(cairo.id!!, variantId, 10, "Opening balance")
        assertEquals(10, stockService.levels(cairo.id).first().qty)

        // 2. Transfer 6 units, dispatch deducts source.
        val transfer = transferService.create(
            cairo.id, giza.id!!, "Restock",
            listOf(TransferItemRequest(variantId, 6)),
        )
        assertEquals(TransferStatus.draft, transfer.status)
        transferService.dispatch(transfer.id!!)
        assertEquals(4, stockService.levels(cairo.id).first().qty)

        // 3. Receive 4 good + 2 damaged (pending).
        val received = transferService.receiveBatch(
            transfer.id,
            listOf(TransferItemRequest(variantId, 4)),
            mapOf(variantId to 2),
        )
        assertEquals(TransferStatus.received, received.status)
        // Dest: 4 good + 2 damaged-pending = 6.
        assertEquals(6, stockService.levels(giza.id).first().qty)

        // 4. Manager approves → damaged deducted.
        transferService.approve(transfer.id)
        assertEquals(4, stockService.levels(giza.id).first().qty)

        // 5. Audit: count 3, reconcile writes -1 move.
        val audit = auditService.open(giza.id, "Cycle count")
        auditService.submitCount(audit.id!!, variantId, 3)
        auditService.reconcile(audit.id)
        assertEquals(3, stockService.levels(giza.id).first().qty)

        // 6. Low-stock alert fires with threshold.
        stockService.setThreshold(giza.id, variantId, 5)
        val alerts = stockService.lowStockAlerts()
        assertNotNull(alerts.firstOrNull { it.variantId == variantId })
    }
}
