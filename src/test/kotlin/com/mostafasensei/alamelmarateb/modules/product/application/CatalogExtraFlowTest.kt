package com.mostafasensei.alamelmarateb.modules.product.application

import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.application.WarehouseService
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductPreset
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductPresetVariant
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.service.BrandService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.QuizAnswer
import com.mostafasensei.alamelmarateb.modules.product.domain.service.QuizService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ReviewService
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
class CatalogExtraFlowTest {

    @Autowired private lateinit var catalogService: ProductCatalogService
    @Autowired private lateinit var brandService: BrandService
    @Autowired private lateinit var reviewService: ReviewService
    @Autowired private lateinit var quizService: QuizService
    @Autowired private lateinit var orderService: OrderService
    @Autowired private lateinit var warehouseService: WarehouseService
    @Autowired private lateinit var stockService: StockService
    @Autowired private lateinit var jdbc: JdbcTemplate
    @Autowired private lateinit var txManager: PlatformTransactionManager

    private fun committed(sql: String, vararg args: Any?) {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        template.execute { jdbc.update(sql, *args) }
    }

    @Test
    fun `quick-create, search, featured, compare, brands, reviews, quiz`() {
        val suffix = System.nanoTime()
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "Cat Branch", "CB-$suffix", "Cairo", "St",
        )
        val customerId = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            customerId, "Reviewer", "010" + UUID.randomUUID().toString().replace("-", "").take(8), "hash",
        )
        val warehouse = warehouseService.create(branchId, "Cat WH", "CWH-$suffix")

        // Preset with one priced variant -> quick-create copies price + single size.
        val preset = catalogService.createPreset(
            ProductPreset(
                categoryId = catalogService.createCategory(
                    ProductCategory(name = "QC Cat", slug = "qc-cat-$suffix"),
                ).id!!,
                name = "QC Model", brand = "QCBrand",
                variants = listOf(
                    ProductPresetVariant(widthCm = 120, lengthCm = 195, heightCm = 25,
                        costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("7000")),
                ),
            ),
        )
        val quick = catalogService.quickCreate(
            preset.id!!, "qc-$suffix", "QC 120", 120, 195, 25, null, null, null, null,
        )
        assertEquals(1, quick.variants.size)
        assertEquals("QC-$suffix".uppercase() + "-120X195X25", quick.variants.single().sku)
        assertEquals(BigDecimal("7000.00"), quick.variants.single().sellingPrice.setScale(2))

        // Search + featured + compare.
        assertTrue(catalogService.search("QC 120", null, null, null, null).any { it.id == quick.id })
        assertTrue(catalogService.search(null, null, "QCBrand", BigDecimal("6000"), BigDecimal("8000")).any { it.id == quick.id })
        catalogService.updateProduct(quick.id!!, quick.copy(isFeatured = true))
        assertTrue(catalogService.featured().any { it.id == quick.id })
        assertEquals(1, catalogService.compare(listOf(quick.id!!, quick.id!!)).size)

        // Brands CRUD.
        val brand = brandService.create("Test Brand $suffix", "tb-$suffix", null, null, 0)
        assertFailsWith<ConflictException> { brandService.create("Dup", "tb-$suffix", null, null, 0) }
        assertTrue(brandService.listActive().any { it.id == brand.id })

        // Verified review lifecycle: stock, buy (delivered), submit, moderate, public.
        val variantId = catalogService.createVariant(
            ProductVariant(
                productId = quick.id, sku = "QCV-$suffix", barcode = null,
                widthCm = 150, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("7000"),
            ),
        ).id!!
        stockService.adjust(warehouse.id!!, variantId, 5, "Opening", by = "test")
        orderService.completeSale(
            PlaceOrderInput(
                branchId = branchId, customerId = customerId, channel = "pos",
                items = listOf(OrderItemInput(variantId, 1)), paymentMethod = PaymentMethod.CASH, by = "test",
            ),
            by = "test",
        )
        val submitted = reviewService.submit(customerId, quick.id!!, 5, "Great", "Very comfy", emptyList())
        assertEquals("pending", submitted.status)
        assertTrue(submitted.verifiedPurchase)
        val approved = reviewService.moderate(submitted.id!!, true)
        assertEquals("approved", approved.status)
        val (items, summary) = reviewService.publicReviews(quick.id!!)
        assertEquals(1, items.size)
        assertEquals(5.0, summary.average)

        // Quiz: two real seeded answers -> recommendations + recorded run.
        val pairs = jdbc.queryForList(
            "SELECT o.id AS oid, o.question_id AS qid FROM quiz_options o " +
                "JOIN quiz_questions q ON q.id = o.question_id WHERE q.is_active " +
                "ORDER BY q.sort_order LIMIT 2",
        )
        assertTrue(pairs.size >= 2)
        val recs = quizService.recommend(
            customerId,
            pairs.map { QuizAnswer(UUID.fromString(it["qid"].toString()), UUID.fromString(it["oid"].toString())) },
        )
        assertTrue(recs.isNotEmpty())
        assertTrue(recs.all { it.matchPercent in 0..100 })
        assertTrue(recs.all { it.reasons.isNotEmpty() })
    }
}
