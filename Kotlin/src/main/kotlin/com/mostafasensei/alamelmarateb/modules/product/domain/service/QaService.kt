package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductQuestionRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.SpringDataJpaProductRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductQuestionJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

data class QuestionView(
    val id: UUID?,
    val productId: UUID?,
    val question: String,
    val answer: String?,
    val status: String,
)

@Service
class QaService(
    private val questionRepository: ProductQuestionRepository,
    private val productRepository: SpringDataJpaProductRepository,
) {

    @Transactional(readOnly = true)
    fun answered(productId: UUID): List<QuestionView> =
        questionRepository.findByProductIdAndStatusOrderByCreatedAtDesc(productId, "answered").map { toView(it) }

    @Transactional
    fun ask(userId: UUID, productId: UUID, question: String): QuestionView {
        if (question.isBlank()) throw BadRequestException("error.qa.question_required")
        productRepository.findById(productId)
            .orElseThrow { NotFoundException("error.catalog.product_not_found") }
        return toView(
            questionRepository.save(
                ProductQuestionJpaEntity(productId = productId, userId = userId, question = question.trim()),
            ),
        )
    }

    @Transactional
    fun answer(id: UUID, answer: String, by: String?): QuestionView {
        if (answer.isBlank()) throw BadRequestException("error.qa.question_required")
        val entity = questionRepository.findById(id)
            .orElseThrow { NotFoundException("error.qa.not_found") }
        entity.answer = answer.trim()
        entity.answeredBy = by
        entity.status = "answered"
        return toView(questionRepository.save(entity))
    }

    private fun toView(e: ProductQuestionJpaEntity) = QuestionView(
        e.id, e.productId, e.question, e.answer, e.status,
    )
}
