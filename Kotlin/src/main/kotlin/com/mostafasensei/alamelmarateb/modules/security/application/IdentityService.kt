package com.mostafasensei.alamelmarateb.modules.security.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.cache.RedisCache
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
import java.time.Duration
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
    private val cache: RedisCache,
) {

    companion object {
        private val REF_TTL: Duration = Duration.ofHours(1)
    }

    @Transactional(readOnly = true)
    fun listBranches(): List<BranchView> =
        cache.getOrLoadList("ref:branches", REF_TTL, BranchView::class.java) { branches.findAll().map { toBranchView(it) } }

    @Transactional
    fun createBranch(name: String, code: String, phone: String?, city: String, address: String, by: String?): BranchView {
        if (name.isBlank()) throw BadRequestException("error.branch.name_required")
        val normalized = code.trim().uppercase()
        if (normalized.isBlank()) throw BadRequestException("error.branch.code_required")
        if (branches.existsByCode(normalized)) throw ConflictException("error.branch.code_exists", listOf(code))
        val saved = branches.save(
            BranchJpaEntity(name = name.trim(), code = normalized, phone = phone, city = city.ifBlank { "Tanta" }, address = address),
        )
        auditLog.record("BRANCH_CREATE", "branch", null, null, by, normalized)
        cache.evict("ref:branches")
        return toBranchView(saved)
    }

    @Transactional
    fun toggleBranch(id: UUID, by: String?): BranchView {
        val entity = branches.findById(id).orElseThrow { NotFoundException("error.branch.not_found") }
        entity.isActive = !entity.isActive
        auditLog.record("BRANCH_TOGGLE", "branch", id, null, by, "active=${entity.isActive}")
        cache.evict("ref:branches")
        return toBranchView(branches.save(entity))
    }

    @Transactional(readOnly = true)
    fun listRoles(): List<RoleView> =
        cache.getOrLoadList("ref:roles", REF_TTL, RoleView::class.java) { roles.findAll().map { RoleView(it.id, it.name, it.description) } }

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
        if (fullName.isBlank()) throw BadRequestException("error.auth.full_name_required")
        if (users.existsByPhoneNumber(phone)) throw ConflictException("error.auth.phone_exists")
        if (password.length < 6) throw BadRequestException("error.auth.password_short")
        if (roleNames.isEmpty()) throw BadRequestException("error.user.role_required")
        val managed = roleNames.map {
            roles.findByName(it).orElseThrow { BadRequestException("error.auth.unknown_role", listOf(it)) }
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
        if (roleNames.isEmpty()) throw BadRequestException("error.user.role_required")
        val user = users.findById(userId).orElseThrow { NotFoundException("error.auth.user_not_found") }
        user.roles = roleNames.map {
            roles.findByName(it).orElseThrow { BadRequestException("error.auth.unknown_role", listOf(it)) }
        }.toMutableSet()
        auditLog.record("USER_ROLES", "user", userId, user.branchId, by, roleNames.joinToString(","))
        return toStaffView(users.save(user))
    }

    @Transactional
    fun toggleUser(userId: UUID, by: String?): StaffView {
        val user = users.findById(userId).orElseThrow { NotFoundException("error.auth.user_not_found") }
        user.isActive = !user.isActive
        auditLog.record("USER_TOGGLE", "user", userId, user.branchId, by, "active=${user.isActive}")
        return toStaffView(users.save(user))
    }

    private fun toBranchView(e: BranchJpaEntity) =
        BranchView(e.id, e.name, e.code, e.phone?.ifBlank { null }, e.city, e.isActive)

    private fun toStaffView(e: UserJpaEntity) = StaffView(
        e.id, e.fullName, e.phoneNumber, e.email, e.branchId,
        e.roles.map { it.name }, e.isActive,
    )
}
