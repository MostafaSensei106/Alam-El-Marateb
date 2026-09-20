package com.mostafasensei.alamelmarateb.modules.security.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.AuthRoutes
import com.mostafasensei.alamelmarateb.core.router.IdentityAdminRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.security.application.AuthService
import com.mostafasensei.alamelmarateb.modules.security.application.AuthUserView
import com.mostafasensei.alamelmarateb.modules.security.application.BranchView
import com.mostafasensei.alamelmarateb.modules.security.application.IdentityService
import com.mostafasensei.alamelmarateb.modules.security.application.RoleView
import com.mostafasensei.alamelmarateb.modules.security.application.StaffView
import com.mostafasensei.alamelmarateb.modules.security.application.TokenPair
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.constraints.NotBlank
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

data class RegisterRequest(
    @field:NotBlank val fullName: String,
    @field:NotBlank val phone: String,
    @field:NotBlank val password: String,
    val email: String? = null,
)

data class LoginRequest(
    @field:NotBlank val phone: String,
    @field:NotBlank val password: String,
)

data class RefreshRequest(
    @field:NotBlank val refreshToken: String,
)

data class ForgotPasswordRequest(
    @field:NotBlank val phone: String,
)

data class ResetPasswordRequest(
    @field:NotBlank val token: String,
    @field:NotBlank @field:Size(min = 6) val newPassword: String,
)

data class ChangePasswordRequest(
    @field:NotBlank val currentPassword: String,
    @field:NotBlank @field:Size(min = 6) val newPassword: String,
)

data class BranchRequest(
    @field:NotBlank val name: String,
    @field:NotBlank val code: String,
    val phone: String? = null,
    val city: String = "Tanta",
    val address: String = "",
)

data class StaffCreateRequest(
    @field:NotBlank val fullName: String,
    @field:NotBlank val phone: String,
    @field:NotBlank val password: String,
    val email: String? = null,
    val branchId: UUID? = null,
    val roles: List<String> = emptyList(),
)

data class SetRolesRequest(val roles: List<String> = emptyList())

/**
 * Public auth — /api/v1/auth/... No login required (except /me).
 */
@Tag(name = "Auth", description = "Register, login, refresh — public")
@RestController
@RequestMapping(AuthRoutes.BASE)
class AuthController(
    private val authService: AuthService,
) : BaseController() {

    @Operation(summary = "Customer self-registration")
    @PostMapping("/register")
    fun register(@RequestBody request: RegisterRequest): ResponseEntity<ApiResponse<TokenPair>> =
        created(authService.register(request.fullName, request.phone, request.password, request.email))

    @Operation(summary = "Login with phone + password")
    @PostMapping("/login")
    fun login(@RequestBody request: LoginRequest): ResponseEntity<ApiResponse<TokenPair>> =
        ok(authService.login(request.phone, request.password))

    @Operation(summary = "Rotate tokens with a refresh token")
    @PostMapping("/refresh")
    fun refresh(@RequestBody request: RefreshRequest): ResponseEntity<ApiResponse<TokenPair>> =
        ok(authService.refresh(request.refreshToken))

    @Operation(summary = "Request password reset (generic response, no enumeration)")
    @PostMapping("/forgot-password")
    fun forgotPassword(@RequestBody request: ForgotPasswordRequest): ResponseEntity<ApiResponse<Nothing>> {
        authService.forgotPassword(request.phone)
        return ok(null)
    }

    @Operation(summary = "Reset password with a single-use token")
    @PostMapping("/reset-password")
    fun resetPassword(@RequestBody request: ResetPasswordRequest): ResponseEntity<ApiResponse<Nothing>> {
        authService.resetPassword(request.token, request.newPassword)
        return ok(null)
    }

    @Operation(summary = "Change password (kills all other sessions)")
    @PostMapping("/change-password")
    fun changePassword(
        @AuthenticationPrincipal principal: UserPrincipal,
        @RequestBody request: ChangePasswordRequest,
    ): ResponseEntity<ApiResponse<Nothing>> {
        authService.changePassword(principal.id, request.currentPassword, request.newPassword)
        return ok(null)
    }

    @Operation(summary = "My profile")
    @GetMapping("/me")
    fun me(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<AuthUserView>> =
        ok(authService.me(principal.id))
}

/**
 * Identity administration — /api/v1/identity/... Super-admin only
 * (branch managers get scoped access in a later phase).
 */
@Tag(name = "Identity (admin)", description = "Branches, staff, roles — SUPER_ADMIN")
@RestController
@RequestMapping(IdentityAdminRoutes.BASE)
@PreAuthorize("hasAnyRole('SUPER_ADMIN')")
class IdentityAdminController(
    private val identityService: IdentityService,
) : BaseController() {

    @Operation(summary = "List branches")
    @GetMapping("/branches")
    fun branches(): ResponseEntity<ApiResponse<List<BranchView>>> =
        ok(identityService.listBranches())

    @Operation(summary = "Create branch")
    @PostMapping("/branches")
    fun createBranch(
        @RequestBody request: BranchRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<BranchView>> =
        created(identityService.createBranch(request.name, request.code, request.phone, request.city, request.address, principal.fullName))

    @Operation(summary = "Enable/disable branch")
    @PostMapping("/branches/{id}/toggle")
    fun toggleBranch(
        @PathVariable id: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<BranchView>> =
        ok(identityService.toggleBranch(id, principal.fullName))

    @Operation(summary = "List roles")
    @GetMapping("/access/roles")
    fun roles(): ResponseEntity<ApiResponse<List<RoleView>>> =
        ok(identityService.listRoles())

    @Operation(summary = "List users (optional branch filter)")
    @GetMapping("/access/users")
    fun users(@RequestParam(required = false) branchId: UUID?): ResponseEntity<ApiResponse<List<StaffView>>> =
        ok(identityService.listUsers(branchId))

    @Operation(summary = "Create staff user")
    @PostMapping("/access/users")
    fun createStaff(
        @RequestBody request: StaffCreateRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<StaffView>> =
        created(
            identityService.createStaff(
                request.fullName, request.phone, request.password, request.email,
                request.branchId, request.roles, principal.fullName,
            ),
        )

    @Operation(summary = "Set user roles")
    @PostMapping("/access/users/{id}/roles")
    fun setRoles(
        @PathVariable id: UUID,
        @RequestBody request: SetRolesRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<StaffView>> =
        ok(identityService.setRoles(id, request.roles, principal.fullName))

    @Operation(summary = "Enable/disable user")
    @PostMapping("/access/users/{id}/toggle")
    fun toggleUser(
        @PathVariable id: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<StaffView>> =
        ok(identityService.toggleUser(id, principal.fullName))
}
