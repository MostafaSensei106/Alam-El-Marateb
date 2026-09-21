package com.mostafasensei.alamelmarateb.core.router.api

import com.mostafasensei.alamelmarateb.core.router.ApiRoutes

/**
 * API versioning policy.
 *
 * - V1 is the current stable version.
 * - A new version (V2, ...) is created ONLY on a breaking change
 *   and ONLY for the affected resource, old version keeps working.
 * - Deprecated versions expose `X-API-Deprecated: true` + `Sunset` header
 *   (see [ApiVersionHeaders]).
 * - Do NOT pre-create V2..V8 upfront.
 */
object ApiVersion {
    const val V1 = "v1"
    const val CURRENT = V1

    /** Prefix: /api/v1 — kept as literal so feature routes stay compile-time const. */
    const val V1_PREFIX: String = "/api/v1"

    val SUPPORTED: Set<String> = setOf(V1)

    fun isSupported(version: String): Boolean = version in SUPPORTED

    fun prefix(version: String = CURRENT): String = "${ApiRoutes.API}/$version"
}

object ApiVersionHeaders {
    const val DEPRECATED = "X-API-Deprecated"
    const val SUNSET = "Sunset"
}
