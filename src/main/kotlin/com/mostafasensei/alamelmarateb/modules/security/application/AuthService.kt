package com.mostafasensei.alamelmarateb.modules.security.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.security.JwtTokenProvider
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.security.data.models.Role
import com.mostafasensei.alamelmarateb.modules.security.data.repository.SpringDataJpaRoleRepository
import com.mostafasensei.alamelmarateb.modules.security.data.repository.SpringDataJpaUserRepository
import com.mostafasensei.alamelmarateb.modules.security.data.repository.UserRepository
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.UserJpaEntity
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
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
) {

    @Transactional
    fun register(fullName: String, phone: String, password: String, email: String?): TokenPair {
        if (fullName.isBlank()) throw BadRequestException("Full name is required")
        if (phone.isBlank()) throw BadRequestException("Phone number is required")
        if (password.length < 6) throw BadRequestException("Password must be at least 6 characters")
        if (userRepository.existsByPhoneNumber(phone)) throw ConflictException("Phone already registered")
        if (!email.isNullOrBlank() && userRepository.existsByEmail(email)) {
            throw ConflictException("Email already registered")
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
        return tokensFor(userId)
    }

    @Transactional(readOnly = true)
    fun me(userId: UUID): AuthUserView {
        val user = userRepository.findById(userId) ?: throw NotFoundException("User not found")
        return AuthUserView(
            user.id, user.fullName, user.phoneNumber, user.email,
            user.branchId, user.roles.map { it.name }, user.isActive,
        )
    }

    fun managedRole(name: String): com.mostafasensei.alamelmarateb.modules.security.domain.entity.RoleJpaEntity =
        jpaRoles.findByName(name).orElseThrow { BadRequestException("Unknown role: $name") }

    private fun tokensFor(userId: UUID): TokenPair {
        val principal = UserPrincipal.create(userRepository.findById(userId)!!)
        val authentication = UsernamePasswordAuthenticationToken(principal, null, principal.authorities)
        return TokenPair(
            accessToken = tokenProvider.generateToken(authentication),
            refreshToken = tokenProvider.generateRefreshToken(userId),
            userId = userId,
        )
    }

    class UnauthorizedException : RuntimeException("Invalid phone or password")
}

data class RoleView(val id: UUID?, val name: String, val description: String?)

fun Role.toView() = RoleView(id, name, description)
