package com.mostafasensei.alamelmarateb.core.storage

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.io.TempDir
import org.springframework.web.multipart.MultipartFile
import java.io.ByteArrayInputStream
import java.io.File
import java.io.InputStream
import java.nio.file.Path
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

private class FakeFile(
    private val name: String,
    private val contentType: String?,
    private val bytes: ByteArray,
) : MultipartFile {
    override fun getName(): String = "file"
    override fun getOriginalFilename(): String? = name
    override fun getContentType(): String? = contentType
    override fun isEmpty(): Boolean = bytes.isEmpty()
    override fun getSize(): Long = bytes.size.toLong()
    override fun getBytes(): ByteArray = bytes
    override fun getInputStream(): InputStream = ByteArrayInputStream(bytes)
    override fun transferTo(dest: File) {
        dest.writeBytes(bytes)
    }
    override fun transferTo(dest: Path) {
        java.nio.file.Files.write(dest, bytes)
    }
}

class LocalStorageServiceTest {

    @TempDir
    lateinit var tmp: Path

    private fun service(maxMb: Long = 5) = LocalStorageService(tmp.toString(), maxMb)

    @Test
    fun `stores image and rejects bad type, empty and oversize`() {
        val url = service().store("products", FakeFile("m.png", "image/png", ByteArray(100) { 7 }))
        assertTrue(url.startsWith("/uploads/products/") && url.endsWith(".png"))
        assertTrue(tmp.resolve(url.removePrefix("/uploads/")).toFile().exists())

        assertFailsWith<BadRequestException> {
            service().store("products", FakeFile("a.pdf", "application/pdf", ByteArray(10)))
        }
        assertFailsWith<BadRequestException> {
            service().store("products", FakeFile("e.png", "image/png", ByteArray(0)))
        }
        assertFailsWith<BadRequestException> {
            service(maxMb = 0).store("products", FakeFile("b.png", "image/png", ByteArray(10)))
        }
    }
}
