package com.mostafasensei.alamelmarateb.core.router

/**
 * CRM MANAGEMENT routes — owning module: crm.
 * Audience: backoffice staff (customer records, warranty + claim handling).
 * Required roles: BRANCH_MANAGER, SUPER_ADMIN.
 */
object CrmAdminRoutes {
    private const val PREFIX = "/api/v1/crm"

    const val BASE = PREFIX

    const val WARRANTY_REGISTER = "$PREFIX/warranties/register"
    const val WARRANTY_BY_ID = "$PREFIX/warranties/{warrantyId}"
    const val WARRANTY_CLAIMS = "$PREFIX/warranties/{warrantyId}/claims"

    const val SCHEDULE_INSPECTION = "$PREFIX/claims/{claimId}/inspection"
    const val RESOLVE_CLAIM = "$PREFIX/claims/{claimId}/resolve"
    const val CLOSE_CLAIM = "$PREFIX/claims/{claimId}/close"

    const val REVIEW_MODERATE = "$PREFIX/reviews/{id}/moderate"
}
