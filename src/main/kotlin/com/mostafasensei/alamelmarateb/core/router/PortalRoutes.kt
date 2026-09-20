package com.mostafasensei.alamelmarateb.core.router

/**
 * Customer self-service portal — owning module: crm.
 * Audience: end customers managing their own data only.
 * Required roles: CUSTOMER, SUPER_ADMIN.
 */
object PortalRoutes {
    private const val PREFIX = "/api/v1/portal"

    const val BASE = PREFIX
    const val ADDRESSES = "$PREFIX/addresses"
    const val ADDRESS_BY_ID = "$PREFIX/addresses/{addressId}"

    const val WARRANTY_REGISTER = "$PREFIX/warranties/register"
    const val WARRANTY_VERIFY = "$PREFIX/warranties/verify/{serialNumber}"
    const val WARRANTY_CLAIMS = "$PREFIX/warranties/claims"

    const val REVIEWS = "$PREFIX/reviews"
}
