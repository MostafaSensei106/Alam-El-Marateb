package com.mostafasensei.alamelmarateb.modules.sales.domain.promotion

import java.math.BigDecimal
import java.util.UUID

enum class PromoType {
    ITEM_PERCENT,
    ITEM_FIXED,
    BUNDLE_FIXED,
    CART_PERCENT,
    CART_FIXED,
    GIFT,
}

data class BundleRequirement(
    val productId: UUID? = null,
    val variantId: UUID? = null,
    val requiredQty: Int = 1,
)

data class Promotion(
    val id: UUID? = null,
    val code: String,
    val name: String,
    val type: PromoType,
    val valuePercent: BigDecimal? = null,
    val valueAmount: BigDecimal? = null,
    val bundlePrice: BigDecimal? = null,
    val targetProductId: UUID? = null,
    val targetVariantId: UUID? = null,
    val bundleItems: List<BundleRequirement> = emptyList(),
    val giftVariantId: UUID? = null,
    val giftProductId: UUID? = null,
    val giftQty: Int = 1,
    val giftUnitPrice: BigDecimal? = null,
    val minCartTotal: BigDecimal? = null,
    val exclusive: Boolean = false,
)

data class PreviewLine(
    val productId: UUID,
    val variantId: UUID? = null,
    val qty: Int,
    val unitPrice: BigDecimal,
)

data class LineResult(
    val productId: UUID,
    val variantId: UUID?,
    val qty: Int,
    val unitPrice: BigDecimal,
    val gross: BigDecimal,
    val discount: BigDecimal,
    val net: BigDecimal,
    val appliedCodes: List<String>,
    val isGift: Boolean = false,
)

data class PricePreview(
    val lines: List<LineResult>,
    val subtotal: BigDecimal,
    val totalDiscount: BigDecimal,
    val total: BigDecimal,
    val appliedCodes: List<String>,
)
