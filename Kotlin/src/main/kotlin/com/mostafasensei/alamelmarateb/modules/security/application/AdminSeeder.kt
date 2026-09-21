package com.mostafasensei.alamelmarateb.modules.security.application

import com.mostafasensei.alamelmarateb.modules.security.data.repository.SpringDataJpaRoleRepository
import com.mostafasensei.alamelmarateb.modules.security.data.repository.SpringDataJpaUserRepository
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.BranchJpaEntity
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.UserJpaEntity
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.CommandLineRunner
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Component

/**
 * First-boot seed: Main branch + super-admin user.
 * Runs ONLY when no SUPER_ADMIN exists. Configure via env:
 * ADMIN_PHONE (default 01000000000), ADMIN_PASSWORD (default admin123 — change immediately),
 * ADMIN_NAME (default System Admin).
 */
@Component
class AdminSeeder(
    private val users: SpringDataJpaUserRepository,
    private val roles: SpringDataJpaRoleRepository,
    private val branches: SpringDataJpaBranchRepository,
    private val passwordEncoder: PasswordEncoder,
    @Value("\${ADMIN_PHONE:01000000000}") private val adminPhone: String,
    @Value("\${ADMIN_PASSWORD:admin123}") private val adminPassword: String,
    @Value("\${ADMIN_NAME:System Admin}") private val adminName: String,
) : CommandLineRunner {

    private val log = LoggerFactory.getLogger(javaClass)

    override fun run(vararg args: String) {
        val hasAdmin = users.findAll().any { u -> u.roles.any { it.name == "ROLE_SUPER_ADMIN" } }
        if (hasAdmin) return
        val branch = branches.save(
            BranchJpaEntity(name = "Main Branch", code = "MAIN", phone = adminPhone, city = "Tanta", address = "Tanta"),
        )
        val superAdmin = roles.findByName("ROLE_SUPER_ADMIN")
            .orElseThrow { IllegalStateException("ROLE_SUPER_ADMIN seed missing — is V1 applied?") }
        users.save(
            UserJpaEntity(
                branchId = branch.id, fullName = adminName, phoneNumber = adminPhone,
                passwordHash = checkNotNull(passwordEncoder.encode(adminPassword)) { "Password encoding failed" },
                roles = mutableSetOf(superAdmin),
            ),
        )
        log.warn("Seeded super-admin {} on branch MAIN — change ADMIN_PASSWORD immediately!", adminPhone)
    }
}
