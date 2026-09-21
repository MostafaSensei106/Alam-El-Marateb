package com.mostafasensei.alamelmarateb.core.router

/**
 * Customer shop routes — owning module: sales.
 * Audience: end customers (website / app buyers).
 * Required roles: CUSTOMER, SUPER_ADMIN.
 * Staff must NOT use these — they have SalesPosRoutes.
 */
object ShopRoutes {
    private const val CART = "/api/v1/shop/cart"

    const val CART_BASE = CART
    const val CART_ITEMS = "$CART/items"
    const val CART_ITEM_BY_ID = "$CART/items/{itemId}"
    const val CART_MERGE = "$CART/merge"
    const val CART_CLEAR = "$CART/clear"
    const val CART_DRAFT = "$CART/draft"

    private const val CHECKOUT = "/api/v1/shop/checkout"

    const val CHECKOUT_BASE = CHECKOUT
    const val CHECKOUT_ESTIMATE_SHIPPING = "$CHECKOUT/estimate-shipping"
    const val CHECKOUT_PLACE_ORDER = "$CHECKOUT/place-order"
    const val CHECKOUT_PAYMENT_CALLBACK = "$CHECKOUT/payment-callback/{gateway}"

    private const val ORDERS = "/api/v1/shop/orders"

    const val MY_ORDERS = ORDERS
    const val MY_ORDER_BY_ID = "$ORDERS/{orderId}"
    const val TRACK_ORDER = "$ORDERS/track/{orderTrackingNumber}"
}
