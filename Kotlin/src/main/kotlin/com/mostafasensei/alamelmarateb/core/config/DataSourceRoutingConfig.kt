package com.mostafasensei.alamelmarateb.core.config

import com.zaxxer.hikari.HikariDataSource
import org.aspectj.lang.ProceedingJoinPoint
import org.aspectj.lang.annotation.Around
import org.aspectj.lang.annotation.Aspect
import org.aspectj.lang.reflect.MethodSignature
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Primary
import org.springframework.core.Ordered
import org.springframework.core.annotation.Order
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource
import org.springframework.transaction.annotation.Transactional
import javax.sql.DataSource

/**
 * Read-routing abstraction (Phase 1: both roles point at primary).
 *
 * - Writes + default reads go to PRIMARY.
 * - `@Transactional(readOnly = true)` is routed to REPLICA via [ReadOnlyRouteAspect].
 * - Today the replica defaults to the primary URL (zero operational change,
 *   zero replication lag). Phase 4 only sets REPLICA_URL/USER/PASSWORD env
 *   to a real streaming replica — no code change.
 */
enum class DbRole { PRIMARY, REPLICA }

object DbRouteHolder {
    private val current = ThreadLocal.withInitial { DbRole.PRIMARY }
    fun set(role: DbRole) = current.set(role)
    fun get(): DbRole = current.get()
    fun clear() = current.remove()
}

class RoutingDataSource(
    primary: DataSource,
    replica: DataSource,
) : AbstractRoutingDataSource() {
    init {
        setTargetDataSources(mapOf<Any, Any>(DbRole.PRIMARY to primary, DbRole.REPLICA to replica))
        setDefaultTargetDataSource(primary)
        afterPropertiesSet()
    }

    override fun determineCurrentLookupKey(): Any = DbRouteHolder.get()
}

@Aspect
@Order(Ordered.HIGHEST_PRECEDENCE)
class ReadOnlyRouteAspect {
    @Around("@annotation(org.springframework.transaction.annotation.Transactional)")
    fun route(joinPoint: ProceedingJoinPoint): Any? {
        val signature = joinPoint.signature as MethodSignature
        val tx = signature.method.getAnnotation(Transactional::class.java)
            ?: joinPoint.target.javaClass.getAnnotation(Transactional::class.java)
        DbRouteHolder.set(if (tx?.readOnly == true) DbRole.REPLICA else DbRole.PRIMARY)
        try {
            return joinPoint.proceed()
        } finally {
            DbRouteHolder.clear()
        }
    }
}

@Configuration
class DataSourceRoutingConfig(
    @Value("\${spring.datasource.url}") private val primaryUrl: String,
    @Value("\${spring.datasource.username}") private val primaryUser: String,
    @Value("\${spring.datasource.password}") private val primaryPassword: String,
    @Value("\${spring.datasource.driver-class-name:org.postgresql.Driver}") private val driver: String,
    @Value("\${app.datasource.replica.url:}") private val replicaUrl: String,
    @Value("\${app.datasource.replica.username:}") private val replicaUser: String,
    @Value("\${app.datasource.replica.password:}") private val replicaPassword: String,
) {
    // Built explicitly (no DataSourceProperties bean) so Boot's own
    // DataSourceAutoConfiguration cleanly backs off: the @Primary
    // routing DataSource below is the only candidate Boot sees.
    @Bean(destroyMethod = "close")
    fun primaryDataSource(): HikariDataSource =
        HikariDataSource().apply {
            jdbcUrl = primaryUrl
            username = primaryUser
            password = primaryPassword
            driverClassName = driver
            poolName = "primary-pool"
        }

    @Bean(destroyMethod = "close")
    fun replicaDataSource(): HikariDataSource =
        HikariDataSource().apply {
            // Phase 1 default: same database as primary. Phase 4 overrides via env.
            jdbcUrl = replicaUrl.ifBlank { primaryUrl }
            username = replicaUser.ifBlank { primaryUser }
            password = replicaPassword.ifBlank { primaryPassword }
            driverClassName = driver
            poolName = "replica-pool"
            maximumPoolSize = 5
            isReadOnly = true
        }

    @Bean
    @Primary
    fun routingDataSource(
        @Qualifier("primaryDataSource") primary: HikariDataSource,
        @Qualifier("replicaDataSource") replica: HikariDataSource,
    ): DataSource = RoutingDataSource(primary, replica)

    @Bean
    fun readOnlyRouteAspect(): ReadOnlyRouteAspect = ReadOnlyRouteAspect()
}
