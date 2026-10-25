package com.mostafasensei.alamelmarateb.modules.auth.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.router.AuthRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.auth.application.AuthService
import com.mostafasensei.alamelmarateb.modules.auth.application.AuthUserView
import com.mostafasensei.alamelmarateb.modules.auth.application.TokenPair
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

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

/**
 * Public auth  /api/v1/auth/... No login required (except /me).
 */
@Tag(name = "Auth", description = "Register, login, refresh  public")
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
        return ResponseEntity.ok(ApiResponse.messageWithoutData(MessageService.t("auth.reset_sent")))
    }

    @Operation(summary = "Reset password with a single-use token")
    @PostMapping("/reset-password")
    fun resetPassword(@RequestBody request: ResetPasswordRequest): ResponseEntity<ApiResponse<Nothing>> {
        authService.resetPassword(request.token, request.newPassword)
        return ResponseEntity.ok(ApiResponse.messageWithoutData(MessageService.t("auth.reset_done")))
    }

    @Operation(summary = "Change password (kills all other sessions)")
    @PostMapping("/change-password")
    fun changePassword(
        @AuthenticationPrincipal principal: UserPrincipal?,
        @RequestBody request: ChangePasswordRequest,
    ): ResponseEntity<ApiResponse<Nothing>> {
        val id = principal?.id ?: throw AuthService.UnauthorizedException()
        authService.changePassword(id, request.currentPassword, request.newPassword)
        return ResponseEntity.ok(ApiResponse.messageWithoutData(MessageService.t("auth.password_changed")))
    }

    @Operation(summary = "My profile")
    @GetMapping("/me")
    fun me(@AuthenticationPrincipal principal: UserPrincipal?): ResponseEntity<ApiResponse<AuthUserView>> {
        val id = principal?.id ?: throw AuthService.UnauthorizedException()
        return ok(authService.me(id))
    }
}
