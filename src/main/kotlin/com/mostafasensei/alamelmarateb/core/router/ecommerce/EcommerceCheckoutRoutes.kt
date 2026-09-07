package com.mostafasensei.alamelmarateb.core.router.ecommerce

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object EcommerceCheckoutRoutes {
    private const val PREFIX = "${ApiVersion.V1}/ecommerce/checkout"

    const val BASE = PREFIX
    const val ESTIMATE_SHIPPING = "/estimate-shipping"
    const val PLACE_ORDER = "/place-order"
    const val PAYMENT_CALLBACK = "/payment-callback/{gateway}"
    const val TRACK_ORDER = "/track/{orderTrackingNumber}"
}