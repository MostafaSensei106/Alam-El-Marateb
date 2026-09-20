package com.mostafasensei.alamelmarateb.modules.security.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.security.JwtTokenProvider
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.notifications.application.NotificationService
import com.mostafasensei.alamelmarateb.modules.security.data.models.Role
import com.mostafasensei.alamelmarateb.modules.security.data.repository.PasswordResetTokenRepository
import com.mostafasensei.alamelmarateb.modules.security.data.repository.SpringDataJpaRoleRepository
import com.mostafasensei.alamelmarateb.modules.security.data.repository.SpringDataJpaUserRepository
import com.mostafasensei.alamelmarateb.modules.security.data.repository.UserRepository
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.PasswordResetTokenJpaEntity
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.UserJpaEntity
import org.slf4j.LoggerFactory
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.security.MessageDigest
import java.security.SecureRandom
import java.time.OffsetDateTime
import java.util.Base64
import java.util.UUID

data class TokenPair(val accessToken: String, val refreshToken: String, val userId: UUID)

data class AuthUserView(
    val id: UUID?,
    val fullName: String,
    val phoneNumber: String,
    val email: String?,
    val branchId: UUID?,
    val roles: List<String>,
    val isActive: Boolean,
)

@Service
class AuthService(
    private val userRepository: UserRepository,
    private val jpaUsers: SpringDataJpaUserRepository,
    private val jpaRoles: SpringDataJpaRoleRepository,
    private val passwordEncoder: PasswordEncoder,
    private val tokenProvider: JwtTokenProvider,
    private val resetTokens: PasswordResetTokenRepository,
    private val notifications: NotificationService,
    private val auditLog: AuditLogService,
) {

    private val log = LoggerFactory.getLogger(AuthService::class.java)

    @Transactional
    fun register(fullName: String, phone: String, password: String, email: String?): TokenPair {
        if (fullName.isBlank()) throw BadRequestException("error.auth.full_name_required")
        if (phone.isBlank()) throw BadRequestException("error.auth.phone_required")
        if (password.length < 6) throw BadRequestException("error.auth.password_short")
        if (userRepository.existsByPhoneNumber(phone)) throw ConflictException("error.auth.phone_exists")
        if (!email.isNullOrBlank() && userRepository.existsByEmail(email)) {
            throw ConflictException("error.auth.email_exists")
        }
        val customerRole = jpaRoles.findByName("ROLE_CUSTOMER")
            .orElseThrow { IllegalStateException("ROLE_CUSTOMER seed missing") }
        val saved = jpaUsers.save(
            UserJpaEntity(
                fullName = fullName.trim(), email = email?.trim()?.ifBlank { null },
                phoneNumber = phone.trim(), passwordHash = checkNotNull(passwordEncoder.encode(password)) { "Password encoding failed" },
                roles = mutableSetOf(customerRole),
            ),
        )
        return tokensFor(saved.id!!)
    }

    @Transactional(readOnly = true)
    fun login(phone: String, password: String): TokenPair {
        val user = userRepository.findByPhoneNumber(phone)
            ?: throw UnauthorizedException()
        if (!user.isActive) throw UnauthorizedException()
        if (!passwordEncoder.matches(password, user.passwordHash)) throw UnauthorizedException()
        return tokensFor(user.id!!)
    }

    @Transactional(readOnly = true)
    fun refresh(refreshToken: String): TokenPair {
        if (!tokenProvider.validateToken(refreshToken) || !tokenProvider.isRefreshToken(refreshToken)) {
            throw UnauthorizedException()
        }
        val userId = tokenProvider.getUserIdFromToken(refreshToken)
        val user = userRepository.findById(userId) ?: throw UnauthorizedException()
        if (!user.isActive) throw UnauthorizedException()
        // Stateless logout-everywhere: password change/reset bumps the version,
        // old refresh tokens (different or missing `tv`) stop working.
        if ((tokenProvider.tokenVersionOf(refreshToken) ?: 0) != user.tokenVersion) {
            throw UnauthorizedException()
        }
        return tokensFor(userId)
    }

    @Transactional(readOnly = true)
    fun me(userId: UUID): AuthUserView {
        val user = userRepository.findById(userId) ?: throw NotFoundException("error.auth.user_not_found")
        return AuthUserView(
            user.id, user.fullName, user.phoneNumber, user.email,
            user.branchId, user.roles.map { it.name }, user.isActive,
        )
    }

    /**
     * Authenticated password change (skills: backend-security-coder —
     * current-password check; auth-implementation-patterns — audit).
     * Bumps token_version: every other session/token dies immediately.
     */
    @Transactional
    fun changePassword(userId: UUID, currentPassword: String, newPassword: String) {
        if (newPassword.length < 6) throw BadRequestException("error.auth.password_short")
        val entity = jpaUsers.findById(userId)
            .orElseThrow { NotFoundException("error.auth.user_not_found") }
        if (!passwordEncoder.matches(currentPassword, entity.passwordHash)) {
            throw BadRequestException("error.auth.current_password_wrong")
        }
        entity.passwordHash = passwordEncoder.encode(newPassword)
        entity.tokenVersion += 1
        jpaUsers.save(entity)
        auditLog.record("PASSWORD_CHANGE", "user", userId, entity.branchId, userId.toString(), null)
    }

    /**
     * Forgot-password, phone-based (broken-authentication §10: no account
     * enumeration — identical response whether the phone exists or not).
     * Single-use 15-minute token, hash-only storage, delivered through the
     * notification channel (log today, SMS/WhatsApp when a sender is wired).
     */
    @Transactional
    fun forgotPassword(phone: String) {
        val user = userRepository.findByPhoneNumber(phone.trim())
        if (user == null || !user.isActive) return // generic response, no leak
        resetTokens.deleteByUserId(user.id!!)
        val raw = ByteArray(32).also { secureRandom.nextBytes(it) }
        val token = Base64.getUrlEncoder().withoutPadding().encodeToString(raw)
        resetTokens.save(
            PasswordResetTokenJpaEntity(
                userId = user.id,
                tokenHash = sha256Hex(token),
                expiresAt = OffsetDateTime.now().plusMinutes(15),
            ),
        )
        notifications.queue(
            channel = "log",
            recipient = user.phoneNumber,
            ref = "pwd-reset:${user.id}",
            titles = mapOf("ar" to "إعادة تعيين كلمة السر", "en" to "Password reset"),
            bodies = mapOf(
                "ar" to "كود إعادة التعيين (صالح 15 دقيقة، لمرة واحدة): $token",
                "en" to "Reset code (valid 15 minutes, single use): $token",
            ),
        )
        log.info("password reset requested user={}", user.id)
        auditLog.record("PASSWORD_RESET_REQUEST", "user", user.id, user.branchId, user.id.toString(), null)
    }

    /**
     * Consumes a reset token: single-use, expiry-bound, account-bound.
     * Also bumps token_version (logout-everywhere) and clears other tokens.
     */
    @Transactional
    fun resetPassword(token: String, newPassword: String) {
        if (newPassword.length < 6) throw BadRequestException("error.auth.password_short")
        val row = resetTokens.findByTokenHash(sha256Hex(token.trim())).orElse(null)
            ?: throw BadRequestException("error.auth.reset_invalid")
        if (row.usedAt != null) throw BadRequestException("error.auth.reset_used")
        if (row.expiresAt!!.isBefore(OffsetDateTime.now())) throw BadRequestException("error.auth.reset_expired")
        val entity = jpaUsers.findById(row.userId!!)
            .orElseThrow { BadRequestException("error.auth.reset_invalid") }
        if (!entity.isActive) throw BadRequestException("error.auth.reset_invalid")
        entity.passwordHash = passwordEncoder.encode(newPassword)
        entity.tokenVersion += 1
        jpaUsers.save(entity)
        // Clear outstanding sibling tokens, then keep this one as the
        // consumed single-use marker.
        resetTokens.deleteByUserId(entity.id!!)
        row.usedAt = OffsetDateTime.now()
        resetTokens.save(row)
        auditLog.record("PASSWORD_RESET", "user", entity.id, entity.branchId, entity.id.toString(), null)
    }

    fun managedRole(name: String): com.mostafasensei.alamelmarateb.modules.security.domain.entity.RoleJpaEntity =
        jpaRoles.findByName(name).orElseThrow { BadRequestException("error.auth.unknown_role", listOf(name)) }

    private fun tokensFor(userId: UUID): TokenPair {
        val user = userRepository.findById(userId)!!
        val principal = UserPrincipal.create(user)
        val authentication = UsernamePasswordAuthenticationToken(principal, null, principal.authorities)
        return TokenPair(
            accessToken = tokenProvider.generateToken(authentication),
            refreshToken = tokenProvider.generateRefreshToken(userId, user.tokenVersion),
            userId = userId,
        )
    }

    class UnauthorizedException : RuntimeException("Invalid phone or password")

    companion object {
        private val secureRandom = SecureRandom()

        fun sha256Hex(raw: String): String {
            val digest = MessageDigest.getInstance("SHA-256").digest(raw.toByteArray(Charsets.UTF_8))
            return digest.joinToString("") { "%02x".format(it) }
        }
    }
}

data class RoleView(val id: UUID?, val name: String, val description: String?)

fun Role.toView() = RoleView(id, name, description)
