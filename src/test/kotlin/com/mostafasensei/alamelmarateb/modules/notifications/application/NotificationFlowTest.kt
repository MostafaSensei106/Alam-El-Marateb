package com.mostafasensei.alamelmarateb.modules.notifications.application

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.transaction.annotation.Transactional
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class NotificationFlowTest {

    @Autowired
    private lateinit var notifications: NotificationService

    @Test
    fun `queue dedupes by ref and lists pending`() {
        val suffix = System.nanoTime()
        val first = notifications.queue(
            channel = "log",
            recipient = "01000000001",
            ref = "test:$suffix",
            titles = mapOf("ar" to "تذكير", "en" to "Reminder"),
            bodies = mapOf("ar" to "نص", "en" to "Body"),
        )
        val second = notifications.queue(
            channel = "log",
            recipient = "01000000001",
            ref = "test:$suffix",
            titles = mapOf("ar" to "تذكير"),
            bodies = mapOf("ar" to "نص"),
        )
        assertEquals(first.id, second.id)

        val pending = notifications.pending(100)
        assertTrue(pending.any { it.id == first.id })
        assertEquals("تذكير", pending.first { it.id == first.id }.titles["ar"])

        notifications.dispatch(100)
        assertTrue(notifications.pending(100).none { it.id == first.id })
    }
}
