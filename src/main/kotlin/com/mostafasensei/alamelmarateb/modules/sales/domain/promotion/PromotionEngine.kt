package com.mostafasensei.alamelmarateb.modules.sales.domain.promotion

import java.math.BigDecimal
import java.math.RoundingMode

/**
 * Pure pricing engine — no Spring, no DB. Fully unit-testable.
 *
 * Order: item promos → bundle promos (proportional split) → cart promos → gifts.
 * Exclusive: best single exclusive wins alone. Discounts never exceed their base.
 */
object PromotionEngine {

    private val HUNDRED = BigDecimal(100)

    private data class State(
        val line: PreviewLine,
        var discount: BigDecimal = BigDecimal.ZERO,
        val codes: MutableList<String> = mutableListOf(),
    )

    fun calculate(lines: List<PreviewLine>, promotions: List<Promotion>): PricePreview {
        if (lines.isEmpty()) {
            return PricePreview(emptyList(), BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, emptyList())
        }
        val subtotal = lines.sumOf { grossOf(it) }.scaled()
        val eligible = promotions.filter { p -> p.minCartTotal == null || subtotal >= p.minCartTotal }
        val exclusives = eligible.filter { it.exclusive }
        val toApply = if (exclusives.isNotEmpty()) listOf(bestExclusive(lines, exclusives)) else eligible
        val states = lines.map { State(it) }

        toApply.filter { it.type == PromoType.ITEM_PERCENT || it.type == PromoType.ITEM_FIXED }
            .forEach { promo ->
                states.filter { matchesTarget(it.line, promo) }.forEach { st ->
                    val remaining = grossOf(st.line).minus(st.discount)
                    val d = when (promo.type) {
                        PromoType.ITEM_PERCENT ->
                            remaining.multiply(promo.valuePercent!!).divide(HUNDRED, 2, RoundingMode.HALF_EVEN)
                        else -> promo.valueAmount!!.multiply(st.line.qty.toBigDecimal()).min(remaining)
                    }.scaled().coerceAtLeast(BigDecimal.ZERO)
                    if (d > BigDecimal.ZERO) {
                        st.discount = st.discount.add(d)
                        st.codes.add(promo.code)
                    }
                }
            }

        toApply.filter { it.type == PromoType.BUNDLE_FIXED }.forEach { promo -> applyBundle(states, promo) }

        val netAfterLines = states.sumOf { grossOf(it.line).minus(it.discount) }.scaled()
        var cartDiscount = BigDecimal.ZERO
        val cartCodes = mutableListOf<String>()
        toApply.filter { it.type == PromoType.CART_PERCENT || it.type == PromoType.CART_FIXED }
            .forEach { promo ->
                val base = netAfterLines.minus(cartDiscount).coerceAtLeast(BigDecimal.ZERO)
                val d = when (promo.type) {
                    PromoType.CART_PERCENT ->
                        base.multiply(promo.valuePercent!!).divide(HUNDRED, 2, RoundingMode.HALF_EVEN)
                    else -> promo.valueAmount!!.min(base)
                }.scaled()
                if (d > BigDecimal.ZERO) {
                    cartDiscount = cartDiscount.add(d)
                    cartCodes.add(promo.code)
                }
            }

        val giftLines = mutableListOf<LineResult>()
        toApply.filter { it.type == PromoType.GIFT }.forEach { promo ->
            val price = promo.giftUnitPrice ?: BigDecimal.ZERO
            if (price > BigDecimal.ZERO && promo.giftQty > 0) {
                val gross = price.multiply(promo.giftQty.toBigDecimal()).scaled()
                giftLines.add(
                    LineResult(
                        productId = promo.giftProductId ?: promo.targetProductId ?: states.first().line.productId,
                        variantId = promo.giftVariantId ?: promo.targetVariantId,
                        qty = promo.giftQty,
                        unitPrice = price,
                        gross = gross,
                        discount = gross,
                        net = BigDecimal.ZERO,
                        appliedCodes = listOf(promo.code),
                        isGift = true,
                    ),
                )
            }
        }

        val results = states.map {
            val gross = grossOf(it.line)
            LineResult(
                it.line.productId, it.line.variantId, it.line.qty, it.line.unitPrice, gross,
                it.discount.scaled(), gross.minus(it.discount).scaled(), it.codes.toList(),
            )
        } + giftLines

        val lineDiscounts = results.sumOf { it.discount }.scaled()
        val totalDiscount = lineDiscounts.add(cartDiscount).scaled()
        val total = subtotal.minus(totalDiscount).scaled().coerceAtLeast(BigDecimal.ZERO)
        return PricePreview(results, subtotal, totalDiscount, total, (results.flatMap { it.appliedCodes } + cartCodes).distinct())
    }

    private fun grossOf(line: PreviewLine): BigDecimal =
        line.unitPrice.multiply(line.qty.toBigDecimal()).scaled()

    private fun matchesTarget(line: PreviewLine, promo: Promotion): Boolean =
        (promo.targetVariantId != null && promo.targetVariantId == line.variantId) ||
            (promo.targetVariantId == null && promo.targetProductId != null && promo.targetProductId == line.productId)

    private fun matchesRequirement(line: PreviewLine, req: BundleRequirement): Boolean =
        (req.variantId != null && req.variantId == line.variantId) ||
            (req.variantId == null && req.productId != null && req.productId == line.productId)

    private fun applyBundle(states: List<State>, promo: Promotion) {
        if (promo.bundlePrice == null || promo.bundleItems.isEmpty()) return
        val times = promo.bundleItems.minOf { req ->
            if (req.requiredQty <= 0) return@minOf 0
            states.filter { matchesRequirement(it.line, req) }.sumOf { it.line.qty } / req.requiredQty
        }
        if (times <= 0) return
        val contributed = mutableMapOf<State, BigDecimal>()
        promo.bundleItems.forEach { req ->
            var need = req.requiredQty * times
            states.filter { matchesRequirement(it.line, req) }.forEach { st ->
                if (need <= 0) return@forEach
                val take = minOf(need, st.line.qty)
                contributed[st] = (contributed[st] ?: BigDecimal.ZERO)
                    .add(st.line.unitPrice.multiply(take.toBigDecimal()))
                need -= take
            }
        }
        val matchedGross = contributed.values.fold(BigDecimal.ZERO) { acc, v -> acc.add(v) }.scaled()
        if (matchedGross <= BigDecimal.ZERO) return
        val totalDiscount = matchedGross
            .minus(promo.bundlePrice.multiply(times.toBigDecimal()))
            .scaled().coerceAtLeast(BigDecimal.ZERO)
        contributed.keys.forEach { if (promo.code !in it.codes) it.codes.add(promo.code) }
        if (totalDiscount <= BigDecimal.ZERO) return
        val entries = contributed.entries.toList()
        var assigned = BigDecimal.ZERO
        entries.forEachIndexed { index, (st, contrib) ->
            val share = if (index == entries.lastIndex) {
                totalDiscount.minus(assigned)
            } else {
                contrib.divide(matchedGross, 10, RoundingMode.HALF_EVEN).multiply(totalDiscount).scaled()
            }.coerceAtLeast(BigDecimal.ZERO)
            st.discount = st.discount.add(share)
            assigned = assigned.add(share)
        }
    }

    private fun bestExclusive(lines: List<PreviewLine>, exclusives: List<Promotion>): Promotion =
        exclusives.maxBy { calculate(lines, listOf(it.copy(exclusive = false))).totalDiscount }

    private fun BigDecimal.scaled(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
