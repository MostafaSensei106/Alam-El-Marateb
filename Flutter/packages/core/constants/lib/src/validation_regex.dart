/// Dart Extension & Utility class for Flutter form validation.
extension ValidationRegex on String {
  /// Auth & Credentials Validation
  /// RFC 5322 Compliant Email validation
  bool get isValidEmail => RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
  ).hasMatch(this);

  /// Simple password: Minimum 8 characters with at least one letter and one number
  bool get isValidSimplePassword =>
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$').hasMatch(this);

  /// Strong password: Min 8 chars, uppercase, lowercase, number & special char
  bool get isValidStrongPassword => RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?~`]).{8,}$',
  ).hasMatch(this);

  /// Username: 3-20 alphanumeric characters with underscores and dots
  bool get isValidUsername => RegExp(r'^[a-zA-Z0-9._]{3,20}$').hasMatch(this);

  /// Personal & Text Validation
  /// Name validation (supports Arabic, English, spaces, and hyphens)
  bool get isValidName => RegExp(
    r'^[a-zA-Z\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\s-]+$',
  ).hasMatch(this);

  /// Arabic-only text (includes Arabic diacritics and spaces)
  bool get isArabicOnly => RegExp(
    r'^[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\s]+$',
  ).hasMatch(this);

  /// English-only text
  bool get isEnglishOnly => RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);

  /// Egyptian National ID (14 digits)
  bool get isValidEgyptNationalId =>
      RegExp(r'^(2|3)[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])[0-9]{7}$')
          .hasMatch(this);

  /// Phone Numbers
  /// International phone number (E.164 standard)
  bool get isValidInternationalPhone =>
      RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(this);

  /// Egyptian phone number (010, 011, 012, 015 or international code +20)
  bool get isValidEgyptPhone =>
      RegExp(r'^(?:\+20|0)?1[0125]\d{8}$').hasMatch(this);

  /// Saudi phone number (05XXXXXXX or international code +966)
  bool get isValidSaudiPhone => RegExp(r'^(?:\+966|0)?5\d{8}$').hasMatch(this);

  /// Web, Network & Formats
  /// Complete URL validation (supports HTTP/HTTPS, ports, query params)
  bool get isValidUrl => RegExp(
    r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  ).hasMatch(this);

  /// IPv4 Address
  bool get isValidIpv4 => RegExp(
    r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
  ).hasMatch(this);

  /// IPv6 Address
  bool get isValidIpv6 => RegExp(
    r'^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$',
  ).hasMatch(this);

  /// UUID (v4)
  bool get isValidUuid => RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[4][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  ).hasMatch(this);

  /// HEX Color Code (#FFF, #FFFFFF, or #FFFFFFFF)
  bool get isValidHexColor => RegExp(
    r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
  ).hasMatch(this);

  /// Payment & Finance
  /// Credit Card (Visa, MasterCard, Amex, Discover - 13 to 19 digits)
  bool get isValidCreditCard => RegExp(
    r'^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$',
  ).hasMatch(this);

  /// Card CVC / CVV Code (3 or 4 digits)
  bool get isValidCvc => RegExp(r'^[0-9]{3,4}$').hasMatch(this);

  /// Credit Card Expiry Date (MM/YY or MM/YYYY)
  bool get isValidCreditCardExpiry =>
      RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2}|20[0-9]{2})$').hasMatch(this);

  /// Dates & Numbers
  /// Digits only
  bool get isDigitsOnly => RegExp(r'^\d+$').hasMatch(this);

  /// Decimal / Double numbers
  bool get isNumeric => RegExp(r'^\d+(\.\d+)?$').hasMatch(this);

  /// ISO Date format (YYYY-MM-DD)
  bool get isValidIsoDate =>
      RegExp(r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$')
          .hasMatch(this);

  /// 24-Hour Time format (HH:mm)
  bool get isValid24hrTime =>
      RegExp(r'^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(this);

  /// 7. Utilities & Character Checks
  /// Contains no whitespace
  bool get hasNoWhitespace => RegExp(r'^\S+$').hasMatch(this);

  /// Contains Emojis
  bool get containsEmoji => RegExp(
    r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
  ).hasMatch(this);

  /// Contains invalid special characters
  bool get hasInvalidSpecialChars =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);

  /// Slug format (e.g., my-blog-post-title)
  bool get isValidSlug => RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(this);

  /// Base64 encoded string
  bool get isBase64 => RegExp(
    r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$',
  ).hasMatch(this);
}
