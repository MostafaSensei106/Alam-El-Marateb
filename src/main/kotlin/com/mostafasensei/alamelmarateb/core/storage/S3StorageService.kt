package com.mostafasensei.alamelmarateb.core.storage

import jakarta.annotation.PostConstruct
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.stereotype.Component
import org.springframework.web.multipart.MultipartFile
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider
import software.amazon.awssdk.core.sync.RequestBody
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.s3.S3Client
import software.amazon.awssdk.services.s3.model.PutObjectRequest
import java.net.URI
import java.util.UUID

/**
 * S3-compatible backend (Minio profile in docker-compose, AWS later).
 * Active with app.storage.backend=s3; LocalStorageService stays the default.
 * Files are public-read (product photos); URLs are `<public-base>/<key>`.
 */
@Component
@ConditionalOnProperty(name = ["app.storage.backend"], havingValue = "s3")
class S3StorageService(
    @Value("\${app.storage.s3.endpoint:http://localhost:9000}") private val endpoint: String,
    @Value("\${app.storage.s3.region:us-east-1}") private val region: String,
    @Value("\${app.storage.s3.bucket:alamelmarateb}") private val bucket: String,
    @Value("\${app.storage.s3.access-key:minioadmin}") private val accessKey: String,
    @Value("\${app.storage.s3.secret-key:minioadmin123}") private val secretKey: String,
    @Value("\${app.storage.s3.public-base:http://localhost:9000/alamelmarateb}") private val publicBase: String,
    @Value("\${app.storage.max-mb:5}") private val maxMb: Long,
    private val local: LocalStorageService,
) : StorageService {

    private val log = LoggerFactory.getLogger(S3StorageService::class.java)
    private val allowed = setOf("image/jpeg", "image/png", "image/webp", "image/gif")

    private lateinit var s3: S3Client

    @PostConstruct
    fun init() {
        s3 = S3Client.builder()
            .endpointOverride(URI.create(endpoint))
            .region(Region.of(region))
            .credentialsProvider(StaticCredentialsProvider.create(AwsBasicCredentials.create(accessKey, secretKey)))
            .forcePathStyle(true)
            .build()
        try {
            s3.createBucket { it.bucket(bucket) }
        } catch (ex: Exception) {
            log.debug("bucket {} not created (may exist): {}", bucket, ex.message)
        }
    }

    override fun store(namespace: String, file: MultipartFile): String {
        if (file.isEmpty) throw com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException("error.storage.empty_file")
        val contentType = file.contentType ?: ""
        if (contentType !in allowed) throw com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException("error.storage.bad_type")
        if (file.size > maxMb * 1024 * 1024) {
            throw com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException("error.storage.too_large", listOf(maxMb))
        }
        val ext = when (contentType) {
            "image/jpeg" -> "jpg"
            "image/png" -> "png"
            "image/webp" -> "webp"
            else -> "gif"
        }
        val key = "$namespace/${UUID.randomUUID()}.$ext"
        try {
            s3.putObject(
                PutObjectRequest.builder().bucket(bucket).key(key).contentType(contentType).build(),
                RequestBody.fromInputStream(file.inputStream, file.size),
            )
        } catch (ex: Exception) {
            log.warn("s3 upload failed, local fallback: {}", ex.message)
            return local.store(namespace, file)
        }
        return "$publicBase/$key"
    }
}
