package com.mostafasensei.alamelmarateb.modules.crm.data.repository

import com.mostafasensei.alamelmarateb.modules.crm.domain.entity.CustomerAddressJpaEntity
import com.mostafasensei.alamelmarateb.modules.crm.domain.entity.CustomerProfileJpaEntity
import com.mostafasensei.alamelmarateb.modules.crm.domain.entity.FavoriteJpaEntity
import com.mostafasensei.alamelmarateb.modules.crm.domain.entity.WarrantyClaimJpaEntity
import com.mostafasensei.alamelmarateb.modules.crm.domain.entity.WarrantyJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface CustomerProfileRepository : JpaRepository<CustomerProfileJpaEntity, UUID> {
    fun findByUserId(userId: UUID): Optional<CustomerProfileJpaEntity>
}

@Repository
interface CustomerAddressRepository : JpaRepository<CustomerAddressJpaEntity, UUID> {
    fun findByUserIdOrderByIsDefaultDesc(userId: UUID): List<CustomerAddressJpaEntity>
}

@Repository
interface FavoriteRepository : JpaRepository<FavoriteJpaEntity, UUID> {
    fun findByUserId(userId: UUID): List<FavoriteJpaEntity>
    fun existsByUserIdAndProductId(userId: UUID, productId: UUID): Boolean
    fun deleteByUserIdAndProductId(userId: UUID, productId: UUID): Long
}

@Repository
interface WarrantyRepository : JpaRepository<WarrantyJpaEntity, UUID> {
    fun findByInvoiceId(invoiceId: UUID): Optional<WarrantyJpaEntity>
}

@Repository
interface WarrantyClaimRepository : JpaRepository<WarrantyClaimJpaEntity, UUID> {
    fun findByWarrantyId(warrantyId: UUID): List<WarrantyClaimJpaEntity>
}
