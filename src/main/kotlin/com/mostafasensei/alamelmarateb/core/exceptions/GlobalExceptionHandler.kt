package com.mostafasensei.alamelmarateb.core.exceptions

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import jakarta.persistence.OptimisticLockException
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.messaging.handler.annotation.support.MethodArgumentNotValidException
import org.springframework.web.HttpRequestMethodNotSupportedException
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice
import org.springframework.web.servlet.resource.NoResourceFoundException

@RestControllerAdvice
class GlobalExceptionHandler {
    ///  Validation
    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleValidationExceptions(ex: MethodArgumentNotValidException): ResponseEntity<ApiResponse<Nothing>> {
        val errors = ex.bindingResult?.fieldErrors?.map {
            "${it.field}: ${it.defaultMessage}"
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.failure(message = "Validation error", errors = errors))
    }

    /// Optimistic locking
    @ExceptionHandler
    fun handleOptimisticLockingFailure(ex: OptimisticLockException): ResponseEntity<ApiResponse<Nothing>> {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(ApiResponse.failure(message = "This data has been modified by other process press refresh and try aging late"))
    }

    /// Spring Security - Access Denied
    @ExceptionHandler(AccessDeniedException::class)
    fun handleAccessDeniedException(ex: AccessDeniedException): ResponseEntity<ApiResponse<Nothing>> {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.failure(message = "You are not allowed to access this functionality"))
    }

    //    * Database constraint violations * Example: * - Duplicate unique value * - Foreign key constraint * - Not-null constraint
    @ExceptionHandler(DataIntegrityViolationException::class)
    fun handleDataIntegrityViolationException(ex: DataIntegrityViolationException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(
            ApiResponse.failure(message = "Data integrity violation")
        )

    }

    /// Unsupported HTTP method
    @ExceptionHandler(HttpRequestMethodNotSupportedException::class)
    fun handleHttpRequestMethodNotSupportedException(ex: HttpRequestMethodNotSupportedException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.failure(message = "HTTP method ${ex.method} is not supported"))
    }

    /// Endpoint not found
    @ExceptionHandler(NoResourceFoundException::class)
    fun handleNoResourceFoundException(ex: NoResourceFoundException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.failure(message = "No resource found"))
    }

    /// Illegal arguments
    @ExceptionHandler(IllegalArgumentException::class)
    fun handleIllegalArgumentException(ex: IllegalArgumentException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.failure(message = ex.message ?: "Invalid Request Arguments"))
    }

    @ExceptionHandler(Exception::class)
    fun handleGeneralException(ex: Exception): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ApiResponse.failure(message = "An unexpected error occurred"))
    }
}