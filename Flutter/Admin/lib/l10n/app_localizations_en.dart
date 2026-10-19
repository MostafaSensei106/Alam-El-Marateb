// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get retry => 'Retry';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get info => 'Info';

  @override
  String get warning => 'Warning';

  @override
  String get downloadFile => 'Download file';

  @override
  String get fileAlreadySaved => 'File is already saved.';

  @override
  String fileSavedToDcim(String fileName) {
    return 'File saved to gallery as $fileName.';
  }

  @override
  String fileSavedToDocuments(String fileName) {
    return 'File saved to documents as $fileName.';
  }

  @override
  String fileOpenedInBrowser(String fileName) {
    return 'File opened in a new browser tab: $fileName.';
  }

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get internetConnectionRestored => 'Internet connection restored';

  @override
  String get sessionExpired => 'Session expired';

  @override
  String get sessionExpiredDescription =>
      'Your session has expired. Please sign in again.';

  @override
  String get paid => 'Paid';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get partial => 'Partially paid';

  @override
  String get httpNoInternet =>
      'No internet connection. Please check your network.';

  @override
  String get httpRequestCancelled => 'The request was cancelled.';

  @override
  String get httpBadCertificate =>
      'The server certificate could not be verified.';

  @override
  String get httpGatewayTimeout => 'The server took too long to respond.';

  @override
  String get httpInternalServerError => 'An internal server error occurred.';

  @override
  String get httpUnknownError => 'An unknown error occurred.';

  @override
  String get error_name_cant_be_empty => 'Name can\'t be empty';

  @override
  String get error_name_invalid => 'Name is invalid';

  @override
  String get error_name_too_short_at_least_3_characters =>
      'Name must be at least 3 characters';

  @override
  String get error_name_too_long_maximum_20_characters =>
      'Name must be at most 20 characters';

  @override
  String get error_name_invalid_special_characters =>
      'Name contains invalid special characters';

  @override
  String get error_name_emoji_not_allowed =>
      'Emojis are not allowed in the name';

  @override
  String get error_email_cant_be_empty => 'Email can\'t be empty';

  @override
  String get error_email_not_invalid_format => 'Email format is invalid';

  @override
  String get error_email_contains_invalid_characters =>
      'Email contains invalid characters';

  @override
  String get error_email_must_contain_at_symbol =>
      'Email must contain an @ symbol';

  @override
  String get error_email_must_be_in_lowercase => 'Email must be in lowercase';

  @override
  String get error_email_emoji_not_allowed =>
      'Emojis are not allowed in the email';

  @override
  String get error_arabic_not_allowed => 'Arabic characters are not allowed';

  @override
  String get error_password_cant_be_empty => 'Password can\'t be empty';

  @override
  String get error_password_must_be_at_least_8_characters_long =>
      'Password must be at least 8 characters long';

  @override
  String
  get error_password_must_contain_uppercase_lowercase_number_and_special_character =>
      'Password must contain uppercase, lowercase, number and special character';

  @override
  String get error_phone_number_cant_be_empty => 'Phone number can\'t be empty';

  @override
  String get error_phone_number_invalid => 'Phone number is invalid';

  @override
  String get error_phone_number_min_length => 'Phone number is too short';

  @override
  String get error_address_line_cant_be_empty => 'Address line can\'t be empty';

  @override
  String get error_address_line_too_long => 'Address line is too long';

  @override
  String get error_address_invalid_special_characters =>
      'Address contains invalid special characters';

  @override
  String get error_address_emoji_not_allowed =>
      'Emojis are not allowed in the address';

  @override
  String get error_address_label_cant_be_empty =>
      'Address label can\'t be empty';

  @override
  String get error_address_label_too_long => 'Address label is too long';

  @override
  String get error_city_cant_be_empty => 'City can\'t be empty';

  @override
  String get error_city_too_long => 'City name is too long';

  @override
  String get error_city_invalid_special_characters =>
      'City contains invalid special characters';
}
