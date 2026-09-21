package com.mostafasensei.alamelmarateb.core.common.api_response

data class PagedResponse<T : Any>(
    val items: List<T>,
    val page: Int,
    val size: Int,
    val totalElements: Long,
    val totalPages: Int,
) {
    companion object {
        fun <T : Any> of(items: List<T>, page: Int, size: Int, totalElements: Long): PagedResponse<T> {
            val totalPages = if (size <= 0) 0 else ((totalElements + size - 1) / size).toInt()
            return PagedResponse(items, page, size, totalElements, totalPages)
        }
    }
}
