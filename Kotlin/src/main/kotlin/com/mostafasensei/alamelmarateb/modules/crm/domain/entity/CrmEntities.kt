package com.mostafasensei.alamelmarateb.modules.crm.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.time.LocalDate
import java.util.UUID

@Entity
@Table(name = "customer_profiles")
class CustomerProfileJpaEntity(
    @Column(name = "user_id", nullable = false, columnDefinition = "UUID")
    var userId: UUID? = null,

    @Column(name = "governorate", length = 100)
    var governorate: String? = null,

    @Column(name = "city", length = 100)
    var city: String? = null,

    @Column(name = "segment", nullable = false, length = 20)
    var segment: String = "new",

    @Column(name = "referral_source", length = 100)
    var referralSource: String? = null,

    @Column(name = "birth_date")
    var birthDate: LocalDate? = null,
) : EntityBase<UUID>() {
    // NOTE: user_id doubles as the business key; UUID PK `id` satisfies EntityBase.
}

@Entity
@Table(name = "customer_addresses")
class CustomerAddressJpaEntity(
    @Column(name = "user_id", nullable = false, columnDefinition = "UUID")
    var userId: UUID? = null,

    @Column(name = "label", nullable = false, length = 60)
    var label: String = "home",

    @Column(name = "phone", nullable = false, length = 20)
    var phone: String = "",

    @Column(name = "governorate", nullable = false, length = 100)
    var governorate: String = "",

    @Column(name = "address_text", nullable = false, columnDefinition = "TEXT")
    var addressText: String = "",

    @Column(name = "lat")
    var lat: Double? = null,

    @Column(name = "lng")
    var lng: Double? = null,

    @Column(name = "is_default", nullable = false)
    var isDefault: Boolean = false,
) : EntityBase<UUID>()

@Entity
@Table(name = "favorites")
class FavoriteJpaEntity(
    @Column(name = "user_id", nullable = false, columnDefinition = "UUID")
    var userId: UUID? = null,

    @Column(name = "product_id", nullable = false, columnDefinition = "UUID")
    var productId: UUID? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "warranties")
class WarrantyJpaEntity(
    @Column(name = "invoice_id", nullable = false, unique = true, columnDefinition = "UUID")
    var invoiceId: UUID? = null,

    @Column(name = "covers_until", nullable = false)
    var coversUntil: LocalDate? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "active",
) : EntityBase<UUID>()

@Entity
@Table(name = "warranty_claims")
class WarrantyClaimJpaEntity(
    @Column(name = "warranty_id", nullable = false, columnDefinition = "UUID")
    var warrantyId: UUID? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "reported",

    @Column(name = "description", nullable = false, columnDefinition = "TEXT")
    var description: String = "",

    @Column(name = "photos", columnDefinition = "TEXT")
    var photos: String? = null,

    @Column(name = "inspection_at")
    var inspectionAt: java.time.Instant? = null,

    @Column(name = "resolution", length = 20)
    var resolution: String? = null,
) : EntityBase<UUID>()
