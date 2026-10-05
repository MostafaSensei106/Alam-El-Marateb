package com.mostafasensei.alamelmarateb.core.security

import org.springframework.security.access.prepost.PreAuthorize

/**
 * Audience annotations — use these instead of raw @PreAuthorize strings.
 * Each one is the only place its role-set is spelled out; controllers just
 * declare their audience. URL-level matchers in SecurityConfig mirror the
 * same sets via [AppRole] (defense in depth).
 */
@Target(AnnotationTarget.FUNCTION, AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
annotation class ManagerApi

@Target(AnnotationTarget.FUNCTION, AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@PreAuthorize("hasAnyRole('SUPER_ADMIN')")
annotation class SuperAdminApi

@Target(AnnotationTarget.FUNCTION, AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@PreAuthorize("hasAnyRole('CUSTOMER', 'SUPER_ADMIN')")
annotation class CustomerApi

@Target(AnnotationTarget.FUNCTION, AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@PreAuthorize("hasAnyRole('CUSTOMER', 'CASHIER', 'BRANCH_MANAGER', 'SUPER_ADMIN')")
annotation class ShopApi

@Target(AnnotationTarget.FUNCTION, AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@PreAuthorize("hasAnyRole('WAREHOUSE_KEEPER', 'BRANCH_MANAGER', 'SUPER_ADMIN')")
annotation class KeeperApi

@Target(AnnotationTarget.FUNCTION, AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@PreAuthorize("hasAnyRole('CASHIER', 'BRANCH_MANAGER', 'SUPER_ADMIN')")
annotation class CashierApi

@Target(AnnotationTarget.FUNCTION, AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@PreAuthorize("hasAnyRole('DELIVERY_DRIVER', 'SUPER_ADMIN')")
annotation class DriverApi

@Target(AnnotationTarget.FUNCTION, AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@PreAuthorize("hasAnyRole('ACCOUNTANT', 'SUPER_ADMIN')")
annotation class AccountantApi

@Target(AnnotationTarget.FUNCTION, AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@PreAuthorize("isAuthenticated()")
annotation class AuthenticatedApi
