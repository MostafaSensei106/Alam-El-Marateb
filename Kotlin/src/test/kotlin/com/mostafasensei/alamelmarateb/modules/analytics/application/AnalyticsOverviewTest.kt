package com.mostafasensei.alamelmarateb.modules.analytics.application

import com.mostafasensei.alamelmarateb.modules.inventory.application.AuditService
import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.application.TransferItemRequest
import com.mostafasensei.alamelmarateb.modules.inventory.application.TransferService
import com.mostafasensei.alamelmarateb.modules.inventory.application.WarehouseService
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
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class AnalyticsOverviewTest {

    @Autowired
    private lateinit var analyticsService: AnalyticsService

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

    @Test
    fun `summary, velocity and audit trail reflect real activity`() {
        val category = catalogService.createCategory(
            ProductCategory(name = "Test Cat", slug = "analytics-cat-${System.nanoTime()}"),
        )
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!,
                name = "Analytics Mattress",
                slug = "analytics-mattress-${System.nanoTime()}",
                brand = "TestBrand",
            ),
        )
        val variant = catalogService.createVariant(
            ProductVariant(
                productId = product.id,
                sku = "ANALYTICS-${System.nanoTime()}",
                barcode = null,
                widthCm = 160,
                lengthCm = 195,
                heightCm = 25,
                costPrice = BigDecimal("5000"),
                sellingPrice = BigDecimal("8000"),
            ),
        )
        val main = warehouseService.create(null, "Main WH", "MAIN-${System.nanoTime()}")
        val branch = warehouseService.create(null, "Branch WH", "BR-${System.nanoTime()}")

        stockService.adjust(main.id!!, variant.id!!, 10, "Opening", by = "tester")
        val transfer = transferService.create(
            main.id, branch.id!!, null, listOf(TransferItemRequest(variant.id, 4)),
        )
        transferService.dispatch(transfer.id!!, by = "tester")

        // Summary sees both warehouses, valuation and pending transfer.
        val summary = analyticsService.summary()
        assertTrue(summary.warehouses >= 2)
        assertTrue(summary.activeProducts >= 1)
        assertTrue(summary.pendingTransfers >= 1)
        // 10 units at cost 5000 minus 4 dispatched = 30000 value.
        assertEquals(BigDecimal("30000.00"), summary.totalStockValue)
        val mainValue = summary.stockValueByWarehouse.first { it.warehouseId == main.id }
        assertEquals(6, mainValue.totalQty)

        // Velocity sees the 4-unit outbound move with cover math.
        val velocity = analyticsService.velocity(main.id)
        val row = velocity.first { it.variantId == variant.id }
        assertEquals(4, row.sold30d)
        assertEquals(6, row.currentQty)
        assertTrue((row.daysOfCover ?: 0) > 0)

        // Audit trail recorded dispatch with actor.
        val trail = analyticsService.auditTrail("transfer", transfer.id)
        assertTrue(trail.any { it.action == "DISPATCH" && it.actor == "tester" })
    }
}
