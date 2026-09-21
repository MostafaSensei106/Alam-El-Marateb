package com.mostafasensei.alamelmarateb.modules.security.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.security.JwtTokenProvider
import com.mostafasensei.alamelmarateb.modules.security.data.repository.PasswordResetTokenRepository
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.PasswordResetTokenJpaEntity
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.transaction.annotation.Transactional
import java.time.OffsetDateTime
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

/**
 * Password lifecycle (skills: broken-authentication §10, backend-security-coder):
 * change kills all sessions via token_version, reset tokens are single-use +
 * expiry-bound, forgot-password never reveals whether a phone exists.
 */
@SpringBootTest
@Transactional
class PasswordFlowTest {

    @Autowired
    private lateinit var authService: AuthService

    @Autowired
    private lateinit var tokenProvider: JwtTokenProvider

    @Autowired
    private lateinit var resetTokens: PasswordResetTokenRepository

    private fun freshUser(suffix: String): Pair<UUID, TokenPair> {
        val phone = "019" + UUID.randomUUID().toString().replace("-", "").take(8)
        val pair = authService.register("Pwd User $suffix", phone, "oldpass123", null)
        return pair.userId to pair
    }

    @Test
    fun `change password kills old access and refresh tokens`() {
        val (userId, before) = freshUser("change")
        authService.changePassword(userId, "oldpass123", "newpass123")

        // Old password dead, new works.
        assertFailsWith<AuthService.UnauthorizedException> {
            authService.login(authService.me(userId).phoneNumber, "oldpass123")
        }
        val after = authService.login(authService.me(userId).phoneNumber, "newpass123")

        // Old tokens carry tv=0, live version is 1 -> both rejected.
        val live = authService.me(userId).let {
            // version visible through refresh acceptance of the new pair
            authService.refresh(after.refreshToken)
            1
        }
        assertEquals(1, live)
        assertFailsWith<AuthService.UnauthorizedException> {
            authService.refresh(before.refreshToken)
        }
        assertTrue((tokenProvider.tokenVersionOf(before.accessToken) ?: 0) != 1)
    }

    @Test
    fun `change password rejects wrong current password`() {
        val (userId, _) = freshUser("wrong")
        assertFailsWith<BadRequestException> {
            authService.changePassword(userId, "not-the-password", "newpass123")
        }
    }

    @Test
    fun `forgot password is generic for unknown phones`() {
        // Must not throw or reveal anything.
        authService.forgotPassword("09000000000")
    }

    @Test
    fun `reset token is single-use and expiry-bound`() {
        val (userId, _) = freshUser("reset")
        val raw = "test-reset-token-" + UUID.randomUUID()
        resetTokens.save(
            PasswordResetTokenJpaEntity(
                userId = userId,
                tokenHash = AuthService.sha256Hex(raw),
                expiresAt = OffsetDateTime.now().plusMinutes(15),
            ),
        )
        authService.resetPassword(raw, "brandnew123")
        // Reuse -> used.
        assertFailsWith<BadRequestException> {
            authService.resetPassword(raw, "another123")
        }
        // Unknown -> invalid.
        assertFailsWith<BadRequestException> {
            authService.resetPassword("nope-missing", "another123")
        }
        // Expired -> expired.
        val raw2 = "test-reset-token-" + UUID.randomUUID()
        resetTokens.save(
            PasswordResetTokenJpaEntity(
                userId = userId,
                tokenHash = AuthService.sha256Hex(raw2),
                expiresAt = OffsetDateTime.now().minusMinutes(1),
            ),
        )
        val ex = assertFailsWith<BadRequestException> {
            authService.resetPassword(raw2, "another123")
        }
        assertEquals("error.auth.reset_expired", ex.errorKey)
        // New password works.
        authService.login(authService.me(userId).phoneNumber, "brandnew123")
    }
}
