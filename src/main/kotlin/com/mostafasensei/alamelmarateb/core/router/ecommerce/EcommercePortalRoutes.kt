package com.mostafasensei.alamelmarateb.core.router.ecommerce

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object EcommercePortalRoutes {
    private const val PREFIX = "${ApiVersion.V1}/ecommerce/portal"

    const val BASE = PREFIX
    const val MY_ORDERS = "/orders"
    const val ORDER_BY_ID = "/orders/{orderId}"
    const val ADDRESSES = "/addresses"
    const val ADDRESS_BY_ID = "/addresses/{addressId}"
    const val WARRANTY_REGISTER = "/warranty/register"
    const val WARRANTY_VERIFY = "/warranty/verify/{serialNumber}"
    const val WARRANTY_CLAIMS = "/warranty/claims"

}