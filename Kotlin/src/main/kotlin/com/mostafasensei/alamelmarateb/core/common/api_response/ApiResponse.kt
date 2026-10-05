package com.mostafasensei.alamelmarateb.core.common.api_response

import com.fasterxml.jackson.annotation.JsonInclude

/**
 * Global response contract: {success, message, data?, errors?} — nothing else.
 * No timestamps, no trace ids in the body: clients cache and diff payloads
 * byte-for-byte. Correlation travels in the `X-Trace-Id` response header.
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
data class ApiResponse<T>(
    val success: Boolean,
    val message: String,
    val data: T? = null,
    val errors : List<String>? = null,
) {
    companion object {
        fun <T> success(data: T, message: String): ApiResponse<T> = ApiResponse(success = true, message = message, data = data)
        fun <T> messageWithoutData(message: String): ApiResponse<T> = ApiResponse(true, message = message, data = null)
        fun <T> failure(message: String, errors: List<String>? = null): ApiResponse<T> = ApiResponse(success = false, message = message, data = null, errors = errors)
    }


}