package com.mostafasensei.alamelmarateb.core.router.dashboard

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object DashboardHrRoutes {
    private const val PREFIX = "${ApiVersion.V1}/dashboard/hr"

    const val BASE = PREFIX
    const val EMPLOYEES = "/employees"
    const val SEARCH = "/search"
    const val BY_ID = "/{id}"
    const val ATTENDANCE = "/attendance"
    const val LEAVES = "/leaves"
    const val LEAVE_ACTION = "/leaves/{id}/action"
    const val PAYROLL_CALCULATE = "/payroll/calculate"
    const val PAYROLL_EXPORT_EXCEL = "/payroll/export-excel"
}