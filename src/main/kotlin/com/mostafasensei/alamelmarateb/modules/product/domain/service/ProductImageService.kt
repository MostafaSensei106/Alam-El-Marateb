package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.events.MediaUploadedEvent
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.outbox.OutboxWriter
import com.mostafasensei.alamelmarateb.core.storage.StorageService
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductImageRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.SpringDataJpaProductRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductImageJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.multipart.MultipartFile
import java.util.UUID

data class ProductImageView(
    val id: UUID?,
    val url: String,
    val sortOrder: Int,
)

@Service
class ProductImageService(
    private val imageRepository: ProductImageRepository,
    private val productRepository: SpringDataJpaProductRepository,
    private val storage: StorageService,
    private val outbox: OutboxWriter,
) {

    @Transactional
    fun upload(productId: UUID, file: MultipartFile): ProductImageView {
        productRepository.findById(productId)
            .orElseThrow { NotFoundException("error.catalog.product_not_found") }
        val url = storage.store("products", file)
        val nextSort = (imageRepository.findByProductIdOrderBySortOrderAsc(productId).maxOfOrNull { it.sortOrder } ?: -1) + 1
        val saved = imageRepository.save(
            ProductImageJpaEntity(productId = productId, url = url, sortOrder = nextSort),
        )
        // Same-transaction event for future async processors (search index,
        // thumbnails in Phase 3) — upload response never waits for them.
        outbox.emit(
            "product-image", saved.id, OutboxWriter.MEDIA_UPLOADED,
            MediaUploadedEvent(imageId = saved.id!!, productId = productId, url = url),
        )
        return toView(saved)
    }

    @Transactional(readOnly = true)
    fun list(productId: UUID): List<ProductImageView> =
        imageRepository.findByProductIdOrderBySortOrderAsc(productId).map { toView(it) }

    @Transactional(readOnly = true)
    fun listMap(productIds: Collection<UUID>): Map<UUID, List<ProductImageView>> =
        imageRepository.findByProductIdIn(productIds).groupBy({ it.productId!! }, { toView(it) })

    @Transactional
    fun delete(imageId: UUID) {
        val entity = imageRepository.findById(imageId).orElseThrow {
            NotFoundException("error.catalog.image_not_found")
        }
        imageRepository.deleteById(imageId)
        // Best-effort file cleanup: DB row is the source of truth, orphan
        // files must never fail the request (purge jobs catch leftovers).
        try {
            storage.delete(entity.url)
        } catch (_: Exception) {
            // swallowed by contract; logged inside the storage backend
        }
    }

    private fun toView(e: ProductImageJpaEntity) = ProductImageView(e.id, e.url, e.sortOrder)
}
