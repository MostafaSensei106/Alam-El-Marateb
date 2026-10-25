package com.mostafasensei.alamelmarateb.modules.security.domain.entity

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.time.OffsetDateTime
import java.util.UUID

/**
 * Single-use password reset token (broken-authentication §10: expiry-bound,
 * account-bound, single-use; only the SHA-256 hash is stored).
 */
@Entity
@Table(name = "password_reset_tokens")
class PasswordResetTokenJpaEntity(
    @Id
    @Column(name = "id", nullable = false, updatable = false)
    var id: UUID = UUID.randomUUID(),

    @Column(name = "user_id", nullable = false)
    var userId: UUID? = null,

    @Column(name = "token_hash", nullable = false, unique = true, length = 64)
    var tokenHash: String = "",

    @Column(name = "expires_at", nullable = false)
    var expiresAt: OffsetDateTime = OffsetDateTime.now().plusMinutes(15),

    @Column(name = "used_at")
    var usedAt: OffsetDateTime? = null,

    @Column(name = "created_at", nullable = false, updatable = false)
    var createdAt: OffsetDateTime = OffsetDateTime.now(),
)
