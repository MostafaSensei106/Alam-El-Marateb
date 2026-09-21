package com.mostafasensei.alamelmarateb.modules.sales.domain.model

import java.math.BigDecimal
import java.util.UUID

enum class OrderStatus {
    draft, confirmed, preparing, delivering, delivered, returned, cancelled, failed,
}

enum class PaymentMethod {
    CASH, CARD, COD, TRANSFER, WALLET, INSTALLMENT,
}

enum class PaymentStatus {
    unpaid, pending_confirmation, paid, partial,
}

data class OrderLine(
    val variantId: UUID,
    val productId: UUID,
    val qty: Int,
    val unitPrice: BigDecimal,
    val discount: BigDecimal = BigDecimal.ZERO,
    val net: BigDecimal = unitPrice.multiply(qty.toBigDecimal()),
    val appliedPromoCodes: List<String> = emptyList(),
    val isGift: Boolean = false,
    val isCustom: Boolean = false,
    val customSpec: String? = null,
)

data class Order(
    val id: UUID? = null,
    val branchId: UUID? = null,
    val customerId: UUID? = null,
    val guestPhone: String? = null,
    val channel: String = "pos",
    val status: OrderStatus = OrderStatus.draft,
    val paymentMethod: PaymentMethod? = null,
    val paymentStatus: PaymentStatus = PaymentStatus.unpaid,
    val subtotal: BigDecimal = BigDecimal.ZERO,
    val discountTotal: BigDecimal = BigDecimal.ZERO,
    val deliveryFee: BigDecimal = BigDecimal.ZERO,
    val carryUpFee: BigDecimal = BigDecimal.ZERO,
    val grandTotal: BigDecimal = BigDecimal.ZERO,
    val paidAmount: BigDecimal = BigDecimal.ZERO,
    val deliveryZoneId: UUID? = null,
    val floorNumber: Int? = null,
    val collectFromBranch: Boolean = false,
    val trackingNumber: String? = null,
    val salesRepId: UUID? = null,
    val lines: List<OrderLine> = emptyList(),
)
