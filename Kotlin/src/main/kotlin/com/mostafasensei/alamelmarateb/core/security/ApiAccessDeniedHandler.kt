package com.mostafasensei.alamelmarateb.core.security

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.i18n.AppLocaleResolver
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.web.HtmlErrorRenderer
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.security.access.AccessDeniedException
import org.springframework.security.web.access.AccessDeniedHandler
import org.springframework.stereotype.Component
import tools.jackson.databind.ObjectMapper

/**
 * Filter-chain 403 (thrown before MVC, so @RestControllerAdvice never sees it).
 * Returns the same ApiResponse envelope + traceId as every other error.
 */
@Component
class ApiAccessDeniedHandler(
    private val objectMapper: ObjectMapper,
    private val msg: MessageService,
    private val locales: AppLocaleResolver,
    private val html: HtmlErrorRenderer,
) : AccessDeniedHandler {

    override fun handle(
        request: HttpServletRequest,
        response: HttpServletResponse,
        accessDeniedException: AccessDeniedException,
    ) {
        if (html.wantsHtml(request)) {
            response.setHeader(ERROR_CODE_HEADER, "FORBIDDEN")
            html.write(response, request, HttpStatus.FORBIDDEN)
            return
        }
        response.contentType = MediaType.APPLICATION_JSON_VALUE
        response.status = HttpServletResponse.SC_FORBIDDEN
        val body = ApiResponse.failure<Nothing>(
            message = msg.get("error.forbidden", locales.resolveLocale(request)),
        )
        objectMapper.writeValue(response.outputStream, body)
    }

    private companion object {
        private const val ERROR_CODE_HEADER = "X-Error-Code"
    }
}
