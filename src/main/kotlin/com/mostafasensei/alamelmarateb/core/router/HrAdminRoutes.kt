package com.mostafasensei.alamelmarateb.core.router

/**
 * HR MANAGEMENT routes — owning module: hr.
 * Audience: branch managers (people management, payroll approval).
 * Required roles: BRANCH_MANAGER, SUPER_ADMIN.
 * Employees must use SelfServiceRoutes for their own data.
 */
object HrAdminRoutes {
    private const val PREFIX = "/api/v1/hr"

    const val EMPLOYEES = "$PREFIX/employees"
    const val EMPLOYEE_BY_ID = "$PREFIX/employees/{id}"
    const val EMPLOYEE_SEARCH = "$PREFIX/employees/search"

    const val ATTENDANCE_LOGS = "$PREFIX/attendance/logs"

    const val LEAVES = "$PREFIX/leaves"
    const val LEAVE_ACTION = "$PREFIX/leaves/{id}/action"

    const val COMMISSION_RULES = "$PREFIX/commissions/rules"

    const val ADVANCES = "$PREFIX/advances"
    const val DEDUCTIONS = "$PREFIX/deductions"

    const val PAYROLL_CALCULATE = "$PREFIX/payroll/calculate"
    const val PAYROLL_APPROVE = "$PREFIX/payroll/{id}/approve"
    const val PAYROLL_EXPORT_EXCEL = "$PREFIX/payroll/{id}/export-excel"
}
