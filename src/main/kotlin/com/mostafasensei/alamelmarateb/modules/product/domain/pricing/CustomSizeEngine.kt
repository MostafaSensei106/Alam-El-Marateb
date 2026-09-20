package com.mostafasensei.alamelmarateb.modules.product.domain.pricing

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import java.math.BigDecimal
import java.math.RoundingMode

enum class CustomShape {
    RECT, OVAL, CIRCLE;

    companion object {
        fun parse(raw: String): CustomShape =
            try {
                valueOf(raw.trim().uppercase())
            } catch (_: Exception) {
                throw BadRequestException("error.custom.bad_shape", listOf(raw))
            }
    }
}

data class CustomQuote(
    val shape: CustomShape,
    val widthCm: Int,
    val lengthCm: Int,
    val areaM2: BigDecimal,
    val pricePerMeter: BigDecimal,
    val basePrice: BigDecimal,
    val operatingPct: Int,
    val total: BigDecimal,
    val skuSuffix: String,
)

/**
 * Custom-size mattress pricing (catalog P2 future).
 *
 * NO size limits: any positive width/length is quotable. Area by shape
 * (meters) x price-per-meter, plus an operating-cost surcharge driven by
 * the requested WIDTH (narrow widths waste more material per piece):
 *   90-100 -> 24%, 101-120 -> 20%, 121-140 -> 13%, 141-160 -> 8%,
 *   161-180 -> 4%, 181-200 -> 2%, 201-210 -> 0%.
 * Widths outside 90-210 carry no surcharge (0%). The surcharge applies to
 * every length — including mattresses longer than 205 cm.
 */
object CustomSizeEngine {

    fun operatingPct(widthCm: Int): Int = when (widthCm) {
        in 90..100 -> 24
        in 101..120 -> 20
        in 121..140 -> 13
        in 141..160 -> 8
        in 161..180 -> 4
        in 181..200 -> 2
        in 201..210 -> 0
        else -> 0
    }

    fun quote(shapeRaw: String, widthCm: Int, lengthCm: Int, pricePerMeter: BigDecimal?): CustomQuote {
        val shape = CustomShape.parse(shapeRaw)
        if (widthCm <= 0 || lengthCm <= 0) throw BadRequestException("error.custom.bad_dims")
        if (pricePerMeter == null || pricePerMeter <= BigDecimal.ZERO) {
            throw UnprocessableException("error.custom.no_meter_price")
        }
        val w = widthCm.toBigDecimal().movePointLeft(2)
        val l = lengthCm.toBigDecimal().movePointLeft(2)
        val area = when (shape) {
            CustomShape.RECT -> w.multiply(l)
            CustomShape.OVAL -> BigDecimal(Math.PI).multiply(w).multiply(l).divide(BigDecimal(4), 6, RoundingMode.HALF_UP)
            CustomShape.CIRCLE -> {
                val r = w.divide(BigDecimal(2), 6, RoundingMode.HALF_UP)
                BigDecimal(Math.PI).multiply(r).multiply(r)
            }
        }.setScale(4, RoundingMode.HALF_UP)
        val pct = operatingPct(widthCm)
        val base = area.multiply(pricePerMeter).scaled()
        val total = base.multiply(BigDecimal(100 + pct)).divide(BigDecimal(100), 2, RoundingMode.HALF_EVEN)
        return CustomQuote(
            shape = shape, widthCm = widthCm, lengthCm = lengthCm,
            areaM2 = area.setScale(2, RoundingMode.HALF_UP),
            pricePerMeter = pricePerMeter.scaled(), basePrice = base,
            operatingPct = pct, total = total,
            skuSuffix = "${shape.name}-${widthCm}X${lengthCm}",
        )
    }

    private fun BigDecimal.scaled(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
