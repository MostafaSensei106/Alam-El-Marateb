package com.mostafasensei.alamelmarateb.core.search

import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.http.MediaType
import org.springframework.http.client.JdkClientHttpRequestFactory
import org.springframework.stereotype.Component
import org.springframework.web.client.RestClient
import tools.jackson.databind.ObjectMapper
import tools.jackson.module.kotlin.readValue
import java.time.Duration
import java.util.UUID

/**
 * Meilisearch backend over its HTTP API (Phase 3). No extra dependency —
 * plain RestClient like ClickHouseClient. Best-effort everywhere: any
 * failure returns false/null and callers fall back to Postgres.
 *
 * Provision with `docker compose --profile search up -d`, then enable with
 * SEARCH_BACKEND=meilisearch (+MEILI_HOST/MEILI_KEY) and run a rebuild.
 */
@Component
@ConditionalOnProperty(name = ["app.search.backend"], havingValue = "meilisearch")
class MeilisearchProductSearch(
    private val objectMapper: ObjectMapper,
    @Value("\${app.search.meili.host:http://localhost:7700}") private val host: String,
    @Value("\${app.search.meili.key:dev-master-key}") private val apiKey: String,
    @Value("\${app.search.meili.index:products}") private val index: String,
    @Value("\${app.search.timeout-ms:2000}") timeoutMs: Long,
) : ProductSearch {

    private val log = LoggerFactory.getLogger(MeilisearchProductSearch::class.java)
    private val rest: RestClient = RestClient.builder()
        .requestFactory(
            JdkClientHttpRequestFactory().apply {
                setReadTimeout(Duration.ofMillis(timeoutMs))
            },
        )
        .defaultHeader("Authorization", "Bearer $apiKey")
        .defaultHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
        .build()

    @Volatile
    private var ensured = false

    private fun ensureIndex(): Boolean {
        if (ensured) return true
        return try {
            // POST /indexes creates; 400 index_already_exists means usable.
            runCatching {
                rest.post().uri("$host/indexes")
                    .body(mapOf("uid" to index, "primaryKey" to "id"))
                    .retrieve().toBodilessEntity()
            }
            rest.patch().uri("$host/indexes/$index/settings")
                .body(
                    mapOf(
                        "searchableAttributes" to listOf("name", "altNames", "slug", "brand"),
                        "filterableAttributes" to listOf("categoryId", "brand", "isActive", "minPrice"),
                        "sortableAttributes" to listOf("minPrice"),
                    ),
                )
                .retrieve().toBodilessEntity()
            ensured = true
            true
        } catch (ex: Exception) {
            log.warn("meili ensureIndex failed: {}", ex.message)
            false
        }
    }

    override fun upsert(doc: ProductSearchDoc): Boolean {
        if (!ensureIndex()) return false
        return try {
            rest.put().uri("$host/indexes/$index/documents")
                .body(listOf(toMap(doc)))
                .retrieve().toBodilessEntity()
            true
        } catch (ex: Exception) {
            log.warn("meili upsert failed id={}: {}", doc.id, ex.message)
            false
        }
    }

    override fun delete(id: UUID): Boolean {
        if (!ensureIndex()) return false
        return try {
            rest.delete().uri("$host/indexes/$index/documents/$id")
                .retrieve().toBodilessEntity()
            true
        } catch (ex: Exception) {
            log.warn("meili delete failed id={}: {}", id, ex.message)
            false
        }
    }

    override fun searchIds(query: ProductSearchQuery): List<UUID>? {
        if (!ensureIndex()) return null
        return try {
            val filters = mutableListOf("isActive = true")
            query.categoryId?.let { filters.add("categoryId = \"${it}\"") }
            query.brand?.takeIf { it.isNotBlank() }?.let { filters.add("brand = \"${it.replace("\"", "")}\"") }
            query.minPrice?.let { filters.add("minPrice >= ${it.toPlainString()}") }
            query.maxPrice?.let { filters.add("minPrice <= ${it.toPlainString()}") }
            val body = mapOf(
                "q" to (query.q ?: ""),
                "filter" to filters,
                "limit" to query.limit.coerceIn(1, 100),
                "attributesToRetrieve" to listOf("id"),
            )
            val raw: String = rest.post().uri("$host/indexes/$index/search")
                .body(objectMapper.writeValueAsString(body))
                .retrieve().body(String::class.java) ?: return null
            val parsed: Map<String, Any?> = objectMapper.readValue(raw)
            @Suppress("UNCHECKED_CAST")
            val hits = parsed["hits"] as? List<Map<String, Any?>> ?: return emptyList()
            hits.mapNotNull { (it["id"] as? String)?.let { id -> runCatching { UUID.fromString(id) }.getOrNull() } }
        } catch (ex: Exception) {
            log.warn("meili search failed q={}: {}", query.q, ex.message)
            null
        }
    }

    override fun suggest(q: String, limit: Int): List<String>? {
        if (!ensureIndex()) return null
        return try {
            val body = mapOf(
                "q" to q,
                "filter" to listOf("isActive = true"),
                "limit" to limit.coerceIn(1, 20),
                "attributesToRetrieve" to listOf("name"),
            )
            val raw: String = rest.post().uri("$host/indexes/$index/search")
                .body(objectMapper.writeValueAsString(body))
                .retrieve().body(String::class.java) ?: return null
            val parsed: Map<String, Any?> = objectMapper.readValue(raw)
            @Suppress("UNCHECKED_CAST")
            val hits = parsed["hits"] as? List<Map<String, Any?>> ?: return emptyList()
            hits.mapNotNull { it["name"] as? String }.distinct()
        } catch (ex: Exception) {
            log.warn("meili suggest failed q={}: {}", q, ex.message)
            null
        }
    }

    override fun rebuild(docs: List<ProductSearchDoc>): Boolean {
        if (!ensureIndex()) return false
        return try {
            // Full replace: delete index and recreate, then bulk load.
            runCatching {
                rest.delete().uri("$host/indexes/$index").retrieve().toBodilessEntity()
            }
            ensured = false
            if (!ensureIndex()) return false
            docs.chunked(500).forEach { chunk ->
                rest.put().uri("$host/indexes/$index/documents")
                    .body(chunk.map { toMap(it) })
                    .retrieve().toBodilessEntity()
            }
            true
        } catch (ex: Exception) {
            log.warn("meili rebuild failed docs={}: {}", docs.size, ex.message)
            false
        }
    }

    private fun toMap(doc: ProductSearchDoc): Map<String, Any?> = mapOf(
        "id" to doc.id.toString(),
        "name" to doc.name,
        "slug" to doc.slug,
        "brand" to doc.brand,
        "categoryId" to doc.categoryId?.toString(),
        "categoryName" to doc.categoryName,
        "minPrice" to doc.minPrice,
        "isActive" to doc.isActive,
        "imageUrl" to doc.imageUrl,
        "altNames" to doc.altNames,
    )
}
