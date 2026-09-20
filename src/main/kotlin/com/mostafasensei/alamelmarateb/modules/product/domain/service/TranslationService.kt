package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeDefinition
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeOption
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.repository.AttributeOptionTranslationRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.AttributeTranslationRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.BrandTranslationRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.CategoryTranslationRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductTranslationRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.AttributeOptionTranslationJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.AttributeTranslationJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.BrandTranslationJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.CategoryTranslationJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductTranslationJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

/**
 * Content translations (docs/database.md translations pattern).
 *
 * - Canonical Arabic lives in master tables; every other language is ROWS.
 * - New language = config in app.i18n.supported + rows. Zero DDL, zero code.
 * - Reads resolve display fields per request language (X-Lang) with
 *   per-field fallback: requested -> ar -> canonical column.
 * - Writes accept `translations: {lang: {field: value}}`; unknown lang codes
 *   are rejected (400) so typos never create dead rows.
 */
@Service
class TranslationService(
    private val messages: MessageService,
    private val productTr: ProductTranslationRepository,
    private val categoryTr: CategoryTranslationRepository,
    private val brandTr: BrandTranslationRepository,
    private val attributeTr: AttributeTranslationRepository,
    private val optionTr: AttributeOptionTranslationRepository,
) {

    fun lang(): String = messages.currentLanguage()

    fun validateLangs(translations: Map<String, Map<String, String?>>?) {
        translations?.keys?.forEach { code ->
            if (!messages.isSupportedLang(code)) {
                throw BadRequestException("error.i18n.unsupported_lang", listOf(code))
            }
        }
    }

    /** Per-field fallback: requested -> ar -> canonical. */
    fun pick(canonical: String?, values: Map<String, String?>, field: String): String {
        val lang = lang()
        return values[lang] ?: values["ar"] ?: canonical ?: ""
    }

    // ---- products ----

    @Transactional
    fun saveProduct(id: UUID, translations: Map<String, Map<String, String?>>?) {
        validateLangs(translations)
        productTr.deleteByProductId(id)
        translations?.forEach { (lang, fields) ->
            productTr.save(
                ProductTranslationJpaEntity(
                    productId = id, lang = lang.lowercase(),
                    name = fields["name"], description = fields["description"],
                ),
            )
        }
    }

    @Transactional(readOnly = true)
    fun attachProducts(products: List<Product>): List<Product> {
        if (products.isEmpty()) return products
        val ids = products.mapNotNull { it.id }
        val byProduct = productTr.findByProductIdIn(ids).groupBy { it.productId }
        return products.map { p ->
            val rows = (p.id?.let { byProduct[it] } ?: emptyList())
            val byLang = rows.associate { it.lang to mapOf("name" to it.name, "description" to it.description) }
            p.copy(
                name = pick(p.name, byLang.mapValues { it.value["name"] }, "name"),
                description = pick(p.description, byLang.mapValues { it.value["description"] }, "description")
                    .ifBlank { null },
                translations = byLang,
            )
        }
    }

    // ---- categories ----

    @Transactional
    fun saveCategory(id: UUID, translations: Map<String, Map<String, String?>>?) {
        validateLangs(translations)
        categoryTr.deleteByCategoryId(id)
        translations?.forEach { (lang, fields) ->
            categoryTr.save(
                CategoryTranslationJpaEntity(
                    categoryId = id, lang = lang.lowercase(),
                    name = fields["name"], description = fields["description"],
                ),
            )
        }
    }

    @Transactional(readOnly = true)
    fun attachCategories(categories: List<ProductCategory>): List<ProductCategory> {
        if (categories.isEmpty()) return categories
        val byCat = categoryTr.findByCategoryIdIn(categories.mapNotNull { it.id }).groupBy { it.categoryId }
        return categories.map { c ->
            val rows = (c.id?.let { byCat[it] } ?: emptyList())
            val byLang = rows.associate { it.lang to mapOf("name" to it.name, "description" to it.description) }
            c.copy(
                name = pick(c.name, byLang.mapValues { it.value["name"] }, "name"),
                description = pick(c.description, byLang.mapValues { it.value["description"] }, "description")
                    .ifBlank { null },
                translations = byLang,
            )
        }
    }

    // ---- brands (views carry translations map) ----

    @Transactional
    fun saveBrand(id: UUID, translations: Map<String, Map<String, String?>>?) {
        validateLangs(translations)
        brandTr.deleteByBrandId(id)
        translations?.forEach { (lang, fields) ->
            brandTr.save(
                BrandTranslationJpaEntity(
                    brandId = id, lang = lang.lowercase(),
                    name = fields["name"], description = fields["description"],
                ),
            )
        }
    }

    @Transactional(readOnly = true)
    fun brandMap(brandId: UUID): Map<String, Map<String, String?>> =
        brandTr.findByBrandId(brandId).associate { it.lang to mapOf("name" to it.name, "description" to it.description) }

    // ---- attributes + options ----

    @Transactional
    fun saveAttribute(id: UUID, translations: Map<String, Map<String, String?>>?) {
        validateLangs(translations)
        attributeTr.deleteByAttributeId(id)
        translations?.forEach { (lang, fields) ->
            attributeTr.save(
                AttributeTranslationJpaEntity(attributeId = id, lang = lang.lowercase(), name = fields["name"]),
            )
        }
    }

    @Transactional
    fun saveOption(id: UUID, translations: Map<String, Map<String, String?>>?) {
        validateLangs(translations)
        optionTr.deleteByOptionId(id)
        translations?.forEach { (lang, fields) ->
            optionTr.save(
                AttributeOptionTranslationJpaEntity(optionId = id, lang = lang.lowercase(), label = fields["label"]),
            )
        }
    }

    @Transactional(readOnly = true)
    fun attachOptions(options: List<ProductAttributeOption>): List<ProductAttributeOption> {
        if (options.isEmpty()) return options
        val labels = optionTr.findByOptionIdIn(options.mapNotNull { it.id })
            .groupBy({ it.optionId }, { it.lang to it.label }).mapValues { it.value.toMap() }
        return options.map { o ->
            val labelMap = o.id?.let { labels[it] } ?: emptyMap()
            o.copy(label = pick(o.label, labelMap, "label"), translations = mapOf("label" to labelMap))
        }
    }
    @Transactional(readOnly = true)
    fun attachDefinitions(defs: List<ProductAttributeDefinition>): List<ProductAttributeDefinition> {
        if (defs.isEmpty()) return defs
        val ids = defs.mapNotNull { it.id }
        val namesByAttr = attributeTr.findByAttributeIdIn(ids).groupBy({ it.attributeId }, { it.lang to it.name })
            .mapValues { it.value.toMap() }
        val optionIds = defs.flatMap { d -> d.options.mapNotNull { it.id } }
        val labelsByOption = optionTr.findByOptionIdIn(optionIds).groupBy({ it.optionId }, { it.lang to it.label })
            .mapValues { it.value.toMap() }
        return defs.map { d ->
            val nameMap = d.id?.let { namesByAttr[it] } ?: emptyMap()
            d.copy(
                name = pick(d.name, nameMap, "name"),
                translations = mapOf("name" to nameMap),
                options = d.options.map { o ->
                    val labelMap = o.id?.let { labelsByOption[it] } ?: emptyMap()
                    o.copy(
                        label = pick(o.label, labelMap, "label"),
                        translations = mapOf("label" to labelMap),
                    )
                },
            )
        }
    }
}
