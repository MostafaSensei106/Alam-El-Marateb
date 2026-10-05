package com.mostafasensei.alamelmarateb.core.config

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion
import com.mostafasensei.alamelmarateb.core.security.ApiAccessDeniedHandler
import com.mostafasensei.alamelmarateb.core.security.AppRole
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
    private val jwtAuthenticationFilter: JwtAuthenticationFilter,
    private val apiAccessDeniedHandler: ApiAccessDeniedHandler
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
            .exceptionHandling {
                it.authenticationEntryPoint(jwtAuthenticationEntryPoint)
                it.accessDeniedHandler(apiAccessDeniedHandler)
            }
            .sessionManagement { it.sessionCreationPolicy(SessionCreationPolicy.STATELESS) }
            .authorizeHttpRequests { auth ->
                auth
                    // Public: auth + storefront browsing
                    // (me/change-password stay authenticated despite the /auth prefix,
                    // so expired/invalid tokens get precise TOKEN_* codes)
                    .requestMatchers("$v1/auth/me", "$v1/auth/change-password").authenticated()
                    .requestMatchers("$v1/auth/**").permitAll()
                    .requestMatchers(HttpMethod.GET, "$v1/catalog/public/**").permitAll()
                    .requestMatchers(HttpMethod.POST, "$v1/catalog/public/quiz/**").permitAll()
                    .requestMatchers(HttpMethod.POST, "$v1/catalog/public/products/*/custom-quote").permitAll()
                    .requestMatchers(HttpMethod.POST, "$v1/analytics/events").permitAll()
                    .requestMatchers(HttpMethod.POST, "$v1/shop/checkout/payment-callback/**").permitAll()
                    .requestMatchers("$v1/estimator/**").permitAll()

                    .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
                    .requestMatchers(HttpMethod.GET, "/uploads/**").permitAll()
                    .requestMatchers("/actuator/health/**", "/actuator/info").permitAll()

                    // Customers: shop + self-service portal
                    .requestMatchers("$v1/shop/**").hasAnyRole(*AppRole.names(AppRole.CUSTOMER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/portal/**").hasAnyRole(*AppRole.names(AppRole.CUSTOMER, AppRole.SUPER_ADMIN))

                    // Staff operations
                    .requestMatchers("$v1/sales/promotions/**").hasAnyRole(*AppRole.names(AppRole.BRANCH_MANAGER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/sales/**").hasAnyRole(*AppRole.names(AppRole.CASHIER, AppRole.BRANCH_MANAGER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/warehouse/**").hasAnyRole(*AppRole.names(AppRole.WAREHOUSE_KEEPER, AppRole.BRANCH_MANAGER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/delivery/**").hasAnyRole(*AppRole.names(AppRole.DELIVERY_DRIVER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/me/**").authenticated()

                    // Backoffice
                    .requestMatchers("$v1/accounting/**").hasAnyRole(*AppRole.names(AppRole.ACCOUNTANT, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/catalog/**").hasAnyRole(*AppRole.names(AppRole.BRANCH_MANAGER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/inventory/**").hasAnyRole(*AppRole.names(AppRole.BRANCH_MANAGER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/purchasing/**").hasAnyRole(*AppRole.names(AppRole.BRANCH_MANAGER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/crm/**").hasAnyRole(*AppRole.names(AppRole.BRANCH_MANAGER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/hr/**").hasAnyRole(*AppRole.names(AppRole.BRANCH_MANAGER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/analytics/**").hasAnyRole(*AppRole.names(AppRole.BRANCH_MANAGER, AppRole.SUPER_ADMIN))
                    .requestMatchers("$v1/identity/**").hasAnyRole(*AppRole.names(AppRole.SUPER_ADMIN))

                    .anyRequest().authenticated()
            }
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter::class.java)
        return http.build()
    }
}
