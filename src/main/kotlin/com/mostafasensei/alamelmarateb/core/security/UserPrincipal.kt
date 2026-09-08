package com.mostafasensei.alamelmarateb.core.security

import com.mostafasensei.alamelmarateb.modules.security.data.models.User
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails
import java.util.UUID

class UserPrincipal(
    var id: UUID,
    var branchId: UUID?,
    var fullName: String,
    private val phoneNumber: String,
    private val passwordHash: String,
    private val active: Boolean,
    private val authorities: Collection<GrantedAuthority>
    ) : UserDetails {
    override fun getAuthorities(): Collection<GrantedAuthority> = authorities
    override fun getPassword(): String = passwordHash
    override fun getUsername(): String = phoneNumber
    override fun isAccountNonExpired(): Boolean = true
    override fun isAccountNonLocked(): Boolean = active
    override fun isCredentialsNonExpired(): Boolean = true
    override fun isEnabled(): Boolean = active

    companion object {
        fun create(user: User): UserPrincipal {
            val authorities = user.roles.map {  SimpleGrantedAuthority(it.name) }
            return UserPrincipal(
                id = user.id ?: throw IllegalStateException("User ID cannot be null"),
                branchId = user.branchId,
                fullName = user.fullName,
                phoneNumber = user.phoneNumber,
                passwordHash = user.passwordHash,
                active = user.isActive,
                authorities = authorities
            )
        }
    }

}