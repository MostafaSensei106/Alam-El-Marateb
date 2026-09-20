package com.mostafasensei.alamelmarateb.core.retention

import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate
import java.time.YearMonth
import java.time.format.DateTimeFormatter

/**
 * Partition maintenance + retention enforcement (Phase 5).
 *
 * Daily at 03:00:
 * - Ensures next month's partition exists for each time-partitioned table
 *   (migrations pre-create a wide window; this rolls it forward forever).
 * - Drops whole partitions fully older than the retention window — O(1),
 *   no table bloat, unlike DELETE on a giant table.
 * - Purges DEFAULT-partition strays older than the window (direct DELETE on
 *   the default child only, never a full scan of real partitions).
 * - Deletes aged operational rows (published outbox, processed consumer
 *   offsets, sent/failed notifications) that would otherwise grow forever.
 *   Guard windows (30d) far exceed outbox retry horizons (hours) and Kafka
 *   retention (days), so no live redelivery can double-apply.
 */
@Service
@ConditionalOnProperty(name = ["app.retention.enabled"], havingValue = "true", matchIfMissing = true)
class RetentionService(
    private val jdbc: JdbcTemplate,
    @Value("\${app.retention.app-events-days:90}") private val appEventsDays: Long,
    @Value("\${app.retention.audit-logs-days:365}") private val auditLogsDays: Long,
    @Value("\${app.retention.outbox-published-days:30}") private val outboxDays: Long,
    @Value("\${app.retention.processed-events-days:30}") private val processedDays: Long,
    @Value("\${app.retention.notifications-sent-days:90}") private val notificationsDays: Long,
    @Value("\${app.retention.precreate-months:3}") private val precreateMonths: Long,
) {

    private val log = LoggerFactory.getLogger(RetentionService::class.java)

    companion object {
        private val SUFFIX = DateTimeFormatter.ofPattern("yyyy_MM")
        fun partitionName(table: String, month: YearMonth): String =
            "${table}_p${month.format(SUFFIX)}"
    }

    @Scheduled(cron = "\${app.retention.cron:0 0 3 * * *}")
    @Transactional
    fun runDaily() {
        val today = LocalDate.now()
        maintainPartitioned("app_events", today, appEventsDays)
        maintainPartitioned("audit_logs", today, auditLogsDays)
        purgeQueues(today)
    }

    fun maintainPartitioned(table: String, today: LocalDate, retentionDays: Long) {
        // Roll forward: current + N future months always exist.
        var month = YearMonth.from(today)
        repeat((precreateMonths + 1).toInt()) {
            ensurePartition(table, month)
            month = month.plusMonths(1)
        }
        // Drop whole months fully older than the window (month-end < cutoff).
        // The cutoff's own month is always kept (it holds days >= cutoff).
        val cutoff = today.minusDays(retentionDays)
        existingPartitions(table)
            .filter { (ym, _) -> ym.atEndOfMonth().isBefore(cutoff) }
            .forEach { (_, name) ->
                jdbc.execute("DROP TABLE IF EXISTS $name")
                log.info("retention dropped {} partition {}", table, name)
            }
        // Strays in DEFAULT older than the window go row by row.
        val purged = jdbc.update(
            "DELETE FROM ${table}_default WHERE created_at < ?",
            cutoff.atStartOfDay().atZone(java.time.ZoneId.systemDefault()).toOffsetDateTime(),
        )
        if (purged > 0) log.info("retention purged {} default strays from {}", purged, table)
    }

    fun ensurePartition(table: String, month: YearMonth) {
        val name = partitionName(table, month)
        val from = month.atDay(1)
        val to = month.plusMonths(1).atDay(1)
        jdbc.execute(
            "CREATE TABLE IF NOT EXISTS $name PARTITION OF $table " +
                "FOR VALUES FROM ('$from') TO ('$to')",
        )
    }

    fun existingPartitions(table: String): List<Pair<YearMonth, String>> =
        jdbc.query(
            """
            SELECT c.relname FROM pg_inherits i
            JOIN pg_class c ON c.oid = i.inhrelid
            JOIN pg_class p ON p.oid = i.inhparent
            WHERE p.relname = ? AND c.relname LIKE '${table}_p%'
            """.trimIndent(),
            { rs, _ -> rs.getString(1) },
            table,
        ).mapNotNull { name ->
            runCatching {
                YearMonth.parse(name.removePrefix("${table}_p"), SUFFIX) to name
            }.getOrNull()
        }

    fun purgeQueues(today: LocalDate) {
        val zone = java.time.ZoneId.systemDefault()
        fun cutoff(days: Long) = today.minusDays(days).atStartOfDay().atZone(zone).toOffsetDateTime()
        val outbox = jdbc.update(
            "DELETE FROM outbox_events WHERE status = 'PUBLISHED' AND published_at < ?",
            cutoff(outboxDays),
        )
        val processed = jdbc.update(
            "DELETE FROM consumer_processed_events WHERE processed_at < ?",
            cutoff(processedDays),
        )
        val notifications = jdbc.update(
            "DELETE FROM notification_outbox WHERE status IN ('sent', 'failed') AND created_at < ?",
            cutoff(notificationsDays),
        )
        if (outbox + processed + notifications > 0) {
            log.info(
                "retention purged queues outbox={} processed={} notifications={}",
                outbox, processed, notifications,
            )
        }
    }
}
