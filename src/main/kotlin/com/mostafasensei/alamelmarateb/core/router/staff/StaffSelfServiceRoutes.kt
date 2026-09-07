package com.mostafasensei.alamelmarateb.core.router.staff

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object StaffSelfServiceRoutes {
    private const val PREFIX = "${ApiVersion.V1}/staff/me"

    const val BASE = PREFIX
    const val CLOCK_IN = "/attendance/clock-in"
    const val CLOCK_OUT = "/attendance/clock-out"
    const val REQUEST_LEAVE = "/leaves/request"
    const val MY_COMMISSIONS = "/commissions"
    const val MY_PAYSLIPS = "/payslips"
}