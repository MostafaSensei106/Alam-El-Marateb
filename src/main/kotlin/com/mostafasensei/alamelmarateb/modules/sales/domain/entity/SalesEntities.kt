package com.mostafasensei.alamelmarateb.modules.sales.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.CascadeType
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.JoinColumn
import jakarta.persistence.ManyToOne
import jakarta.persistence.OneToMany
import jakarta.persistence.Table
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID

@Entity
@Table(name = "promotions")
class PromotionJpaEntity(
    @Column(name = "code", nullable = false, unique = true, length = 60)
    var code: String = "",

    @Column(name = "name", nullable = false, length = 150)
    var name: String = "",

    @Column(name = "promo_type", nullable = false, length = 20)
    var promoType: String = "",

    @Column(name = "value_percent", precision = 5, scale = 2)
    var valuePercent: BigDecimal? = null,

    @Column(name = "value_amount", precision = 12, scale = 2)
    var valueAmount: BigDecimal? = null,

    @Column(name = "bundle_price", precision = 12, scale = 2)
    var bundlePrice: BigDecimal? = null,

    @Column(name = "target_product_id", columnDefinition = "UUID")
    var targetProductId: UUID? = null,

    @Column(name = "target_variant_id", columnDefinition = "UUID")
    var targetVariantId: UUID? = null,

    @Column(name = "min_cart_total", precision = 12, scale = 2)
    var minCartTotal: BigDecimal? = null,

    @Column(name = "starts_at")
    var startsAt: java.time.Instant? = null,

    @Column(name = "ends_at")
    var endsAt: java.time.Instant? = null,

    @Column(name = "max_uses")
    var maxUses: Int? = null,

    @Column(name = "used_count", nullable = false)
    var usedCount: Int = 0,

    @Column(name = "exclusive", nullable = false)
    var exclusive: Boolean = false,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,

    @OneToMany(mappedBy = "promotion", cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    var bundleItems: MutableList<PromotionBundleItemJpaEntity> = mutableListOf(),
) : EntityBase<UUID>()

@Entity
@Table(name = "promotion_bundle_items")
class PromotionBundleItemJpaEntity(
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "promotion_id", nullable = false)
    var promotion: PromotionJpaEntity? = null,

    @Column(name = "product_id", columnDefinition = "UUID")
    var productId: UUID? = null,

    @Column(name = "variant_id", columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "required_qty", nullable = false)
    var requiredQty: Int = 1,
) : EntityBase<UUID>()

@Entity
@Table(name = "orders")
class OrderJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "customer_id", columnDefinition = "UUID")
    var customerId: UUID? = null,

    @Column(name = "guest_phone", length = 20)
    var guestPhone: String? = null,

    @Column(name = "channel", nullable = false, length = 10)
    var channel: String = "pos",

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "draft",

    @Column(name = "payment_method", length = 20)
    var paymentMethod: String? = null,

    @Column(name = "payment_status", nullable = false, length = 20)
    var paymentStatus: String = "unpaid",

    @Column(name = "subtotal", nullable = false, precision = 12, scale = 2)
    var subtotal: BigDecimal = BigDecimal.ZERO,

    @Column(name = "discount_total", nullable = false, precision = 12, scale = 2)
    var discountTotal: BigDecimal = BigDecimal.ZERO,

    @Column(name = "delivery_fee", nullable = false, precision = 12, scale = 2)
    var deliveryFee: BigDecimal = BigDecimal.ZERO,

    @Column(name = "carry_up_fee", nullable = false, precision = 12, scale = 2)
    var carryUpFee: BigDecimal = BigDecimal.ZERO,

    @Column(name = "grand_total", nullable = false, precision = 12, scale = 2)
    var grandTotal: BigDecimal = BigDecimal.ZERO,

    @Column(name = "delivery_zone_id", columnDefinition = "UUID")
    var deliveryZoneId: UUID? = null,

    @Column(name = "floor_number")
    var floorNumber: Int? = null,

    @Column(name = "collect_from_branch", nullable = false)
    var collectFromBranch: Boolean = false,

    @Column(name = "tracking_number", unique = true, length = 60)
    var trackingNumber: String? = null,

    @Column(name = "idempotency_key", unique = true, length = 100)
    var idempotencyKey: String? = null,

    @Column(name = "sales_rep_id", columnDefinition = "UUID")
    var salesRepId: UUID? = null,

    @OneToMany(mappedBy = "order", cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    var lines: MutableList<OrderItemJpaEntity> = mutableListOf(),
) : EntityBase<UUID>()

@Entity
@Table(name = "order_items")
class OrderItemJpaEntity(
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    var order: OrderJpaEntity? = null,

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "qty", nullable = false)
    var qty: Int = 0,

    @Column(name = "unit_price", nullable = false, precision = 12, scale = 2)
    var unitPrice: BigDecimal = BigDecimal.ZERO,

    @Column(name = "discount", nullable = false, precision = 12, scale = 2)
    var discount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "net", nullable = false, precision = 12, scale = 2)
    var net: BigDecimal = BigDecimal.ZERO,

    @Column(name = "applied_promo_codes")
    var appliedPromoCodes: String = "",

    @Column(name = "is_gift", nullable = false)
    var isGift: Boolean = false,
) : EntityBase<UUID>()

@Entity
@Table(name = "invoices")
class InvoiceJpaEntity(
    @Column(name = "order_id", nullable = false, unique = true, columnDefinition = "UUID")
    var orderId: UUID? = null,

    @Column(name = "serial", nullable = false, unique = true, length = 60)
    var serial: String = "",

    @Column(name = "pdf_path", columnDefinition = "TEXT")
    var pdfPath: String? = null,

    @Column(name = "issued_at", nullable = false)
    var issuedAt: java.time.Instant = java.time.Instant.now(),
) : EntityBase<UUID>()

@Entity
@Table(name = "returns")
class ReturnJpaEntity(
    @Column(name = "order_id", nullable = false, columnDefinition = "UUID")
    var orderId: UUID? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "requested",

    @Column(name = "reason", nullable = false, columnDefinition = "TEXT")
    var reason: String = "",

    @Column(name = "refund_amount", nullable = false, precision = 12, scale = 2)
    var refundAmount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "refund_method", length = 20)
    var refundMethod: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "reservations")
class ReservationJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "customer_id", columnDefinition = "UUID")
    var customerId: UUID? = null,

    @Column(name = "guest_phone", length = 20)
    var guestPhone: String? = null,

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "qty", nullable = false)
    var qty: Int = 0,

    @Column(name = "deposit", nullable = false, precision = 12, scale = 2)
    var deposit: BigDecimal = BigDecimal.ZERO,

    @Column(name = "deliver_at")
    var deliverAt: LocalDate? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "active",
) : EntityBase<UUID>()

@Entity
@Table(name = "installment_plans")
class InstallmentPlanJpaEntity(
    @Column(name = "order_id", nullable = false, columnDefinition = "UUID")
    var orderId: UUID? = null,

    @Column(name = "total", nullable = false, precision = 12, scale = 2)
    var total: BigDecimal = BigDecimal.ZERO,

    @Column(name = "down_payment", nullable = false, precision = 12, scale = 2)
    var downPayment: BigDecimal = BigDecimal.ZERO,

    @Column(name = "months", nullable = false)
    var months: Int = 0,

    @Column(name = "monthly_amount", nullable = false, precision = 12, scale = 2)
    var monthlyAmount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "active",

    @OneToMany(mappedBy = "plan", cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    var installments: MutableList<InstallmentJpaEntity> = mutableListOf(),
) : EntityBase<UUID>()

@Entity
@Table(name = "installments")
class InstallmentJpaEntity(
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "plan_id", nullable = false)
    var plan: InstallmentPlanJpaEntity? = null,

    @Column(name = "due_date", nullable = false)
    var dueDate: LocalDate? = null,

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "paid_amount", nullable = false, precision = 12, scale = 2)
    var paidAmount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "pending",
) : EntityBase<UUID>()

@Entity
@Table(name = "cash_shifts")
class CashShiftJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "cashier_id", columnDefinition = "UUID")
    var cashierId: UUID? = null,

    @Column(name = "opening_balance", nullable = false, precision = 12, scale = 2)
    var openingBalance: BigDecimal = BigDecimal.ZERO,

    @Column(name = "closed_at")
    var closedAt: java.time.Instant? = null,

    @Column(name = "expected_cash", precision = 12, scale = 2)
    var expectedCash: BigDecimal? = null,

    @Column(name = "actual_cash", precision = 12, scale = 2)
    var actualCash: BigDecimal? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "open",
) : EntityBase<UUID>()

@Entity
@Table(name = "carts")
class CartJpaEntity(
    @Column(name = "customer_id", columnDefinition = "UUID")
    var customerId: UUID? = null,

    @Column(name = "guest_key", length = 100)
    var guestKey: String? = null,

    @OneToMany(mappedBy = "cart", cascade = [CascadeType.ALL], fetch = FetchType.LAZY, orphanRemoval = true)
    var items: MutableList<CartItemJpaEntity> = mutableListOf(),
) : EntityBase<UUID>()

@Entity
@Table(name = "cart_items")
class CartItemJpaEntity(
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cart_id", nullable = false)
    var cart: CartJpaEntity? = null,

    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "qty", nullable = false)
    var qty: Int = 0,
) : EntityBase<UUID>()

// Owned by delivery module later; needed now for shipping estimates.
@Entity
@Table(name = "delivery_zones")
class DeliveryZoneJpaEntity(
    @Column(name = "governorate", nullable = false, length = 100)
    var governorate: String = "",

    @Column(name = "area", nullable = false, length = 150)
    var area: String = "",

    @Column(name = "fee", nullable = false, precision = 12, scale = 2)
    var fee: BigDecimal = BigDecimal.ZERO,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,
) : EntityBase<UUID>()

@Entity
@Table(name = "carry_up_fees")
class CarryUpFeeJpaEntity(
    @Column(name = "floor_from", nullable = false)
    var floorFrom: Int = 0,

    @Column(name = "floor_to", nullable = false)
    var floorTo: Int = 0,

    @Column(name = "fee", nullable = false, precision = 12, scale = 2)
    var fee: BigDecimal = BigDecimal.ZERO,
) : EntityBase<UUID>()

@Entity
@Table(name = "cash_drops")
class CashDropJpaEntity(
    @jakarta.persistence.Id
    @jakarta.persistence.GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID? = null,

    @Column(name = "shift_id", nullable = false, columnDefinition = "UUID")
    var shiftId: UUID? = null,

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "created_at", nullable = false, updatable = false, insertable = false)
    var createdAt: java.time.Instant? = null,

    @Column(name = "created_by", length = 100)
    var createdBy: String? = null,
)
