package com.mostafasensei.alamelmarateb.core.router.staff

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object StaffWarehouseRoutes {
    private const val PREFIX = "${ApiVersion.V1}/staff/warehouse"

    const val BASE = PREFIX
    const val STOCK_LOOKUP = "/stocks/lookup/{barcodeOrSku}"

    const val QUICK_ADJUSTMENT = "/stocks/adjustment"
    const val TRANSFERS_PENDING = "/transfers/pending"
    const val TRANSFER_CONFIRM = "/transfers/{transferId}/confirm-receipt"
    const val AUDIT_SUBMIT_COUNT = "/audits/{auditId}/count"


}