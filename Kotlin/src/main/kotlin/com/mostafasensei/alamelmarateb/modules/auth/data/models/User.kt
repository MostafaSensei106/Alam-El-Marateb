package com.mostafasensei.alamelmarateb.modules.auth.data.models

import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

/**
 * Authenticated user aggregate.
 *
 * Required: [id] (always assigned, never null), [fullName], [phoneNumber], [passwordHash], [createdAt], [updatedAt].
 * Optional: [branchId], [email], [roles] (defaults to empty).
 */
data class User(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Optional.** Home branch; `null` for cross-branch accounts. */
    val branchId: UUID? = null,
    /** **Required.** Display name. */
    val fullName: String,
    /** **Optional.** Email; nullable because phone-only accounts exist. */
    val email: String?,
    /** **Required.** Unique login phone. */
    val phoneNumber: String,
    /** **Required.** BCrypt hash; never the plain password. */
    val passwordHash: String,
    val isActive: Boolean = true,
    val tokenVersion: Int = 0,
    val roles: Set<Role> = emptySet(),
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now()
)

/**
 * Security role.
 *
 * Required: [id] (always assigned, never null), [name].
 * Optional: [description].
 */
data class Role(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Required.** Unique role name (e.g. `ADMIN`). */
    val name: String,
    /** **Optional.** Human-readable description. */
    val description: String? = null
)