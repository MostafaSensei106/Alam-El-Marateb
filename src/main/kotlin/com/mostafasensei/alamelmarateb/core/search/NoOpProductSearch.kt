package com.mostafasensei.alamelmarateb.core.search

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.stereotype.Component
import java.util.UUID

/**
 * No-op backend (default): every call returns null so callers use the
 * Postgres filter. Active when app.search.backend is anything but meilisearch.
 */
@Component
@ConditionalOnProperty(name = ["app.search.backend"], havingValue = "none", matchIfMissing = true)
class NoOpProductSearch : ProductSearch {
    override fun upsert(doc: ProductSearchDoc): Boolean = false
    override fun delete(id: UUID): Boolean = false
    override fun searchIds(query: ProductSearchQuery): List<UUID>? = null
    override fun suggest(q: String, limit: Int): List<String>? = null
    override fun rebuild(docs: List<ProductSearchDoc>): Boolean = false
}
