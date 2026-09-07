package com.mostafasensei.alamelmarateb.core.router.admin

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object AdminCrmRoutes {
    private const val PREFIX = "${ApiVersion.V1}/admin/crm"

    const val BASE = PREFIX
    const val CUSTOMERS = "/customers"
    const val CUSTOMER_BY_ID = "/customers/{id}"
    const val WARRANTIES = "/warranties"
    const val WARRANTY_BY_SERIAL = "/warranties/{serialNumber}"
    const val CLAIMS = "/claims"
    const val CLAIM_BY_ID = "/claims/{claimId}"
    const val SCHEDULE_INSPECTION = "/claims/{claimId}/inspection"
    const val RESOLVE_REPLACE = "/claims/{claimId}/replace"
    const val RESOLVE_REPAIR = "/claims/{claimId}/repair"

}