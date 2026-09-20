package com.mostafasensei.alamelmarateb.core.cache

import org.slf4j.LoggerFactory
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.stereotype.Component
import tools.jackson.databind.JavaType
import tools.jackson.databind.ObjectMapper
import java.time.Duration

/**
 * Best-effort Redis cache-aside (docs/modules/analytics.md 4).
 *
 * - Hit -> deserialized value. Miss/error -> [loader] runs and the result
 *   is stored with [ttl]. Redis down or serialization trouble NEVER fails
 *   the request: we log and fall through to the loader.
 * - Values are JSON via the app ObjectMapper (Kotlin module), so no
 *   JDK-serialization constraints on domain models.
 * - TTL bounds staleness; mutations evict exact keys (see callers).
 */
@Component
class RedisCache(
    private val redis: StringRedisTemplate,
    private val objectMapper: ObjectMapper,
) {

    private val log = LoggerFactory.getLogger(RedisCache::class.java)

    fun <T : Any> getOrLoad(
        key: String,
        ttl: Duration,
        type: Class<T>,
        loader: () -> T?,
    ): T? {
        read(key, type)?.let { return it }
        val loaded = loader() ?: return null
        write(key, loaded, ttl)
        return loaded
    }

    fun <T : Any> getOrLoadList(
        key: String,
        ttl: Duration,
        element: Class<T>,
        loader: () -> List<T>,
    ): List<T> {
        readList(key, element)?.let { return it }
        val loaded = loader()
        write(key, loaded, ttl)
        return loaded
    }

    fun evict(vararg keys: String) {
        if (keys.isEmpty()) return
        try {
            redis.delete(keys.toList())
        } catch (ex: Exception) {
            log.warn("redis evict failed keys={}: {}", keys.toList(), ex.message)
        }
    }

    fun <T : Any> read(key: String, type: Class<T>): T? {
        return try {
            val json = redis.opsForValue().get(key) ?: return null
            objectMapper.readValue(json, type)
        } catch (ex: Exception) {
            log.warn("redis read failed key={}: {}", key, ex.message)
            null
        }
    }

    fun <T : Any> readList(key: String, element: Class<T>): List<T>? {
        return try {
            val json = redis.opsForValue().get(key) ?: return null
            val listType: JavaType =
                objectMapper.typeFactory.constructCollectionType(List::class.java, element)
            objectMapper.readValue(json, listType)
        } catch (ex: Exception) {
            log.warn("redis read failed key={}: {}", key, ex.message)
            null
        }
    }

    fun write(key: String, value: Any, ttl: Duration) {
        try {
            redis.opsForValue().set(key, objectMapper.writeValueAsString(value), ttl)
        } catch (ex: Exception) {
            log.warn("redis write failed key={}: {}", key, ex.message)
        }
    }
}
