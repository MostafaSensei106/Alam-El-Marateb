package com.mostafasensei.alamelmarateb.core.security

/**
 * Canonical application roles — the single source of truth.
 * [roleName] is the Spring Security authority (ROLE_*); [names] feeds
 * both the URL matchers in SecurityConfig and the method annotations
 * in this package, so role strings never appear as literals elsewhere.
 */
enum class AppRole(val roleName: String) {
    SUPER_ADMIN("ROLE_SUPER_ADMIN"),
    BRANCH_MANAGER("ROLE_BRANCH_MANAGER"),
    CASHIER("ROLE_CASHIER"),
    WAREHOUSE_KEEPER("ROLE_WAREHOUSE_KEEPER"),
    DELIVERY_DRIVER("ROLE_DELIVERY_DRIVER"),
    ACCOUNTANT("ROLE_ACCOUNTANT"),
    CUSTOMER("ROLE_CUSTOMER"),
    ;

    companion object {
        /** Short names for hasAnyRole(...). */
        fun names(vararg roles: AppRole): Array<String> =
            roles.map { it.name }.toTypedArray()

        fun fromAuthority(authority: String): AppRole? =
            entries.firstOrNull { it.roleName == authority }
    }
}
