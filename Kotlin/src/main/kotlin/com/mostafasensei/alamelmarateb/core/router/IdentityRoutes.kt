package com.mostafasensei.alamelmarateb.core.router

/**
 * Auth routes — owning module: identity.
 * Audience: public (login / register / refresh / social).
 * Access: permitAll.
 */
object AuthRoutes {
    private const val PREFIX = "/api/v1/auth"

    const val BASE = PREFIX
}

/**
 * Identity administration routes — owning module: identity.
 * Audience: system administration (branches, users, roles, fleet).
 * Required roles: SUPER_ADMIN for everything under /identity
 * (SecurityConfig + @SuperAdminApi agree; managers use their own modules).
 */
object IdentityAdminRoutes {
    private const val PREFIX = "/api/v1/identity"

    const val BASE = PREFIX
    const val BRANCHES = "$PREFIX/branches"
    const val BRANCH_TOGGLE = "$PREFIX/branches/{id}/toggle"

    const val USERS = "$PREFIX/access/users"
    const val ROLES = "$PREFIX/access/roles"

    const val VEHICLES = "$PREFIX/fleet/vehicles"
    const val VEHICLE_BY_ID = "$PREFIX/fleet/vehicles/{id}"
}
