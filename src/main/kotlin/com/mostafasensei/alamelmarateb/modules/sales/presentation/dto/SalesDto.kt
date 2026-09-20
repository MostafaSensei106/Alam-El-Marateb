package com.mostafasensei.alamelmarateb.modules.sales.presentation.dto

import com.mostafasensei.alamelmarateb.modules.sales.application.BundleItemInput
import com.mostafasensei.alamelmarateb.modules.sales.application.PromotionInput
import com.mostafasensei.alamelmarateb.modules.sales.application.PromotionView
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.Order
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentMethod
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.LineResult
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.PricePreview
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.PromoType
import jakarta.validation.Valid
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Positive
import jakarta.validation.constraints.PositiveOrZero
import java.math.BigDecimal
import java.time.Instant
import java.time.LocalDate
import java.util.UUID

// ---------- promotions ----------

data class BundleItemRequest(
    val productId: UUID? = null,
    val variantId: UUID? = null,
    @field:Positive val requiredQty: Int = 1,
)

data class PromotionCreateRequest(
    @field:NotBlank val code: String,
    @field:NotBlank val name: String,
    @field:NotNull val type: PromoType,
    @field:Positive val valuePercent: BigDecimal? = null,
    @field:PositiveOrZero val valueAmount: BigDecimal? = null,
    @field:PositiveOrZero val bundlePrice: BigDecimal? = null,
    val targetProductId: UUID? = null,
    val targetVariantId: UUID? = null,
    @field:Valid val bundleItems: List<BundleItemRequest> = emptyList(),
    val giftVariantId: UUID? = null,
    val giftProductId: UUID? = null,
    @field:Positive val giftQty: Int = 1,
    @field:PositiveOrZero val minCartTotal: BigDecimal? = null,
    val startsAt: Instant? = null,
    val endsAt: Instant? = null,
    @field:Positive val maxUses: Int? = null,
    val exclusive: Boolean = false,
) {
    fun toInput() = PromotionInput(
        code, name, type, valuePercent, valueAmount, bundlePrice,
        targetProductId, targetVariantId,
        bundleItems.map { BundleItemInput(it.productId, it.variantId, it.requiredQty) },
        giftVariantId, giftProductId, giftQty, minCartTotal, startsAt, endsAt, maxUses, exclusive,
    )
}

// ---------- checkout ----------

data class CheckoutLineRequest(
    @field:NotNull val variantId: UUID,
    @field:Positive val qty: Int,
)

data class PricePreviewRequest(
    @field:Valid @field:NotNull val lines: List<CheckoutLineRequest>,
)

data class LineResultResponse(
    val productId: UUID,
    val variantId: UUID?,
    val qty: Int,
    val unitPrice: BigDecimal,
    val gross: BigDecimal,
    val discount: BigDecimal,
    val net: BigDecimal,
    val appliedCodes: List<String>,
    val isGift: Boolean,
)

data class PricePreviewResponse(
    val lines: List<LineResultResponse>,
    val subtotal: BigDecimal,
    val totalDiscount: BigDecimal,
    val total: BigDecimal,
    val appliedCodes: List<String>,
) {
    companion object {
        fun fromDomain(preview: PricePreview): PricePreviewResponse =
            PricePreviewResponse(
                lines = preview.lines.map { l: LineResult ->
                    LineResultResponse(
                        l.productId, l.variantId, l.qty, l.unitPrice, l.gross,
                        l.discount, l.net, l.appliedCodes, l.isGift,
                    )
                },
                subtotal = preview.subtotal,
                totalDiscount = preview.totalDiscount,
                total = preview.total,
                appliedCodes = preview.appliedCodes,
            )
    }
}

data class EstimateRequest(
    @field:NotBlank val governorate: String,
    @field:NotBlank val area: String,
    @field:PositiveOrZero val floor: Int? = null,
)

data class EstimateResponse(val deliveryFee: BigDecimal, val carryUpFee: BigDecimal)

// ---------- orders ----------

data class OrderLineRequest(
    @field:NotNull val variantId: UUID,
    @field:Positive val qty: Int,
)

data class PlaceOrderRequest(
    @field:NotNull val branchId: UUID,
    val customerId: UUID? = null,
    val guestPhone: String? = null,
    @field:Valid @field:NotNull val items: List<OrderLineRequest>,
    @field:NotNull val paymentMethod: PaymentMethod,
    val deliveryZoneId: UUID? = null,
    val floorNumber: Int? = null,
    val collectFromBranch: Boolean = false,
    val salesRepId: UUID? = null,
    val idempotencyKey: String? = null,
    @field:PositiveOrZero val downPayment: BigDecimal? = null,
    @field:Positive val months: Int? = null,
)

data class CompleteDraftRequest(
    @field:NotNull val paymentMethod: PaymentMethod,
    val deliveryZoneId: UUID? = null,
    val floorNumber: Int? = null,
    val collectFromBranch: Boolean = false,
    @field:PositiveOrZero val downPayment: BigDecimal? = null,
    @field:Positive val months: Int? = null,
)

data class OrderLineResponse(
    val variantId: UUID,
    val qty: Int,
    val unitPrice: BigDecimal,
    val discount: BigDecimal,
    val net: BigDecimal,
    val appliedPromoCodes: List<String>,
    val isGift: Boolean,
)

data class OrderResponse(
    val id: UUID?,
    val status: String,
    val channel: String,
    val paymentMethod: String?,
    val paymentStatus: String,
    val subtotal: BigDecimal,
    val discountTotal: BigDecimal,
    val deliveryFee: BigDecimal,
    val carryUpFee: BigDecimal,
    val grandTotal: BigDecimal,
    val trackingNumber: String?,
    val lines: List<OrderLineResponse>,
) {
    companion object {
        fun fromDomain(order: Order): OrderResponse = OrderResponse(
            id = order.id, status = order.status.name, channel = order.channel,
            paymentMethod = order.paymentMethod?.name, paymentStatus = order.paymentStatus.name,
            subtotal = order.subtotal, discountTotal = order.discountTotal,
            deliveryFee = order.deliveryFee, carryUpFee = order.carryUpFee,
            grandTotal = order.grandTotal, trackingNumber = order.trackingNumber,
            lines = order.lines.map {
                OrderLineResponse(
                    it.variantId, it.qty, it.unitPrice, it.discount, it.net,
                    it.appliedPromoCodes, it.isGift,
                )
            },
        )
    }
}

data class ReturnRequest(
    @field:NotBlank val reason: String,
    @field:Valid @field:NotNull val lines: List<OrderLineRequest>,
)

data class ReservationRequest(
    @field:NotNull val branchId: UUID,
    val customerId: UUID? = null,
    val guestPhone: String? = null,
    @field:NotNull val variantId: UUID,
    @field:Positive val qty: Int,
    @field:PositiveOrZero val deposit: BigDecimal = BigDecimal.ZERO,
    val deliverAt: LocalDate? = null,
)

// ---------- cart ----------

data class CartItemRequest(
    @field:NotNull val variantId: UUID,
    @field:Positive val qty: Int,
)

data class CartSetQtyRequest(
    @field:NotNull val variantId: UUID,
    @field:PositiveOrZero val qty: Int,
)

data class CartMergeRequest(
    @field:NotBlank val guestKey: String,
)

data class ShiftOpenRequest(
    @field:NotNull val branchId: UUID,
    @field:PositiveOrZero val openingBalance: BigDecimal = BigDecimal.ZERO,
)

data class ShiftDropRequest(
    @field:NotNull val shiftId: UUID,
    @field:Positive val amount: BigDecimal,
)

data class ShiftCloseRequest(
    @field:NotNull val shiftId: UUID,
    @field:PositiveOrZero val actualCash: BigDecimal,
)
