package com.mostafasensei.alamelmarateb.modules.product.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.domain.service.CustomSizeService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class PricingTablesFlowTest {

    @Autowired
    private lateinit var catalogService: ProductCatalogService

    @Autowired
    private lateinit var customSizeService: CustomSizeService

    @Test
    fun `meter price per shape with generic fallback and bracket overrides`() {
        val suffix = System.nanoTime()
        val category = catalogService.createCategory(ProductCategory(name = "Price Cat", slug = "price-cat-$suffix"))
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!, name = "Price Model", slug = "price-model-$suffix", brand = "B",
                pricePerMeter = BigDecimal("5000"),
            ),
        )
        val productId = product.id!!

        // Shape-specific row wins over the generic meter price.
        customSizeService.setMeterPrice(productId, "oval", BigDecimal("6500"))
        assertEquals(
            BigDecimal("6500.00"),
            customSizeService.meterPrices(productId).single { it.shape == "OVAL" }.price,
        )
        // Oval 160x195 @6500: area pi*1.6*1.95/4 = 2.4504m2 -> base 15927.60 + 8% = 17201.81.
        val oval = customSizeService.quoteByProduct(productId, "oval", 160, 195)
        assertEquals(8, oval.operatingPct)
        assertEquals(BigDecimal("17201.81"), oval.total)
        // Rect has no row -> generic 5000 fallback.
        val rect = customSizeService.quoteByProduct(productId, "rect", 120, 200)
        assertEquals(BigDecimal("14400.00"), rect.total)
        // Delete the generic price -> quoting without any basis is rejected.
        catalogService.updateProduct(productId, product.copy(pricePerMeter = null))
        customSizeService.deleteMeterPrice(customSizeService.meterPrices(productId).single().id!!)
        assertFailsWith<com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException> {
            customSizeService.quoteByProduct(productId, "rect", 120, 200)
        }

        // Per-model bracket override beats the global table (generic meter price restored first).
        catalogService.updateProduct(productId, product.copy(pricePerMeter = BigDecimal("5000")))
        val overridden = customSizeService.createBracket(productId, 150, 160, 50)
        assertEquals(50, customSizeService.quoteByProduct(productId, "rect", 155, 195).operatingPct)
        assertEquals(20, customSizeService.quoteByProduct(productId, "rect", 120, 195).operatingPct)
        customSizeService.deleteBracket(overridden.id!!)
        assertEquals(8, customSizeService.quoteByProduct(productId, "rect", 155, 195).operatingPct)

        // Validation: bad range, bad pct, unknown shape, unknown ids.
        assertFailsWith<BadRequestException> { customSizeService.createBracket(productId, 160, 150, 10) }
        assertFailsWith<BadRequestException> { customSizeService.createBracket(productId, 150, 160, 101) }
        assertFailsWith<BadRequestException> { customSizeService.setMeterPrice(productId, "triangle", BigDecimal("100")) }
        assertFailsWith<NotFoundException> { customSizeService.deleteBracket(java.util.UUID.randomUUID()) }
        assertTrue(customSizeService.brackets(null).size >= 7)
    }
}
