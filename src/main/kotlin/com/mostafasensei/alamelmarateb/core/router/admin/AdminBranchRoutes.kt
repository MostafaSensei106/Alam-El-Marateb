package com.mostafasensei.alamelmarateb.core.router.admin

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object AdminBranchRoutes {
    private const val PREFIX = "${ApiVersion.V1}/admin/branches"

    const val BASE = PREFIX
    const val BY_ID = "/{id}"
    const val STATUS = "/{id}/status"
    const val VEHICLES = "${ApiVersion.V1}/admin/fleet/vehicles"
    const val VEHICLE_BY_ID = "${ApiVersion.V1}/admin/fleet/vehicles/{id}"
    const val SYSTEM_USERS = "${ApiVersion.V1}/admin/access/users"
    const val SYSTEM_ROLES = "${ApiVersion.V1}/admin/access/roles"
}