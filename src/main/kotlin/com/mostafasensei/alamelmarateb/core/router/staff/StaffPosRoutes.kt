package com.mostafasensei.alamelmarateb.core.router.staff

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object StaffPosRoutes {
    private const val PREFIX = "${ApiVersion.V1}/staff/pos"

    const val BASE = PREFIX
    const val SCAN = "/scan/{barcode}"
    const val COMPLETE_SALE = "/complete-sale"
    const val RECEIPT = "/orders/{orderId}/receipt"
    const val INVOICE_PDF = "/orders/{orderId}/invoice-pdf"
    const val RETURN_ORDER = "/orders/{orderId}/returns"
    const val CASH_DRAWER_SHIFT = "/cash-drawer/shift"
}