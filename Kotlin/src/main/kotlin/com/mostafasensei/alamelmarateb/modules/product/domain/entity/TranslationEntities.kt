package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import jakarta.persistence.UniqueConstraint
import java.util.UUID

@Entity
@Table(
    name = "product_translations",
    uniqueConstraints = [UniqueConstraint(columnNames = ["product_id", "lang"])],
)
class ProductTranslationJpaEntity(
    @Column(name = "product_id", nullable = false, columnDefinition = "UUID")
    var productId: UUID? = null,

    @Column(name = "lang", nullable = false, length = 10)
    var lang: String = "",

    @Column(name = "name", length = 150)
    var name: String? = null,

    @Column(name = "description", columnDefinition = "TEXT")
    var description: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(
    name = "category_translations",
    uniqueConstraints = [UniqueConstraint(columnNames = ["category_id", "lang"])],
)
class CategoryTranslationJpaEntity(
    @Column(name = "category_id", nullable = false, columnDefinition = "UUID")
    var categoryId: UUID? = null,

    @Column(name = "lang", nullable = false, length = 10)
    var lang: String = "",

    @Column(name = "name", length = 100)
    var name: String? = null,

    @Column(name = "description", columnDefinition = "TEXT")
    var description: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(
    name = "brand_translations",
    uniqueConstraints = [UniqueConstraint(columnNames = ["brand_id", "lang"])],
)
class BrandTranslationJpaEntity(
    @Column(name = "brand_id", nullable = false, columnDefinition = "UUID")
    var brandId: UUID? = null,

    @Column(name = "lang", nullable = false, length = 10)
    var lang: String = "",

    @Column(name = "name", length = 120)
    var name: String? = null,

    @Column(name = "description", columnDefinition = "TEXT")
    var description: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(
    name = "attribute_translations",
    uniqueConstraints = [UniqueConstraint(columnNames = ["attribute_id", "lang"])],
)
class AttributeTranslationJpaEntity(
    @Column(name = "attribute_id", nullable = false, columnDefinition = "UUID")
    var attributeId: UUID? = null,

    @Column(name = "lang", nullable = false, length = 10)
    var lang: String = "",

    @Column(name = "name", length = 150)
    var name: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(
    name = "attribute_option_translations",
    uniqueConstraints = [UniqueConstraint(columnNames = ["option_id", "lang"])],
)
class AttributeOptionTranslationJpaEntity(
    @Column(name = "option_id", nullable = false, columnDefinition = "UUID")
    var optionId: UUID? = null,

    @Column(name = "lang", nullable = false, length = 10)
    var lang: String = "",

    @Column(name = "label", length = 150)
    var label: String? = null,
) : EntityBase<UUID>()
