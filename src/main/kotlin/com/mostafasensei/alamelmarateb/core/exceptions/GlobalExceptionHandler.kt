package com.mostafasensei.alamelmarateb.core.exceptions

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.modules.security.application.AuthService
import jakarta.persistence.OptimisticLockException
import jakarta.validation.ConstraintViolationException
import org.slf4j.LoggerFactory
import org.slf4j.MDC
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.http.converter.HttpMessageNotReadableException
import org.springframework.security.access.AccessDeniedException
import org.springframework.security.core.AuthenticationException
import org.springframework.web.HttpRequestMethodNotSupportedException
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.MissingServletRequestParameterException
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException
import org.springframework.web.servlet.resource.NoResourceFoundException

/**
 * Single HTTP-policy enforcement point (docs/api-status.md).
 * Rules: @Valid syntax errors -> 400; business semantics -> 422;
 * state conflicts -> 409; unknown path -> 404; wrong method -> 405 + Allow.
 *
 * Localization (arch.md 11): `message` and every entry of `errors` are
 * resolved from messages_*.properties in the request locale (X-Lang).
 * Services throw keys ([LocalizedException.errorKey]) — never English text.
 */
@RestControllerAdvice
class GlobalExceptionHandler(private val msg: MessageService) {

    private val log = LoggerFactory.getLogger(GlobalExceptionHandler::class.java)

    private fun render(key: String, args: List<Any> = emptyList()): String =
        msg.get(key, *args.toTypedArray())

    private fun render(ex: LocalizedException): List<String> {
        val details = ex.errorDetails.map { render(it.key, it.args) }
        return details.ifEmpty { listOf(render(ex.errorKey, ex.errorArgs)) }
    }

    /** Bean Validation: map constraint type -> validation.* key (locale-aware). */
    private fun constraintMessage(code: String?, field: String, fallback: String?): String {
        val key = "validation.$code"
        val resolved = msg.get(key, field)
        // MessageService returns the key itself on miss -> fall back to raw text.
        return if (resolved == key) fallback ?: code ?: "invalid" else resolved
    }

    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleValidationExceptions(ex: MethodArgumentNotValidException): ResponseEntity<ApiResponse<Nothing>> {
        val errors = ex.bindingResult.fieldErrors.map {
            "${it.field}: ${constraintMessage(it.code, it.field, it.defaultMessage)}"
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(message = msg.get("error.validation"), errors = errors))
    }

    @ExceptionHandler(ConstraintViolationException::class)
    fun handleConstraintViolation(ex: ConstraintViolationException): ResponseEntity<ApiResponse<Nothing>> {
        val errors = ex.constraintViolations.map { v ->
            val code = v.constraintDescriptor?.annotation?.annotationClass?.simpleName
            val field = v.propertyPath?.toString() ?: ""
            "$field: ${constraintMessage(code, field, v.message)}"
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(message = msg.get("error.validation"), errors = errors))
    }

    @ExceptionHandler(HttpMessageNotReadableException::class)
    fun handleUnreadable(ex: HttpMessageNotReadableException): ResponseEntity<ApiResponse<Nothing>> {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(msg.get("error.invalid_request"), listOf(render("error.request.malformed_json"))))
    }

    @ExceptionHandler(MissingServletRequestParameterException::class)
    fun handleMissingParam(ex: MissingServletRequestParameterException): ResponseEntity<ApiResponse<Nothing>> {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(msg.get("error.invalid_request"), listOf(render("error.request.missing_param", listOf(ex.parameterName)))))
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException::class)
    fun handleTypeMismatch(ex: MethodArgumentTypeMismatchException): ResponseEntity<ApiResponse<Nothing>> {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(msg.get("error.invalid_request"), listOf(render("error.request.type_mismatch", listOf(ex.name)))))
    }

    @ExceptionHandler(NotFoundException::class)
    fun handleNotFound(ex: NotFoundException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.failure(msg.get("error.not_found"), render(ex)))

    @ExceptionHandler(GoneException::class)
    fun handleGone(ex: GoneException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.GONE)
            .body(ApiResponse.failure(msg.get("error.gone"), render(ex)))

    @ExceptionHandler(PreconditionFailedException::class)
    fun handlePrecondition(ex: PreconditionFailedException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.PRECONDITION_FAILED)
            .body(ApiResponse.failure(msg.get("error.precondition"), render(ex)))

    @ExceptionHandler(UnprocessableException::class)
    fun handleUnprocessable(ex: UnprocessableException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY)
            .body(ApiResponse.failure(msg.get("error.unprocessable"), render(ex)))

    @ExceptionHandler(RateLimitException::class)
    fun handleRateLimit(ex: RateLimitException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS)
            .header(HttpHeaders.RETRY_AFTER, ex.retryAfterSeconds.toString())
            .body(ApiResponse.failure(msg.get("error.rate_limited"), render(ex)))

    @ExceptionHandler(ConflictException::class)
    fun handleConflict(ex: ConflictException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.CONFLICT)
            .body(ApiResponse.failure(msg.get("error.conflict"), render(ex)))

    @ExceptionHandler(AuthService.UnauthorizedException::class)
    fun handleUnauthorized(ex: AuthService.UnauthorizedException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(ApiResponse.failure(msg.get("auth.invalid_credentials")))

    @ExceptionHandler(AuthenticationException::class)
    fun handleAuthentication(ex: AuthenticationException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(ApiResponse.failure(msg.get("auth.unauthorized"), listOf("TOKEN_EXPIRED")))

    @ExceptionHandler(BadRequestException::class)
    fun handleBadRequest(ex: BadRequestException): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(msg.get("error.invalid_request"), render(ex)))

    @ExceptionHandler(OptimisticLockException::class)
    fun handleOptimisticLockingFailure(ex: OptimisticLockException): ResponseEntity<ApiResponse<Nothing>> {
        return ResponseEntity.status(HttpStatus.CONFLICT)
            .body(ApiResponse.failure(message = msg.get("error.locked")))
    }

    @ExceptionHandler(AccessDeniedException::class)
    fun handleAccessDeniedException(ex: AccessDeniedException): ResponseEntity<ApiResponse<Nothing>> {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
            .body(ApiResponse.failure(message = msg.get("error.forbidden")))
    }

    @ExceptionHandler(DataIntegrityViolationException::class)
    fun handleDataIntegrityViolationException(ex: DataIntegrityViolationException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(
            ApiResponse.failure(message = msg.get("error.integrity")),
        )
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException::class)
    fun handleHttpRequestMethodNotSupportedException(ex: HttpRequestMethodNotSupportedException): ResponseEntity<ApiResponse<String>> {
        val headers = HttpHeaders()
        ex.supportedHttpMethods?.let { headers.allow = it }
        return ResponseEntity.status(HttpStatus.METHOD_NOT_ALLOWED)
            .headers(headers)
            .body(ApiResponse.failure(message = msg.get("error.method"), listOfNotNull(ex.method)))
    }

    @ExceptionHandler(NoResourceFoundException::class)
    fun handleNoResourceFoundException(ex: NoResourceFoundException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.failure(msg.get("error.not_found"), listOf(render("error.request.no_route", listOf(ex.httpMethod, ex.resourcePath)))))
    }

    @ExceptionHandler(IllegalArgumentException::class)
    fun handleIllegalArgumentException(ex: IllegalArgumentException): ResponseEntity<ApiResponse<String>> {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.failure(message = msg.get("error.invalid_request"), ex.message?.let { listOf(it) }))
    }

    @ExceptionHandler(Exception::class)
    fun handleGeneralException(ex: Exception): ResponseEntity<ApiResponse<String>> {
        log.error("Unhandled error traceId={} : {}", MDC.get("traceId"), ex.message, ex)
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(ApiResponse.failure(message = msg.get("error.internal")))
    }
}
