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
 * Required roles: BRANCH_MANAGER, SUPER_ADMIN for branches/fleet;
 * access (users/roles) additionally narrowed via @PreAuthorize to SUPER_ADMIN.
 */
object IdentityAdminRoutes {
    private const val PREFIX = "/api/v1/identity"

    const val BRANCHES = "$PREFIX/branches"
    const val BRANCH_BY_ID = "$PREFIX/branches/{id}"
    const val BRANCH_STATUS = "$PREFIX/branches/{id}/status"

    const val USERS = "$PREFIX/access/users"
    const val ROLES = "$PREFIX/access/roles"

    const val VEHICLES = "$PREFIX/fleet/vehicles"
    const val VEHICLE_BY_ID = "$PREFIX/fleet/vehicles/{id}"
}
