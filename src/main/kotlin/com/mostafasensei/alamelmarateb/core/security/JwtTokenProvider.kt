package com.mostafasensei.alamelmarateb.core.security

import io.jsonwebtoken.Claims
import io.jsonwebtoken.JwtException
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.security.Keys
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.core.Authentication
import org.springframework.stereotype.Component
import java.nio.charset.StandardCharsets
import java.util.Date
import java.util.UUID
import javax.crypto.SecretKey


@Component
class JwtTokenProvider(
    @Value("\${app.jwt.secret}") private val jwtSecret: String,
    @Value("\${app.jwt.expiration-ms:86400000}") private val jwtExpirationMs: Long,
    @Value("\${app.jwt.refresh-expiration-ms:604800000}") private val refreshExpirationMs: Long,
) {

    private val key: SecretKey by lazy {
        Keys.hmacShaKeyFor(jwtSecret.toByteArray(StandardCharsets.UTF_8))
    }

    fun generateToken(authentication: Authentication): String {
        val userPrincipal = authentication.principal as UserPrincipal
        val now = Date()
        val expiryDate = Date(now.time + jwtExpirationMs)

        return Jwts.builder()
            .subject(userPrincipal.id.toString())
            .claim("branchId", userPrincipal.branchId?.toString())
            .claim("phone", userPrincipal.username)
            .claim("roles", userPrincipal.authorities.map { it.authority })
            .issuedAt(now)
            .expiration(expiryDate)
            .signWith(key)
            .compact()
    }

    fun generateRefreshToken(userId: UUID): String {
        val now = Date()
        return Jwts.builder()
            .subject(userId.toString())
            .claim("type", "refresh")
            .issuedAt(now)
            .expiration(Date(now.time + refreshExpirationMs))
            .signWith(key)
            .compact()
    }

    fun isRefreshToken(token: String): Boolean {
        return try {
            val claims: Claims = Jwts.parser().verifyWith(key).build().parseSignedClaims(token).payload
            claims["type"] == "refresh"
        } catch (_: Exception) {
            false
        }
    }

    fun getUserIdFromToken(token: String): UUID {
        val claims: Claims = Jwts.parser()
            .verifyWith(key)
            .build()
            .parseSignedClaims(token)
            .payload

        return UUID.fromString(claims.subject)
    }

    fun validateToken(authToken: String): Boolean {
        return try {
            Jwts.parser().verifyWith(key).build().parseSignedClaims(authToken)
            true
        } catch (_: JwtException) {
            false
        } catch (_: IllegalArgumentException) {
            false
        }
    }
}