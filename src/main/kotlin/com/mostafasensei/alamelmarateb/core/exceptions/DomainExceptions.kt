package com.mostafasensei.alamelmarateb.core.exceptions

/**
 * Localized failures (arch.md §11 — one language per request).
 *
 * Convention: services throw with an [errorKey] from messages_*.properties
 * plus [errorArgs] for placeholders — NEVER a hardcoded English sentence.
 * [GlobalExceptionHandler] renders key+args in the request locale (X-Lang)
 * into ApiResponse.errors. RuntimeException.message stays the key for logs.
 */
data class ErrorDetail(val key: String, val args: List<Any> = emptyList())

open class LocalizedException(
    val errorKey: String,
    val errorArgs: List<Any> = emptyList(),
    val errorDetails: List<ErrorDetail> = emptyList(),
) : RuntimeException(errorKey)

class NotFoundException(
    errorKey: String,
    errorArgs: List<Any> = emptyList(),
) : LocalizedException(errorKey, errorArgs)

class ConflictException(
    errorKey: String,
    errorArgs: List<Any> = emptyList(),
) : LocalizedException(errorKey, errorArgs)

class BadRequestException(
    errorKey: String,
    errorArgs: List<Any> = emptyList(),
    errorDetails: List<ErrorDetail> = emptyList(),
) : LocalizedException(errorKey, errorArgs, errorDetails)

/** 422 — request syntax is valid but business semantics reject it (api-status.md §3). */
class UnprocessableException(
    errorKey: String,
    errorArgs: List<Any> = emptyList(),
    errorDetails: List<ErrorDetail> = emptyList(),
) : LocalizedException(errorKey, errorArgs, errorDetails)

/** 410 — resource existed and was permanently removed (old links, favorites). */
class GoneException(
    errorKey: String,
    errorArgs: List<Any> = emptyList(),
) : LocalizedException(errorKey, errorArgs)

/** 412 — If-Match / version precondition failed (concurrent edit). */
class PreconditionFailedException(
    errorKey: String,
    errorArgs: List<Any> = emptyList(),
) : LocalizedException(errorKey, errorArgs)

/** 429 — rate limit exceeded; [retryAfterSeconds] drives the Retry-After header. */
class RateLimitException(
    errorKey: String,
    errorArgs: List<Any> = emptyList(),
    val retryAfterSeconds: Long = 60,
) : LocalizedException(errorKey, errorArgs)
