package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "product_images")
class ProductImageJpaEntity(
    @Column(name = "product_id", nullable = false, columnDefinition = "UUID")
    var productId: UUID? = null,

    @Column(name = "url", nullable = false, columnDefinition = "TEXT")
    var url: String = "",

    @Column(name = "sort_order", nullable = false)
    var sortOrder: Int = 0,
) : EntityBase<UUID>()
