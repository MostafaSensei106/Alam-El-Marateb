package com.mostafasensei.alamelmarateb.modules.analytics.clickhouse

import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.stereotype.Component
import org.springframework.web.client.RestClient
import tools.jackson.databind.ObjectMapper
import tools.jackson.module.kotlin.readValue

/**
 * ClickHouse over its HTTP interface (docs/modules/analytics.md §4 — heavy
 * analytics when data grows). No native driver: INSERTs use JSONEachRow,
 * SELECTs use JSON output, all best-effort (analytics must never break sales).
 *
 * Enable with CLICKHOUSE_ENABLED=true (+CLICKHOUSE_URL/USER/PASSWORD);
 * `docker compose --profile clickhouse up -d` provisions the server.
 */
@Component
@ConditionalOnProperty(name = ["app.clickhouse.enabled"], havingValue = "true")
class ClickHouseClient(
    private val objectMapper: ObjectMapper,
    @Value("\${app.clickhouse.url:http://localhost:8123}") private val baseUrl: String,
    @Value("\${app.clickhouse.user:default}") private val user: String,
    @Value("\${app.clickhouse.password:}") private val password: String,
    @Value("\${app.clickhouse.database:alamelmarateb}") private val database: String,
) {

    private val log = LoggerFactory.getLogger(ClickHouseClient::class.java)
    private val rest = RestClient.create()

    fun qualified(table: String): String = "$database.$table"

    fun insertJsonEachRow(table: String, rows: List<Map<String, Any?>>): Boolean {
        if (rows.isEmpty()) return true
        return try {
            val body = rows.joinToString("\n") { objectMapper.writeValueAsString(it) }
            rest.post()
                .uri("$baseUrl?query=${encode("INSERT INTO $database.$table FORMAT JSONEachRow")}")
                .headers { it.setBasicAuth(user, password) }
                .body(body)
                .retrieve()
                .toBodilessEntity()
            true
        } catch (ex: Exception) {
            log.warn("clickhouse insert failed table={}: {}", table, ex.message)
            false
        }
    }

    fun select(sql: String): List<Map<String, Any?>> {
        return try {
            val raw = rest.post()
                .uri("$baseUrl?query=${encode(sql)} FORMAT JSON")
                .headers { it.setBasicAuth(user, password) }
                .retrieve()
                .body(String::class.java) ?: return emptyList()
            val parsed: Map<String, Any?> = objectMapper.readValue(raw)
            @Suppress("UNCHECKED_CAST")
            (parsed["data"] as? List<Map<String, Any?>>) ?: emptyList()
        } catch (ex: Exception) {
            log.warn("clickhouse select failed: {}", ex.message)
            emptyList()
        }
    }

    fun ping(): Boolean {
        return try {
            val raw = rest.get().uri("$baseUrl/ping")
                .headers { it.setBasicAuth(user, password) }
                .retrieve().body(String::class.java)
            raw?.trim() == "Ok."
        } catch (_: Exception) {
            false
        }
    }

    private fun encode(sql: String): String = java.net.URLEncoder.encode(sql, Charsets.UTF_8)
}
