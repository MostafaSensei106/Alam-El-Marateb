package com.mostafasensei.alamelmarateb.core.router.staff

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object StaffPosRoutes {
    private const val PREFIX = "${ApiVersion.V1}/staff/pos"

    const val BASE = PREFIX
    const val SCAN = "/scan/{barcode}"
    const val DRAFT_ORDER= "/orders/draft"
    const val COMPLETE_SALE = "/complete-sale"
    const val PLACE_ORDER = "/place-order"
    const val CUSTOM_ORDER = "/custom-order"
    const val PRINT_RECEIPT = "/orders/{orderId}/receipt"
    const val PRINT_INVOICE = "/orders/{orderId}/invoice-pdf"
    const val PROCESS_RETURN = "/orders/{orderId}/return"

    const val SHIFT_CURRENT = "/drawer/shift/current"
    const val SHIFT_OPEN = "/drawer/shift/open"
    const val SHIFT_CLOSE = "/drawer/shift/close"
    const val SHIFT_DROP_CASH = "/drawer/shift/drop"
}