package com.mostafasensei.alamelmarateb.core.exceptions

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.web.HtmlErrorRenderer
import com.mostafasensei.alamelmarateb.modules.auth.application.AuthService
import jakarta.persistence.OptimisticLockException
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import jakarta.validation.ConstraintViolationException
import org.slf4j.LoggerFactory
import org.slf4j.MDC
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.http.converter.HttpMessageNotReadableException
import org.springframework.security.access.AccessDeniedException
import org.springframework.security.core.AuthenticationException
import org.springframework.web.HttpMediaTypeNotAcceptableException
import org.springframework.web.HttpRequestMethodNotSupportedException
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.MissingServletRequestParameterException
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException
import org.springframework.web.servlet.resource.NoResourceFoundException
import tools.jackson.databind.ObjectMapper

/**
 * Single HTTP-policy enforcement point (docs/api-status.md).
 * Rules: @Valid syntax errors -> 400; business semantics -> 422;
 * state conflicts -> 409; unknown path -> 404; wrong method -> 405 + Allow.
 *
 * Localization (arch.md 11): `message` and every entry of `errors` are
 * resolved from messages_*.properties in the request locale (X-Lang).
 * Services throw keys ([LocalizedException.errorKey])  never English text.
 *
 * Content negotiation is handled manually ([respond]): every handler writes
 * straight to the response so browser-like callers (no `Accept` / `text/html`)
 * get the static HTML fallback and API clients keep the exact JSON envelope.
 */
@RestControllerAdvice
class GlobalExceptionHandler(
    private val msg: MessageService,
    private val html: HtmlErrorRenderer,
    private val objectMapper: ObjectMapper,
) {

    private val log = LoggerFactory.getLogger(GlobalExceptionHandler::class.java)

    /**
     * Writes [status] to the response in the shape the caller understands.
     * JSON path keeps the historical `ApiResponse` contract byte-for-byte;
     * HTML path renders the static, data-free fallback page.
     */
    private fun respond(
        request: HttpServletRequest,
        response: HttpServletResponse,
        status: HttpStatus,
        headers: HttpHeaders = HttpHeaders(),
        body: () -> ApiResponse<Nothing>,
    ) {
        if (response.isCommitted) return
        headers.forEach { name, values -> values.forEach { response.addHeader(name, it) } }
        if (html.wantsHtml(request)) {
            html.write(response, request, status)
            return
        }
        response.status = status.value()
        response.contentType = MediaType.APPLICATION_JSON_VALUE
        response.characterEncoding = Charsets.UTF_8.name()
        objectMapper.writeValue(response.outputStream, body())
    }

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
    fun handleValidationExceptions(
        ex: MethodArgumentNotValidException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) {
        val errors = ex.bindingResult.fieldErrors.map {
            "${it.field}: ${constraintMessage(it.code, it.field, it.defaultMessage)}"
        }
        respond(request, response, HttpStatus.BAD_REQUEST) {
            ApiResponse.failure(message = msg.get("error.validation"), errors = errors)
        }
    }

    @ExceptionHandler(ConstraintViolationException::class)
    fun handleConstraintViolation(
        ex: ConstraintViolationException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) {
        val errors = ex.constraintViolations.map { v ->
            val code = v.constraintDescriptor?.annotation?.annotationClass?.simpleName
            val field = v.propertyPath?.toString() ?: ""
            "$field: ${constraintMessage(code, field, v.message)}"
        }
        respond(request, response, HttpStatus.BAD_REQUEST) {
            ApiResponse.failure(message = msg.get("error.validation"), errors = errors)
        }
    }

    @ExceptionHandler(HttpMessageNotReadableException::class)
    fun handleUnreadable(
        ex: HttpMessageNotReadableException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) {
        respond(request, response, HttpStatus.BAD_REQUEST) {
            ApiResponse.failure(
                msg.get("error.invalid_request"),
                listOf(render("error.request.malformed_json")),
            )
        }
    }

    @ExceptionHandler(MissingServletRequestParameterException::class)
    fun handleMissingParam(
        ex: MissingServletRequestParameterException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) {
        respond(request, response, HttpStatus.BAD_REQUEST) {
            ApiResponse.failure(
                msg.get("error.invalid_request"),
                listOf(render("error.request.missing_param", listOf(ex.parameterName))),
            )
        }
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException::class)
    fun handleTypeMismatch(
        ex: MethodArgumentTypeMismatchException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) {
        respond(request, response, HttpStatus.BAD_REQUEST) {
            ApiResponse.failure(
                msg.get("error.invalid_request"),
                listOf(render("error.request.type_mismatch", listOf(ex.name))),
            )
        }
    }

    @ExceptionHandler(NotFoundException::class)
    fun handleNotFound(
        ex: NotFoundException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.NOT_FOUND) {
        ApiResponse.failure(msg.get("error.not_found"), render(ex))
    }

    @ExceptionHandler(GoneException::class)
    fun handleGone(
        ex: GoneException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.GONE) {
        ApiResponse.failure(msg.get("error.gone"), render(ex))
    }

    @ExceptionHandler(PreconditionFailedException::class)
    fun handlePrecondition(
        ex: PreconditionFailedException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.PRECONDITION_FAILED) {
        ApiResponse.failure(msg.get("error.precondition"), render(ex))
    }

    @ExceptionHandler(UnprocessableException::class)
    fun handleUnprocessable(
        ex: UnprocessableException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.UNPROCESSABLE_ENTITY) {
        ApiResponse.failure(msg.get("error.unprocessable"), render(ex))
    }

    @ExceptionHandler(RateLimitException::class)
    fun handleRateLimit(
        ex: RateLimitException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) {
        val headers = HttpHeaders().apply {
            set(HttpHeaders.RETRY_AFTER, ex.retryAfterSeconds.toString())
        }
        respond(request, response, HttpStatus.TOO_MANY_REQUESTS, headers) {
            ApiResponse.failure(msg.get("error.rate_limited"), render(ex))
        }
    }

    @ExceptionHandler(ConflictException::class)
    fun handleConflict(
        ex: ConflictException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.CONFLICT) {
        ApiResponse.failure(msg.get("error.conflict"), render(ex))
    }

    @ExceptionHandler(AuthService.UnauthorizedException::class)
    fun handleUnauthorized(
        ex: AuthService.UnauthorizedException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.UNAUTHORIZED) {
        ApiResponse.failure(msg.get("auth.invalid_credentials"), listOf("INVALID_CREDENTIALS"))
    }

    @ExceptionHandler(AuthenticationException::class)
    fun handleAuthentication(
        ex: AuthenticationException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.UNAUTHORIZED) {
        ApiResponse.failure(msg.get("auth.unauthorized"), listOf("TOKEN_INVALID"))
    }

    @ExceptionHandler(BadRequestException::class)
    fun handleBadRequest(
        ex: BadRequestException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.BAD_REQUEST) {
        ApiResponse.failure(msg.get("error.invalid_request"), render(ex))
    }

    @ExceptionHandler(OptimisticLockException::class)
    fun handleOptimisticLockingFailure(
        ex: OptimisticLockException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.CONFLICT) {
        ApiResponse.failure(message = msg.get("error.locked"), errors = listOf("VERSION_CONFLICT"))
    }

    @ExceptionHandler(AccessDeniedException::class)
    fun handleAccessDeniedException(
        ex: AccessDeniedException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.FORBIDDEN) {
        ApiResponse.failure(message = msg.get("error.forbidden"), errors = listOf("FORBIDDEN"))
    }

    @ExceptionHandler(DataIntegrityViolationException::class)
    fun handleDataIntegrityViolationException(
        ex: DataIntegrityViolationException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) {
        val detail = ex.mostSpecificCause.message?.take(200) ?: "constraint violation"
        respond(request, response, HttpStatus.CONFLICT) {
            ApiResponse.failure(message = msg.get("error.integrity"), errors = listOf(detail))
        }
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException::class)
    fun handleHttpRequestMethodNotSupportedException(
        ex: HttpRequestMethodNotSupportedException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) {
        val headers = HttpHeaders()
        ex.supportedHttpMethods?.let { headers.allow = it }
        respond(request, response, HttpStatus.METHOD_NOT_ALLOWED, headers) {
            ApiResponse.failure(message = msg.get("error.method"), listOfNotNull(ex.method))
        }
    }

    /**
     * The API only serves JSON and the static HTML fallback. A caller asking
     * for anything else (e.g. `application/xml`) gets 406 instead of a
     * converter error.
     */
    @ExceptionHandler(HttpMediaTypeNotAcceptableException::class)
    fun handleNotAcceptable(
        ex: HttpMediaTypeNotAcceptableException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.NOT_ACCEPTABLE) {
        ApiResponse.failure(msg.get("error.not_acceptable"), listOf("NOT_ACCEPTABLE"))
    }

    @ExceptionHandler(NoResourceFoundException::class)
    fun handleNoResourceFoundException(
        ex: NoResourceFoundException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.NOT_FOUND) {
        ApiResponse.failure(
            msg.get("error.not_found"),
            listOf(render("error.request.no_route", listOf(ex.httpMethod, ex.resourcePath))),
        )
    }

    @ExceptionHandler(IllegalArgumentException::class)
    fun handleIllegalArgumentException(
        ex: IllegalArgumentException,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) = respond(request, response, HttpStatus.BAD_REQUEST) {
        ApiResponse.failure(message = msg.get("error.invalid_request"), ex.message?.let { listOf(it) })
    }

    @ExceptionHandler(Exception::class)
    fun handleGeneralException(
        ex: Exception,
        request: HttpServletRequest,
        response: HttpServletResponse,
    ) {
        log.error("Unhandled error traceId={} : {}", MDC.get("traceId"), ex.message, ex)
        respond(request, response, HttpStatus.INTERNAL_SERVER_ERROR) {
            ApiResponse.failure(message = msg.get("error.internal"), errors = listOf("INTERNAL_ERROR"))
        }
    }
}
