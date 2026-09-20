package com.mostafasensei.alamelmarateb.core.common.api_response

import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.slf4j.MDC
import org.springframework.core.Ordered
import org.springframework.core.annotation.Order
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import java.util.UUID

/**
 * Trace correlation (api-status.md §5): every response carries `traceId`
 * (ApiResponse.traceId + `X-Trace-Id` header). Client may send
 * `X-Trace-Id`; otherwise a UUID is generated. Also stored in MDC
 * so application logs can be correlated with the user-facing id.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 1)
class TraceIdFilter : OncePerRequestFilter() {

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        chain: FilterChain,
    ) {
        val incoming = request.getHeader(TRACE_HEADER)?.takeIf { it.isNotBlank() }
        val traceId = incoming ?: UUID.randomUUID().toString().replace("-", "").take(16)
        MDC.put("traceId", traceId)
        // Expose early so error paths (security entry point included) also carry it.
        response.setHeader(TRACE_HEADER, traceId)
        try {
            chain.doFilter(request, response)
        } finally {
            MDC.remove("traceId")
        }
    }

    companion object {
        const val TRACE_HEADER = "X-Trace-Id"
    }
}
