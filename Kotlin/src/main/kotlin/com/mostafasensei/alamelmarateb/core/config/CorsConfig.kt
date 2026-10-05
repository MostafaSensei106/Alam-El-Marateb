package com.mostafasensei.alamelmarateb.core.config

import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.cors.CorsConfiguration
import org.springframework.web.cors.CorsConfigurationSource
import org.springframework.web.cors.UrlBasedCorsConfigurationSource

/**
 * CORS allowlist: only our own frontends may call the API cross-origin.
 * Custom client headers (X-Api-Key, Idempotency-Key, X-Lang) are exposed
 * explicitly — browsers block them otherwise, preflight included.
 */
@Configuration
class CorsConfig(
    @Value("\${app.cors.origins:http://localhost:3000,http://localhost:8080}") origins: String,
) {
    private val allowedOrigins: List<String> =
        origins.split(",").map { it.trim() }.filter { it.isNotEmpty() }

    @Bean
    fun corsConfigurationSource(): CorsConfigurationSource {
        val config = CorsConfiguration()
        config.allowedOrigins = allowedOrigins
        config.allowedMethods = listOf("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
        config.allowedHeaders = listOf(
            "Authorization",
            "Content-Type",
            "Accept",
            "X-Lang",
            "Accept-Language",
            "X-Api-Client",
            "X-Api-Key",
            "X-Trace-Id",
            "Idempotency-Key",
            "If-None-Match",
        )
        config.exposedHeaders = listOf("X-Trace-Id", "ETag", "Idempotent-Replay", "Retry-After")
        config.maxAge = 3600
        val source = UrlBasedCorsConfigurationSource()
        source.registerCorsConfiguration("/api/**", config)
        return source
    }
}
