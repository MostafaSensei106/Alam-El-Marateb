package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.modules.product.data.model.AttributeValue
import com.mostafasensei.alamelmarateb.modules.product.data.repository.QuizOptionRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.QuizOptionTranslationRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.QuizQuestionRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.QuizQuestionTranslationRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.RecommendationRunRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.RecommendationRunJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import tools.jackson.databind.ObjectMapper
import tools.jackson.module.kotlin.readValue
import java.math.BigDecimal
import java.util.UUID
import kotlin.math.abs
import kotlin.math.roundToInt

data class QuizQuestionView(
    val id: UUID?,
    val sortOrder: Int,
    val text: String,
    val dimension: String,
    val options: List<QuizOptionView>,
    val texts: Map<String, String?> = emptyMap(),
)

data class QuizOptionView(
    val id: UUID?,
    val label: String,
    val labels: Map<String, String?> = emptyMap(),
)

data class QuizAnswer(val questionId: UUID, val optionId: UUID)

data class Recommendation(
    val productId: UUID?,
    val name: String,
    val slug: String,
    val matchPercent: Int,
    val reasons: List<String>,
)

@Service
class QuizService(
    private val questionRepository: QuizQuestionRepository,
    private val optionRepository: QuizOptionRepository,
    private val questionTrRepository: QuizQuestionTranslationRepository,
    private val optionTrRepository: QuizOptionTranslationRepository,
    private val runRepository: RecommendationRunRepository,
    private val catalogService: ProductCatalogService,
    private val objectMapper: ObjectMapper,
    private val messages: MessageService,
) {

    companion object {
        val DIMENSIONS = listOf("support", "cooling", "firmness", "material")

        private val FIRM_POS = listOf("ناشف", "صلب", "firm", "hard", "extra")
        private val FIRM_NEG = listOf("طري", "soft", "plush", "ناعم")
        private val COOL_POS = listOf("جل", "gel", "cool", "بارد", "تهوية", "breathable", "بامبو", "bamboo")
        private val COOL_NEG = listOf("ميموري", "memory")
        private val SUPPORT_POS = listOf("بوكيت", "pocket", "zones", "مناطق", "طبي", "medical", "زنبرك منفصل")
        private val SUPPORT_NEG = listOf("فايبر", "fiber", "اسفنج", "foam")
        private val MATERIAL_POS = listOf("قطن", "cotton", "لاتكس", "latex", "طبيعي", "natural", "بامبو", "bamboo")
        private val MATERIAL_NEG = listOf("صناعي", "synthetic", "بوليستر", "polyester")
    }

    @Transactional(readOnly = true)
    fun questions(): List<QuizQuestionView> {
        val questions = questionRepository.findByIsActiveTrueOrderBySortOrderAsc()
        val texts = questionTrRepository.findByQuestionIdIn(questions.mapNotNull { it.id })
            .groupBy({ it.questionId }, { it.lang to it.text }).mapValues { it.value.toMap() }
        val lang = messages.currentLanguage()
        return questions.map { q ->
            val options = optionRepository.findByQuestionId(q.id!!)
            val labels = optionTrRepository.findByOptionIdIn(options.mapNotNull { it.id })
                .groupBy({ it.optionId }, { it.lang to it.label }).mapValues { it.value.toMap() }
            val qTexts = q.id?.let { texts[it] } ?: emptyMap()
            QuizQuestionView(
                q.id, q.sortOrder,
                qTexts[lang] ?: qTexts["ar"] ?: "",
                q.dimension,
                options.map { o ->
                    val oLabels = o.id?.let { labels[it] } ?: emptyMap()
                    QuizOptionView(o.id, oLabels[lang] ?: oLabels["ar"] ?: "", oLabels)
                },
                qTexts,
            )
        }
    }

    @Transactional
    fun recommend(
        userId: UUID?,
        answers: List<QuizAnswer>,
        categoryId: UUID? = null,
        maxPrice: BigDecimal? = null,
        limit: Int = 3,
    ): List<Recommendation> {
        if (answers.isEmpty()) throw UnprocessableException("error.quiz.empty_answers")
        val profile = mutableMapOf<String, Int>()
        answers.forEach { answer ->
            val question = questionRepository.findById(answer.questionId)
                .orElseThrow { UnprocessableException("error.quiz.unknown_question", listOf(answer.questionId)) }
            val option = optionRepository.findById(answer.optionId)
                .filter { it.questionId == answer.questionId }
                .orElseThrow { UnprocessableException("error.quiz.unknown_option", listOf(answer.optionId)) }
            if (!question.isActive) throw UnprocessableException("error.quiz.unknown_question", listOf(answer.questionId))
            val scores: Map<String, Int> = try {
                objectMapper.readValue(option.scores)
            } catch (_: Exception) {
                emptyMap()
            }
            scores.forEach { (dim, pts) -> profile[dim] = (profile[dim] ?: 0) + pts }
        }

        var products = catalogService.getAllProducts()
        if (categoryId != null) products = products.filter { it.categoryId == categoryId }
        if (maxPrice != null) {
            products = products.filter { p ->
                p.variants.minOfOrNull { it.sellingPrice }?.let { it <= maxPrice } ?: true
            }
        }
        val ranked = products.map { product ->
            val vector = productVector(product.id!!)
            val expressed = DIMENSIONS.filter { (profile[it] ?: 0) != 0 }
            val agreement = if (expressed.isEmpty()) 0.5 else {
                expressed.map { dim ->
                    val u = profile[dim] ?: 0
                    val p = vector[dim] ?: 0
                    1.0 - abs(u - p).toDouble() / (abs(u) + abs(p) + 3.0)
                }.average()
            }
            val pct = (agreement * 100).roundToInt().coerceIn(0, 100)
            Triple(product, pct, reasons(profile, vector))
        }.sortedWith(compareByDescending<Triple<com.mostafasensei.alamelmarateb.modules.product.data.model.Product, Int, List<String>>> { it.second }.thenBy { it.first.name })
            .take(limit.coerceIn(1, 10))

        runRepository.save(
            RecommendationRunJpaEntity(
                userId = userId,
                answers = objectMapper.writeValueAsString(answers.map { mapOf("q" to it.questionId, "o" to it.optionId) }),
                results = objectMapper.writeValueAsString(ranked.map { mapOf("product" to it.first.id, "match" to it.second) }),
            ),
        )
        return ranked.map { (product, pct, reasons) ->
            Recommendation(product.id, product.name, product.slug, pct, reasons)
        }
    }

    private fun productVector(productId: UUID): Map<String, Int> {
        val product = catalogService.getProduct(productId) ?: return emptyMap()
        val texts = product.attributes.flatMap { attr ->
            when (val v = attr.value) {
                is AttributeValue.Text -> listOf(v.value)
                is AttributeValue.Option -> optionLabels(attr.attributeId, setOf(v.optionId))
                is AttributeValue.MultiOption -> optionLabels(attr.attributeId, v.optionIds)
                else -> emptyList()
            }
        }.joinToString(" ").lowercase()
        fun hits(list: List<String>) = list.count { texts.contains(it) }
        return mapOf(
            "firmness" to (hits(FIRM_POS) * 2 - hits(FIRM_NEG) * 2),
            "cooling" to (hits(COOL_POS) * 2 - hits(COOL_NEG)),
            "support" to (hits(SUPPORT_POS) * 2 - hits(SUPPORT_NEG)),
            "material" to (hits(MATERIAL_POS) * 2 - hits(MATERIAL_NEG)),
        )
    }

    private fun optionLabels(attributeId: UUID, optionIds: Set<UUID>): List<String> =
        catalogService.getOptionsForAttribute(attributeId)
            .filter { it.id in optionIds }
            .flatMap { listOf(it.label, it.value) }

    private fun reasons(profile: Map<String, Int>, vector: Map<String, Int>): List<String> {
        val out = mutableListOf<String>()
        val support = profile["support"] ?: 0
        val firmness = profile["firmness"] ?: 0
        val cooling = profile["cooling"] ?: 0
        if (support >= 2) out.add("دعم عالٍ مناسب لآلام الظهر")
        if (firmness >= 2) out.add("صلابة عالية بثبات ممتاز")
        if (firmness <= -2) out.add("ملمس طري ومريح")
        if (cooling >= 2) out.add("تهوية وتبريد أثناء النوم")
        if ((vector["material"] ?: 0) > 0) out.add("خامات طبيعية")
        if (out.isEmpty()) out.add("متوافق مع إجاباتك")
        return out.take(3)
    }
}
