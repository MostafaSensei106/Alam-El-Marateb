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
 * the requested WIDTH. Brackets come from the operating_brackets table
 * (global rows, or per-model overrides) — never hardcoded here.
 * Widths outside every bracket carry no surcharge (0%).
 */
object CustomSizeEngine {

    data class Bracket(val from: Int, val to: Int, val pct: Int)

    fun operatingPct(widthCm: Int, brackets: List<Bracket>): Int =
        brackets.firstOrNull { widthCm in it.from..it.to }?.pct ?: 0

    fun quote(
        shapeRaw: String,
        widthCm: Int,
        lengthCm: Int,
        pricePerMeter: BigDecimal?,
        brackets: List<Bracket>,
    ): CustomQuote {
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
        val pct = operatingPct(widthCm, brackets)
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
