package com.mostafasensei.alamelmarateb.modules.security.application

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.transaction.annotation.Transactional
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue
@SpringBootTest
@Transactional
class AuthFlowTest {

    @Autowired
    private lateinit var authService: AuthService

    @Autowired
    private lateinit var identityService: IdentityService

    @Autowired
    private lateinit var txManager: org.springframework.transaction.PlatformTransactionManager

    @Test
    fun `register, login, refresh, me and duplicate rejection`() {
        val phone = "019${System.nanoTime().toString().takeLast(8)}"
        val pair = authService.register("Auth Customer", phone, "secret123", null)
        assertTrue(pair.accessToken.isNotBlank())
        assertTrue(pair.refreshToken.isNotBlank())

        val login = authService.login(phone, "secret123")
        assertEquals(pair.userId, login.userId)

        assertFailsWith<AuthService.UnauthorizedException> {
            authService.login(phone, "wrongpass")
        }
        assertFailsWith<com.mostafasensei.alamelmarateb.core.exceptions.ConflictException> {
            authService.register("Dup", phone, "secret123", null)
        }

        val rotated = authService.refresh(login.refreshToken)
        assertEquals(pair.userId, rotated.userId)

        val me = authService.me(pair.userId)
        assertEquals(listOf("ROLE_CUSTOMER"), me.roles)
    }

    @Test
    fun `staff lifecycle with roles and branch`() {
        val branchId: UUID = org.springframework.transaction.support.TransactionTemplate(
            txManager,
        ).apply { propagationBehavior = org.springframework.transaction.TransactionDefinition.PROPAGATION_REQUIRES_NEW }
            .execute<UUID> {
                identityService.createBranch("Auth Branch", "AB-${System.nanoTime()}", null, "Cairo", "Cairo St", "test").id!!
            }!!
        val branch = branchId.let { identityService.listBranches().first { b -> b.id == it } }
        assertTrue(branch.id != null)

        val phone = "018${System.nanoTime().toString().takeLast(8)}"
        val staff = identityService.createStaff(
            "Auth Cashier", phone, "secret123", null, branch.id, listOf("ROLE_CASHIER"), "test",
        )
        assertEquals(listOf("ROLE_CASHIER"), staff.roles)

        val login = authService.login(phone, "secret123")
        assertEquals(staff.id, login.userId)

        val updated = identityService.setRoles(staff.id!!, listOf("ROLE_CASHIER", "ROLE_WAREHOUSE_KEEPER"), "test")
        assertEquals(2, updated.roles.size)

        val toggled = identityService.toggleUser(staff.id!!, "test")
        assertEquals(false, toggled.isActive)
        assertFailsWith<AuthService.UnauthorizedException> {
            authService.login(phone, "secret123")
        }
    }
}
