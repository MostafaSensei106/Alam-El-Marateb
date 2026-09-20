package com.mostafasensei.alamelmarateb.core.config

import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.boot.web.servlet.FilterRegistrationBean
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.Ordered
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.web.filter.OncePerRequestFilter
import org.springframework.web.util.ContentCachingResponseWrapper
import tools.jackson.databind.ObjectMapper
import tools.jackson.databind.node.ObjectNode
import java.security.MessageDigest

/**
 * HTTP caching via content ETags (conditional GET) — allowlisted endpoints only.
 *
 * Covered (stable, shared, high-traffic reads):
 * - storefront catalog under catalog-public: products, search, suggest,
 *   featured, compare, categories, brands, reviews, quiz, variants
 * - estimator catalog + spin campaigns (reference-like reads)
 * - identity reference data (branches, roles)
 *
 * Deliberately NOT covered: carts, orders, shifts, analytics, loyalty,
 * portal/personal data, auth, live GPS, notifications, audit trails —
 * per-user or constantly-changing payloads where hashing costs more than
 * any 304 could ever save, and a stale 304 would be a bug magnet.
 *
 * Why a custom filter instead of Spring's ShallowEtagHeaderFilter: every
 * ApiResponse body carries a random traceId and a fresh timestamp, so a
 * whole-body hash never repeats and 304 would never fire. This filter hashes
 * the STABLE part only (top-level traceId and timestamp excluded) — 304
 * fires exactly when the data is unchanged. Frontend flow: cache body +
 * ETag, send If-None-Match next time, 304 means reuse.
 *
 * Scope: GET with a JSON 200 body. Everything else passes through untouched.
 * Best-effort: any failure serves the body as-is.
 */
@Configuration
class EtagConfig(
    private val objectMapper: ObjectMapper,
) {

    companion object {
        /** Endpoints worth an ETag. Everything else skips hashing entirely. */
        val ETAG_PATHS = listOf(
            "/api/v1/catalog/public/*",
            "/api/v1/estimator/catalog",
            "/api/v1/estimator/spin/campaigns",
            "/api/v1/estimator/spin/campaigns/*",
            "/api/v1/identity/branches",
            "/api/v1/identity/access/roles",
        )
    }

    @Bean
    fun etagFilter(): FilterRegistrationBean<StableEtagFilter> {
        val registration = FilterRegistrationBean(StableEtagFilter(objectMapper))
        registration.urlPatterns = ETAG_PATHS
        registration.order = Ordered.HIGHEST_PRECEDENCE + 3
        return registration
    }

    @Bean
    fun cachePolicyFilter(): FilterRegistrationBean<CachePolicyFilter> {
        val registration = FilterRegistrationBean(CachePolicyFilter())
        registration.urlPatterns = listOf("/api/*")
        registration.order = Ordered.HIGHEST_PRECEDENCE + 4
        return registration
    }
}

class StableEtagFilter(
    private val objectMapper: ObjectMapper,
) : OncePerRequestFilter() {

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        chain: FilterChain,
    ) {
        if (request.method != HttpMethod.GET.name()) {
            chain.doFilter(request, response)
            return
        }
        val wrapper = ContentCachingResponseWrapper(response)
        try {
            chain.doFilter(request, wrapper)
        } catch (ex: Exception) {
            wrapper.copyBodyToResponse()
            throw ex
        }
        val body = wrapper.contentAsByteArray
        val etag = stableEtag(wrapper.contentType, wrapper.status, body)
        if (etag == null) {
            wrapper.copyBodyToResponse()
            return
        }
        response.setHeader(HttpHeaders.ETAG, etag)
        if (notModified(request, etag)) {
            response.status = HttpServletResponse.SC_NOT_MODIFIED
            return
        }
        wrapper.copyBodyToResponse()
    }

    private fun stableEtag(contentType: String?, status: Int, body: ByteArray): String? {
        if (status != HttpServletResponse.SC_OK || body.isEmpty()) return null
        if (contentType == null || !contentType.contains("application/json")) return null
        return try {
            val node = objectMapper.readTree(body)
            if (node is ObjectNode) {
                node.remove(listOf("traceId", "timestamp"))
            }
            val canonical = objectMapper.writeValueAsBytes(node)
            val digest = MessageDigest.getInstance("MD5").digest(canonical)
            "\"" + digest.joinToString("") { "%02x".format(it) } + "\""
        } catch (_: Exception) {
            null
        }
    }

    private fun notModified(request: HttpServletRequest, etag: String): Boolean {
        val header = request.getHeader(HttpHeaders.IF_NONE_MATCH) ?: return false
        if (header.trim() == "*") return true
        return header.split(",").any { it.trim().removePrefix("W/") == etag }
    }
}

class CachePolicyFilter : OncePerRequestFilter() {
    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        chain: FilterChain,
    ) {
        chain.doFilter(request, response)
        if (request.requestURI.startsWith("/api/")) {
            response.setHeader("Cache-Control", "private, must-revalidate, max-age=0")
            response.setHeader("Vary", "Authorization, X-Lang, Accept-Language")
        }
    }
}
