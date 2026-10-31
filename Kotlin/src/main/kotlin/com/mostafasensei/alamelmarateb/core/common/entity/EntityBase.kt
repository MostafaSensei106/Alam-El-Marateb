package com.mostafasensei.alamelmarateb.core.common.entity

import jakarta.persistence.Column
import jakarta.persistence.EntityListeners
import jakarta.persistence.Id
import jakarta.persistence.MappedSuperclass
import jakarta.persistence.Version
import org.hibernate.annotations.CreationTimestamp
import org.hibernate.annotations.UpdateTimestamp
import org.springframework.data.annotation.CreatedBy
import org.springframework.data.annotation.LastModifiedBy
import org.springframework.data.jpa.domain.support.AuditingEntityListener
import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

/**
 * Base class for every persisted JPA entity in the application.
 *
 * ### Primary key contract (non-negotiable)
 * [id] is always non-null. It is **application-assigned** before the entity reaches Hibernate, so
 * `INSERT` never has to round-trip to the database to learn its own key. Consequences:
 * - New entities are safe to reference (logs, events, child rows) *before* `save()`.
 * - `equals`/`hashCode` are stable from construction onwards.
 * - Flyway still declares `DEFAULT gen_random_uuid()` on the column as a defence-in-depth fallback
 *   for rows inserted by hand (psql, migrations, fixtures); the application never relies on it.
 *
 * ### Version contract
 * [version] is `null` until the row is first written. Spring Data JPA uses the version attribute to
 * decide `isNew()`: `null` means `persist` (INSERT), non-null means `merge`/dirty-check (UPDATE).
 * Hibernate seeds it with `0` on insert, so after the first flush it is never null again.
 */
@MappedSuperclass
@EntityListeners(AuditingEntityListener::class)
abstract class EntityBase {
    /**
     * Primary key. **Required, never null.** Automatically generated client-side.
     * `updatable = false` makes the key immutable for the whole row lifetime.
     */
    @Id
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID = UUID.randomUUID()

    /** Creation timestamp. **Required.** Populated by Hibernate on persist; never set by callers. */
    @CreationTimestamp
    @Column(name = "created_at", updatable = false, nullable = false)
    var createdAt: Instant = Clock.System.now()

    /** Last-update timestamp. **Required.** Maintained by Hibernate on every write. */
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    var updatedAt: Instant = Clock.System.now()

    /** Author that created the row. **Optional** at the type level; populated by Spring Data auditing. */
    @CreatedBy
    @Column(name = "created_by", nullable = false, updatable = false)
    var createdBy: String? = null

    /** Author that last modified the row. **Optional.** Populated by Spring Data auditing on update. */
    @LastModifiedBy
    @Column(name = "updated_by")
    var updatedBy: String? = null

    /**
     * Optimistic-locking version. **Optional until first flush** — `null` marks a transient entity.
     * Must stay nullable: a non-null default would make `Persistable.isNew()` return `false` and turn
     * the first `save()` into a `merge()` (extra SELECT + possible stale-row insert attempt).
     */
    @Version
    @Column(name = "version", nullable = false)
    var version: Long? = null

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is EntityBase) return false
        return id == other.id
    }

    override fun hashCode(): Int = id.hashCode()
}
