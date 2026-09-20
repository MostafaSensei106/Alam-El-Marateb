package com.mostafasensei.alamelmarateb.core.storage

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.stereotype.Component
import org.springframework.web.multipart.MultipartFile
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.StandardCopyOption
import java.util.UUID

/**
 * File storage port (arch.md §12: local disk now, S3-compatible later —
 * swapping means a new StorageService bean, zero caller changes).
 */
interface StorageService {
    /** Stores the file, returns the public URL path (e.g. /uploads/products/<name>). */
    fun store(namespace: String, file: MultipartFile): String
}

@Component
@ConditionalOnProperty(name = ["app.storage.backend"], havingValue = "local", matchIfMissing = true)
class LocalStorageService(    @Value("\${app.storage.dir:./data/uploads}") private val baseDir: String,
    @Value("\${app.storage.max-mb:5}") private val maxMb: Long,
) : StorageService {

    private val allowed = setOf("image/jpeg", "image/png", "image/webp", "image/gif")

    override fun store(namespace: String, file: MultipartFile): String {
        if (file.isEmpty) throw BadRequestException("error.storage.empty_file")
        val contentType = file.contentType ?: ""
        if (contentType !in allowed) throw BadRequestException("error.storage.bad_type")
        if (file.size > maxMb * 1024 * 1024) {
            throw BadRequestException("error.storage.too_large", listOf(maxMb))
        }
        val ext = when (contentType) {
            "image/jpeg" -> "jpg"
            "image/png" -> "png"
            "image/webp" -> "webp"
            else -> "gif"
        }
        val dir: Path = Paths.get(baseDir, namespace)
        Files.createDirectories(dir)
        val name = "${UUID.randomUUID()}.$ext"
        Files.copy(file.inputStream, dir.resolve(name), StandardCopyOption.REPLACE_EXISTING)
        return "/uploads/$namespace/$name"
    }
}
