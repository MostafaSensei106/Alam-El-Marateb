package com.mostafasensei.alamelmarateb.core.security

import org.slf4j.LoggerFactory
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.stereotype.Component
import java.time.Duration
import java.time.Instant
import java.util.concurrent.ConcurrentHashMap

/**
 * Sliding-window limiter with Redis backing (multi-instance safe).
 * Redis unavailable -> transparent in-memory fallback (single-instance semantics).
 */
@Component
class RedisRateLimiter(
    private val redis: StringRedisTemplate,
) {

    private data class Window(var count: Int, var resetAt: Long)

    private val memory = ConcurrentHashMap<String, Window>()
    private val log = LoggerFactory.getLogger(RedisRateLimiter::class.java)

    data class Verdict(val allowed: Boolean, val retryAfterSeconds: Long)

    fun check(key: String, limitPerMinute: Int): Verdict {
        try {
            val redisKey = "ratelimit:$key"
            val count = redis.opsForValue().increment(redisKey) ?: return allowMemory(key, limitPerMinute)
            if (count == 1L) redis.expire(redisKey, Duration.ofMinutes(1))
            if (count > limitPerMinute) {
                val ttl = redis.getExpire(redisKey).coerceAtLeast(1)
                return Verdict(false, ttl)
            }
            return Verdict(true, 0)
        } catch (ex: Exception) {
            log.warn("redis rate-limit unavailable, memory fallback: {}", ex.message)
            return allowMemory(key, limitPerMinute)
        }
    }

    private fun allowMemory(key: String, limit: Int): Verdict {
        val now = Instant.now().epochSecond
        val window = memory.compute(key) { _, existing ->
            if (existing == null || now >= existing.resetAt) Window(1, now + 60)
            else existing.copy(count = existing.count + 1)
        }!!
        return if (window.count > limit) Verdict(false, (window.resetAt - now).coerceAtLeast(1))
        else Verdict(true, 0)
    }
}
