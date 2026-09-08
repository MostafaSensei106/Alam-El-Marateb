package com.mostafasensei.alamelmarateb.core.config

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion
import com.mostafasensei.alamelmarateb.core.security.JwtAuthenticationEntryPoint
import com.mostafasensei.alamelmarateb.core.security.JwtAuthenticationFilter
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
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
        http
            .csrf { it.disable() }
            .cors { }
            .exceptionHandling { it.authenticationEntryPoint(jwtAuthenticationEntryPoint) }
            .sessionManagement { it.sessionCreationPolicy(SessionCreationPolicy.STATELESS) }
            .authorizeHttpRequests { auth ->
                auth
                    .requestMatchers("${ApiVersion.V1}/auth/**").permitAll()

                    .requestMatchers("${ApiVersion.V1}/ecommerce/products/**").permitAll()
                    .requestMatchers("${ApiVersion.V1}/ecommerce/categories/**").permitAll()
                    .requestMatchers("${ApiVersion.V1}/ecommerce/presets/**").permitAll()

                    .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
                    .requestMatchers("/actuator/health/**", "/actuator/info").permitAll()

                    .requestMatchers("${ApiVersion.V1}/ecommerce/**").hasAnyRole("CUSTOMER", "SUPER_ADMIN")
                    .requestMatchers("${ApiVersion.V1}/staff/pos/**").hasAnyRole("CASHIER", "BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("${ApiVersion.V1}/staff/warehouse/**").hasAnyRole("WAREHOUSE_KEEPER", "SUPER_ADMIN")
                    .requestMatchers("${ApiVersion.V1}/staff/delivery/**").hasAnyRole("DELIVERY_DRIVER", "SUPER_ADMIN")
                    .requestMatchers("${ApiVersion.V1}/staff/**").authenticated()

                    .requestMatchers("${ApiVersion.V1}/admin/accounting/**").hasAnyRole("ACCOUNTANT", "SUPER_ADMIN")
                    .requestMatchers("${ApiVersion.V1}/admin/hr/**").hasAnyRole("BRANCH_MANAGER", "SUPER_ADMIN")
                    .requestMatchers("${ApiVersion.V1}/admin/**").hasAnyRole("BRANCH_MANAGER", "SUPER_ADMIN")

                    .anyRequest().authenticated()
            }
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter::class.java)
        return http.build()
    }
}
