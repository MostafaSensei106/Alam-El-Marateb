package com.mostafasensei.alamelmarateb.core.config

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.context.annotation.Configuration
import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession

/**
 * Redis-backed HTTP sessions (Phase 1: infrastructure ready).
 *
 * The stateless JWT API is untouched — [SecurityConfig] keeps
 * STATELESS creation. Sessions are only created where code explicitly
 * uses them (future admin console), and then they survive restarts and
 * work behind any number of app instances.
 */
@Configuration
@ConditionalOnProperty(name = ["spring.session.store-type"], havingValue = "redis", matchIfMissing = true)
@EnableRedisHttpSession(
    maxInactiveIntervalInSeconds = 86400,
    redisNamespace = "alamelmarateb:session",
)
class RedisSessionConfig
