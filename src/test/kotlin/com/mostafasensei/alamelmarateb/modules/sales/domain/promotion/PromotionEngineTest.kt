package com.mostafasensei.alamelmarateb.modules.sales.domain.promotion

import org.junit.jupiter.api.Test
import java.math.BigDecimal
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class PromotionEngineTest {

    private val mattress = UUID.randomUUID()
    private val cover = UUID.randomUUID()
    private val pillow = UUID.randomUUID()

    private fun line(product: UUID, qty: Int, price: String, variant: UUID? = null) =
        PreviewLine(productId = product, variantId = variant, qty = qty, unitPrice = BigDecimal(price))

    @Test
    fun `no promotions returns gross totals`() {
        val preview = PromotionEngine.calculate(listOf(line(mattress, 1, "10000")), emptyList())
        assertEquals(BigDecimal("10000.00"), preview.subtotal)
        assertEquals(BigDecimal("0.00"), preview.totalDiscount)
        assertEquals(BigDecimal("10000.00"), preview.total)
    }

    @Test
    fun `item percent applies to targeted product only`() {
        val preview = PromotionEngine.calculate(
            listOf(line(mattress, 1, "10000"), line(pillow, 2, "500")),
            listOf(
                Promotion(code = "MATT10", name = "m10", type = PromoType.ITEM_PERCENT,
                    valuePercent = BigDecimal(10), targetProductId = mattress),
            ),
        )
        assertEquals(BigDecimal("11000.00"), preview.subtotal)
        assertEquals(BigDecimal("1000.00"), preview.totalDiscount)
        assertEquals(BigDecimal("10000.00"), preview.total)
        assertEquals(listOf("MATT10"), preview.lines[0].appliedCodes)
        assertTrue(preview.lines[1].appliedCodes.isEmpty())
    }

    @Test
    fun `bundle replaces set price and splits discount`() {
        val preview = PromotionEngine.calculate(
            listOf(line(mattress, 1, "10000"), line(cover, 1, "1500")),
            listOf(
                Promotion(code = "BUNDLE", name = "b", type = PromoType.BUNDLE_FIXED,
                    bundlePrice = BigDecimal("10500"),
                    bundleItems = listOf(
                        BundleRequirement(productId = mattress, requiredQty = 1),
                        BundleRequirement(productId = cover, requiredQty = 1),
                    )),
            ),
        )
        assertEquals(BigDecimal("1000.00"), preview.totalDiscount)
        assertEquals(BigDecimal("10500.00"), preview.total)
        assertEquals(BigDecimal("869.57"), preview.lines[0].discount)
        assertEquals(BigDecimal("130.43"), preview.lines[1].discount)
    }

    @Test
    fun `cart percent applies on net after item discounts`() {
        val preview = PromotionEngine.calculate(
            listOf(line(mattress, 1, "10000")),
            listOf(
                Promotion(code = "MATT10", name = "10%", type = PromoType.ITEM_PERCENT,
                    valuePercent = BigDecimal(10), targetProductId = mattress),
                Promotion(code = "CART5", name = "5%", type = PromoType.CART_PERCENT, valuePercent = BigDecimal(5)),
            ),
        )
        assertEquals(BigDecimal("1450.00"), preview.totalDiscount)
        assertEquals(BigDecimal("8550.00"), preview.total)
    }

    @Test
    fun `gift adds zero-net line showing original price`() {
        val preview = PromotionEngine.calculate(
            listOf(line(mattress, 1, "10000")),
            listOf(
                Promotion(code = "FREEPILLOW", name = "gift", type = PromoType.GIFT,
                    giftProductId = pillow, giftQty = 1, giftUnitPrice = BigDecimal("500"),
                    minCartTotal = BigDecimal("5000")),
            ),
        )
        assertEquals(2, preview.lines.size)
        val gift = preview.lines.last()
        assertTrue(gift.isGift)
        assertEquals(BigDecimal("0.00"), gift.net)
        assertEquals(BigDecimal("9500.00"), preview.total)
    }

    @Test
    fun `exclusive promo wins alone`() {
        val preview = PromotionEngine.calculate(
            listOf(line(mattress, 1, "10000")),
            listOf(
                Promotion(code = "SMALL", name = "s", type = PromoType.ITEM_PERCENT,
                    valuePercent = BigDecimal(5), targetProductId = mattress),
                Promotion(code = "BIG", name = "b", type = PromoType.CART_FIXED,
                    valueAmount = BigDecimal("2000"), exclusive = true),
            ),
        )
        assertEquals(listOf("BIG"), preview.appliedCodes)
        assertEquals(BigDecimal("8000.00"), preview.total)
    }

    @Test
    fun `min cart total blocks promotion`() {
        val preview = PromotionEngine.calculate(
            listOf(line(pillow, 1, "500")),
            listOf(
                Promotion(code = "CART10", name = "10%", type = PromoType.CART_PERCENT,
                    valuePercent = BigDecimal(10), minCartTotal = BigDecimal("1000")),
            ),
        )
        assertEquals(BigDecimal("0.00"), preview.totalDiscount)
    }
}
