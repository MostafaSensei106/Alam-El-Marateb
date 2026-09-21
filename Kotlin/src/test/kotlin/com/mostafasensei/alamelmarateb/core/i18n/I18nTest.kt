package com.mostafasensei.alamelmarateb.core.i18n

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.i18n.LocaleContextHolder
import java.util.Locale
import kotlin.test.assertEquals

@SpringBootTest
class I18nTest {

    @Autowired
    private lateinit var messages: MessageService

    @Test
    fun `default locale is Arabic`() {
        LocaleContextHolder.setLocale(Locale("fr"))
        try {
            assertEquals("تمت العملية بنجاح", messages.get("success.operation"))
        } finally {
            LocaleContextHolder.resetLocaleContext()
        }
    }

    @Test
    fun `english header resolves English`() {
        LocaleContextHolder.setLocale(Locale("en"))
        try {
            assertEquals("Operation Successful", messages.get("success.operation"))
            assertEquals("Invalid phone or password", messages.get("auth.invalid_credentials"))
        } finally {
            LocaleContextHolder.resetLocaleContext()
        }
    }

    @Test
    fun `unknown code falls back to code`() {
        assertEquals("no.such.key", messages.get("no.such.key"))
    }

    @Test
    fun `domain error keys resolve in both locales with args`() {
        LocaleContextHolder.setLocale(Locale("ar"))
        try {
            assertEquals("السلة فارغة", messages.get("error.promo.cart_empty"))
            assertEquals("كود الفرع موجود بالفعل: TAN-01", messages.get("error.branch.code_exists", "TAN-01"))
            assertEquals("الحقل qty مطلوب", messages.get("validation.NotBlank", "qty"))
        } finally {
            LocaleContextHolder.resetLocaleContext()
        }
        LocaleContextHolder.setLocale(Locale("en"))
        try {
            assertEquals("Cart is empty", messages.get("error.promo.cart_empty"))
            assertEquals("Branch code already exists: TAN-01", messages.get("error.branch.code_exists", "TAN-01"))
            assertEquals("Field qty is required", messages.get("validation.NotBlank", "qty"))
        } finally {
            LocaleContextHolder.resetLocaleContext()
        }
    }
}
