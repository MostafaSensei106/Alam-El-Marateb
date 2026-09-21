package com.mostafasensei.alamelmarateb.core.router

/**
 * POS + order-fulfillment routes — owning module: sales.
 * Audience: branch staff (in-store selling, returns, receipts, cash shifts).
 * Required roles: CASHIER, BRANCH_MANAGER, SUPER_ADMIN.
 */
object SalesPosRoutes {
    private const val POS = "/api/v1/sales/pos"

    const val BASE = POS
    const val SCAN = "$POS/scan/{barcode}"
    const val DRAFT_ORDER = "$POS/orders/draft"
    const val COMPLETE_SALE = "$POS/complete-sale"
    const val PLACE_ORDER = "$POS/place-order"
    const val CUSTOM_ORDER = "$POS/custom-order"
    const val RECEIPT = "$POS/orders/{orderId}/receipt"
    const val INVOICE_PDF = "$POS/orders/{orderId}/invoice-pdf"
    const val RETURN = "$POS/orders/{orderId}/return"

    const val SHIFT_CURRENT = "$POS/drawer/shift/current"
    const val SHIFT_OPEN = "$POS/drawer/shift/open"
    const val SHIFT_CLOSE = "$POS/drawer/shift/close"
    const val SHIFT_DROP_CASH = "$POS/drawer/shift/drop"

    const val RESERVATIONS = "$POS/reservations"
    const val RESERVATION_BY_ID = "$POS/reservations/{id}"
    const val RESERVATION_PAY = "$POS/reservations/{id}/pay"
    const val RESERVATION_FULFILL = "$POS/reservations/{id}/fulfill"
    const val RESERVATION_CANCEL = "$POS/reservations/{id}/cancel"

    private const val ORDERS = "/api/v1/sales/orders"

    const val ORDER_LIST = ORDERS
    const val ORDER_BY_ID = "$ORDERS/{orderId}"
    const val ORDER_PAY_BALANCE = "$ORDERS/{orderId}/pay-balance"
}
