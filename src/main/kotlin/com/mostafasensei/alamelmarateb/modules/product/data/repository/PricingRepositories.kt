package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.domain.entity.MeterPriceJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.OperatingBracketJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface MeterPriceRepository : JpaRepository<MeterPriceJpaEntity, UUID> {
    fun findByProductId(productId: UUID): List<MeterPriceJpaEntity>
    fun findByProductIdAndShape(productId: UUID, shape: String): Optional<MeterPriceJpaEntity>
}

@Repository
interface OperatingBracketRepository : JpaRepository<OperatingBracketJpaEntity, UUID> {
    fun findByProductId(productId: UUID): List<OperatingBracketJpaEntity>
    fun findByProductIdIsNull(): List<OperatingBracketJpaEntity>
}
