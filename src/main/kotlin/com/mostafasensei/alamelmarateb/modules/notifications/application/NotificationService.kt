package com.mostafasensei.alamelmarateb.modules.notifications.application

import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.modules.crm.data.repository.WarrantyRepository
import com.mostafasensei.alamelmarateb.modules.notifications.data.repository.NotificationRepository
import com.mostafasensei.alamelmarateb.modules.notifications.data.repository.NotificationTranslationRepository
import com.mostafasensei.alamelmarateb.modules.notifications.domain.entity.NotificationJpaEntity
import com.mostafasensei.alamelmarateb.modules.notifications.domain.entity.NotificationTranslationJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.InvoiceRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.OrderRepository
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.Instant
import java.time.LocalDate
import java.util.UUID

data class NotificationView(
    val id: UUID?,
    val channel: String,
    val recipient: String,
    val ref: String?,
    val status: String,
    val attempts: Int,
    val titles: Map<String, String?>,
    val bodies: Map<String, String?>,
)

/** Delivery plug-in point: log today, SMS/WhatsApp providers tomorrow. */
interface NotificationSender {
    val channel: String
    fun send(recipient: String, title: String, body: String)
}

@Component
class LogNotificationSender : NotificationSender {
    override val channel: String = "log"
    private val log = LoggerFactory.getLogger(LogNotificationSender::class.java)

    override fun send(recipient: String, title: String, body: String) {
        log.info("notify to={} title={} body={}", recipient, title, body)
    }
}

@Service
class NotificationService(
    private val notificationRepository: NotificationRepository,
    private val translationRepository: NotificationTranslationRepository,
    private val messages: MessageService,
    private val senders: List<NotificationSender>,
) {

    @Transactional
    fun queue(
        channel: String,
        recipient: String,
        ref: String?,
        titles: Map<String, String?>,
        bodies: Map<String, String?>,
    ): NotificationView {
        (titles.keys + bodies.keys).forEach { code ->
            if (!messages.isSupportedLang(code)) {
                throw com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException(
                    "error.i18n.unsupported_lang", listOf(code),
                )
            }
        }
        if (ref != null && notificationRepository.existsByRecipientAndRefAndStatus(recipient, ref, "pending")) {
            val existing = notificationRepository.findAll()
                .first { it.recipient == recipient && it.ref == ref && it.status == "pending" }
            return toView(existing)
        }
        val saved = notificationRepository.save(
            NotificationJpaEntity(channel = channel, recipient = recipient, ref = ref),
        )
        (titles.keys + bodies.keys).forEach { lang ->
            translationRepository.save(
                NotificationTranslationJpaEntity(
                    notificationId = saved.id, lang = lang,
                    title = titles[lang], body = bodies[lang],
                ),
            )
        }
        return toView(saved)
    }

    @Transactional(readOnly = true)
    fun pending(limit: Int = 100): List<NotificationView> {
        val now = Instant.now()
        return notificationRepository.findByStatusOrderByCreatedAtAsc("pending")
            .filter { it.nextAttemptAt == null || !it.nextAttemptAt!!.isAfter(now) }
            .take(limit).map { toView(it) }
    }

    @Transactional
    fun dispatch(limit: Int = 100) {
        pending(limit).forEach { view ->
            val entity = notificationRepository.findById(view.id!!).orElse(null) ?: return@forEach
            val sender = senders.firstOrNull { it.channel == entity.channel }
            if (sender == null) {
                entity.status = "failed"
                notificationRepository.save(entity)
                return@forEach
            }
            try {
                val lang = messages.currentLanguage()
                val title = view.titles[lang] ?: view.titles["ar"] ?: ""
                val body = view.bodies[lang] ?: view.bodies["ar"] ?: ""
                sender.send(entity.recipient, title, body)
                entity.status = "sent"
                entity.sentAt = Instant.now()
            } catch (ex: Exception) {
                entity.attempts += 1
                entity.nextAttemptAt = Instant.now().plusSeconds(3600)
                if (entity.attempts >= 5) entity.status = "failed"
            }
            notificationRepository.save(entity)
        }
    }

    private fun toView(e: NotificationJpaEntity): NotificationView {
        val tr = translationRepository.findByNotificationId(e.id!!)
        return NotificationView(
            e.id, e.channel, e.recipient, e.ref, e.status, e.attempts,
            tr.associate { it.lang to it.title },
            tr.associate { it.lang to it.body },
        )
    }
}

/**
 * Scheduled jobs (infra): warranty-expiry follow-up feeds the outbox,
 * the dispatcher delivers. Providers plug in via NotificationSender.
 */
@Component
class NotificationJobs(
    private val notifications: NotificationService,
    private val warrantyRepository: WarrantyRepository,
    private val invoiceRepository: InvoiceRepository,
    private val orderRepository: OrderRepository,
) {

    @Scheduled(cron = "0 0 6 * * *")
    fun warrantyFollowUp() {
        val horizon = LocalDate.now().plusDays(30)
        warrantyRepository.findAll()
            .filter { it.status == "active" && it.coversUntil != null && !it.coversUntil!!.isAfter(horizon) }
            .forEach { warranty ->
                val order = warranty.invoiceId
                    ?.let { invoiceRepository.findById(it).orElse(null)?.orderId }
                    ?.let { orderRepository.findById(it).orElse(null) }
                    ?: return@forEach
                val recipient = order.customerId?.toString() ?: order.guestPhone ?: return@forEach
                notifications.queue(
                    channel = "log",
                    recipient = recipient,
                    ref = "warranty-expiry:${warranty.id}",
                    titles = mapOf(
                        "ar" to "الضمان قرب يخلص",
                        "en" to "Warranty expiring soon",
                    ),
                    bodies = mapOf(
                        "ar" to "ضمان فاتورتك يغطي حتى ${warranty.coversUntil} — اسأل عن عروض التجديد",
                        "en" to "Your invoice warranty covers until ${warranty.coversUntil} — ask about renewal offers",
                    ),
                )
            }
    }

    @Scheduled(fixedDelay = 300_000)
    fun dispatchOutbox() {
        notifications.dispatch()
    }
}
