package com.mostafasensei.alamelmarateb.core.router

/**
 * Delivery routes — owning module: delivery.
 * Audience: delivery drivers (trips, stops, proof of delivery).
 * Required roles: DELIVERY_DRIVER, SUPER_ADMIN.
 */
object DeliveryRoutes {
    private const val PREFIX = "/api/v1/delivery"

    const val BASE = PREFIX
    const val MY_TRIPS = "$PREFIX/my-trips"
    const val TRIP_STOPS = "$PREFIX/trips/{tripId}/stops"
    const val UPDATE_STOP_STATUS = "$PREFIX/stops/{stopId}/status"
    const val CONFIRM_DELIVER = "$PREFIX/orders/{orderId}"
    const val REPORT_FAILED_DELIVERY = "$PREFIX/orders/{orderId}/failed"

    const val TRIPS = "$PREFIX/trips"
    const val TRIP_DISPATCH = "$PREFIX/trips/{tripId}/dispatch"
    const val TRIP_CANCEL = "$PREFIX/trips/{tripId}/cancel"
    const val TRIP_COMPLETE = "$PREFIX/trips/{tripId}/complete"
}
