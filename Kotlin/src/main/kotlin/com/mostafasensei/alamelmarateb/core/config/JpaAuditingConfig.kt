package com.mostafasensei.alamelmarateb.core.config

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.data.domain.AuditorAware
import org.springframework.data.jpa.repository.config.EnableJpaAuditing
import org.springframework.security.core.context.SecurityContextHolder
import java.util.Optional

@Configuration
@EnableJpaAuditing(auditorAwareRef = "auditorProvider")
class JpaAuditingConfig {
    @Bean
    fun auditorProvider(): AuditorAware<String> {
        return  AuditorAware{
            val authentication = SecurityContextHolder.getContext().authentication
            if (authentication == null || !authentication.isAuthenticated || authentication.principal == "anonymousUser" ){
                Optional.of("SYSTEM")
            } else {
                Optional.ofNullable(authentication.name)
            }
        }
    }
}