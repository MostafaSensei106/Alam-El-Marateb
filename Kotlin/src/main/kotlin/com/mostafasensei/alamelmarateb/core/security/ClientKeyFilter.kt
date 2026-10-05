package com.mostafasensei.alamelmarateb.core.security

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.beans.factory.annotation.Value
import org.springframework.core.Ordered
import org.springframework.core.annotation.Order
import org.springframework.http.HttpMethod
import org.springframework.http.MediaType
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import tools.jackson.databind.ObjectMapper
import java.security.MessageDigest

/**
 * First-party client gate: a valid JWT alone is NOT enough — the caller
 * must also prove it is one of our own apps via `X-Api-Client` + `X-Api-Key`.
 * Runs before the whole security chain and rejects unknown clients with
 * 401 CLIENT_REJECTED (same ApiResponse envelope, no body timestamps).
 *
 * Exempt (no key needed): Swagger/OpenAPI, actuator health/info, public
 * uploads (plain <img> tags cannot send headers), CORS preflights.
 * Everything else under the /api/ routes requires a key — login included.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 2)
class ClientKeyFilter(
    private val objectMapper: ObjectMapper,
    @Value("\${app.clients.enabled:true}") private val enabled: Boolean,
    @Value("\${app.clients.keys:dev-local-key}") keys: String,
) : OncePerRequestFilter() {

    private val validKeys: Set<String> =
        keys.split(",").map { it.trim() }.filter { it.isNotEmpty() }.toSet()

    companion object {
        const val CLIENT_HEADER = "X-Api-Client"
        const val KEY_HEADER = "X-Api-Key"

        private val EXEMPT_PREFIXES = listOf(
            "/v3/api-docs",
            "/swagger-ui",
            "/swagger-ui.html",
            "/actuator/health",
            "/actuator/info",
        )
    }

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        chain: FilterChain,
    ) {
        if (!enabled || isExempt(request)) {
            chain.doFilter(request, response)
            return
        }
        val client = request.getHeader(CLIENT_HEADER)?.trim().orEmpty()
        val key = request.getHeader(KEY_HEADER)?.trim().orEmpty()
        if (client.isEmpty() || !isValid(key)) {
            reject(response)
            return
        }
        chain.doFilter(request, response)
    }

    private fun isExempt(request: HttpServletRequest): Boolean {
        if (request.method == HttpMethod.OPTIONS.name()) return true
        val uri = request.requestURI
        if (EXEMPT_PREFIXES.any { uri.startsWith(it) }) return true
        // Public images: browsers fetch <img> without custom headers.
        if (uri.startsWith("/uploads") && request.method == HttpMethod.GET.name()) return true
        return false
    }

    private fun isValid(key: String): Boolean {
        if (key.isEmpty()) return false
        // Constant-time compare against each known key.
        return validKeys.any { known ->
            MessageDigest.isEqual(
                known.toByteArray(Charsets.UTF_8),
                key.toByteArray(Charsets.UTF_8),
            ) && known.length == key.length
        }
    }

    private fun reject(response: HttpServletResponse) {
        response.contentType = MediaType.APPLICATION_JSON_VALUE
        response.status = HttpServletResponse.SC_UNAUTHORIZED
        objectMapper.writeValue(
            response.outputStream,
            ApiResponse.failure<Nothing>(
                message = "Client rejected",
                errors = listOf("CLIENT_REJECTED"),
            ),
        )
    }
}
