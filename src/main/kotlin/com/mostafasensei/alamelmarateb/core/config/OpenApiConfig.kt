package com.mostafasensei.alamelmarateb.core.config

import io.swagger.v3.oas.models.Components
import io.swagger.v3.oas.models.OpenAPI
import io.swagger.v3.oas.models.info.Info
import io.swagger.v3.oas.models.security.SecurityRequirement
import io.swagger.v3.oas.models.security.SecurityScheme
import io.swagger.v3.oas.models.servers.Server
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

/**
 * Swagger / OpenAPI (mandatory docs): UI at /swagger-ui.html, JSON at /v3/api-docs.
 * All endpoints except auth + public storefront require the JWT bearer below.
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
                            "Full planning in docs/.",
                    ),
            )
            .servers(listOf(Server().url("/").description("Same origin (use docs/api/postman_collection.json for hosted envs)")))
            .addSecurityItem(SecurityRequirement().addList(bearer))
            .components(
                Components().addSecuritySchemes(
                    bearer,
                    SecurityScheme()
                        .name(bearer)
                        .type(SecurityScheme.Type.HTTP)
                        .scheme("bearer")
                        .bearerFormat("JWT"),
                ),
            )
    }
}
