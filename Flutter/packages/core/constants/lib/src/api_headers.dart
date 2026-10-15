final class ApiHeader {
  ApiHeader._();
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String locale = 'locale';
  static const String authorization = 'Authorization';
  static const String applicationJson = 'application/json';
  static const String textPlain = 'text/plain';
  static const String multipartFormData = 'multipart/form-data';
  static const String xRequestedWith = 'X-Requested-With';
  static const String tokenType = 'Bearer';
  static const String acceptLanguage = 'Accept-Language';

  /// First-party client gate (backend `ClientKeyFilter`): every `/api/`
  /// call — login included — must carry both headers or it is rejected
  /// with 401 `CLIENT_REJECTED` before reaching any controller.
  static const String xApiClient = 'X-Api-Client';
  static const String xApiKey = 'X-Api-Key';
}
