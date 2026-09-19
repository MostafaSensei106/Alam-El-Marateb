package com.mostafasensei.alamelmarateb.core.exceptions

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.modules.security.application.AuthService
import jakarta.persistence.OptimisticLockException
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.HttpRequestMethodNotSupportedException
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice
import org.springframework.web.servlet.resource.NoResourceFoundException

/**
 * Localized envelopes (per X-Lang header); specifics stay in `errors`.
 * Same shape in every language — see core/i18n contract.
 */
@RestControllerAdvice
class GlobalExceptionHandler(private val msg: MessageService) {
    ///  Validation
    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleValidationExceptions(ex: MethodArgumentNotValidException): ResponseEntity<ApiResponse<Nothing>> {
        val errors = ex.bindingResult.fieldErrors.map {
            "${it.field}: ${it.defaultMessage}"
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(message = msg.get("error.validation"), errors = errors))
    }

    /// Domain not-found -> 404 (controllers throw this instead of building 404 manually)
    @ExceptionHandler(NotFoundException::class)
    fun handleNotFound(ex: NotFoundException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.failure(msg.get("error.not_found"), ex.message?.let { listOf(it) }))

    @ExceptionHandler(ConflictException::class)
    fun handleConflict(ex: ConflictException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.CONFLICT)
            .body(ApiResponse.failure(msg.get("error.conflict"), ex.message?.let { listOf(it) }))

    @ExceptionHandler(AuthService.UnauthorizedException::class)
    fun handleUnauthorized(ex: AuthService.UnauthorizedException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(ApiResponse.failure(msg.get("auth.invalid_credentials")))

    @ExceptionHandler(BadRequestException::class)
    fun handleBadRequest(ex: BadRequestException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(msg.get("error.invalid_request"), ex.errors ?: ex.message?.let { listOf(it) }))

    /// Optimistic locking
    @ExceptionHandler(OptimisticLockException::class)
    fun handleOptimisticLockingFailure(ex: OptimisticLockException): ResponseEntity<ApiResponse<Nothing>> {
        return ResponseEntity.status(HttpStatus.CONFLICT)
            .body(ApiResponse.failure(message = msg.get("error.locked")))
    }

    /// Spring Security - Access Denied
    @ExceptionHandler(AccessDeniedException::class)
    fun handleAccessDeniedException(ex: AccessDeniedException): ResponseEntity<ApiResponse<Nothing>> {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
            .body(ApiResponse.failure(message = msg.get("error.forbidden")))
    }

    //    * Database constraint violations * Example: * - Duplicate unique value * - Foreign key constraint * - Not-null constraint
    @ExceptionHandler(DataIntegrityViolationException::class)
    fun handleDataIntegrityViolationException(ex: DataIntegrityViolationException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(
            ApiResponse.failure(message = msg.get("error.integrity")),
        )
    }

    /// Unsupported HTTP method
    @ExceptionHandler(HttpRequestMethodNotSupportedException::class)
    fun handleHttpRequestMethodNotSupportedException(ex: HttpRequestMethodNotSupportedException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(message = msg.get("error.method"), listOfNotNull(ex.method)))
    }

    /// Endpoint not found
    @ExceptionHandler(NoResourceFoundException::class)
    fun handleNoResourceFoundException(ex: NoResourceFoundException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.failure(message = msg.get("error.not_found")))
    }

    /// Illegal arguments
    @ExceptionHandler(IllegalArgumentException::class)
    fun handleIllegalArgumentException(ex: IllegalArgumentException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(message = msg.get("error.invalid_request"), ex.message?.let { listOf(it) }))
    }

    @ExceptionHandler(Exception::class)
    fun handleGeneralException(ex: Exception): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(ApiResponse.failure(message = msg.get("error.internal")))
    }
}
