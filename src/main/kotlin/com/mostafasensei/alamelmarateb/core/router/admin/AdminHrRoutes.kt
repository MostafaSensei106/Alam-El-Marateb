package com.mostafasensei.alamelmarateb.core.router.admin

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object AdminHrRoutes {
    private const val PREFIX = "${ApiVersion.V1}/admin/hr"

    const val BASE = PREFIX
    const val EMPLOYEES = "/employees"
    const val EMPLOYEE_BY_ID = "/employees/{id}"
    const val ATTENDANCE_LOGS = "/attendance/logs"
    const val LEAVE_MANAGEMENT = "/leaves"
    const val LEAVE_ACTION = "/leaves/{id}/action"
    const val COMMISSION_RULES = "/commissions/rules"
    const val ADVANCES = "/advances"
    const val DEDUCTIONS = "/deductions"
    const val PAYROLL_CALCULATE = "/payroll/calculate"
    const val PAYROLL_APPROVE = "/payroll/{id}/approve"
    const val PAYROLL_EXPORT_EXCEL = "/payroll/{id}/export-excel"
}