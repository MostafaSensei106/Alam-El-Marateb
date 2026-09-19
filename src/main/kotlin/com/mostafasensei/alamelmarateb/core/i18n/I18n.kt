package com.mostafasensei.alamelmarateb.core.i18n

import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.MessageSource
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.i18n.LocaleContextHolder
import org.springframework.context.support.ReloadableResourceBundleMessageSource
import org.springframework.core.Ordered
import org.springframework.core.annotation.Order
import org.springframework.stereotype.Component
import org.springframework.stereotype.Service
import org.springframework.web.filter.OncePerRequestFilter
import org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver
import java.util.Locale

/**
 * i18n contract (mandatory):
 * - Same response shape always; ONE language per request.
 * - Language key comes from the `X-Lang` header (ar|en, extensible via app.i18n.supported),
 *   then Accept-Language, then default (ar).
 * - New language = new messages_<code>.properties + adding the code. No code changes.
 *
 * Single source of truth is [AppLocaleResolver] (a Spring MVC LocaleResolver),
 * so DispatcherServlet and MessageService always agree.
 */
@Configuration
class MessageConfig {
    @Bean
    fun messageSource(): MessageSource {
        val source = ReloadableResourceBundleMessageSource()
        source.setBasename("classpath:messages/messages")
        source.defaultEncoding = "UTF-8"
        source.setDefaultLocale(Locale("ar"))
        source.isUseCodeAsDefaultMessage = true
        return source
    }
}

@Service
class MessageService(
    private val source: MessageSource,
    @Value("\${app.i18n.supported:ar,en}") supported: String,
    @Value("\${app.i18n.default:ar}") default: String,
) {
    private val supportedCodes = supported.split(",").map { it.trim().lowercase() }.toSet()
    private val defaultLocale = Locale(default)

    init {
        holder = this
    }

    fun get(code: String, vararg args: Any): String {
        val requested = try {
            LocaleContextHolder.getLocale()
        } catch (_: Exception) {
            defaultLocale
        }
        return get(code, requested, *args)
    }

    fun get(code: String, locale: Locale, vararg args: Any): String {
        val effective = if (locale.language.lowercase() in supportedCodes) locale else defaultLocale
        return try {
            source.getMessage(code, args, effective)
        } catch (_: Exception) {
            code
        }
    }

    companion object {
        private var holder: MessageService? = null

        /** Static access for non-bean helpers (e.g. BaseController defaults). */
        fun t(code: String, vararg args: Any): String = holder?.get(code, *args) ?: code
    }
}

@Component("localeResolver")
class AppLocaleResolver(
    @Value("\${app.i18n.supported:ar,en}") supported: String,
    @Value("\${app.i18n.default:ar}") default: String,
) : AcceptHeaderLocaleResolver() {

    private val supportedCodes = supported.split(",").map { it.trim().lowercase() }.toSet()
    private val fallback = Locale(default)

    init {
        defaultLocale = fallback
    }

    override fun resolveLocale(request: HttpServletRequest): Locale {
        // 1. Explicit client key wins.
        request.getHeader("X-Lang")?.lowercase()?.let {
            if (it in supportedCodes) return Locale(it)
        }
        // 2. Explicit Accept-Language only — never the server JVM default.
        val header = request.getHeader("Accept-Language")
        if (header != null) {
            val tag = header.split(",").firstOrNull()
                ?.split(";")?.firstOrNull()
                ?.trim()?.substringBefore("-")?.lowercase()
            if (tag in supportedCodes) return Locale(tag)
        }
        // 3. Configured default.
        return fallback
    }
}

/**
 * Sets the holder locale EARLY (before the security chain) using the same
 * rules as [AppLocaleResolver], so 401/403 responses are localized too.
 * DispatcherServlet re-resolves identically afterwards — no conflict.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
class LocaleHolderFilter(private val resolver: AppLocaleResolver) : OncePerRequestFilter() {

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        chain: FilterChain,
    ) {
        try {
            LocaleContextHolder.setLocale(resolver.resolveLocale(request), true)
            chain.doFilter(request, response)
        } finally {
            LocaleContextHolder.resetLocaleContext()
        }
    }
}
