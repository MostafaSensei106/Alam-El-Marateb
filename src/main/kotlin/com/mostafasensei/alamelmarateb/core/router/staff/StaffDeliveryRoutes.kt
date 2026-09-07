package com.mostafasensei.alamelmarateb.core.router.staff

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object StaffDeliveryRoutes {
    private const val PREFIX = "${ApiVersion.V1}/staff/delivery"

    const val BASE = PREFIX
    const val MY_TRIPS = "/my-trips"
    const val TRIP_STOPS = "/trips/{tripId}/stops"
    const val UPDATE_STOP_STATUS = "/stops/{stopId}/status"
    const val CONFIRM_DELIVER = "/orders/{orderId}"
    const val REPORT_FAILED_DELIVERY = "/orders/{orderId}/failed"
}