package com.mostafasensei.alamelmarateb.core.config

import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.cors.CorsConfiguration
import org.springframework.web.cors.CorsConfigurationSource
import org.springframework.web.cors.UrlBasedCorsConfigurationSource

/**
* CORS allowlist: only our own frontends may call the API cross-origin.
* Custom client headers (X-Api-Key, Idempotency-Key, X-Lang, locale) are
* allowlisted explicitly  browsers block them otherwise, preflight included.
*/
@Configuration
class CorsConfig(
   @Value(
    "\${app.cors.origins:http://localhost:*,http://127.0.0.1:*,http://192.168.*:*}",   ) origins: String,
) {
   private val allowedOrigins: List<String> =
       origins.split(",").map { it.trim() }.filter { it.isNotEmpty() }

   @Bean
   fun corsConfigurationSource(): CorsConfigurationSource {
       val config = CorsConfiguration()
       config.allowedOriginPatterns = allowedOrigins
       config.allowedMethods = listOf("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
       config.allowedHeaders = listOf("*")
       config.exposedHeaders = listOf("X-Trace-Id", "ETag", "Idempotent-Replay", "Retry-After")
       config.allowCredentials = true
       config.maxAge = 3600L
       val source = UrlBasedCorsConfigurationSource()
       source.registerCorsConfiguration("/api/**", config)
       return source
   }
}
