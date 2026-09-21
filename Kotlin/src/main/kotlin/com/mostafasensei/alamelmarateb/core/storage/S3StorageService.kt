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
        val ext = StorageRules.check(namespace, file, maxMb)
        val contentType = file.contentType ?: ""
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

    override fun delete(publicUrl: String): Boolean {
        val key = publicUrl.removePrefix("$publicBase/").removePrefix("/")
        if (key.isBlank() || key == publicUrl) return local.delete(publicUrl)
        return try {
            s3.deleteObject { it.bucket(bucket).key(key) }
            true
        } catch (ex: Exception) {
            log.warn("s3 delete failed key={}: {}", key, ex.message)
            false
        }
    }

    override fun exists(publicUrl: String): Boolean {
        val key = publicUrl.removePrefix("$publicBase/").removePrefix("/")
        if (key.isBlank() || key == publicUrl) return local.exists(publicUrl)
        return try {
            s3.headObject { it.bucket(bucket).key(key) }
            true
        } catch (_: Exception) {
            false
        }
    }
}
