package com.mostafasensei.alamelmarateb.modules.security.domain.model

import org.hibernate.validator.constraints.UUID
import kotlin.time.Clock
import kotlin.time.Instant

data class UserRole(
    val id: UUID? = null,
    val name: String,
    val description: String,
)

data class User(
    val id : UUID? = null,
    val branchId: UUID? = null,
    val fullName: String,
    val email: String,
    val phoneNumber: String,
    val passwordHash:String,
    val isActive: Boolean,
    val roles: Set<UserRole> = emptySet(),
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now(),
    )
