package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
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
) {

    @Transactional
    fun upload(productId: UUID, file: MultipartFile): ProductImageView {
        productRepository.findById(productId)
            .orElseThrow { NotFoundException("error.catalog.product_not_found") }
        val url = storage.store("products", file)
        val nextSort = (imageRepository.findByProductIdOrderBySortOrderAsc(productId).maxOfOrNull { it.sortOrder } ?: -1) + 1
        return toView(
            imageRepository.save(ProductImageJpaEntity(productId = productId, url = url, sortOrder = nextSort)),
        )
    }

    @Transactional(readOnly = true)
    fun list(productId: UUID): List<ProductImageView> =
        imageRepository.findByProductIdOrderBySortOrderAsc(productId).map { toView(it) }

    @Transactional(readOnly = true)
    fun listMap(productIds: Collection<UUID>): Map<UUID, List<ProductImageView>> =
        imageRepository.findByProductIdIn(productIds).groupBy({ it.productId!! }, { toView(it) })

    @Transactional
    fun delete(imageId: UUID) {
        if (!imageRepository.existsById(imageId)) throw NotFoundException("error.catalog.image_not_found")
        imageRepository.deleteById(imageId)
    }

    private fun toView(e: ProductImageJpaEntity) = ProductImageView(e.id, e.url, e.sortOrder)
}
