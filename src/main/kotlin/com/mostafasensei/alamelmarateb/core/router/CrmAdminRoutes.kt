package com.mostafasensei.alamelmarateb.core.router

/**
 * CRM MANAGEMENT routes — owning module: crm.
 * Audience: backoffice staff (customer records, warranty + claim handling).
 * Required roles: BRANCH_MANAGER, SUPER_ADMIN.
 */
object CrmAdminRoutes {
    private const val PREFIX = "/api/v1/crm"

    const val BASE = PREFIX
    const val CUSTOMERS = "$PREFIX/customers"
    const val CUSTOMER_BY_ID = "$PREFIX/customers/{id}"

    const val WARRANTIES = "$PREFIX/warranties"
    const val WARRANTY_BY_SERIAL = "$PREFIX/warranties/{serialNumber}"

    const val CLAIMS = "$PREFIX/claims"
    const val CLAIM_BY_ID = "$PREFIX/claims/{claimId}"
    const val SCHEDULE_INSPECTION = "$PREFIX/claims/{claimId}/inspection"
    const val RESOLVE_REPLACE = "$PREFIX/claims/{claimId}/replace"
    const val RESOLVE_REPAIR = "$PREFIX/claims/{claimId}/repair"
}
