package com.mostafasensei.alamelmarateb.core.web

import com.mostafasensei.alamelmarateb.core.i18n.AppLocaleResolver
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.stereotype.Component
import org.thymeleaf.context.Context
import org.thymeleaf.spring6.SpringTemplateEngine

/**
 * Static HTML fallback for browser-like callers.
 *
 * The backend is an API consumed by our own clients (they always send
 * `X-Api-Client` / `X-Api-Key` and expect the `ApiResponse` JSON envelope).
 * A request that arrives with no `Accept` header or that explicitly asks for
 * HTML is a human/browser hitting the API by mistake, so it gets a small
 * static error page instead of raw JSON.
 *
 * Content rule (single source of truth for every error emitter):
 *  - blank/absent `Accept`                        -> HTML (browser default)
 *  - contains `application/json`                  -> JSON (API clients win)
 *  - contains `text/html` / `application/xhtml+xml` -> HTML
 *  - anything else (e.g. `* / *` only)             -> JSON (safe API default)
 *
 * The page is deliberately data-free: only the status code and localized
 * generic wording, no application or user data whatsoever.
 */
@Component
class HtmlErrorRenderer(
    private val templates: SpringTemplateEngine,
    private val msg: MessageService,
    private val locales: AppLocaleResolver,
) {

    companion object {
        private const val XHTML = "application/xhtml+xml"
        private const val TEMPLATE = "error/fallback"
    }

    fun wantsHtml(request: HttpServletRequest): Boolean {
        val accept = request.getHeader(HttpHeaders.ACCEPT)
        if (accept.isNullOrBlank()) return true
        val lower = accept.lowercase()
        if (lower.contains(MediaType.APPLICATION_JSON_VALUE)) return false
        return lower.contains(MediaType.TEXT_HTML_VALUE) || lower.contains(XHTML)
    }

    /** Renders the fallback page body for [status] in the request locale. */
    fun render(request: HttpServletRequest, status: HttpStatus): String {
        val locale = locales.resolveLocale(request)
        val statusKey = "html.status.${status.value()}"
        val title = msg.get(statusKey, locale).let {
            if (it == statusKey) msg.get("html.status.default", locale) else it
        }
        val context = Context(locale).apply {
            setVariable("code", status.value())
            setVariable("title", title)
            setVariable("message", msg.get("html.fallback.message", locale))
            setVariable("lang", locale.language)
            setVariable("dir", if (locale.language.equals("ar", ignoreCase = true)) "rtl" else "ltr")
        }
        return templates.process(TEMPLATE, context)
    }

    /** Writes the fallback page directly to the response (filters / error handlers). */
    fun write(response: HttpServletResponse, request: HttpServletRequest, status: HttpStatus) {
        if (response.isCommitted) return
        response.status = status.value()
        response.contentType = contentType(request)
        response.characterEncoding = Charsets.UTF_8.name()
        response.writer.write(render(request, status))
        response.writer.flush()
    }

    private fun contentType(request: HttpServletRequest): String {
        val accept = request.getHeader(HttpHeaders.ACCEPT)?.lowercase().orEmpty()
        return if (accept.contains(XHTML) && !accept.contains(MediaType.TEXT_HTML_VALUE)) {
            "$XHTML;charset=UTF-8"
        } else {
            "${MediaType.TEXT_HTML_VALUE};charset=UTF-8"
        }
    }
}
