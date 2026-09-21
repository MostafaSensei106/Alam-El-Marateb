package com.mostafasensei.alamelmarateb.modules.product.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.i18n.LocaleContextHolder
import org.springframework.transaction.annotation.Transactional
import java.util.Locale
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class LocalizationFlowTest {

    @Autowired
    private lateinit var catalogService: ProductCatalogService

    @Test
    fun `translations resolve per locale with fallback and reject unknown langs`() {
        val suffix = System.nanoTime()
        val category = catalogService.createCategory(
            ProductCategory(
                name = "مراتب",
                slug = "loc-cat-$suffix",
                translations = mapOf("en" to mapOf("name" to "Mattresses")),
            ),
        )
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!,
                name = "مرتبة سيرتا",
                slug = "loc-prod-$suffix",
                brand = "سيرتا",
                description = "وصف عربي",
                translations = mapOf("en" to mapOf("name" to "Serta Mattress")),
            ),
        )

        LocaleContextHolder.setLocale(Locale("en"))
        try {
            val enCat = catalogService.getCategory(category.id!!)!!
            assertEquals("Mattresses", enCat.name)
            // description_en missing -> falls back to canonical Arabic.
            assertEquals(category.description, enCat.description)
            assertTrue(enCat.translations.containsKey("en"))

            val enProd = catalogService.getProduct(product.id!!)!!
            assertEquals("Serta Mattress", enProd.name)
            assertEquals("وصف عربي", enProd.description)
        } finally {
            LocaleContextHolder.resetLocaleContext()
        }

        LocaleContextHolder.setLocale(Locale("ar"))
        try {
            val arProd = catalogService.getProduct(product.id!!)!!
            // No ar row stored; canonical Arabic is the display value.
            assertEquals("مرتبة سيرتا", arProd.name)
        } finally {
            LocaleContextHolder.resetLocaleContext()
        }

        // Unknown language codes are rejected, never stored.
        assertFailsWith<BadRequestException> {
            catalogService.createCategory(
                ProductCategory(
                    name = "X",
                    slug = "loc-bad-$suffix",
                    translations = mapOf("xx" to mapOf("name" to "X")),
                ),
            )
        }
    }
}
