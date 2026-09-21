package com.mostafasensei.alamelmarateb.core.retention

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import java.time.LocalDate
import java.time.OffsetDateTime
import java.time.YearMonth
import java.time.ZoneOffset
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

/**
 * Phase 5: old partitions drop as a whole, recent data survives, and aged
 * operational rows (published outbox, consumer offsets) are purged while
 * pending work is kept.
 */
@SpringBootTest
class RetentionServiceTest {

    @Autowired
    private lateinit var retention: RetentionService

    @Autowired
    private lateinit var jdbc: JdbcTemplate

    private fun oldTs(daysAgo: Long): OffsetDateTime =
        LocalDate.now().minusDays(daysAgo).atStartOfDay().atZone(ZoneOffset.UTC).toOffsetDateTime()

    @Test
    fun `drops old app_events partition and keeps recent rows`() {
        // 120d ago: fully outside the 90d window -> whole partition drops.
        val oldId = UUID.randomUUID()
        val midId = UUID.randomUUID()
        val recentId = UUID.randomUUID()
        try {
            // The old month may already be dropped by an earlier run; ensure
            // it (also covers ensurePartition) BEFORE inserting old data, so
            // the row lands in the real partition (not DEFAULT).
            val oldYm = YearMonth.from(LocalDate.now().minusDays(120))
            retention.ensurePartition("app_events", oldYm)
            val oldMonth = RetentionService.partitionName("app_events", oldYm)
            assertTrue(
                retention.existingPartitions("app_events").any { it.second == oldMonth },
                "old month partition must exist before purge",
            )
            jdbc.update(
                "INSERT INTO app_events (id, type, payload, created_at) VALUES (?, 't', '{}', ?)",
                oldId, oldTs(120),
            )
            jdbc.update(
                "INSERT INTO app_events (id, type, payload, created_at) VALUES (?, 't', '{}', ?)",
                midId, oldTs(10),
            )
            jdbc.update(
                "INSERT INTO app_events (id, type, payload, created_at) VALUES (?, 't', '{}', ?)",
                recentId, OffsetDateTime.now(),
            )
            retention.maintainPartitioned("app_events", LocalDate.now(), 90)
            assertFalse(
                retention.existingPartitions("app_events").any { it.second == oldMonth },
                "old month partition must be dropped",
            )
            assertEquals(
                0,
                jdbc.queryForObject("SELECT COUNT(*) FROM app_events WHERE id = ?", Int::class.java, oldId),
            )
            assertEquals(
                1,
                jdbc.queryForObject("SELECT COUNT(*) FROM app_events WHERE id = ?", Int::class.java, midId),
            )
            assertEquals(
                1,
                jdbc.queryForObject("SELECT COUNT(*) FROM app_events WHERE id = ?", Int::class.java, recentId),
            )
            // Rolling pre-creation: next months exist.
            val next = RetentionService.partitionName("app_events", YearMonth.from(LocalDate.now().plusMonths(2)))
            assertTrue(retention.existingPartitions("app_events").any { it.second == next })
        } finally {
            jdbc.update("DELETE FROM app_events WHERE id IN (?, ?, ?)", oldId, midId, recentId)
        }
    }

    @Test
    fun `purges aged queues but keeps pending work`() {
        val agg = UUID.randomUUID()
        val oldEvent = UUID.randomUUID()
        jdbc.update(
            """INSERT INTO outbox_events
               (aggregate_type, aggregate_id, type, payload, status, published_at, created_at)
               VALUES ('t', ?, 't', '{}', 'PUBLISHED', ?, ?)
            """.trimIndent(),
            agg, oldTs(40), oldTs(40),
        )
        jdbc.update(
            "INSERT INTO outbox_events (aggregate_type, aggregate_id, type, payload, status) VALUES ('t', ?, 't', '{}', 'PENDING')",
            agg,
        )
        jdbc.update(
            "INSERT INTO consumer_processed_events (consumer, event_id, processed_at) VALUES ('test', ?, ?)",
            oldEvent, oldTs(40),
        )
        try {
            retention.purgeQueues(LocalDate.now())
            assertEquals(
                1,
                jdbc.queryForObject(
                    "SELECT COUNT(*) FROM outbox_events WHERE aggregate_id = ?", Int::class.java, agg,
                ),
                "only the PENDING row must survive",
            )
            assertEquals(
                0,
                jdbc.queryForObject(
                    "SELECT COUNT(*) FROM consumer_processed_events WHERE event_id = ?", Int::class.java, oldEvent,
                ),
            )
        } finally {
            jdbc.update("DELETE FROM outbox_events WHERE aggregate_id = ?", agg)
            jdbc.update("DELETE FROM consumer_processed_events WHERE consumer = 'test'")
        }
    }
}
