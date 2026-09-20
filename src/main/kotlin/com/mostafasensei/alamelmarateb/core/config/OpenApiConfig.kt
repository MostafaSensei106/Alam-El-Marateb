package com.mostafasensei.alamelmarateb.core.config

import io.swagger.v3.oas.models.Components
import io.swagger.v3.oas.models.OpenAPI
import io.swagger.v3.oas.models.info.Contact
import io.swagger.v3.oas.models.info.Info
import io.swagger.v3.oas.models.info.License
import io.swagger.v3.oas.models.media.Content
import io.swagger.v3.oas.models.media.MediaType
import io.swagger.v3.oas.models.media.Schema
import io.swagger.v3.oas.models.responses.ApiResponse
import io.swagger.v3.oas.models.security.SecurityRequirement
import io.swagger.v3.oas.models.security.SecurityScheme
import io.swagger.v3.oas.models.servers.Server
import org.springdoc.core.customizers.OperationCustomizer
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

/**
 * Swagger / OpenAPI (mandatory docs): UI at /swagger-ui.html, JSON at /v3/api-docs.
 * All endpoints except auth + public storefront require the JWT bearer below.
 *
 * The [globalErrorCodes] customizer documents the api-status.md contract on
 * every operation (400/401/403/404/405/409/422/429 + traceId envelope) so the
 * UI itself teaches edge cases; controllers only add operation-specific text.
 */
@Configuration
class OpenApiConfig {

    @Bean
    fun openAPI(): OpenAPI {
        val bearer = "bearerAuth"
        return OpenAPI()
            .info(
                Info()
                    .title("Alamelmarateb — Mattress Store ERP")
                    .version("v1")
                    .description(
                        "Modular monolith backend: catalog, sales, inventory, purchasing, " +
                            "crm, hr, accounting, delivery, analytics, identity. " +
                            "Full planning in docs/. " +
                            "Global contract: every response is ApiResponse{success,message,data,errors,traceId,timestamp}; " +
                            "send X-Lang: ar|en for language, Idempotency-Key for place-order/complete-sale/receive, " +
                            "and expect X-Trace-Id + Idempotent-Replay / Retry-After / Allow headers where documented.",
                    )
                    .contact(Contact().name("Alamelmarateb backend").url("/swagger-ui.html"))
                    .license(License().name("Private — internal use")),
            )
            .servers(listOf(Server().url("/").description("Same origin (use docs/api/postman_collection.json for hosted envs)")))
            .addSecurityItem(SecurityRequirement().addList(bearer))
            .components(
                Components()
                    .addSecuritySchemes(
                        bearer,
                        SecurityScheme()
                            .name(bearer)
                            .type(SecurityScheme.Type.HTTP)
                            .scheme("bearer")
                            .bearerFormat("JWT"),
                    )
                    .addParameters(
                        "X-Lang",
                        io.swagger.v3.oas.models.parameters.HeaderParameter()
                            .name("X-Lang").description("Response language: ar|en (default ar)")
                            .schema(Schema<String>()._enum(listOf("ar", "en"))._default("ar"))
                            .required(false),
                    )
                    .addParameters(
                        "Idempotency-Key",
                        io.swagger.v3.oas.models.parameters.HeaderParameter()
                            .name("Idempotency-Key")
                            .description("Required for place-order / complete-sale / confirm-receipt — replay returns the original response + Idempotent-Replay: true")
                            .schema(Schema<String>().example("order-2026-09-20-001"))
                            .required(false),
                    )
                    .addParameters(
                        "X-Trace-Id",
                        io.swagger.v3.oas.models.parameters.HeaderParameter()
                            .name("X-Trace-Id")
                            .description("Optional client trace id; echoed back on every response (generated when absent)")
                            .schema(Schema<String>())
                            .required(false),
                    ),
            )
    }

    @Bean
    fun globalErrorCodes(): OperationCustomizer = OperationCustomizer { operation, _ ->
        val responses = operation.responses ?: io.swagger.v3.oas.models.responses.ApiResponses()
        fun error(code: String, description: String) {
            if (!responses.containsKey(code)) {
                responses.addApiResponse(
                    code,
                    ApiResponse().description(description).content(
                        Content().addMediaType(
                            "application/json",
                            MediaType().schema(Schema<Any>().`$ref`("#/components/schemas/ApiResponse")),
                        ),
                    ),
                )
            }
        }
        error("400", "Bad request — malformed JSON / @Valid failure (api-status 400)")
        error("401", "Missing/expired JWT — refresh and retry (TOKEN_EXPIRED)")
        error("403", "Authenticated but role not allowed")
        error("404", "Unknown route or missing resource id")
        error("405", "Wrong HTTP method — see Allow header")
        error("409", "State conflict — duplicate key / bad transition / insufficient stock / stale version")
        error("422", "Valid syntax, rejected semantics — empty cart, wrong variant, expired promo, bad down payment")
        error("429", "Rate limited — see Retry-After header")
        operation.responses(responses)
        operation
    }
}
