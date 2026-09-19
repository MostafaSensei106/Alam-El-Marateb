package com.mostafasensei.alamelmarateb.core.router

/**
 * Staff SELF-SERVICE routes — owning module: hr.
 * Audience: every authenticated employee, scoped to their OWN record only.
 * Access: authenticated (any staff role). No management data exposed here.
 */
object SelfServiceRoutes {
    private const val PREFIX = "/api/v1/me"

    const val BASE = PREFIX
    const val CLOCK_IN = "$PREFIX/attendance/clock-in"
    const val CLOCK_OUT = "$PREFIX/attendance/clock-out"
    const val REQUEST_LEAVE = "$PREFIX/leaves/request"
    const val MY_COMMISSIONS = "$PREFIX/commissions"
    const val MY_PAYSLIPS = "$PREFIX/payslips"
}
