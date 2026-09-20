package com.mostafasensei.alamelmarateb.core.security

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.i18n.AppLocaleResolver
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.beans.factory.annotation.Value
import org.springframework.core.Ordered
import org.springframework.core.annotation.Order
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import tools.jackson.databind.ObjectMapper

/**
 * Sliding-window limiter (api-status.md §3: 429 + Retry-After).
 * Guards brute-force/expensive endpoints only: login, refresh, price-preview.
 * Backed by Redis via RedisRateLimiter (multi-instance; memory fallback).
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 2)
class RateLimitFilter(
    private val objectMapper: ObjectMapper,
    private val msg: MessageService,
    private val locales: AppLocaleResolver,
    private val limiter: RedisRateLimiter,
    @Value("\${app.rate-limit.enabled:true}") private val enabled: Boolean,
    @Value("\${app.rate-limit.login-per-minute:10}") private val loginPerMinute: Int,
    @Value("\${app.rate-limit.preview-per-minute:60}") private val previewPerMinute: Int,
) : OncePerRequestFilter() {

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        chain: FilterChain,
    ) {
        if (!enabled) {
            chain.doFilter(request, response)
            return
        }
        val limit = limitFor(request) ?: run {
            chain.doFilter(request, response)
            return
        }
        val key = "${request.method}:${request.requestURI}:${clientIp(request)}"
        val verdict = limiter.check(key, limit)

        if (!verdict.allowed) {
            val retryAfter = verdict.retryAfterSeconds.coerceAtLeast(1)
            response.contentType = MediaType.APPLICATION_JSON_VALUE
            response.status = 429
            response.setHeader(HttpHeaders.RETRY_AFTER, retryAfter.toString())
            val locale = locales.resolveLocale(request)
            val body = ApiResponse.failure<Nothing>(
                message = msg.get("error.rate_limited", locale),
                errors = listOf(msg.get("error.rate_limited.retry", locale, retryAfter)),
            )
            objectMapper.writeValue(response.outputStream, body)
            return
        }
        chain.doFilter(request, response)
    }

    private fun limitFor(request: HttpServletRequest): Int? {
        val uri = request.requestURI
        if (request.method == "POST" && (
            uri.endsWith("/auth/login") || uri.endsWith("/auth/refresh") ||
                uri.endsWith("/auth/forgot-password") || uri.endsWith("/auth/reset-password")
            )
        ) {
            return loginPerMinute
        }
        if (request.method == "POST" && uri.endsWith("/shop/checkout/price-preview")) {
            return previewPerMinute
        }
        return null
    }

    private fun clientIp(request: HttpServletRequest): String {
        val forwarded = request.getHeader("X-Forwarded-For")?.split(",")?.firstOrNull()?.trim()
        return forwarded?.takeIf { it.isNotBlank() } ?: request.remoteAddr ?: "unknown"
    }
}
