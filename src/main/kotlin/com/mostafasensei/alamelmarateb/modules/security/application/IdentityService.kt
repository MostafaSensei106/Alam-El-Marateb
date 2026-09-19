package com.mostafasensei.alamelmarateb.modules.security.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.security.data.repository.SpringDataJpaRoleRepository
import com.mostafasensei.alamelmarateb.modules.security.data.repository.SpringDataJpaUserRepository
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.BranchJpaEntity
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.UserJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Repository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Repository
interface SpringDataJpaBranchRepository : JpaRepository<BranchJpaEntity, UUID> {
    fun existsByCode(code: String): Boolean
}

data class BranchView(
    val id: UUID?,
    val name: String,
    val code: String,
    val phone: String?,
    val city: String,
    val isActive: Boolean,
)

data class StaffView(
    val id: UUID?,
    val fullName: String,
    val phoneNumber: String,
    val email: String?,
    val branchId: UUID?,
    val roles: List<String>,
    val isActive: Boolean,
)

@Service
class IdentityService(
    private val branches: SpringDataJpaBranchRepository,
    private val users: SpringDataJpaUserRepository,
    private val roles: SpringDataJpaRoleRepository,
    private val passwordEncoder: PasswordEncoder,
    private val auditLog: AuditLogService,
) {

    @Transactional(readOnly = true)
    fun listBranches(): List<BranchView> = branches.findAll().map { toBranchView(it) }

    @Transactional
    fun createBranch(name: String, code: String, phone: String?, city: String, by: String?): BranchView {
        if (name.isBlank()) throw BadRequestException("Branch name is required")
        val normalized = code.trim().uppercase()
        if (normalized.isBlank()) throw BadRequestException("Branch code is required")
        if (branches.existsByCode(normalized)) throw ConflictException("Branch code exists: $code")
        val saved = branches.save(
            BranchJpaEntity(name = name.trim(), code = normalized, phone = phone ?: "", city = city.ifBlank { "Tanta" }),
        )
        auditLog.record("BRANCH_CREATE", "branch", null, null, by, normalized)
        return toBranchView(saved)
    }

    @Transactional
    fun toggleBranch(id: UUID, by: String?): BranchView {
        val entity = branches.findById(id).orElseThrow { NotFoundException("Branch not found") }
        entity.isActive = !entity.isActive
        auditLog.record("BRANCH_TOGGLE", "branch", id, null, by, "active=${entity.isActive}")
        return toBranchView(branches.save(entity))
    }

    @Transactional(readOnly = true)
    fun listRoles(): List<RoleView> = roles.findAll().map { RoleView(it.id, it.name, it.description) }

    @Transactional(readOnly = true)
    fun listUsers(branchId: UUID?): List<StaffView> {
        val entities = if (branchId == null) users.findAll() else users.findAllByBranchId(branchId)
        return entities.map { toStaffView(it) }
    }

    @Transactional
    fun createStaff(
        fullName: String, phone: String, password: String, email: String?,
        branchId: UUID?, roleNames: List<String>, by: String?,
    ): StaffView {
        if (fullName.isBlank()) throw BadRequestException("Full name is required")
        if (users.existsByPhoneNumber(phone)) throw ConflictException("Phone already registered")
        if (password.length < 6) throw BadRequestException("Password must be at least 6 characters")
        if (roleNames.isEmpty()) throw BadRequestException("At least one role is required")
        val managed = roleNames.map {
            roles.findByName(it).orElseThrow { BadRequestException("Unknown role: $it") }
        }.toMutableSet()
        val saved = users.save(
            UserJpaEntity(
                branchId = branchId, fullName = fullName.trim(),
                email = email?.trim()?.ifBlank { null }, phoneNumber = phone.trim(),
                passwordHash = checkNotNull(passwordEncoder.encode(password)) { "Password encoding failed" }, roles = managed,
            ),
        )
        auditLog.record("USER_CREATE", "user", saved.id, branchId, by, roleNames.joinToString(","))
        return toStaffView(saved)
    }

    @Transactional
    fun setRoles(userId: UUID, roleNames: List<String>, by: String?): StaffView {
        if (roleNames.isEmpty()) throw BadRequestException("At least one role is required")
        val user = users.findById(userId).orElseThrow { NotFoundException("User not found") }
        user.roles = roleNames.map {
            roles.findByName(it).orElseThrow { BadRequestException("Unknown role: $it") }
        }.toMutableSet()
        auditLog.record("USER_ROLES", "user", userId, user.branchId, by, roleNames.joinToString(","))
        return toStaffView(users.save(user))
    }

    @Transactional
    fun toggleUser(userId: UUID, by: String?): StaffView {
        val user = users.findById(userId).orElseThrow { NotFoundException("User not found") }
        user.isActive = !user.isActive
        auditLog.record("USER_TOGGLE", "user", userId, user.branchId, by, "active=${user.isActive}")
        return toStaffView(users.save(user))
    }

    private fun toBranchView(e: BranchJpaEntity) =
        BranchView(e.id, e.name, e.code, e.phone.ifBlank { null }, e.city, e.isActive)

    private fun toStaffView(e: UserJpaEntity) = StaffView(
        e.id, e.fullName, e.phoneNumber, e.email, e.branchId,
        e.roles.map { it.name }, e.isActive,
    )
}
