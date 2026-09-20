package com.mostafasensei.alamelmarateb.modules.analytics.application

import com.mostafasensei.alamelmarateb.modules.analytics.clickhouse.ClickHouseClient
import org.springframework.beans.factory.ObjectProvider
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.LocalDate
import java.util.UUID

data class DrilldownRow(
    val day: String,
    val branchId: String?,
    val variantId: String?,
    val qty: Int,
    val revenue: BigDecimal,
)

/**
 * Heavy sales drilldown: ClickHouse when enabled, Postgres facts otherwise.
 * Same shape either way — the frontend never knows which engine answered.
 */
@Service
class DrilldownService(
    private val clickHouse: ObjectProvider<ClickHouseClient>,
    private val jdbc: JdbcTemplate,
) {

    @Transactional(readOnly = true)
    fun drilldown(from: LocalDate, to: LocalDate, branchId: UUID?, limit: Int): List<DrilldownRow> {
        val ch = clickHouse.ifAvailable
        if (ch != null) {
            val branchFilter = branchId?.let { "AND branch_id = '$it'" } ?: ""
            val rows = ch.select(
                "SELECT day, branch_id, variant_id, sum(qty) qty, sum(net) revenue " +
                    "FROM ${ch.qualified("order_lines")} WHERE day BETWEEN '$from' AND '$to' $branchFilter " +
                    "GROUP BY day, branch_id, variant_id ORDER BY day DESC LIMIT ${limit.coerceIn(1, 1000)}",
            )
            if (rows.isNotEmpty()) {
                return rows.map {
                    DrilldownRow(
                        it["day"].toString(), it["branch_id"]?.toString(), it["variant_id"]?.toString(),
                        (it["qty"] as Number).toInt(), BigDecimal(it["revenue"].toString()).scaled(),
                    )
                }
            }
            // Empty ClickHouse (fresh install) -> fall through to Postgres.
        }
        return jdbc.queryForList(
            "SELECT day, branch_id, variant_id, qty, revenue FROM sales_daily_facts " +
                "WHERE day BETWEEN ? AND ? AND (? IS NULL OR branch_id = ?) ORDER BY day DESC LIMIT ?",
            from, to, branchId, branchId, limit.coerceIn(1, 1000),
        ).map {
            DrilldownRow(
                (it["day"] as java.sql.Date).toLocalDate().toString(),
                it["branch_id"]?.toString(), it["variant_id"]?.toString(),
                (it["qty"] as Number).toInt(), BigDecimal(it["revenue"].toString()).scaled(),
            )
        }
    }

    private fun BigDecimal.scaled(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
