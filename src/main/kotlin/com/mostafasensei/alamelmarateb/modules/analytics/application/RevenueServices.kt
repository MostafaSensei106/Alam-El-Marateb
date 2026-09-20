package com.mostafasensei.alamelmarateb.modules.analytics.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.analytics.data.repository.AppEventRepository
import com.mostafasensei.alamelmarateb.modules.analytics.data.repository.InquiryRepository
import com.mostafasensei.alamelmarateb.modules.analytics.domain.entity.AppEventJpaEntity
import com.mostafasensei.alamelmarateb.modules.analytics.domain.entity.InquiryJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.DeliveryZoneRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.OrderRepository
import org.slf4j.LoggerFactory
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import tools.jackson.databind.ObjectMapper
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.LocalDate
import java.util.UUID

data class RevenuePoint(val day: LocalDate, val revenue: BigDecimal, val profit: BigDecimal, val orders: Int)

data class RevenueSummary(
    val totalRevenue: BigDecimal,
    val totalProfit: BigDecimal,
    val totalQty: Int,
    val points: List<RevenuePoint>,
)

data class TopVariant(val variantId: UUID, val qty: Int, val revenue: BigDecimal)

data class RfmRow(
    val customerId: UUID?,
    val guestPhone: String?,
    val recencyDays: Long,
    val frequency: Int,
    val monetary: BigDecimal,
    val segment: String,
)

data class BranchPerformance(
    val branchId: UUID?,
    val revenue: BigDecimal,
    val profit: BigDecimal,
    val orders: Int,
)

data class GeoCell(val governorate: String, val orders: Int, val revenue: BigDecimal)

data class InquiryView(
    val id: UUID?,
    val branchId: UUID?,
    val productId: UUID?,
    val variantId: UUID?,
    val note: String?,
    val outcome: String,
    val customerPhone: String?,
    val at: String?,
)

@Service
class RevenueService(
    private val jdbc: JdbcTemplate,
    private val orderRepository: OrderRepository,
    private val zoneRepository: DeliveryZoneRepository,
) {

    @Transactional(readOnly = true)
    fun revenue(from: LocalDate, to: LocalDate, branchId: UUID?): RevenueSummary {
        if (to.isBefore(from)) throw BadRequestException("error.accounting.report_dates")
        val rows = jdbc.queryForList(
            "SELECT day, SUM(qty) qty, SUM(revenue) revenue, SUM(profit) profit FROM sales_daily_facts " +
                "WHERE day BETWEEN ? AND ? AND (? IS NULL OR branch_id = ?) GROUP BY day ORDER BY day",
            from, to, branchId, branchId,
        )
        val points = rows.map {
            RevenuePoint(
                (it["day"] as java.sql.Date).toLocalDate(),
                BigDecimal(it["revenue"].toString()).scaled(),
                BigDecimal(it["profit"].toString()).scaled(),
                0,
            )
        }
        return RevenueSummary(
            points.fold(BigDecimal.ZERO) { a, p -> a.add(p.revenue) }.scaled(),
            points.fold(BigDecimal.ZERO) { a, p -> a.add(p.profit) }.scaled(),
            rows.sumOf { (it["qty"] as Number).toLong() }.toInt(),
            points,
        )
    }

    @Transactional(readOnly = true)
    fun topVariants(from: LocalDate, to: LocalDate, limit: Int): List<TopVariant> =
        jdbc.queryForList(
            "SELECT variant_id, SUM(qty) qty, SUM(revenue) revenue FROM sales_daily_facts " +
                "WHERE day BETWEEN ? AND ? GROUP BY variant_id ORDER BY SUM(qty) DESC LIMIT ?",
            from, to, limit.coerceIn(1, 50),
        ).map {
            TopVariant(
                UUID.fromString(it["variant_id"].toString()),
                (it["qty"] as Number).toInt(),
                BigDecimal(it["revenue"].toString()).scaled(),
            )
        }

    @Transactional(readOnly = true)
    fun rfm(): List<RfmRow> {
        return orderRepository.findAll()
            .filter { it.status != "cancelled" && (it.customerId != null || !it.guestPhone.isNullOrBlank()) }
            .groupBy { it.customerId ?: it.guestPhone }
            .map { (key, orders) ->
                val monetary = orders.fold(BigDecimal.ZERO) { a, o -> a.add(o.grandTotal) }.scaled()
                val lastMs = orders.maxOf { it.createdAt.toEpochMilliseconds() }
                val recency = ((System.currentTimeMillis() - lastMs) / 86_400_000).coerceAtLeast(0)
                val freq = orders.size
                val segment = when {
                    monetary >= BigDecimal("50000") || freq >= 10 -> "vip"
                    freq >= 3 -> "repeat"
                    else -> "new"
                }
                RfmRow(
                    customerId = key as? UUID,
                    guestPhone = key as? String,
                    recencyDays = recency,
                    frequency = freq,
                    monetary = monetary,
                    segment = segment,
                )
            }.sortedByDescending { it.monetary }
    }

    @Transactional(readOnly = true)
    fun branchPerformance(from: LocalDate, to: LocalDate): List<BranchPerformance> {
        val facts = jdbc.queryForList(
            "SELECT branch_id, SUM(revenue) revenue, SUM(profit) profit FROM sales_daily_facts " +
                "WHERE day BETWEEN ? AND ? GROUP BY branch_id",
            from, to,
        ).associate {
            UUID.fromString(it["branch_id"].toString()) to
                (BigDecimal(it["revenue"].toString()).scaled() to BigDecimal(it["profit"].toString()).scaled())
        }
        val orderCounts = orderRepository.findAll()
            .filter { it.createdAt.toEpochMilliseconds() >= from.atStartOfDay().toInstant(java.time.ZoneOffset.UTC).toEpochMilli() }
            .groupBy { it.branchId }.mapValues { it.value.size }
        return (facts.keys + orderCounts.keys.filterNotNull()).distinct().map { branch ->
            val (rev, prof) = facts[branch] ?: (BigDecimal.ZERO to BigDecimal.ZERO)
            BranchPerformance(branch, rev, prof, orderCounts[branch] ?: 0)
        }
    }

    @Transactional(readOnly = true)
    fun geoHeatmap(from: LocalDate, to: LocalDate): List<GeoCell> {
        val zones = zoneRepository.findAll().associateBy { it.id }
        return orderRepository.findAll()
            .filter { it.status != "cancelled" && it.deliveryZoneId != null }
            .groupBy { zones[it.deliveryZoneId]?.governorate ?: "غير محدد" }
            .map { (gov, orders) ->
                GeoCell(gov, orders.size, orders.fold(BigDecimal.ZERO) { a, o -> a.add(o.grandTotal) }.scaled())
            }.sortedByDescending { it.revenue }
    }

    private fun BigDecimal.scaled(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}

@Service
class InquiryService(
    private val inquiryRepository: InquiryRepository,
) {

    @Transactional
    fun log(
        branchId: UUID?, staffId: UUID?, productId: UUID?, variantId: UUID?,
        note: String?, outcome: String, customerPhone: String?, by: String?,
    ): InquiryView {
        val valid = setOf("bought_later", "no_stock", "price", "just_asking")
        val saved = inquiryRepository.save(
            InquiryJpaEntity(
                branchId = branchId, staffId = staffId, productId = productId, variantId = variantId,
                note = note, outcome = if (outcome in valid) outcome else "just_asking",
                customerPhone = customerPhone,
            ),
        )
        return toView(saved)
    }

    @Transactional(readOnly = true)
    fun list(branchId: UUID?): List<InquiryView> {
        val entities = if (branchId != null) inquiryRepository.findByBranchIdOrderByCreatedAtDesc(branchId)
        else inquiryRepository.findAll()
        return entities.map { toView(it) }
    }

    @Transactional(readOnly = true)
    fun topAsked(from: LocalDate, limit: Int): List<Map<String, Any?>> {
        // Most-asked products never bought: inquiry signal for pricing/stock/marketing.
        return inquiryRepository.findAll()
            .filter { it.productId != null }
            .groupBy { it.productId }
            .map { (product, rows) ->
                mapOf(
                    "productId" to product,
                    "inquiries" to rows.size,
                    "noStock" to rows.count { r -> r.outcome == "no_stock" },
                    "price" to rows.count { r -> r.outcome == "price" },
                )
            }.sortedByDescending { (it["inquiries"] as Int) }.take(limit.coerceIn(1, 50))
    }

    private fun toView(e: InquiryJpaEntity) = InquiryView(
        e.id, e.branchId, e.productId, e.variantId, e.note, e.outcome, e.customerPhone, e.createdAt.toString(),
    )
}

@Service
class BeaconService(
    private val eventRepository: AppEventRepository,
    private val objectMapper: ObjectMapper,
) {

    private val log = LoggerFactory.getLogger(BeaconService::class.java)

    /**
     * Behavior beacon: ALWAYS 202, never breaks UX. Stores raw events only
     * with explicit consent; without consent the hit is counted nowhere.
     */
    fun ingest(type: String, actorId: UUID?, anonymousId: String?, payload: Any?, consent: Boolean) {
        if (!consent) return
        try {
            eventRepository.save(
                AppEventJpaEntity(
                    type = type.take(80),
                    actorId = actorId,
                    anonymousId = anonymousId?.take(80),
                    payload = objectMapper.writeValueAsString(payload ?: emptyMap<String, Any>()),
                ),
            )
        } catch (ex: Exception) {
            log.warn("beacon store failed type={}: {}", type, ex.message)
        }
    }
}
