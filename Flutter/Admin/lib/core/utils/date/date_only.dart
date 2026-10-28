/// Small date helpers shared by the API models.
///
/// The backend exposes `LocalDate` values as `yyyy-MM-dd` and `Instant` values
/// as ISO-8601 strings, so the app only needs these two directions.
library;

/// Formats [date] as the `yyyy-MM-dd` string the API expects for `LocalDate`.
String formatDateOnly(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year.toString().padLeft(4, '0')}-$month-$day';
}

/// Parses an ISO-8601 string (date or full timestamp). Returns `null` when the
/// value is missing or malformed.
DateTime? parseDateTime(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

/// Parses an ISO-8601 date and falls back to [fallback] when the value is
/// missing. Reports always carry their boundaries, so the fallback is only a
/// guard against a truncated payload.
DateTime parseDateOr(String? raw, DateTime fallback) =>
    parseDateTime(raw) ?? fallback;
