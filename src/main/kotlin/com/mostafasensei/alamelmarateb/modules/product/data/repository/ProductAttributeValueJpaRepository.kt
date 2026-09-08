package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductAttributeValueJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface ProductAttributeValueJpaRepository : JpaRepository<ProductAttributeValueJpaEntity, UUID> {
    fun findByProductId(productId: UUID): List<ProductAttributeValueJpaEntity>
}
