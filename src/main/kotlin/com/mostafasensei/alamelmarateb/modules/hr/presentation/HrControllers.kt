package com.mostafasensei.alamelmarateb.modules.hr.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.router.HrAdminRoutes
import com.mostafasensei.alamelmarateb.core.router.SelfServiceRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.hr.application.AdvanceView
import com.mostafasensei.alamelmarateb.modules.hr.application.CommissionRuleView
import com.mostafasensei.alamelmarateb.modules.hr.application.DeductionView
import com.mostafasensei.alamelmarateb.modules.hr.application.EmployeeView
import com.mostafasensei.alamelmarateb.modules.hr.application.HrService
import com.mostafasensei.alamelmarateb.modules.hr.application.LeaveView
import com.mostafasensei.alamelmarateb.modules.hr.application.PayrollLineView
import com.mostafasensei.alamelmarateb.modules.hr.application.PayrollRunView
import com.mostafasensei.alamelmarateb.modules.hr.presentation.dto.AdvanceCreateRequest
import com.mostafasensei.alamelmarateb.modules.hr.presentation.dto.CommissionRuleRequest
import com.mostafasensei.alamelmarateb.modules.hr.presentation.dto.DeductionCreateRequest
import com.mostafasensei.alamelmarateb.modules.hr.presentation.dto.EmployeeCreateRequest
import com.mostafasensei.alamelmarateb.modules.hr.presentation.dto.EmployeeUpdateRequest
import com.mostafasensei.alamelmarateb.modules.hr.presentation.dto.LeaveActionRequest
import com.mostafasensei.alamelmarateb.modules.hr.presentation.dto.LeaveRequestBody
import com.mostafasensei.alamelmarateb.modules.hr.presentation.dto.PayrollCalculateRequest
import com.mostafasensei.alamelmarateb.modules.hr.presentation.dto.SelfLeaveRequestBody
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ContentDisposition
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.nio.charset.StandardCharsets
import java.util.UUID

/**
 * HR MANAGEMENT — /api/v1/hr/... Branch managers only.
 * All paths come from HrAdminRoutes; no literals here.
 */
@Tag(name = "HR (management)", description = "Employees, leaves, commissions, advances, deductions, payroll — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class HrAdminController(
    private val hrService: HrService,
) : BaseController() {

    @Operation(summary = "List employees")
    @GetMapping(HrAdminRoutes.EMPLOYEES)
    fun employees(@RequestParam(required = false) branchId: UUID?): ResponseEntity<ApiResponse<List<EmployeeView>>> =
        ok(hrService.listEmployees(branchId))

    @Operation(summary = "Create employee (links an existing user)")
    @PostMapping(HrAdminRoutes.EMPLOYEES)
    fun createEmployee(@Valid @RequestBody request: EmployeeCreateRequest): ResponseEntity<ApiResponse<EmployeeView>> =
        created(
            hrService.createEmployee(
                request.userId, request.branchId, request.jobTitle,
                request.hireDate, request.baseSalary, request.commissionRuleId,
            ),
        )

    @Operation(summary = "Get employee by id")
    @GetMapping(HrAdminRoutes.EMPLOYEE_BY_ID)
    fun employee(@PathVariable("id") id: UUID): ResponseEntity<ApiResponse<EmployeeView>> =
        ok(hrService.getEmployee(id))

    @Operation(summary = "Update employee")
    @PatchMapping(HrAdminRoutes.EMPLOYEE_BY_ID)
    fun patchUpdateEmployee(
        @PathVariable("id") id: UUID,
        @Valid @RequestBody request: EmployeeUpdateRequest,
    ): ResponseEntity<ApiResponse<EmployeeView>> =
        updateEmployee(id, request)

    @PutMapping(HrAdminRoutes.EMPLOYEE_BY_ID)
    fun updateEmployee(
        @PathVariable("id") id: UUID,
        @Valid @RequestBody request: EmployeeUpdateRequest,
    ): ResponseEntity<ApiResponse<EmployeeView>> =
        ok(
            hrService.updateEmployee(
                id, request.branchId, request.jobTitle, request.hireDate,
                request.baseSalary, request.commissionRuleId, request.isActive,
            ),
        )

    @Operation(summary = "Delete employee")
    @DeleteMapping(HrAdminRoutes.EMPLOYEE_BY_ID)
    fun deleteEmployee(@PathVariable("id") id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        hrService.deleteEmployee(id)
        return deleted(MessageService.t("success.deleted"))
    }

    @Operation(summary = "Search employees")
    @GetMapping(HrAdminRoutes.EMPLOYEE_SEARCH)
    fun searchEmployees(
        @RequestParam(required = false) branchId: UUID?,
        @RequestParam(required = false) q: String?,
    ): ResponseEntity<ApiResponse<List<EmployeeView>>> =
        ok(hrService.searchEmployees(branchId, q))

    @Operation(summary = "List leave requests")
    @GetMapping(HrAdminRoutes.LEAVES)
    fun leaves(@RequestParam(required = false) employeeId: UUID?): ResponseEntity<ApiResponse<List<LeaveView>>> =
        ok(hrService.listLeaves(employeeId))

    @Operation(summary = "Create leave request (on behalf of an employee)")
    @PostMapping(HrAdminRoutes.LEAVES)
    fun createLeave(@Valid @RequestBody request: LeaveRequestBody): ResponseEntity<ApiResponse<LeaveView>> =
        created(hrService.requestLeave(request.employeeId, request.type, request.fromDate, request.toDate, request.substitute))

    @Operation(summary = "Approve or reject a leave request")
    @PostMapping(HrAdminRoutes.LEAVE_ACTION)
    fun leaveAction(
        @PathVariable("id") id: UUID,
        @Valid @RequestBody request: LeaveActionRequest,
    ): ResponseEntity<ApiResponse<LeaveView>> =
        ok(hrService.leaveAction(id, request.action))

    @Operation(summary = "List commission rules")
    @GetMapping(HrAdminRoutes.COMMISSION_RULES)
    fun commissionRules(): ResponseEntity<ApiResponse<List<CommissionRuleView>>> =
        ok(hrService.listRules())

    @Operation(summary = "Create commission rule")
    @PostMapping(HrAdminRoutes.COMMISSION_RULES)
    fun createCommissionRule(@Valid @RequestBody request: CommissionRuleRequest): ResponseEntity<ApiResponse<CommissionRuleView>> =
        created(hrService.createRule(request.name, request.kind, request.value, request.appliesToCategory))

    @Operation(summary = "List advances")
    @GetMapping(HrAdminRoutes.ADVANCES)
    fun advances(@RequestParam(required = false) employeeId: UUID?): ResponseEntity<ApiResponse<List<AdvanceView>>> =
        ok(hrService.listAdvances(employeeId))

    @Operation(summary = "Grant advance")
    @PostMapping(HrAdminRoutes.ADVANCES)
    fun createAdvance(@Valid @RequestBody request: AdvanceCreateRequest): ResponseEntity<ApiResponse<AdvanceView>> =
        created(hrService.createAdvance(request.employeeId, request.amount))

    @Operation(summary = "List deductions")
    @GetMapping(HrAdminRoutes.DEDUCTIONS)
    fun deductions(@RequestParam(required = false) employeeId: UUID?): ResponseEntity<ApiResponse<List<DeductionView>>> =
        ok(hrService.listDeductions(employeeId))

    @Operation(summary = "Record deduction")
    @PostMapping(HrAdminRoutes.DEDUCTIONS)
    fun createDeduction(@Valid @RequestBody request: DeductionCreateRequest): ResponseEntity<ApiResponse<DeductionView>> =
        created(hrService.createDeduction(request.employeeId, request.amount, request.reason))

    @Operation(summary = "Calculate payroll for a branch month (creates or recomputes a draft run)")
    @PostMapping(HrAdminRoutes.PAYROLL_CALCULATE)
    fun calculatePayroll(@Valid @RequestBody request: PayrollCalculateRequest): ResponseEntity<ApiResponse<PayrollRunView>> =
        ok(hrService.calculate(request.branchId, request.month))

    @Operation(summary = "Approve a payroll run")
    @PostMapping(HrAdminRoutes.PAYROLL_APPROVE)
    fun approvePayroll(@PathVariable("id") id: UUID): ResponseEntity<ApiResponse<PayrollRunView>> =
        ok(hrService.approveRun(id))

    @Operation(summary = "Export payroll run as CSV")
    @GetMapping(HrAdminRoutes.PAYROLL_EXPORT_EXCEL)
    fun exportPayroll(@PathVariable("id") id: UUID): ResponseEntity<ByteArray> {
        val csv = hrService.exportCsv(id)
        val bytes = csv.toByteArray(StandardCharsets.UTF_8)
        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, ContentDisposition.attachment().filename("payroll-$id.csv").build().toString())
            .contentType(MediaType.parseMediaType("text/csv"))
            .body(bytes)
    }
}

/**
 * Staff SELF-SERVICE — /api/v1/me/... Any authenticated employee, own record only.
 * All paths come from SelfServiceRoutes; no literals here.
 */
@Tag(name = "Self service", description = "Leave requests, commissions, payslips — authenticated staff")
@RestController
@PreAuthorize("isAuthenticated()")
class SelfServiceController(
    private val hrService: HrService,
) : BaseController() {

    @Operation(summary = "Request leave (own record)")
    @PostMapping(SelfServiceRoutes.REQUEST_LEAVE)
    fun requestLeave(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: SelfLeaveRequestBody,
    ): ResponseEntity<ApiResponse<LeaveView>> {
        val employeeId = hrService.employeeIdForUser(principal?.id ?: throw BadCredentialsException("missing authentication"))
        return created(hrService.requestLeave(employeeId, request.type, request.fromDate, request.toDate, request.substitute))
    }

    @Operation(summary = "My commissions (payroll lines)")
    @GetMapping(SelfServiceRoutes.MY_COMMISSIONS)
    fun myCommissions(@AuthenticationPrincipal principal: UserPrincipal?): ResponseEntity<ApiResponse<List<PayrollLineView>>> =
        ok(hrService.myCommissions(principal?.id ?: throw BadCredentialsException("missing authentication")))

    @Operation(summary = "My payslips (payroll lines)")
    @GetMapping(SelfServiceRoutes.MY_PAYSLIPS)
    fun myPayslips(@AuthenticationPrincipal principal: UserPrincipal?): ResponseEntity<ApiResponse<List<PayrollLineView>>> =
        ok(hrService.myPayslips(principal?.id ?: throw BadCredentialsException("missing authentication")))
}
