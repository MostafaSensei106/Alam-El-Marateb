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
 *
 * Phase 1 hardening: shared validation ([StorageRules]), namespace
 * allowlist, and lifecycle ops ([delete]/[exists]) so callers stop
 * assuming local-disk paths.
 */
interface StorageService {
    /** Stores the file, returns the public URL (local path or S3 URL). */
    fun store(namespace: String, file: MultipartFile): String

    /** Best-effort delete by a previously returned public URL/key. */
    fun delete(publicUrl: String): Boolean = false

    /** Existence check by a previously returned public URL/key. */
    fun exists(publicUrl: String): Boolean = false
}

object StorageRules {
    val IMAGE_TYPES = mapOf(
        "image/jpeg" to "jpg",
        "image/png" to "png",
        "image/webp" to "webp",
        "image/gif" to "gif",
    )

    /** Namespaces the app is allowed to write (prevents path traversal). */
    val NAMESPACES = setOf(
        "products", "brands", "categories", "receipts", "expenses",
        "delivery-proof", "warranty", "avatars", "quiz", "tmp",
    )

    fun check(namespace: String, file: MultipartFile, maxMb: Long): String {
        if (namespace !in NAMESPACES) throw BadRequestException("error.storage.bad_namespace")
        if (file.isEmpty) throw BadRequestException("error.storage.empty_file")
        val contentType = file.contentType ?: ""
        val ext = IMAGE_TYPES[contentType] ?: throw BadRequestException("error.storage.bad_type")
        if (file.size > maxMb * 1024 * 1024) {
            throw BadRequestException("error.storage.too_large", listOf(maxMb))
        }
        return ext
    }
}

@Component
@ConditionalOnProperty(name = ["app.storage.backend"], havingValue = "local", matchIfMissing = true)
class LocalStorageService(
    @Value("\${app.storage.dir:./data/uploads}") private val baseDir: String,
    @Value("\${app.storage.max-mb:5}") private val maxMb: Long,
) : StorageService {

    override fun store(namespace: String, file: MultipartFile): String {
        val ext = StorageRules.check(namespace, file, maxMb)
        val dir: Path = Paths.get(baseDir, namespace)
        Files.createDirectories(dir)
        val name = "${UUID.randomUUID()}.$ext"
        Files.copy(file.inputStream, dir.resolve(name), StandardCopyOption.REPLACE_EXISTING)
        return "/uploads/$namespace/$name"
    }

    override fun delete(publicUrl: String): Boolean = try {
        val relative = publicUrl.removePrefix("/uploads/").removePrefix("/")
        val target = Paths.get(baseDir, relative).normalize()
        // Stay inside the base dir (traversal guard).
        if (!target.startsWith(Paths.get(baseDir).normalize())) false
        else Files.deleteIfExists(target)
    } catch (_: Exception) {
        false
    }

    override fun exists(publicUrl: String): Boolean = try {
        val relative = publicUrl.removePrefix("/uploads/").removePrefix("/")
        Files.exists(Paths.get(baseDir, relative))
    } catch (_: Exception) {
        false
    }
}
