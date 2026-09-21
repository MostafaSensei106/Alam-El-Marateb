package com.mostafasensei.alamelmarateb.core.router

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

/**
 * Single source of truth for API prefixes.
 *
 * Rule: route objects must be version-agnostic (relative paths only).
 * The version is composed here / at the controller base mapping,
 * never hardcoded inside feature route files.
 */
object ApiRoutes {
    const val API = "/api"

    fun versioned(version: String = ApiVersion.CURRENT, path: String): String {
        val normalized = if (path.startsWith("/")) path else "/$path"
        return "$API/$version$normalized"
    }

    fun v1(path: String): String = versioned(ApiVersion.V1, path)
}
