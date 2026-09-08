package com.mostafasensei.alamelmarateb.modules.security.data.models

import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

data class User(
    val id: UUID? = null,
    val branchId: UUID? = null,
    val fullName: String,
    val email: String?,
    val phoneNumber: String,
    val passwordHash: String,
    val isActive: Boolean = true,
    val roles: Set<Role> = emptySet(),
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now()
)

data class Role(
    val id: UUID? = null,
    val name: String,
    val description: String? = null
)