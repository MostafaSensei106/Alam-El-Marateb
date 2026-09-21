package com.mostafasensei.alamelmarateb.modules.product.domain.pricing

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.product.domain.pricing.CustomSizeEngine.Bracket
import org.junit.jupiter.api.Test
import java.math.BigDecimal
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

class CustomSizeEngineTest {

    private val standard = listOf(
        Bracket(90, 100, 24),
        Bracket(101, 120, 20),
        Bracket(121, 140, 13),
        Bracket(141, 160, 8),
        Bracket(161, 180, 4),
        Bracket(181, 200, 2),
        Bracket(201, 210, 0),
    )

    @Test
    fun `rect area times meter price plus width bracket`() {
        // 120x200 @ 5000/m2: area 2.40m2 -> base 12000 + 20% (101-120) = 14400.
        val quote = CustomSizeEngine.quote("rect", 120, 200, BigDecimal("5000"), standard)
        assertEquals(20, quote.operatingPct)
        assertEquals(BigDecimal("12000.00"), quote.basePrice)
        assertEquals(BigDecimal("14400.00"), quote.total)
    }

    @Test
    fun `oval uses ellipse area and long lengths allowed`() {
        // 160x210 @ 4000/m2: area pi*1.6*2.1/4 = 2.6389m2 -> base 10555.60 + 8% = 11400.05.
        val quote = CustomSizeEngine.quote("oval", 160, 210, BigDecimal("4000"), standard)
        assertEquals(8, quote.operatingPct)
        assertEquals(BigDecimal("11400.05"), quote.total)
    }

    @Test
    fun `circle uses diameter and out-of-table widths carry no surcharge`() {
        // D=200 @ 5000/m2: area pi*1^2 = 3.1416m2 -> base 15708.00 + 2% = 16022.16.
        val quote = CustomSizeEngine.quote("circle", 200, 200, BigDecimal("5000"), standard)
        assertEquals(2, quote.operatingPct)
        assertEquals(BigDecimal("16022.16"), quote.total)

        // Narrowest bracket still 24%.
        assertEquals(24, CustomSizeEngine.quote("rect", 90, 195, BigDecimal("5000"), standard).operatingPct)
        // Outside the table: no surcharge, no rejection.
        assertEquals(0, CustomSizeEngine.quote("rect", 220, 220, BigDecimal("5000"), standard).operatingPct)
        assertEquals(0, CustomSizeEngine.quote("rect", 80, 190, BigDecimal("5000"), standard).operatingPct)
        // Empty table: everything at base price.
        assertEquals(0, CustomSizeEngine.quote("rect", 120, 200, BigDecimal("5000"), emptyList()).operatingPct)
        assertEquals(BigDecimal("12000.00"), CustomSizeEngine.quote("rect", 120, 200, BigDecimal("5000"), emptyList()).total)
    }

    @Test
    fun `bad shape, non-positive dims and missing meter price rejected`() {
        assertFailsWith<BadRequestException> { CustomSizeEngine.quote("triangle", 120, 200, BigDecimal("5000"), standard) }
        assertFailsWith<BadRequestException> { CustomSizeEngine.quote("rect", 0, 200, BigDecimal("5000"), standard) }
        assertFailsWith<UnprocessableException> { CustomSizeEngine.quote("rect", 120, 200, null, standard) }
        assertFailsWith<UnprocessableException> { CustomSizeEngine.quote("rect", 120, 200, BigDecimal.ZERO, standard) }
    }
}
