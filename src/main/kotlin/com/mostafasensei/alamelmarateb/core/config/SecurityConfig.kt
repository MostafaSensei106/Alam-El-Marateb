package com.mostafasensei.alamelmarateb.core.config

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion
import com.mostafasensei.alamelmarateb.core.security.JwtAuthenticationEntryPoint
import com.mostafasensei.alamelmarateb.core.security.JwtAuthenticationFilter
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.http.HttpMethod
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.security.web.SecurityFilterChain
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter

/**
 * URL-level authorization mirrors the route split in core/router:
 * every route object declares its audience + required roles.
 * Controllers add @PreAuthorize as a second layer (defense in depth).
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
class SecurityConfig (
    private val jwtAuthenticationEntryPoint: JwtAuthenticationEntryPoint,
    private val jwtAuthenticationFilter: JwtAuthenticationFilter
){
    @Bean
    fun passwordEncoder(): PasswordEncoder = BCryptPasswordEncoder()

    @Bean
    fun authenticationManager(authConfig: AuthenticationConfiguration): AuthenticationManager =
        authConfig.authenticationManager

    @Bean
    fun filterChain(http: HttpSecurity): SecurityFilterChain {
        val v1 = ApiVersion.V1_PREFIX
        http
            .csrf { it.disable() }
            .cors { }
            .exceptionHandling { it.authenticationEntryPoint(jwtAuthenticationEntryPoint) }
            .sessionManagement { it.sessionCreationPolicy(SessionCreationPolicy.STATELESS) }
            .authorizeHttpRequests { auth ->
                auth
                    // Public: auth + storefront browsing
                    .requestMatchers("$v1/auth/**").permitAll()
                    .requestMatchers(HttpMethod.GET, "$v1/catalog/public/**").permitAll()

                    .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
                    .requestMatchers("/actuator/health/**", "/actuator/info").permitAll()

                    // Customers: shop + self-service portal
                    .requestMatchers("$v1/shop/**").hasAnyRole("CUSTOMER", "SUPER_ADMIN")
                    .requestMatchers("$v1/portal/**").hasAnyRole("CUSTOMER", "SUPER_ADMIN")

                    // Staff operations
                    .requestMatchers("$v1/sales/promotions/**").hasAnyRole("BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("$v1/sales/**").hasAnyRole("CASHIER", "BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("$v1/warehouse/**").hasAnyRole("WAREHOUSE_KEEPER", "BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("$v1/delivery/**").hasAnyRole("DELIVERY_DRIVER", "SUPER_ADMIN")
                    .requestMatchers("$v1/me/**").authenticated()

                    // Backoffice
                    .requestMatchers("$v1/accounting/**").hasAnyRole("ACCOUNTANT", "SUPER_ADMIN")
                    .requestMatchers("$v1/catalog/**").hasAnyRole("BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("$v1/inventory/**").hasAnyRole("BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("$v1/purchasing/**").hasAnyRole("BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("$v1/crm/**").hasAnyRole("BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("$v1/hr/**").hasAnyRole("BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("$v1/analytics/**").hasAnyRole("BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("$v1/identity/**").hasAnyRole("SUPER_ADMIN")

                    .anyRequest().authenticated()
            }
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter::class.java)
        return http.build()
    }
}
