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
}
