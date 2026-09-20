package com.mostafasensei.alamelmarateb.modules.estimator.application

import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.modules.sales.application.PromotionService
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.annotation.Transactional
import org.springframework.transaction.support.TransactionTemplate
import java.math.BigDecimal
import java.time.LocalDateTime
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertNotNull
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class EstimatorSpinFlowTest {

    @Autowired private lateinit var estimatorService: EstimatorService
    @Autowired private lateinit var spinService: SpinService
    @Autowired private lateinit var promotionService: PromotionService
    @Autowired private lateinit var catalogService: ProductCatalogService
    @Autowired private lateinit var jdbc: JdbcTemplate
    @Autowired private lateinit var txManager: PlatformTransactionManager

    private fun <T> committedTx(block: () -> T): T {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        return template.execute { block() }!!
    }

    private fun committed(sql: String, vararg args: Any?) {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        template.execute { jdbc.update(sql, *args) }
    }

    private fun seedUser(): UUID {
        val id = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            id, "Spinner", "010" + UUID.randomUUID().toString().replace("-", "").take(8), "hash",
        )
        return id
    }

    private fun seedProduct(suffix: Long): UUID = committedTx {
        val category = catalogService.createCategory(ProductCategory(name = "Est Cat", slug = "est-cat-$suffix"))
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!, name = "Est Model", slug = "est-model-$suffix", brand = "B",
                pricePerMeter = BigDecimal("5000"),
            ),
        )
        catalogService.createVariant(
            ProductVariant(productId = product.id, sku = "ESTV-$suffix", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 30,
                costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("8000")),
        )
        product.id!!
    }

    @Test
    fun `catalog picker plus automatic quote with shipping`() {
        val productId = seedProduct(System.nanoTime())

        val models = estimatorService.catalog(null)
        val model = models.first { it.productId == productId }
        assertTrue(model.hasMeterPrice)
        assertEquals(listOf(30), model.heightsCm)

        // Rect 120x200 @5000 = 14400 mattress + no zone = fees zero.
        val quote = estimatorService.quote(
            userId = null, branchId = null, channel = "shop", productId = productId,
            shape = "rect", widthCm = 120, lengthCm = 200, heightCm = 30,
            governorate = null, area = null, floor = null, qty = 1,
        )
        assertEquals(BigDecimal("14400.00"), quote.mattressTotal)
        assertEquals(BigDecimal("14400.00"), quote.grandTotal)
        assertTrue(quote.skuSuggestion.contains("120X200X30"))

        // Staff channel recorded.
        val channels = jdbc.queryForList("SELECT channel FROM estimate_runs").map { it["channel"] }
        assertTrue(channels.contains("shop") && channels.contains("pos"))
        estimatorService.quote(
            userId = null, branchId = null, channel = "pos", productId = productId,
            shape = "circle", widthCm = 200, lengthCm = 200, heightCm = null,
            governorate = null, area = null, floor = null, qty = 2,
        )
        val last = jdbc.queryForList("SELECT channel, result FROM estimate_runs ORDER BY created_at DESC LIMIT 1").single()
        assertEquals("pos", last["channel"])
        assertTrue(last["result"].toString().contains("32044.32"))
    }

    @Test
    fun `six prizes max, losing spin, second spin rejected`() {
        val campaign = spinService.createCampaign(
            "Eid Wheel", LocalDateTime.now().minusDays(1), LocalDateTime.now().plusDays(7), true, 1,
        )
        repeat(6) { i ->
            spinService.addPrize(campaign.id!!, "No luck $i", "NONE", BigDecimal.ZERO, null, 1, null, i)
        }
        assertFailsWith<ConflictException> {
            spinService.addPrize(campaign.id!!, "Extra", "NONE", BigDecimal.ZERO, null, 1, null, 6)
        }

        val userId = seedUser()
        val result = spinService.spin(userId, campaign.id)
        assertEquals(false, result.won)
        assertEquals(null, result.promoCode)
        assertFailsWith<ConflictException> { spinService.spin(userId, campaign.id) }
    }

    @Test
    fun `winning spin grants a usable single-use promo`() {
        val campaign = spinService.createCampaign(
            "Win Wheel", LocalDateTime.now().minusDays(1), LocalDateTime.now().plusDays(7), true, 1,
        )
        spinService.addPrize(campaign.id!!, "200 off", "FIXED", BigDecimal("200"), null, 1, null, 0)

        val result = spinService.spin(seedUser(), campaign.id)
        assertEquals(true, result.won)
        assertNotNull(result.promoCode)

        val preview = promotionService.preview(
            promotionService.resolveLines(listOf(firstVariant() to 1)),
        )
        assertTrue(preview.appliedCodes.contains(result.promoCode))
        assertEquals(BigDecimal("7800.00"), preview.total)
    }

    @Test
    fun `no active campaign and unknown campaign`() {
        assertFailsWith<NotFoundException> { spinService.spin(seedUser(), null) }
        assertFailsWith<NotFoundException> { spinService.spin(seedUser(), UUID.randomUUID()) }
    }

    private fun firstVariant(): UUID {        val productId = seedProduct(System.nanoTime())
        return jdbc.queryForObject(
            "SELECT id FROM product_variants WHERE product_id = ? LIMIT 1", String::class.java, productId,
        )!!.let { UUID.fromString(it) }
    }
}
