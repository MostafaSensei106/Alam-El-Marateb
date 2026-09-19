package com.mostafasensei.alamelmarateb.core.security

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.i18n.AppLocaleResolver
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.http.MediaType
import org.springframework.security.core.AuthenticationException
import org.springframework.security.web.AuthenticationEntryPoint
import org.springframework.stereotype.Component
import tools.jackson.databind.ObjectMapper

@Component
class JwtAuthenticationEntryPoint(
    private val objectMapper: ObjectMapper,
    private val msg: MessageService,
    private val locales: AppLocaleResolver,
) : AuthenticationEntryPoint {
    override fun commence(
        request: HttpServletRequest,
        response: HttpServletResponse,
        authException: AuthenticationException
    ) {
        response.contentType = MediaType.APPLICATION_JSON_VALUE
        response.status = HttpServletResponse.SC_UNAUTHORIZED
        // Security chain runs before MVC: resolve locale straight from the request.
        val body = ApiResponse.failure<Nothing>(
            message = msg.get("auth.unauthorized", locales.resolveLocale(request)),
            errors = listOf(authException.localizedMessage),
        )

        objectMapper.writeValue(response.outputStream, body)
    }

}