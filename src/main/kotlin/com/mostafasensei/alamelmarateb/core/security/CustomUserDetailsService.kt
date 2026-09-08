package com.mostafasensei.alamelmarateb.core.security

import com.mostafasensei.alamelmarateb.modules.security.data.models.User
import com.mostafasensei.alamelmarateb.modules.security.data.repository.UserRepository
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Service
class CustomUserDetailsService(
    private val userRepository: UserRepository,
) : UserDetailsService {

    override fun loadUserByUsername(username: String): UserDetails {
        val user = userRepository.findByPhoneNumber(username)
            ?: throw UsernameNotFoundException("User not found with phone: $username")
        return UserPrincipal.create(user)
    }


    fun loadUserById(userId: UUID): UserDetails {
        var user = userRepository.findById(userId)
            ?: throw UsernameNotFoundException("User not found with id: $userId")
        return UserPrincipal.create(user)
    }
}