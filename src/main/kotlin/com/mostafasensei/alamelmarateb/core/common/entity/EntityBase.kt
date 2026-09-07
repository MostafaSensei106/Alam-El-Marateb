package com.mostafasensei.alamelmarateb.core.common.entity

import com.mostafasensei.alamelmarateb.core.router.staff.StaffDeliveryRoutes.CONFIRM_DELIVER
import jakarta.persistence.Column
import jakarta.persistence.EntityListeners
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.MappedSuperclass
import jakarta.persistence.Version
import org.hibernate.annotations.CreationTimestamp
import org.hibernate.annotations.UpdateTimestamp
import org.springframework.data.annotation.CreatedBy
import org.springframework.data.annotation.LastModifiedBy
import org.springframework.data.jpa.domain.support.AuditingEntityListener
import java.io.Serializable
import kotlin.time.Clock
import kotlin.time.Instant

@MappedSuperclass
@EntityListeners(AuditingEntityListener::class)
abstract class EntityBase<UUID: Serializable> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")    open var id: UUID? = null

    @CreationTimestamp
    @Column(name = "creation_time", updatable = false, nullable = false)
    open var createdAt: Instant = Clock.System.now()

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    open var updatedAt: Instant = Clock.System.now()


    @CreatedBy
    @Column(name = "created_by", nullable = false, updatable = false)
    open var createdBy: String? = null

    @LastModifiedBy
    @Column(name = "updated_by")
    open var updatedBy: String? = null

    @Version
    @Column(name = "version", nullable = false)
    open var version: Int = 0

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is EntityBase<*>) return false
        if (id == null || other.id == null) return false
        return id == other.id
    }

    override fun hashCode(): Int {
        return id?.hashCode() ?: 31
    }}