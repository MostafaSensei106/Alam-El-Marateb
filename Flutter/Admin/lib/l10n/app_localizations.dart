import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget password?'**
  String get forgetPassword;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get email;

  /// No description provided for @alm_el_marateb.
  ///
  /// In en, this message translates to:
  /// **'Alm-El-Marateb'**
  String get alm_el_marateb;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @enterYourCredentialsToAccessYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access your account.'**
  String get enterYourCredentialsToAccessYourAccount;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @downloadFile.
  ///
  /// In en, this message translates to:
  /// **'Download file'**
  String get downloadFile;

  /// No description provided for @fileAlreadySaved.
  ///
  /// In en, this message translates to:
  /// **'File is already saved.'**
  String get fileAlreadySaved;

  /// No description provided for @fileSavedToDcim.
  ///
  /// In en, this message translates to:
  /// **'File saved to gallery as {fileName}.'**
  String fileSavedToDcim(String fileName);

  /// No description provided for @fileSavedToDocuments.
  ///
  /// In en, this message translates to:
  /// **'File saved to documents as {fileName}.'**
  String fileSavedToDocuments(String fileName);

  /// No description provided for @fileOpenedInBrowser.
  ///
  /// In en, this message translates to:
  /// **'File opened in a new browser tab: {fileName}.'**
  String fileOpenedInBrowser(String fileName);

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @internetConnectionRestored.
  ///
  /// In en, this message translates to:
  /// **'Internet connection restored'**
  String get internetConnectionRestored;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get sessionExpired;

  /// No description provided for @sessionExpiredDescription.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get sessionExpiredDescription;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @partial.
  ///
  /// In en, this message translates to:
  /// **'Partially paid'**
  String get partial;

  /// No description provided for @httpNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get httpNoInternet;

  /// No description provided for @httpConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your connection and try again.'**
  String get httpConnectionFailed;

  /// No description provided for @httpRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled.'**
  String get httpRequestCancelled;

  /// No description provided for @httpBadCertificate.
  ///
  /// In en, this message translates to:
  /// **'The server certificate could not be verified.'**
  String get httpBadCertificate;

  /// No description provided for @httpGatewayTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond.'**
  String get httpGatewayTimeout;

  /// No description provided for @httpInternalServerError.
  ///
  /// In en, this message translates to:
  /// **'An internal server error occurred.'**
  String get httpInternalServerError;

  /// No description provided for @httpUnknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get httpUnknownError;

  /// No description provided for @error_name_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be empty'**
  String get error_name_cant_be_empty;

  /// No description provided for @error_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'Name is invalid'**
  String get error_name_invalid;

  /// No description provided for @error_name_too_short_at_least_3_characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get error_name_too_short_at_least_3_characters;

  /// No description provided for @error_name_too_long_maximum_20_characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at most 20 characters'**
  String get error_name_too_long_maximum_20_characters;

  /// No description provided for @error_name_invalid_special_characters.
  ///
  /// In en, this message translates to:
  /// **'Name contains invalid special characters'**
  String get error_name_invalid_special_characters;

  /// No description provided for @error_name_emoji_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Emojis are not allowed in the name'**
  String get error_name_emoji_not_allowed;

  /// No description provided for @error_email_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Email can\'t be empty'**
  String get error_email_cant_be_empty;

  /// No description provided for @error_email_not_invalid_format.
  ///
  /// In en, this message translates to:
  /// **'Email format is invalid'**
  String get error_email_not_invalid_format;

  /// No description provided for @error_email_contains_invalid_characters.
  ///
  /// In en, this message translates to:
  /// **'Email contains invalid characters'**
  String get error_email_contains_invalid_characters;

  /// No description provided for @error_email_must_contain_at_symbol.
  ///
  /// In en, this message translates to:
  /// **'Email must contain an @ symbol'**
  String get error_email_must_contain_at_symbol;

  /// No description provided for @error_email_must_be_in_lowercase.
  ///
  /// In en, this message translates to:
  /// **'Email must be in lowercase'**
  String get error_email_must_be_in_lowercase;

  /// No description provided for @error_email_emoji_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Emojis are not allowed in the email'**
  String get error_email_emoji_not_allowed;

  /// No description provided for @error_arabic_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Arabic characters are not allowed'**
  String get error_arabic_not_allowed;

  /// No description provided for @error_password_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Password can\'t be empty'**
  String get error_password_cant_be_empty;

  /// No description provided for @error_password_must_be_at_least_8_characters_long.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get error_password_must_be_at_least_8_characters_long;

  /// No description provided for @error_password_must_contain_uppercase_lowercase_number_and_special_character.
  ///
  /// In en, this message translates to:
  /// **'Password must contain uppercase, lowercase, number and special character'**
  String
  get error_password_must_contain_uppercase_lowercase_number_and_special_character;

  /// No description provided for @error_phone_number_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Phone number can\'t be empty'**
  String get error_phone_number_cant_be_empty;

  /// No description provided for @error_phone_number_invalid.
  ///
  /// In en, this message translates to:
  /// **'Phone number is invalid'**
  String get error_phone_number_invalid;

  /// No description provided for @error_phone_number_min_length.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too short'**
  String get error_phone_number_min_length;

  /// No description provided for @error_address_line_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Address line can\'t be empty'**
  String get error_address_line_cant_be_empty;

  /// No description provided for @error_address_line_too_long.
  ///
  /// In en, this message translates to:
  /// **'Address line is too long'**
  String get error_address_line_too_long;

  /// No description provided for @error_address_invalid_special_characters.
  ///
  /// In en, this message translates to:
  /// **'Address contains invalid special characters'**
  String get error_address_invalid_special_characters;

  /// No description provided for @error_address_emoji_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Emojis are not allowed in the address'**
  String get error_address_emoji_not_allowed;

  /// No description provided for @error_address_label_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Address label can\'t be empty'**
  String get error_address_label_cant_be_empty;

  /// No description provided for @error_address_label_too_long.
  ///
  /// In en, this message translates to:
  /// **'Address label is too long'**
  String get error_address_label_too_long;

  /// No description provided for @error_city_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'City can\'t be empty'**
  String get error_city_cant_be_empty;

  /// No description provided for @error_city_too_long.
  ///
  /// In en, this message translates to:
  /// **'City name is too long'**
  String get error_city_too_long;

  /// No description provided for @error_city_invalid_special_characters.
  ///
  /// In en, this message translates to:
  /// **'City contains invalid special characters'**
  String get error_city_invalid_special_characters;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get navIdentity;

  /// No description provided for @navCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get navCatalog;

  /// No description provided for @navInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// No description provided for @navSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get navSales;

  /// No description provided for @navPurchasing.
  ///
  /// In en, this message translates to:
  /// **'Purchasing'**
  String get navPurchasing;

  /// No description provided for @navCrm.
  ///
  /// In en, this message translates to:
  /// **'CRM'**
  String get navCrm;

  /// No description provided for @navDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get navDelivery;

  /// No description provided for @navHr.
  ///
  /// In en, this message translates to:
  /// **'HR'**
  String get navHr;

  /// No description provided for @navAccounting.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get navAccounting;

  /// No description provided for @navMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get navMarketing;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @expandNavigation.
  ///
  /// In en, this message translates to:
  /// **'Expand navigation'**
  String get expandNavigation;

  /// No description provided for @collapseNavigation.
  ///
  /// In en, this message translates to:
  /// **'Collapse navigation'**
  String get collapseNavigation;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get toggleTheme;

  /// No description provided for @screenComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This screen will be added soon.'**
  String get screenComingSoon;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics & Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Key performance indicators and administrative analytics'**
  String get dashboardDescription;

  /// No description provided for @dashboardFeature1.
  ///
  /// In en, this message translates to:
  /// **'Sales, revenue and profit summary'**
  String get dashboardFeature1;

  /// No description provided for @dashboardFeature2.
  ///
  /// In en, this message translates to:
  /// **'Branch performance comparison'**
  String get dashboardFeature2;

  /// No description provided for @dashboardFeature3.
  ///
  /// In en, this message translates to:
  /// **'Sales and orders heat map'**
  String get dashboardFeature3;

  /// No description provided for @dashboardFeature4.
  ///
  /// In en, this message translates to:
  /// **'Best-selling products and turnover speed'**
  String get dashboardFeature4;

  /// No description provided for @dashboardFeature5.
  ///
  /// In en, this message translates to:
  /// **'Customer RFM analysis'**
  String get dashboardFeature5;

  /// No description provided for @identityTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity & Access'**
  String get identityTitle;

  /// No description provided for @identityDescription.
  ///
  /// In en, this message translates to:
  /// **'Branches, users and permissions'**
  String get identityDescription;

  /// No description provided for @identityFeature1.
  ///
  /// In en, this message translates to:
  /// **'Manage branches and showrooms'**
  String get identityFeature1;

  /// No description provided for @identityFeature2.
  ///
  /// In en, this message translates to:
  /// **'Users, roles and permissions'**
  String get identityFeature2;

  /// No description provided for @identityFeature3.
  ///
  /// In en, this message translates to:
  /// **'Vehicle fleet and load capacities'**
  String get identityFeature3;

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog Management'**
  String get catalogTitle;

  /// No description provided for @catalogDescription.
  ///
  /// In en, this message translates to:
  /// **'Products, catalog and pricing'**
  String get catalogDescription;

  /// No description provided for @catalogFeature1.
  ///
  /// In en, this message translates to:
  /// **'Products, images, translations and specifications'**
  String get catalogFeature1;

  /// No description provided for @catalogFeature2.
  ///
  /// In en, this message translates to:
  /// **'Categories and brands'**
  String get catalogFeature2;

  /// No description provided for @catalogFeature3.
  ///
  /// In en, this message translates to:
  /// **'Attributes, traits and options'**
  String get catalogFeature3;

  /// No description provided for @catalogFeature4.
  ///
  /// In en, this message translates to:
  /// **'Price lists and sales channel prices'**
  String get catalogFeature4;

  /// No description provided for @catalogFeature5.
  ///
  /// In en, this message translates to:
  /// **'Square meter pricing and custom shapes'**
  String get catalogFeature5;

  /// No description provided for @inventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory & Warehouse'**
  String get inventoryTitle;

  /// No description provided for @inventoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Warehouses, stock movement and cost'**
  String get inventoryDescription;

  /// No description provided for @inventoryFeature1.
  ///
  /// In en, this message translates to:
  /// **'Manage warehouses'**
  String get inventoryFeature1;

  /// No description provided for @inventoryFeature2.
  ///
  /// In en, this message translates to:
  /// **'Stock balances and low-stock alerts'**
  String get inventoryFeature2;

  /// No description provided for @inventoryFeature3.
  ///
  /// In en, this message translates to:
  /// **'Transfers between warehouses'**
  String get inventoryFeature3;

  /// No description provided for @inventoryFeature4.
  ///
  /// In en, this message translates to:
  /// **'Stock counts and adjustments'**
  String get inventoryFeature4;

  /// No description provided for @inventoryFeature5.
  ///
  /// In en, this message translates to:
  /// **'Batches and FIFO inventory valuation'**
  String get inventoryFeature5;

  /// No description provided for @salesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales & POS'**
  String get salesTitle;

  /// No description provided for @salesDescription.
  ///
  /// In en, this message translates to:
  /// **'Sales, point of sale and orders'**
  String get salesDescription;

  /// No description provided for @salesFeature1.
  ///
  /// In en, this message translates to:
  /// **'Point of sale, barcode and discounts'**
  String get salesFeature1;

  /// No description provided for @salesFeature2.
  ///
  /// In en, this message translates to:
  /// **'Payment methods: cash, card and credit'**
  String get salesFeature2;

  /// No description provided for @salesFeature3.
  ///
  /// In en, this message translates to:
  /// **'Open shifts, cash handover and closing'**
  String get salesFeature3;

  /// No description provided for @salesFeature4.
  ///
  /// In en, this message translates to:
  /// **'Orders, returns and cancellations'**
  String get salesFeature4;

  /// No description provided for @salesFeature5.
  ///
  /// In en, this message translates to:
  /// **'Special orders, reservations and deposits'**
  String get salesFeature5;

  /// No description provided for @salesFeature6.
  ///
  /// In en, this message translates to:
  /// **'Promotions and coupons'**
  String get salesFeature6;

  /// No description provided for @purchasingTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchasing'**
  String get purchasingTitle;

  /// No description provided for @purchasingDescription.
  ///
  /// In en, this message translates to:
  /// **'Suppliers, purchase orders and costs'**
  String get purchasingDescription;

  /// No description provided for @purchasingFeature1.
  ///
  /// In en, this message translates to:
  /// **'Suppliers and account statements'**
  String get purchasingFeature1;

  /// No description provided for @purchasingFeature2.
  ///
  /// In en, this message translates to:
  /// **'Purchase orders and goods receipt'**
  String get purchasingFeature2;

  /// No description provided for @purchasingFeature3.
  ///
  /// In en, this message translates to:
  /// **'Shipments, customs and additional costs'**
  String get purchasingFeature3;

  /// No description provided for @purchasingFeature4.
  ///
  /// In en, this message translates to:
  /// **'Supplier invoices, installments and payments'**
  String get purchasingFeature4;

  /// No description provided for @crmTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Relations'**
  String get crmTitle;

  /// No description provided for @crmDescription.
  ///
  /// In en, this message translates to:
  /// **'Customers, warranty and complaints'**
  String get crmDescription;

  /// No description provided for @crmFeature1.
  ///
  /// In en, this message translates to:
  /// **'Warranty registry'**
  String get crmFeature1;

  /// No description provided for @crmFeature2.
  ///
  /// In en, this message translates to:
  /// **'Customer claims, inspections and repairs'**
  String get crmFeature2;

  /// No description provided for @crmFeature3.
  ///
  /// In en, this message translates to:
  /// **'Customer review moderation'**
  String get crmFeature3;

  /// No description provided for @crmFeature4.
  ///
  /// In en, this message translates to:
  /// **'Inquiries and product questions'**
  String get crmFeature4;

  /// No description provided for @deliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get deliveryTitle;

  /// No description provided for @deliveryDescription.
  ///
  /// In en, this message translates to:
  /// **'Trips, drivers and delivery tracking'**
  String get deliveryDescription;

  /// No description provided for @deliveryFeature1.
  ///
  /// In en, this message translates to:
  /// **'Create delivery trips and group orders'**
  String get deliveryFeature1;

  /// No description provided for @deliveryFeature2.
  ///
  /// In en, this message translates to:
  /// **'Assign driver and vehicle'**
  String get deliveryFeature2;

  /// No description provided for @deliveryFeature3.
  ///
  /// In en, this message translates to:
  /// **'Route optimization'**
  String get deliveryFeature3;

  /// No description provided for @deliveryFeature4.
  ///
  /// In en, this message translates to:
  /// **'Live tracking and stops'**
  String get deliveryFeature4;

  /// No description provided for @deliveryFeature5.
  ///
  /// In en, this message translates to:
  /// **'Proof of delivery by photo or signature'**
  String get deliveryFeature5;

  /// No description provided for @hrTitle.
  ///
  /// In en, this message translates to:
  /// **'Human Resources'**
  String get hrTitle;

  /// No description provided for @hrDescription.
  ///
  /// In en, this message translates to:
  /// **'Employees, leave and payroll'**
  String get hrDescription;

  /// No description provided for @hrFeature1.
  ///
  /// In en, this message translates to:
  /// **'Employee records and job data'**
  String get hrFeature1;

  /// No description provided for @hrFeature2.
  ///
  /// In en, this message translates to:
  /// **'Leave requests'**
  String get hrFeature2;

  /// No description provided for @hrFeature3.
  ///
  /// In en, this message translates to:
  /// **'Payroll runs and Excel export'**
  String get hrFeature3;

  /// No description provided for @hrFeature4.
  ///
  /// In en, this message translates to:
  /// **'Commissions, advances and deductions'**
  String get hrFeature4;

  /// No description provided for @accountingTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounting & Finance'**
  String get accountingTitle;

  /// No description provided for @accountingDescription.
  ///
  /// In en, this message translates to:
  /// **'Accounts, treasuries and financial reports'**
  String get accountingDescription;

  /// No description provided for @accountingFeature1.
  ///
  /// In en, this message translates to:
  /// **'Chart of accounts'**
  String get accountingFeature1;

  /// No description provided for @accountingFeature2.
  ///
  /// In en, this message translates to:
  /// **'Journal entries and general ledger'**
  String get accountingFeature2;

  /// No description provided for @accountingFeature3.
  ///
  /// In en, this message translates to:
  /// **'Treasuries, banks and fund transfers'**
  String get accountingFeature3;

  /// No description provided for @accountingFeature4.
  ///
  /// In en, this message translates to:
  /// **'Expenses and checks'**
  String get accountingFeature4;

  /// No description provided for @accountingFeature5.
  ///
  /// In en, this message translates to:
  /// **'Income statement, balance sheet and tax reports'**
  String get accountingFeature5;

  /// No description provided for @marketingTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get marketingTitle;

  /// No description provided for @marketingDescription.
  ///
  /// In en, this message translates to:
  /// **'Promotional campaigns'**
  String get marketingDescription;

  /// No description provided for @marketingFeature1.
  ///
  /// In en, this message translates to:
  /// **'Wheel of fortune campaigns'**
  String get marketingFeature1;

  /// No description provided for @marketingFeature2.
  ///
  /// In en, this message translates to:
  /// **'Prize management and campaign activation'**
  String get marketingFeature2;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Profile'**
  String get profileTitle;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'The administrator\'s personal data'**
  String get profileDescription;

  /// No description provided for @profileFeature1.
  ///
  /// In en, this message translates to:
  /// **'Personal account details'**
  String get profileFeature1;

  /// No description provided for @profileFeature2.
  ///
  /// In en, this message translates to:
  /// **'Edit name and contact details'**
  String get profileFeature2;

  /// No description provided for @profileFeature3.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileFeature3;

  /// No description provided for @profileFeature4.
  ///
  /// In en, this message translates to:
  /// **'Review user role and permissions'**
  String get profileFeature4;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsDescription.
  ///
  /// In en, this message translates to:
  /// **'System and application settings'**
  String get settingsDescription;

  /// No description provided for @settingsFeature1.
  ///
  /// In en, this message translates to:
  /// **'Language and appearance'**
  String get settingsFeature1;

  /// No description provided for @settingsFeature2.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get settingsFeature2;

  /// No description provided for @settingsFeature3.
  ///
  /// In en, this message translates to:
  /// **'General system settings'**
  String get settingsFeature3;

  /// No description provided for @settingsFeature4.
  ///
  /// In en, this message translates to:
  /// **'App info'**
  String get settingsFeature4;

  /// No description provided for @adminWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Admin workspace'**
  String get adminWorkspace;

  /// No description provided for @adminDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Mostafa Mahmoud'**
  String get adminDisplayName;

  /// No description provided for @adminRole.
  ///
  /// In en, this message translates to:
  /// **'Super administrator'**
  String get adminRole;

  /// No description provided for @openAccountMenu.
  ///
  /// In en, this message translates to:
  /// **'Open account menu'**
  String get openAccountMenu;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access the admin workspace.'**
  String get signOutConfirmMessage;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @plannedScreens.
  ///
  /// In en, this message translates to:
  /// **'Planned screens'**
  String get plannedScreens;

  /// No description provided for @interactivePrototype.
  ///
  /// In en, this message translates to:
  /// **'Interactive prototype'**
  String get interactivePrototype;

  /// No description provided for @prototypeNotice.
  ///
  /// In en, this message translates to:
  /// **'Layout preview with sample data. Screens will be connected to the API next.'**
  String get prototypeNotice;

  /// No description provided for @sampleData.
  ///
  /// In en, this message translates to:
  /// **'Sample data'**
  String get sampleData;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String dashboardGreeting(String name);

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here is what is happening across your store today.'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get dashboardRevenue;

  /// No description provided for @dashboardOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get dashboardOrders;

  /// No description provided for @dashboardCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get dashboardCustomers;

  /// No description provided for @dashboardLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get dashboardLowStock;

  /// No description provided for @dashboardRevenueChange.
  ///
  /// In en, this message translates to:
  /// **'+12.4% vs last week'**
  String get dashboardRevenueChange;

  /// No description provided for @dashboardOrdersChange.
  ///
  /// In en, this message translates to:
  /// **'+8.1% vs last week'**
  String get dashboardOrdersChange;

  /// No description provided for @dashboardCustomersChange.
  ///
  /// In en, this message translates to:
  /// **'+4.6% vs last week'**
  String get dashboardCustomersChange;

  /// No description provided for @dashboardLowStockChange.
  ///
  /// In en, this message translates to:
  /// **'6 items need attention'**
  String get dashboardLowStockChange;

  /// No description provided for @dashboardRevenueTrend.
  ///
  /// In en, this message translates to:
  /// **'Revenue, last 7 days'**
  String get dashboardRevenueTrend;

  /// No description provided for @dashboardAverageOrder.
  ///
  /// In en, this message translates to:
  /// **'Average order'**
  String get dashboardAverageOrder;

  /// No description provided for @dashboardTodaySales.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dashboardTodaySales;

  /// No description provided for @dashboardRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent orders'**
  String get dashboardRecentOrders;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get dashboardViewAll;

  /// No description provided for @dashboardOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get dashboardOrder;

  /// No description provided for @dashboardCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get dashboardCustomer;

  /// No description provided for @dashboardStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get dashboardStatus;

  /// No description provided for @dashboardTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get dashboardTotal;

  /// No description provided for @dashboardStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get dashboardStatusPaid;

  /// No description provided for @dashboardStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get dashboardStatusPending;

  /// No description provided for @dashboardStatusShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get dashboardStatusShipping;

  /// No description provided for @dashboardNewSale.
  ///
  /// In en, this message translates to:
  /// **'New sale'**
  String get dashboardNewSale;

  /// No description provided for @dashboardAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get dashboardAddProduct;

  /// No description provided for @dashboardNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'New customer'**
  String get dashboardNewCustomer;

  /// No description provided for @dashboardCreateTrip.
  ///
  /// In en, this message translates to:
  /// **'Delivery trip'**
  String get dashboardCreateTrip;

  /// No description provided for @profileAccountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get profileAccountDetails;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileFullName;

  /// No description provided for @profileJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get profileJobTitle;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get profileBranch;

  /// No description provided for @profileBranchValue.
  ///
  /// In en, this message translates to:
  /// **'Main showroom · Tanta'**
  String get profileBranchValue;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get profileMemberSince;

  /// No description provided for @profileMemberSinceValue.
  ///
  /// In en, this message translates to:
  /// **'January 2024'**
  String get profileMemberSinceValue;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @profilePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferences;

  /// No description provided for @profileSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSecurity;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileChangePassword;

  /// No description provided for @profileChangePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Use a strong password you don\'t reuse elsewhere.'**
  String get profileChangePasswordDescription;

  /// No description provided for @profileTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication'**
  String get profileTwoFactor;

  /// No description provided for @profileTwoFactorDescription.
  ///
  /// In en, this message translates to:
  /// **'Ask for a verification code on every new device.'**
  String get profileTwoFactorDescription;

  /// No description provided for @profileSessions.
  ///
  /// In en, this message translates to:
  /// **'Active sessions'**
  String get profileSessions;

  /// No description provided for @profileSessionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign out of every device except this one.'**
  String get profileSessionsDescription;

  /// No description provided for @profilePermissions.
  ///
  /// In en, this message translates to:
  /// **'Role & permissions'**
  String get profilePermissions;

  /// No description provided for @profilePermissionHint.
  ///
  /// In en, this message translates to:
  /// **'Full access to every module in the workspace.'**
  String get profilePermissionHint;

  /// No description provided for @profilePermissionAll.
  ///
  /// In en, this message translates to:
  /// **'All modules'**
  String get profilePermissionAll;

  /// No description provided for @profileEditNotReady.
  ///
  /// In en, this message translates to:
  /// **'Profile editing will be enabled once the API is connected.'**
  String get profileEditNotReady;

  /// No description provided for @profilePasswordNotReady.
  ///
  /// In en, this message translates to:
  /// **'Password changes will be enabled once the API is connected.'**
  String get profilePasswordNotReady;

  /// No description provided for @profileTwoFactorOn.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication enabled.'**
  String get profileTwoFactorOn;

  /// No description provided for @profileTwoFactorOff.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication disabled.'**
  String get profileTwoFactorOff;

  /// No description provided for @profileSessionsCleared.
  ///
  /// In en, this message translates to:
  /// **'Other sessions were signed out.'**
  String get profileSessionsCleared;

  /// No description provided for @profileSignOutDevice.
  ///
  /// In en, this message translates to:
  /// **'Sign out from this device'**
  String get profileSignOutDevice;

  /// No description provided for @settingsAppearanceHint.
  ///
  /// In en, this message translates to:
  /// **'Choose how the admin panel looks.'**
  String get settingsAppearanceHint;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsHint.
  ///
  /// In en, this message translates to:
  /// **'Pick the events you want to be alerted about.'**
  String get settingsNotificationsHint;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsGeneralHint.
  ///
  /// In en, this message translates to:
  /// **'Defaults that apply to the whole workspace.'**
  String get settingsGeneralHint;

  /// No description provided for @settingsNotificationOrders.
  ///
  /// In en, this message translates to:
  /// **'New orders'**
  String get settingsNotificationOrders;

  /// No description provided for @settingsNotificationOrdersHint.
  ///
  /// In en, this message translates to:
  /// **'Alert me when an order is placed.'**
  String get settingsNotificationOrdersHint;

  /// No description provided for @settingsNotificationLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get settingsNotificationLowStock;

  /// No description provided for @settingsNotificationLowStockHint.
  ///
  /// In en, this message translates to:
  /// **'Alert me when an item drops below its reorder point.'**
  String get settingsNotificationLowStockHint;

  /// No description provided for @settingsNotificationReviews.
  ///
  /// In en, this message translates to:
  /// **'New reviews'**
  String get settingsNotificationReviews;

  /// No description provided for @settingsNotificationReviewsHint.
  ///
  /// In en, this message translates to:
  /// **'Alert me when a customer leaves a review.'**
  String get settingsNotificationReviewsHint;

  /// No description provided for @settingsNotificationDigest.
  ///
  /// In en, this message translates to:
  /// **'Daily digest'**
  String get settingsNotificationDigest;

  /// No description provided for @settingsNotificationDigestHint.
  ///
  /// In en, this message translates to:
  /// **'Send a summary every morning.'**
  String get settingsNotificationDigestHint;

  /// No description provided for @settingsDefaultBranch.
  ///
  /// In en, this message translates to:
  /// **'Default branch'**
  String get settingsDefaultBranch;

  /// No description provided for @settingsDefaultBranchHint.
  ///
  /// In en, this message translates to:
  /// **'The branch selected when you sign in.'**
  String get settingsDefaultBranchHint;

  /// No description provided for @settingsLandingPage.
  ///
  /// In en, this message translates to:
  /// **'Landing page'**
  String get settingsLandingPage;

  /// No description provided for @settingsLandingPageHint.
  ///
  /// In en, this message translates to:
  /// **'The first screen after sign-in.'**
  String get settingsLandingPageHint;

  /// No description provided for @settingsAutoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto-refresh dashboards'**
  String get settingsAutoRefresh;

  /// No description provided for @settingsAutoRefreshHint.
  ///
  /// In en, this message translates to:
  /// **'Refresh KPIs every 60 seconds.'**
  String get settingsAutoRefreshHint;

  /// No description provided for @settingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get settingsSave;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved.'**
  String get settingsSaved;

  /// No description provided for @settingsBranchMain.
  ///
  /// In en, this message translates to:
  /// **'Main showroom · Tanta'**
  String get settingsBranchMain;

  /// No description provided for @settingsBranchAlex.
  ///
  /// In en, this message translates to:
  /// **'Alexandria branch'**
  String get settingsBranchAlex;

  /// No description provided for @settingsBranchGiza.
  ///
  /// In en, this message translates to:
  /// **'Giza branch'**
  String get settingsBranchGiza;

  /// No description provided for @appInfoAppName.
  ///
  /// In en, this message translates to:
  /// **'App name'**
  String get appInfoAppName;

  /// No description provided for @appInfoPackageName.
  ///
  /// In en, this message translates to:
  /// **'Package name'**
  String get appInfoPackageName;

  /// No description provided for @appInfoVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appInfoVersion;

  /// No description provided for @appInfoBuildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build number'**
  String get appInfoBuildNumber;

  /// No description provided for @appInfoBuildMode.
  ///
  /// In en, this message translates to:
  /// **'Build mode'**
  String get appInfoBuildMode;

  /// No description provided for @appInfoBuildModeDebug.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get appInfoBuildModeDebug;

  /// No description provided for @appInfoBuildModeRelease.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get appInfoBuildModeRelease;

  /// No description provided for @appInfoOperatingSystem.
  ///
  /// In en, this message translates to:
  /// **'Operating system'**
  String get appInfoOperatingSystem;

  /// No description provided for @appInfoOperatingSystemVersion.
  ///
  /// In en, this message translates to:
  /// **'OS version'**
  String get appInfoOperatingSystemVersion;

  /// No description provided for @appInfoFlutterVersion.
  ///
  /// In en, this message translates to:
  /// **'Flutter version'**
  String get appInfoFlutterVersion;

  /// No description provided for @appInfoFlutterChannel.
  ///
  /// In en, this message translates to:
  /// **'Flutter channel'**
  String get appInfoFlutterChannel;

  /// No description provided for @appInfoDartVersion.
  ///
  /// In en, this message translates to:
  /// **'Dart version'**
  String get appInfoDartVersion;

  /// No description provided for @appInfoDartChannel.
  ///
  /// In en, this message translates to:
  /// **'Dart channel'**
  String get appInfoDartChannel;

  /// No description provided for @appInfoInstallDate.
  ///
  /// In en, this message translates to:
  /// **'Installed on'**
  String get appInfoInstallDate;

  /// No description provided for @appInfoUpdateDate.
  ///
  /// In en, this message translates to:
  /// **'Updated on'**
  String get appInfoUpdateDate;

  /// No description provided for @appInfoInstaller.
  ///
  /// In en, this message translates to:
  /// **'Installer'**
  String get appInfoInstaller;

  /// No description provided for @appInfoUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not reported'**
  String get appInfoUnknown;

  /// No description provided for @appInfoCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy details'**
  String get appInfoCopy;

  /// No description provided for @appInfoCopied.
  ///
  /// In en, this message translates to:
  /// **'App details copied.'**
  String get appInfoCopied;

  /// No description provided for @appInfoUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'App information unavailable'**
  String get appInfoUnavailableTitle;

  /// No description provided for @appInfoUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'The app information service is not available in this session.'**
  String get appInfoUnavailableBody;

  /// No description provided for @appInfoSectionApplication.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get appInfoSectionApplication;

  /// No description provided for @appInfoSectionApplicationHint.
  ///
  /// In en, this message translates to:
  /// **'Identity of the installed admin build.'**
  String get appInfoSectionApplicationHint;

  /// No description provided for @appInfoSectionRuntime.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get appInfoSectionRuntime;

  /// No description provided for @appInfoSectionRuntimeHint.
  ///
  /// In en, this message translates to:
  /// **'Flutter, Dart and the host platform.'**
  String get appInfoSectionRuntimeHint;

  /// No description provided for @appInfoSectionDistribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get appInfoSectionDistribution;

  /// No description provided for @appInfoSectionDistributionHint.
  ///
  /// In en, this message translates to:
  /// **'Install source and update timing.'**
  String get appInfoSectionDistributionHint;

  /// No description provided for @wireframeTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Data table'**
  String get wireframeTableTitle;

  /// No description provided for @wireframeFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get wireframeFormTitle;

  /// No description provided for @wireframeStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get wireframeStatsTitle;

  /// No description provided for @wireframeCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get wireframeCalendarTitle;

  /// No description provided for @wireframeMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get wireframeMapTitle;

  /// No description provided for @wireframeBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get wireframeBoardTitle;

  /// No description provided for @wireframeListTitle.
  ///
  /// In en, this message translates to:
  /// **'List & detail'**
  String get wireframeListTitle;

  /// No description provided for @wireframeDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Record details'**
  String get wireframeDetailTitle;

  /// No description provided for @wireframeToolbar.
  ///
  /// In en, this message translates to:
  /// **'Search, filters and actions'**
  String get wireframeToolbar;

  /// No description provided for @wireframeSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get wireframeSearch;

  /// No description provided for @wireframeFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get wireframeFilter;

  /// No description provided for @wireframeNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get wireframeNew;

  /// No description provided for @wireframeExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get wireframeExport;

  /// No description provided for @wireframeColumns.
  ///
  /// In en, this message translates to:
  /// **'Column'**
  String get wireframeColumns;

  /// No description provided for @wireframeRows.
  ///
  /// In en, this message translates to:
  /// **'Row'**
  String get wireframeRows;

  /// No description provided for @wireframeActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get wireframeActions;

  /// No description provided for @wireframeField.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get wireframeField;

  /// No description provided for @wireframeValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get wireframeValue;

  /// No description provided for @wireframeSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get wireframeSave;

  /// No description provided for @wireframeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get wireframeCancel;

  /// No description provided for @wireframeChartArea.
  ///
  /// In en, this message translates to:
  /// **'Chart area'**
  String get wireframeChartArea;

  /// No description provided for @wireframeTableArea.
  ///
  /// In en, this message translates to:
  /// **'Table area'**
  String get wireframeTableArea;

  /// No description provided for @wireframeMapArea.
  ///
  /// In en, this message translates to:
  /// **'Route and stops'**
  String get wireframeMapArea;

  /// No description provided for @wireframeTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get wireframeTimeline;

  /// No description provided for @wireframeCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get wireframeCard;

  /// No description provided for @wireframeMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get wireframeMetric;

  /// No description provided for @wireframePreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Preview of the planned layout'**
  String get wireframePreviewHint;

  /// No description provided for @hubScreens.
  ///
  /// In en, this message translates to:
  /// **'Screens'**
  String get hubScreens;

  /// No description provided for @hubSelectScreen.
  ///
  /// In en, this message translates to:
  /// **'Select a screen to preview its planned layout.'**
  String get hubSelectScreen;

  /// No description provided for @currencyEgp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyEgp;

  /// No description provided for @sampleCustomer1.
  ///
  /// In en, this message translates to:
  /// **'Mona Abdelrahman'**
  String get sampleCustomer1;

  /// No description provided for @sampleCustomer2.
  ///
  /// In en, this message translates to:
  /// **'Youssef Kamal'**
  String get sampleCustomer2;

  /// No description provided for @sampleCustomer3.
  ///
  /// In en, this message translates to:
  /// **'Salma Fathy'**
  String get sampleCustomer3;

  /// No description provided for @sampleCustomer4.
  ///
  /// In en, this message translates to:
  /// **'Karim Nabil'**
  String get sampleCustomer4;

  /// No description provided for @dashboardChannelSplit.
  ///
  /// In en, this message translates to:
  /// **'Sales by channel'**
  String get dashboardChannelSplit;

  /// No description provided for @dashboardChannelStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get dashboardChannelStore;

  /// No description provided for @dashboardChannelOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get dashboardChannelOnline;

  /// No description provided for @dashboardChannelWholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get dashboardChannelWholesale;

  /// No description provided for @dashboardMonthlyTarget.
  ///
  /// In en, this message translates to:
  /// **'Monthly target'**
  String get dashboardMonthlyTarget;

  /// No description provided for @dashboardTargetHint.
  ///
  /// In en, this message translates to:
  /// **'74% of the monthly target achieved'**
  String get dashboardTargetHint;

  /// No description provided for @wireframeTableRef.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get wireframeTableRef;

  /// No description provided for @wireframeTableName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get wireframeTableName;

  /// No description provided for @wireframeTableStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get wireframeTableStatus;

  /// No description provided for @wireframeTableValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get wireframeTableValue;

  /// No description provided for @wireframeStatsSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get wireframeStatsSales;

  /// No description provided for @wireframeStatsOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get wireframeStatsOrders;

  /// No description provided for @wireframeStatsGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get wireframeStatsGrowth;

  /// No description provided for @wireframeStatsChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance over time'**
  String get wireframeStatsChartTitle;

  /// No description provided for @wireframeEventDelivery.
  ///
  /// In en, this message translates to:
  /// **'Order delivery'**
  String get wireframeEventDelivery;

  /// No description provided for @wireframeEventVisit.
  ///
  /// In en, this message translates to:
  /// **'Customer visit'**
  String get wireframeEventVisit;

  /// No description provided for @wireframeEventAudit.
  ///
  /// In en, this message translates to:
  /// **'Stock audit'**
  String get wireframeEventAudit;

  /// No description provided for @wireframeEventMeeting.
  ///
  /// In en, this message translates to:
  /// **'Team meeting'**
  String get wireframeEventMeeting;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @sectionRecordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} records'**
  String sectionRecordsCount(int count);

  /// No description provided for @paginationShowing.
  ///
  /// In en, this message translates to:
  /// **'Showing {from}–{to} of {total}'**
  String paginationShowing(int from, int to, int total);

  /// No description provided for @paginationPerPage.
  ///
  /// In en, this message translates to:
  /// **'Per page'**
  String get paginationPerPage;

  /// No description provided for @paginationPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get paginationPrevious;

  /// No description provided for @paginationNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get paginationNext;

  /// No description provided for @paginationPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages}'**
  String paginationPageOf(int page, int pages);

  /// No description provided for @sectionEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get sectionEmptyTitle;

  /// No description provided for @sectionEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first record or adjust the filters.'**
  String get sectionEmptyMessage;

  /// No description provided for @sectionNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching results'**
  String get sectionNoResultsTitle;

  /// No description provided for @sectionNoResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or clear the search.'**
  String get sectionNoResultsMessage;

  /// No description provided for @sectionClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get sectionClearSearch;

  /// No description provided for @sectionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Record details'**
  String get sectionDetailTitle;

  /// No description provided for @sectionSelectRecord.
  ///
  /// In en, this message translates to:
  /// **'Pick a record from the list to see its details.'**
  String get sectionSelectRecord;

  /// No description provided for @sectionTimeline.
  ///
  /// In en, this message translates to:
  /// **'Activity timeline'**
  String get sectionTimeline;

  /// No description provided for @sectionRecordNote.
  ///
  /// In en, this message translates to:
  /// **'This record was created from the dashboard. You can edit or archive it at any time.'**
  String get sectionRecordNote;

  /// No description provided for @sectionCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get sectionCreatedAt;

  /// No description provided for @sectionLastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get sectionLastUpdate;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @formFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get formFieldName;

  /// No description provided for @formFieldReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get formFieldReference;

  /// No description provided for @formFieldAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get formFieldAmount;

  /// No description provided for @formFieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get formFieldDate;

  /// No description provided for @formFieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get formFieldNotes;

  /// No description provided for @formFieldStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get formFieldStatus;

  /// No description provided for @formFieldBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get formFieldBranch;

  /// No description provided for @formSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get formSaveSuccess;

  /// No description provided for @boardColumnNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get boardColumnNew;

  /// No description provided for @boardColumnInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get boardColumnInProgress;

  /// No description provided for @boardColumnDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get boardColumnDone;

  /// No description provided for @statsAverageOrder.
  ///
  /// In en, this message translates to:
  /// **'Average order'**
  String get statsAverageOrder;

  /// No description provided for @statsActiveCustomers.
  ///
  /// In en, this message translates to:
  /// **'Active customers'**
  String get statsActiveCustomers;

  /// No description provided for @statsConversion.
  ///
  /// In en, this message translates to:
  /// **'Conversion rate'**
  String get statsConversion;

  /// No description provided for @calendarUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming appointments'**
  String get calendarUpcoming;

  /// No description provided for @mapZone.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get mapZone;

  /// No description provided for @mapOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get mapOrders;

  /// No description provided for @mapRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get mapRevenue;

  /// No description provided for @sampleProduct1.
  ///
  /// In en, this message translates to:
  /// **'Classic cotton shirt'**
  String get sampleProduct1;

  /// No description provided for @sampleProduct2.
  ///
  /// In en, this message translates to:
  /// **'Genuine leather shoes'**
  String get sampleProduct2;

  /// No description provided for @sampleProduct3.
  ///
  /// In en, this message translates to:
  /// **'Practical backpack'**
  String get sampleProduct3;

  /// No description provided for @sampleProduct4.
  ///
  /// In en, this message translates to:
  /// **'Elegant wristwatch'**
  String get sampleProduct4;

  /// No description provided for @sampleProduct5.
  ///
  /// In en, this message translates to:
  /// **'Sunglasses'**
  String get sampleProduct5;

  /// No description provided for @sampleEmployee1.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Saeed'**
  String get sampleEmployee1;

  /// No description provided for @sampleEmployee2.
  ///
  /// In en, this message translates to:
  /// **'Noha Mostafa'**
  String get sampleEmployee2;

  /// No description provided for @sampleEmployee3.
  ///
  /// In en, this message translates to:
  /// **'Khaled Fouad'**
  String get sampleEmployee3;

  /// No description provided for @sampleEmployee4.
  ///
  /// In en, this message translates to:
  /// **'Reem Hassan'**
  String get sampleEmployee4;

  /// No description provided for @sampleCampaign1.
  ///
  /// In en, this message translates to:
  /// **'Eid offer'**
  String get sampleCampaign1;

  /// No description provided for @sampleCampaign2.
  ///
  /// In en, this message translates to:
  /// **'Weekend discounts'**
  String get sampleCampaign2;

  /// No description provided for @sampleCampaign3.
  ///
  /// In en, this message translates to:
  /// **'Customer win-back campaign'**
  String get sampleCampaign3;

  /// No description provided for @sampleCampaign4.
  ///
  /// In en, this message translates to:
  /// **'New collection launch'**
  String get sampleCampaign4;

  /// No description provided for @sampleBranch1.
  ///
  /// In en, this message translates to:
  /// **'Tanta branch'**
  String get sampleBranch1;

  /// No description provided for @sampleBranch2.
  ///
  /// In en, this message translates to:
  /// **'Cairo branch'**
  String get sampleBranch2;

  /// No description provided for @sampleBranch3.
  ///
  /// In en, this message translates to:
  /// **'Alexandria branch'**
  String get sampleBranch3;

  /// No description provided for @sampleBranch4.
  ///
  /// In en, this message translates to:
  /// **'Mansoura branch'**
  String get sampleBranch4;

  /// No description provided for @dashboardSubtitleBranches.
  ///
  /// In en, this message translates to:
  /// **'Alam El Marateb performance across branches, stock and customers.'**
  String get dashboardSubtitleBranches;

  /// No description provided for @dashboardPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get dashboardPeriod;

  /// No description provided for @dashboardLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get dashboardLast7Days;

  /// No description provided for @dashboardLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get dashboardLast30Days;

  /// No description provided for @dashboardLast90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get dashboardLast90Days;

  /// No description provided for @dashboardBranchFilter.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get dashboardBranchFilter;

  /// No description provided for @dashboardAllBranches.
  ///
  /// In en, this message translates to:
  /// **'All branches'**
  String get dashboardAllBranches;

  /// No description provided for @dashboardRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get dashboardRefresh;

  /// No description provided for @dashboardExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get dashboardExport;

  /// No description provided for @dashboardExportHint.
  ///
  /// In en, this message translates to:
  /// **'Export will be available once the dashboard API is connected.'**
  String get dashboardExportHint;

  /// No description provided for @dashboardRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Dashboard refreshed with the latest sample data.'**
  String get dashboardRefreshed;

  /// No description provided for @dashboardUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String dashboardUpdated(String time);

  /// No description provided for @dashboardSampleBadge.
  ///
  /// In en, this message translates to:
  /// **'Sample data'**
  String get dashboardSampleBadge;

  /// No description provided for @dashboardSampleNote.
  ///
  /// In en, this message translates to:
  /// **'Sample data shaped like the analytics API. Flutter-only additions are documented in dashboard-flutter-features.md.'**
  String get dashboardSampleNote;

  /// No description provided for @dashboardActionHint.
  ///
  /// In en, this message translates to:
  /// **'\"{action}\" will open here once dashboard actions are connected.'**
  String dashboardActionHint(String action);

  /// No description provided for @dashboardOpenModuleHint.
  ///
  /// In en, this message translates to:
  /// **'Open the {module} module to continue.'**
  String dashboardOpenModuleHint(String module);

  /// No description provided for @dashboardClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dashboardClose;

  /// No description provided for @dashboardKpiRevenue.
  ///
  /// In en, this message translates to:
  /// **'Net revenue'**
  String get dashboardKpiRevenue;

  /// No description provided for @dashboardKpiProfit.
  ///
  /// In en, this message translates to:
  /// **'Gross profit'**
  String get dashboardKpiProfit;

  /// No description provided for @dashboardKpiOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get dashboardKpiOrders;

  /// No description provided for @dashboardKpiAverageOrder.
  ///
  /// In en, this message translates to:
  /// **'Average order'**
  String get dashboardKpiAverageOrder;

  /// No description provided for @dashboardKpiCustomers.
  ///
  /// In en, this message translates to:
  /// **'Active customers'**
  String get dashboardKpiCustomers;

  /// No description provided for @dashboardKpiLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low-stock variants'**
  String get dashboardKpiLowStock;

  /// No description provided for @dashboardVsPrevious.
  ///
  /// In en, this message translates to:
  /// **'{value} vs previous period'**
  String dashboardVsPrevious(String value);

  /// No description provided for @dashboardNoChange.
  ///
  /// In en, this message translates to:
  /// **'No change vs previous period'**
  String get dashboardNoChange;

  /// No description provided for @dashboardRevenueProfit.
  ///
  /// In en, this message translates to:
  /// **'Revenue & profit'**
  String get dashboardRevenueProfit;

  /// No description provided for @dashboardRevenueProfitHint.
  ///
  /// In en, this message translates to:
  /// **'Daily performance for the selected period'**
  String get dashboardRevenueProfitHint;

  /// No description provided for @dashboardProfit.
  ///
  /// In en, this message translates to:
  /// **'Gross profit'**
  String get dashboardProfit;

  /// No description provided for @dashboardMargin.
  ///
  /// In en, this message translates to:
  /// **'{value} margin'**
  String dashboardMargin(String value);

  /// No description provided for @dashboardOrdersCount.
  ///
  /// In en, this message translates to:
  /// **'{value} orders'**
  String dashboardOrdersCount(String value);

  /// No description provided for @dashboardUnitsCount.
  ///
  /// In en, this message translates to:
  /// **'{value} units'**
  String dashboardUnitsCount(String value);

  /// No description provided for @dashboardPreviousPeriod.
  ///
  /// In en, this message translates to:
  /// **'vs previous period'**
  String get dashboardPreviousPeriod;

  /// No description provided for @dashboardOperations.
  ///
  /// In en, this message translates to:
  /// **'Operational alerts'**
  String get dashboardOperations;

  /// No description provided for @dashboardOperationsHint.
  ///
  /// In en, this message translates to:
  /// **'Items that need attention from the operations team'**
  String get dashboardOperationsHint;

  /// No description provided for @dashboardLowStockAlert.
  ///
  /// In en, this message translates to:
  /// **'Low-stock variants'**
  String get dashboardLowStockAlert;

  /// No description provided for @dashboardLowStockAlertHint.
  ///
  /// In en, this message translates to:
  /// **'Below the reorder point'**
  String get dashboardLowStockAlertHint;

  /// No description provided for @dashboardPendingTransfers.
  ///
  /// In en, this message translates to:
  /// **'Pending transfers'**
  String get dashboardPendingTransfers;

  /// No description provided for @dashboardPendingTransfersHint.
  ///
  /// In en, this message translates to:
  /// **'Waiting for dispatch or receipt'**
  String get dashboardPendingTransfersHint;

  /// No description provided for @dashboardOpenAudits.
  ///
  /// In en, this message translates to:
  /// **'Open stock audits'**
  String get dashboardOpenAudits;

  /// No description provided for @dashboardOpenAuditsHint.
  ///
  /// In en, this message translates to:
  /// **'Counts that are not closed yet'**
  String get dashboardOpenAuditsHint;

  /// No description provided for @dashboardStockByWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Stock by warehouse'**
  String get dashboardStockByWarehouse;

  /// No description provided for @dashboardStockHint.
  ///
  /// In en, this message translates to:
  /// **'Quantity and valuation per warehouse'**
  String get dashboardStockHint;

  /// No description provided for @dashboardStockTotal.
  ///
  /// In en, this message translates to:
  /// **'Total stock value'**
  String get dashboardStockTotal;

  /// No description provided for @dashboardStockQuantity.
  ///
  /// In en, this message translates to:
  /// **'{value} units'**
  String dashboardStockQuantity(String value);

  /// No description provided for @dashboardWarehouses.
  ///
  /// In en, this message translates to:
  /// **'{value} warehouses'**
  String dashboardWarehouses(String value);

  /// No description provided for @dashboardBranchPerformance.
  ///
  /// In en, this message translates to:
  /// **'Branch performance'**
  String get dashboardBranchPerformance;

  /// No description provided for @dashboardBranchHint.
  ///
  /// In en, this message translates to:
  /// **'Revenue, profit and orders per branch'**
  String get dashboardBranchHint;

  /// No description provided for @dashboardBranchProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get dashboardBranchProfit;

  /// No description provided for @dashboardBranchOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get dashboardBranchOrders;

  /// No description provided for @dashboardBranchShare.
  ///
  /// In en, this message translates to:
  /// **'{value} of revenue'**
  String dashboardBranchShare(String value);

  /// No description provided for @dashboardShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get dashboardShare;

  /// No description provided for @dashboardWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get dashboardWarehouse;

  /// No description provided for @dashboardNoBranches.
  ///
  /// In en, this message translates to:
  /// **'No branch data for this filter.'**
  String get dashboardNoBranches;

  /// No description provided for @dashboardVelocity.
  ///
  /// In en, this message translates to:
  /// **'Stock velocity'**
  String get dashboardVelocity;

  /// No description provided for @dashboardVelocityHint.
  ///
  /// In en, this message translates to:
  /// **'Sold in the last 30 days versus available cover'**
  String get dashboardVelocityHint;

  /// No description provided for @dashboardVariant.
  ///
  /// In en, this message translates to:
  /// **'Variant'**
  String get dashboardVariant;

  /// No description provided for @dashboardSold30d.
  ///
  /// In en, this message translates to:
  /// **'Sold 30d'**
  String get dashboardSold30d;

  /// No description provided for @dashboardCurrentQty.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get dashboardCurrentQty;

  /// No description provided for @dashboardDaysOfCover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get dashboardDaysOfCover;

  /// No description provided for @dashboardCoverOut.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get dashboardCoverOut;

  /// No description provided for @dashboardCoverLow.
  ///
  /// In en, this message translates to:
  /// **'Reorder now'**
  String get dashboardCoverLow;

  /// No description provided for @dashboardCoverHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get dashboardCoverHealthy;

  /// No description provided for @dashboardCoverDays.
  ///
  /// In en, this message translates to:
  /// **'{value} days'**
  String dashboardCoverDays(String value);

  /// No description provided for @dashboardTopProducts.
  ///
  /// In en, this message translates to:
  /// **'Top products'**
  String get dashboardTopProducts;

  /// No description provided for @dashboardTopProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Best sellers by revenue for the selected period'**
  String get dashboardTopProductsHint;

  /// No description provided for @dashboardTopProductQty.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get dashboardTopProductQty;

  /// No description provided for @dashboardTopProductRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get dashboardTopProductRevenue;

  /// No description provided for @dashboardTopProductShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get dashboardTopProductShare;

  /// No description provided for @dashboardRfm.
  ///
  /// In en, this message translates to:
  /// **'Customer RFM'**
  String get dashboardRfm;

  /// No description provided for @dashboardRfmHint.
  ///
  /// In en, this message translates to:
  /// **'Recency, frequency and monetary value'**
  String get dashboardRfmHint;

  /// No description provided for @dashboardRfmCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get dashboardRfmCustomers;

  /// No description provided for @dashboardRfmMonetary.
  ///
  /// In en, this message translates to:
  /// **'Monetary'**
  String get dashboardRfmMonetary;

  /// No description provided for @dashboardRfmChampions.
  ///
  /// In en, this message translates to:
  /// **'Champions'**
  String get dashboardRfmChampions;

  /// No description provided for @dashboardRfmLoyal.
  ///
  /// In en, this message translates to:
  /// **'Loyal'**
  String get dashboardRfmLoyal;

  /// No description provided for @dashboardRfmPotential.
  ///
  /// In en, this message translates to:
  /// **'Potential loyalists'**
  String get dashboardRfmPotential;

  /// No description provided for @dashboardRfmNew.
  ///
  /// In en, this message translates to:
  /// **'New customers'**
  String get dashboardRfmNew;

  /// No description provided for @dashboardRfmAtRisk.
  ///
  /// In en, this message translates to:
  /// **'At risk'**
  String get dashboardRfmAtRisk;

  /// No description provided for @dashboardRfmLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get dashboardRfmLost;

  /// No description provided for @dashboardGeo.
  ///
  /// In en, this message translates to:
  /// **'Orders by governorate'**
  String get dashboardGeo;

  /// No description provided for @dashboardGeoHint.
  ///
  /// In en, this message translates to:
  /// **'Delivery demand across Egypt'**
  String get dashboardGeoHint;

  /// No description provided for @dashboardGeoTop.
  ///
  /// In en, this message translates to:
  /// **'Top governorate'**
  String get dashboardGeoTop;

  /// No description provided for @dashboardInquiries.
  ///
  /// In en, this message translates to:
  /// **'Customer inquiries'**
  String get dashboardInquiries;

  /// No description provided for @dashboardInquiriesHint.
  ///
  /// In en, this message translates to:
  /// **'Latest product questions from the floor'**
  String get dashboardInquiriesHint;

  /// No description provided for @dashboardInquiryBought.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get dashboardInquiryBought;

  /// No description provided for @dashboardInquiryPrice.
  ///
  /// In en, this message translates to:
  /// **'Price question'**
  String get dashboardInquiryPrice;

  /// No description provided for @dashboardInquiryNoStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get dashboardInquiryNoStock;

  /// No description provided for @dashboardInquiryJustAsking.
  ///
  /// In en, this message translates to:
  /// **'Just asking'**
  String get dashboardInquiryJustAsking;

  /// No description provided for @dashboardInquiriesCount.
  ///
  /// In en, this message translates to:
  /// **'{value} inquiries'**
  String dashboardInquiriesCount(String value);

  /// No description provided for @dashboardTopAsked.
  ///
  /// In en, this message translates to:
  /// **'Most asked products'**
  String get dashboardTopAsked;

  /// No description provided for @dashboardTopAskedHint.
  ///
  /// In en, this message translates to:
  /// **'Questions and missed sales by product'**
  String get dashboardTopAskedHint;

  /// No description provided for @dashboardAsked.
  ///
  /// In en, this message translates to:
  /// **'Asked'**
  String get dashboardAsked;

  /// No description provided for @dashboardNoStockAsked.
  ///
  /// In en, this message translates to:
  /// **'No stock'**
  String get dashboardNoStockAsked;

  /// No description provided for @dashboardPriceAsked.
  ///
  /// In en, this message translates to:
  /// **'Price asks'**
  String get dashboardPriceAsked;

  /// No description provided for @dashboardAuditTrail.
  ///
  /// In en, this message translates to:
  /// **'Audit trail'**
  String get dashboardAuditTrail;

  /// No description provided for @dashboardAuditHint.
  ///
  /// In en, this message translates to:
  /// **'Recent changes across inventory and sales'**
  String get dashboardAuditHint;

  /// No description provided for @dashboardAuditBy.
  ///
  /// In en, this message translates to:
  /// **'by {actor}'**
  String dashboardAuditBy(String actor);

  /// No description provided for @dashboardAuditTransfer.
  ///
  /// In en, this message translates to:
  /// **'Stock transfer'**
  String get dashboardAuditTransfer;

  /// No description provided for @dashboardAuditAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Stock adjustment'**
  String get dashboardAuditAdjustment;

  /// No description provided for @dashboardAuditPrice.
  ///
  /// In en, this message translates to:
  /// **'Price change'**
  String get dashboardAuditPrice;

  /// No description provided for @dashboardAuditShift.
  ///
  /// In en, this message translates to:
  /// **'Shift closed'**
  String get dashboardAuditShift;

  /// No description provided for @dashboardAuditWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty claim'**
  String get dashboardAuditWarranty;

  /// No description provided for @dashboardAuditPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase receipt'**
  String get dashboardAuditPurchase;

  /// No description provided for @dashboardAuditTransferDetail.
  ///
  /// In en, this message translates to:
  /// **'{qty} units from {from} to {to}'**
  String dashboardAuditTransferDetail(String qty, String from, String to);

  /// No description provided for @dashboardAuditAdjustmentDetail.
  ///
  /// In en, this message translates to:
  /// **'{variant} adjusted by {diff}'**
  String dashboardAuditAdjustmentDetail(String variant, String diff);

  /// No description provided for @dashboardAuditPriceDetail.
  ///
  /// In en, this message translates to:
  /// **'{product}: {oldPrice} to {newPrice}'**
  String dashboardAuditPriceDetail(
    String product,
    String oldPrice,
    String newPrice,
  );

  /// No description provided for @dashboardAuditShiftDetail.
  ///
  /// In en, this message translates to:
  /// **'{branch} closed with {variance} variance'**
  String dashboardAuditShiftDetail(String branch, String variance);

  /// No description provided for @dashboardAuditWarrantyDetail.
  ///
  /// In en, this message translates to:
  /// **'{customer} · {product}'**
  String dashboardAuditWarrantyDetail(String customer, String product);

  /// No description provided for @dashboardAuditPurchaseDetail.
  ///
  /// In en, this message translates to:
  /// **'{supplier} · {amount}'**
  String dashboardAuditPurchaseDetail(String supplier, String amount);

  /// No description provided for @dashboardTopCustomers.
  ///
  /// In en, this message translates to:
  /// **'Top customers'**
  String get dashboardTopCustomers;

  /// No description provided for @dashboardTopCustomersHint.
  ///
  /// In en, this message translates to:
  /// **'Ranked by lifetime spend and loyalty'**
  String get dashboardTopCustomersHint;

  /// No description provided for @dashboardCustomerSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone'**
  String get dashboardCustomerSearch;

  /// No description provided for @dashboardCustomerProfile.
  ///
  /// In en, this message translates to:
  /// **'Customer 360'**
  String get dashboardCustomerProfile;

  /// No description provided for @dashboardCustomerSince.
  ///
  /// In en, this message translates to:
  /// **'Customer since {date}'**
  String dashboardCustomerSince(String date);

  /// No description provided for @dashboardCustomerContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get dashboardCustomerContact;

  /// No description provided for @dashboardCustomerAddresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get dashboardCustomerAddresses;

  /// No description provided for @dashboardCustomerWarranties.
  ///
  /// In en, this message translates to:
  /// **'Warranties & claims'**
  String get dashboardCustomerWarranties;

  /// No description provided for @dashboardCustomerLoyalty.
  ///
  /// In en, this message translates to:
  /// **'Loyalty'**
  String get dashboardCustomerLoyalty;

  /// No description provided for @dashboardCustomerNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get dashboardCustomerNotes;

  /// No description provided for @dashboardCustomerSpend.
  ///
  /// In en, this message translates to:
  /// **'Lifetime spend'**
  String get dashboardCustomerSpend;

  /// No description provided for @dashboardCustomerAvgOrder.
  ///
  /// In en, this message translates to:
  /// **'Average order'**
  String get dashboardCustomerAvgOrder;

  /// No description provided for @dashboardCustomerPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get dashboardCustomerPoints;

  /// No description provided for @dashboardCustomerTier.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get dashboardCustomerTier;

  /// No description provided for @dashboardCustomerRfm.
  ///
  /// In en, this message translates to:
  /// **'RFM segment'**
  String get dashboardCustomerRfm;

  /// No description provided for @dashboardCustomerPreferred.
  ///
  /// In en, this message translates to:
  /// **'Preferred channel'**
  String get dashboardCustomerPreferred;

  /// No description provided for @dashboardPreferredBranch.
  ///
  /// In en, this message translates to:
  /// **'Preferred branch'**
  String get dashboardPreferredBranch;

  /// No description provided for @dashboardCustomerRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent orders'**
  String get dashboardCustomerRecentOrders;

  /// No description provided for @dashboardCustomerNoOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders on record.'**
  String get dashboardCustomerNoOrders;

  /// No description provided for @dashboardCustomerNoClaims.
  ///
  /// In en, this message translates to:
  /// **'No warranty claims on record.'**
  String get dashboardCustomerNoClaims;

  /// No description provided for @dashboardCustomerNoAddresses.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses.'**
  String get dashboardCustomerNoAddresses;

  /// No description provided for @dashboardWarrantyExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String dashboardWarrantyExpires(String date);

  /// No description provided for @dashboardWarrantyPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased {date}'**
  String dashboardWarrantyPurchased(String date);

  /// No description provided for @dashboardWarrantyExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get dashboardWarrantyExpiry;

  /// No description provided for @dashboardClaimOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get dashboardClaimOpen;

  /// No description provided for @dashboardClaimInspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get dashboardClaimInspection;

  /// No description provided for @dashboardClaimResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get dashboardClaimResolved;

  /// No description provided for @dashboardTierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get dashboardTierBronze;

  /// No description provided for @dashboardTierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get dashboardTierSilver;

  /// No description provided for @dashboardTierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get dashboardTierGold;

  /// No description provided for @dashboardTierPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get dashboardTierPlatinum;

  /// No description provided for @dashboardOrderCount.
  ///
  /// In en, this message translates to:
  /// **'{value} orders'**
  String dashboardOrderCount(String value);

  /// No description provided for @dashboardCustomerNote1.
  ///
  /// In en, this message translates to:
  /// **'Prefers medical mattresses in 160×200 and confirms visits on WhatsApp.'**
  String get dashboardCustomerNote1;

  /// No description provided for @dashboardCustomerNote2.
  ///
  /// In en, this message translates to:
  /// **'Corporate account: ordered 12 mattresses for a Tanta hotel and needs a tax invoice.'**
  String get dashboardCustomerNote2;

  /// No description provided for @dashboardCustomerNote3.
  ///
  /// In en, this message translates to:
  /// **'Complained about a late delivery before; confirm the slot one day ahead.'**
  String get dashboardCustomerNote3;

  /// No description provided for @dashboardCustomerNote4.
  ///
  /// In en, this message translates to:
  /// **'Interested in instalments and asked to be called when a new batch arrives.'**
  String get dashboardCustomerNote4;

  /// No description provided for @dashboardRecentOrdersHint.
  ///
  /// In en, this message translates to:
  /// **'Latest sales across every branch'**
  String get dashboardRecentOrdersHint;

  /// No description provided for @dashboardOrderDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dashboardOrderDate;

  /// No description provided for @dashboardOrderChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get dashboardOrderChannel;

  /// No description provided for @dashboardQuickActionsHint.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts for the counter and back office'**
  String get dashboardQuickActionsHint;

  /// No description provided for @dashboardStockTransfer.
  ///
  /// In en, this message translates to:
  /// **'Stock transfer'**
  String get dashboardStockTransfer;

  /// No description provided for @dashboardNewPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase order'**
  String get dashboardNewPurchase;

  /// No description provided for @dashboardChannelShowroom.
  ///
  /// In en, this message translates to:
  /// **'Showroom'**
  String get dashboardChannelShowroom;

  /// No description provided for @dashboardChannelPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get dashboardChannelPhone;

  /// No description provided for @dashboardChannelWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get dashboardChannelWhatsapp;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @warehouseTanta.
  ///
  /// In en, this message translates to:
  /// **'Tanta main warehouse'**
  String get warehouseTanta;

  /// No description provided for @warehouseCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo warehouse'**
  String get warehouseCairo;

  /// No description provided for @warehouseAlex.
  ///
  /// In en, this message translates to:
  /// **'Alexandria warehouse'**
  String get warehouseAlex;

  /// No description provided for @warehouseMansoura.
  ///
  /// In en, this message translates to:
  /// **'Mansoura warehouse'**
  String get warehouseMansoura;

  /// No description provided for @govGharbia.
  ///
  /// In en, this message translates to:
  /// **'Gharbia'**
  String get govGharbia;

  /// No description provided for @govCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get govCairo;

  /// No description provided for @govAlexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get govAlexandria;

  /// No description provided for @govDakahlia.
  ///
  /// In en, this message translates to:
  /// **'Dakahlia'**
  String get govDakahlia;

  /// No description provided for @govMenoufia.
  ///
  /// In en, this message translates to:
  /// **'Menoufia'**
  String get govMenoufia;

  /// No description provided for @govQalyubia.
  ///
  /// In en, this message translates to:
  /// **'Qalyubia'**
  String get govQalyubia;

  /// No description provided for @govSharqia.
  ///
  /// In en, this message translates to:
  /// **'Sharqia'**
  String get govSharqia;

  /// No description provided for @govBeheira.
  ///
  /// In en, this message translates to:
  /// **'Beheira'**
  String get govBeheira;

  /// No description provided for @categoryMattress.
  ///
  /// In en, this message translates to:
  /// **'Mattresses'**
  String get categoryMattress;

  /// No description provided for @categoryPillow.
  ///
  /// In en, this message translates to:
  /// **'Pillows'**
  String get categoryPillow;

  /// No description provided for @categoryBase.
  ///
  /// In en, this message translates to:
  /// **'Bed bases'**
  String get categoryBase;

  /// No description provided for @categoryAccessory.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get categoryAccessory;

  /// No description provided for @supplierDeltaFoam.
  ///
  /// In en, this message translates to:
  /// **'Delta Foam'**
  String get supplierDeltaFoam;

  /// No description provided for @supplierSleepTech.
  ///
  /// In en, this message translates to:
  /// **'Sleep Tech'**
  String get supplierSleepTech;

  /// No description provided for @product1.
  ///
  /// In en, this message translates to:
  /// **'Orthopedic mattress 160×200'**
  String get product1;

  /// No description provided for @product2.
  ///
  /// In en, this message translates to:
  /// **'Memory foam mattress 180×200'**
  String get product2;

  /// No description provided for @product3.
  ///
  /// In en, this message translates to:
  /// **'Spring mattress 150×195'**
  String get product3;

  /// No description provided for @product4.
  ///
  /// In en, this message translates to:
  /// **'Kids mattress 120×190'**
  String get product4;

  /// No description provided for @product5.
  ///
  /// In en, this message translates to:
  /// **'Latex pillow 50×70'**
  String get product5;

  /// No description provided for @product6.
  ///
  /// In en, this message translates to:
  /// **'Memory pillow'**
  String get product6;

  /// No description provided for @product7.
  ///
  /// In en, this message translates to:
  /// **'Wooden bed base 160×200'**
  String get product7;

  /// No description provided for @product8.
  ///
  /// In en, this message translates to:
  /// **'Upholstered bed base 180×200'**
  String get product8;

  /// No description provided for @product9.
  ///
  /// In en, this message translates to:
  /// **'Waterproof mattress protector'**
  String get product9;

  /// No description provided for @product10.
  ///
  /// In en, this message translates to:
  /// **'Cotton bed sheet set'**
  String get product10;

  /// No description provided for @product11.
  ///
  /// In en, this message translates to:
  /// **'Custom oval mattress'**
  String get product11;

  /// No description provided for @product12.
  ///
  /// In en, this message translates to:
  /// **'Hotel mattress 200×200'**
  String get product12;

  /// No description provided for @customer1.
  ///
  /// In en, this message translates to:
  /// **'Mona Abdelrahman'**
  String get customer1;

  /// No description provided for @customer2.
  ///
  /// In en, this message translates to:
  /// **'Youssef Kamal'**
  String get customer2;

  /// No description provided for @customer3.
  ///
  /// In en, this message translates to:
  /// **'Salma Fathy'**
  String get customer3;

  /// No description provided for @customer4.
  ///
  /// In en, this message translates to:
  /// **'Karim Nabil'**
  String get customer4;

  /// No description provided for @customer5.
  ///
  /// In en, this message translates to:
  /// **'Hana Tarek'**
  String get customer5;

  /// No description provided for @customer6.
  ///
  /// In en, this message translates to:
  /// **'Omar Sherif'**
  String get customer6;

  /// No description provided for @customer7.
  ///
  /// In en, this message translates to:
  /// **'Nour Adel'**
  String get customer7;

  /// No description provided for @customer8.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Fathy'**
  String get customer8;

  /// No description provided for @customer9.
  ///
  /// In en, this message translates to:
  /// **'Mariam Hossam'**
  String get customer9;

  /// No description provided for @customer10.
  ///
  /// In en, this message translates to:
  /// **'Tamer Said'**
  String get customer10;

  /// No description provided for @dashboardWeek.
  ///
  /// In en, this message translates to:
  /// **'Week {value}'**
  String dashboardWeek(String value);

  /// No description provided for @dashboardInquiryNote1.
  ///
  /// In en, this message translates to:
  /// **'Is the orthopedic mattress available in 160×200?'**
  String get dashboardInquiryNote1;

  /// No description provided for @dashboardInquiryNote2.
  ///
  /// In en, this message translates to:
  /// **'What is the difference between memory foam and spring?'**
  String get dashboardInquiryNote2;

  /// No description provided for @dashboardInquiryNote3.
  ///
  /// In en, this message translates to:
  /// **'I need the price of the upholstered bed base.'**
  String get dashboardInquiryNote3;

  /// No description provided for @dashboardInquiryNote4.
  ///
  /// In en, this message translates to:
  /// **'Do you offer interest-free instalments?'**
  String get dashboardInquiryNote4;

  /// No description provided for @dashboardInquiryNote5.
  ///
  /// In en, this message translates to:
  /// **'How many days does a custom oval mattress take?'**
  String get dashboardInquiryNote5;

  /// No description provided for @dashboardInquiryNote6.
  ///
  /// In en, this message translates to:
  /// **'I need hotel mattresses 200×200 in bulk.'**
  String get dashboardInquiryNote6;

  /// No description provided for @dashboardClaimIssue1.
  ///
  /// In en, this message translates to:
  /// **'Sagging on the left side'**
  String get dashboardClaimIssue1;

  /// No description provided for @dashboardClaimIssue2.
  ///
  /// In en, this message translates to:
  /// **'Broken zip on the cover'**
  String get dashboardClaimIssue2;

  /// No description provided for @dashboardClaimIssue3.
  ///
  /// In en, this message translates to:
  /// **'Wrong size delivered'**
  String get dashboardClaimIssue3;

  /// No description provided for @dashboardClaimIssue4.
  ///
  /// In en, this message translates to:
  /// **'Noise from the spring unit'**
  String get dashboardClaimIssue4;

  /// No description provided for @addressHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get addressHome;

  /// No description provided for @addressWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get addressWork;

  /// No description provided for @addressFamily.
  ///
  /// In en, this message translates to:
  /// **'Family home'**
  String get addressFamily;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'12 El Geish Street, Tanta'**
  String get addressLine1;

  /// No description provided for @addressLine2.
  ///
  /// In en, this message translates to:
  /// **'Nasr City, Cairo'**
  String get addressLine2;

  /// No description provided for @addressLine3.
  ///
  /// In en, this message translates to:
  /// **'Smouha, Alexandria'**
  String get addressLine3;

  /// No description provided for @addressLine4.
  ///
  /// In en, this message translates to:
  /// **'El Mashaya, Mansoura'**
  String get addressLine4;

  /// No description provided for @dashboardProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get dashboardProduct;

  /// No description provided for @dashboardGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get dashboardGovernorate;

  /// No description provided for @dashboardItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get dashboardItems;

  /// No description provided for @dashboardUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get dashboardUnits;

  /// No description provided for @dashboardIssue.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get dashboardIssue;

  /// No description provided for @dashboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No records match this filter.'**
  String get dashboardEmpty;

  /// No description provided for @dashboardAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get dashboardAction;

  /// No description provided for @dashboardOutcome.
  ///
  /// In en, this message translates to:
  /// **'Outcome'**
  String get dashboardOutcome;

  /// No description provided for @dashboardDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get dashboardDetails;

  /// No description provided for @dashboardTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get dashboardTime;

  /// No description provided for @identityFeature4.
  ///
  /// In en, this message translates to:
  /// **'Roles and the permissions matrix'**
  String get identityFeature4;

  /// No description provided for @availabilityLive.
  ///
  /// In en, this message translates to:
  /// **'Live data'**
  String get availabilityLive;

  /// No description provided for @availabilityPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get availabilityPlanned;

  /// No description provided for @availabilityLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get availabilityLocal;

  /// No description provided for @permissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions matrix'**
  String get permissionsTitle;

  /// No description provided for @permissionsHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a role, then grant each module its capabilities. Changes are saved on this device only.'**
  String get permissionsHint;

  /// No description provided for @permissionsReset.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults'**
  String get permissionsReset;

  /// No description provided for @permissionsModuleColumn.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get permissionsModuleColumn;

  /// No description provided for @permissionsActionView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get permissionsActionView;

  /// No description provided for @permissionsActionCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get permissionsActionCreate;

  /// No description provided for @permissionsActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get permissionsActionEdit;

  /// No description provided for @permissionsActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get permissionsActionDelete;

  /// No description provided for @permissionsRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get permissionsRoleAdmin;

  /// No description provided for @permissionsRoleManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get permissionsRoleManager;

  /// No description provided for @permissionsRoleCashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get permissionsRoleCashier;

  /// No description provided for @permissionsRoleWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get permissionsRoleWarehouse;

  /// No description provided for @plannedNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Planned screen'**
  String get plannedNoticeTitle;

  /// No description provided for @plannedNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'This screen is designed and ready, but its backend endpoint is not available yet. The values below are sample data and saving is disabled.'**
  String get plannedNoticeBody;

  /// No description provided for @adminSampleActionMessage.
  ///
  /// In en, this message translates to:
  /// **'Sample action: no data was saved.'**
  String get adminSampleActionMessage;

  /// No description provided for @catalogTabProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get catalogTabProducts;

  /// No description provided for @catalogTabCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get catalogTabCategories;

  /// No description provided for @catalogTabAttributes.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get catalogTabAttributes;

  /// No description provided for @catalogTabPrices.
  ///
  /// In en, this message translates to:
  /// **'Price sheets'**
  String get catalogTabPrices;

  /// No description provided for @catalogTabMeter.
  ///
  /// In en, this message translates to:
  /// **'Meter pricing'**
  String get catalogTabMeter;

  /// No description provided for @catalogSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products or SKU'**
  String get catalogSearchProducts;

  /// No description provided for @catalogSearchAttributes.
  ///
  /// In en, this message translates to:
  /// **'Search attributes'**
  String get catalogSearchAttributes;

  /// No description provided for @catalogSearchPrices.
  ///
  /// In en, this message translates to:
  /// **'Search price entries'**
  String get catalogSearchPrices;

  /// No description provided for @catalogMetricProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get catalogMetricProducts;

  /// No description provided for @catalogMetricLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get catalogMetricLowStock;

  /// No description provided for @catalogMetricAveragePrice.
  ///
  /// In en, this message translates to:
  /// **'Average price'**
  String get catalogMetricAveragePrice;

  /// No description provided for @catalogMetricStockValue.
  ///
  /// In en, this message translates to:
  /// **'Stock value'**
  String get catalogMetricStockValue;

  /// No description provided for @catalogMetricCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get catalogMetricCategories;

  /// No description provided for @catalogMetricCategoryProducts.
  ///
  /// In en, this message translates to:
  /// **'Categorized products'**
  String get catalogMetricCategoryProducts;

  /// No description provided for @catalogMetricTopCategory.
  ///
  /// In en, this message translates to:
  /// **'Largest category'**
  String get catalogMetricTopCategory;

  /// No description provided for @catalogMetricAttributes.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get catalogMetricAttributes;

  /// No description provided for @catalogMetricValues.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get catalogMetricValues;

  /// No description provided for @catalogMetricRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get catalogMetricRequired;

  /// No description provided for @catalogMetricPriceLists.
  ///
  /// In en, this message translates to:
  /// **'Price lists'**
  String get catalogMetricPriceLists;

  /// No description provided for @catalogMetricChannels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get catalogMetricChannels;

  /// No description provided for @catalogMetricAverageMargin.
  ///
  /// In en, this message translates to:
  /// **'Average margin'**
  String get catalogMetricAverageMargin;

  /// No description provided for @catalogMetricEntries.
  ///
  /// In en, this message translates to:
  /// **'Price entries'**
  String get catalogMetricEntries;

  /// No description provided for @catalogColProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get catalogColProduct;

  /// No description provided for @catalogColSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get catalogColSku;

  /// No description provided for @catalogColCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get catalogColCategory;

  /// No description provided for @catalogColPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get catalogColPrice;

  /// No description provided for @catalogColStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get catalogColStock;

  /// No description provided for @catalogColValues.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get catalogColValues;

  /// No description provided for @catalogColUsage.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get catalogColUsage;

  /// No description provided for @catalogColRequirement.
  ///
  /// In en, this message translates to:
  /// **'Requirement'**
  String get catalogColRequirement;

  /// No description provided for @catalogColPriceList.
  ///
  /// In en, this message translates to:
  /// **'Price list'**
  String get catalogColPriceList;

  /// No description provided for @catalogColChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get catalogColChannel;

  /// No description provided for @catalogColMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get catalogColMargin;

  /// No description provided for @catalogStockIn.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get catalogStockIn;

  /// No description provided for @catalogStockLow.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get catalogStockLow;

  /// No description provided for @catalogStockOut.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get catalogStockOut;

  /// No description provided for @catalogCategoryShareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share of catalog'**
  String get catalogCategoryShareLabel;

  /// No description provided for @catalogCategoryProductsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No products} =1{1 product} other{{count} products}}'**
  String catalogCategoryProductsCount(int count);

  /// No description provided for @catalogAttributeSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get catalogAttributeSize;

  /// No description provided for @catalogAttributeColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get catalogAttributeColor;

  /// No description provided for @catalogAttributeMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get catalogAttributeMaterial;

  /// No description provided for @catalogAttributeFirmness.
  ///
  /// In en, this message translates to:
  /// **'Firmness'**
  String get catalogAttributeFirmness;

  /// No description provided for @catalogAttributeWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get catalogAttributeWarranty;

  /// No description provided for @catalogValueSize1.
  ///
  /// In en, this message translates to:
  /// **'160 × 200'**
  String get catalogValueSize1;

  /// No description provided for @catalogValueSize2.
  ///
  /// In en, this message translates to:
  /// **'180 × 200'**
  String get catalogValueSize2;

  /// No description provided for @catalogValueSize3.
  ///
  /// In en, this message translates to:
  /// **'150 × 195'**
  String get catalogValueSize3;

  /// No description provided for @catalogValueColor1.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get catalogValueColor1;

  /// No description provided for @catalogValueColor2.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get catalogValueColor2;

  /// No description provided for @catalogValueColor3.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get catalogValueColor3;

  /// No description provided for @catalogValueMaterial1.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get catalogValueMaterial1;

  /// No description provided for @catalogValueMaterial2.
  ///
  /// In en, this message translates to:
  /// **'Foam'**
  String get catalogValueMaterial2;

  /// No description provided for @catalogValueMaterial3.
  ///
  /// In en, this message translates to:
  /// **'Latex'**
  String get catalogValueMaterial3;

  /// No description provided for @catalogValueFirmness1.
  ///
  /// In en, this message translates to:
  /// **'Soft'**
  String get catalogValueFirmness1;

  /// No description provided for @catalogValueFirmness2.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get catalogValueFirmness2;

  /// No description provided for @catalogValueFirmness3.
  ///
  /// In en, this message translates to:
  /// **'Firm'**
  String get catalogValueFirmness3;

  /// No description provided for @catalogValueWarranty1.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get catalogValueWarranty1;

  /// No description provided for @catalogValueWarranty2.
  ///
  /// In en, this message translates to:
  /// **'5 years'**
  String get catalogValueWarranty2;

  /// No description provided for @catalogRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get catalogRequired;

  /// No description provided for @catalogOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get catalogOptional;

  /// No description provided for @catalogPriceListRetail.
  ///
  /// In en, this message translates to:
  /// **'Retail'**
  String get catalogPriceListRetail;

  /// No description provided for @catalogPriceListWholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get catalogPriceListWholesale;

  /// No description provided for @catalogPriceListOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get catalogPriceListOnline;

  /// No description provided for @catalogChannelShowroom.
  ///
  /// In en, this message translates to:
  /// **'Showroom'**
  String get catalogChannelShowroom;

  /// No description provided for @catalogChannelWeb.
  ///
  /// In en, this message translates to:
  /// **'Web store'**
  String get catalogChannelWeb;

  /// No description provided for @catalogChannelWholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get catalogChannelWholesale;

  /// No description provided for @catalogMeterDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions and shape'**
  String get catalogMeterDimensions;

  /// No description provided for @catalogMeterPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing inputs'**
  String get catalogMeterPricing;

  /// No description provided for @catalogMeterSummary.
  ///
  /// In en, this message translates to:
  /// **'Live estimate'**
  String get catalogMeterSummary;

  /// No description provided for @catalogMeterWidth.
  ///
  /// In en, this message translates to:
  /// **'Width (cm)'**
  String get catalogMeterWidth;

  /// No description provided for @catalogMeterHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get catalogMeterHeight;

  /// No description provided for @catalogMeterRate.
  ///
  /// In en, this message translates to:
  /// **'Price per m²'**
  String get catalogMeterRate;

  /// No description provided for @catalogMeterWaste.
  ///
  /// In en, this message translates to:
  /// **'Waste (%)'**
  String get catalogMeterWaste;

  /// No description provided for @catalogMeterShape.
  ///
  /// In en, this message translates to:
  /// **'Shape'**
  String get catalogMeterShape;

  /// No description provided for @catalogShapeRectangle.
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get catalogShapeRectangle;

  /// No description provided for @catalogShapeRound.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get catalogShapeRound;

  /// No description provided for @catalogShapeLShape.
  ///
  /// In en, this message translates to:
  /// **'L-shape'**
  String get catalogShapeLShape;

  /// No description provided for @catalogMeterArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get catalogMeterArea;

  /// No description provided for @catalogMeterBasePrice.
  ///
  /// In en, this message translates to:
  /// **'Base price'**
  String get catalogMeterBasePrice;

  /// No description provided for @catalogMeterWasteCost.
  ///
  /// In en, this message translates to:
  /// **'Waste cost'**
  String get catalogMeterWasteCost;

  /// No description provided for @catalogMeterTotal.
  ///
  /// In en, this message translates to:
  /// **'Estimated price'**
  String get catalogMeterTotal;

  /// No description provided for @catalogMeterHint.
  ///
  /// In en, this message translates to:
  /// **'Updates as you type'**
  String get catalogMeterHint;

  /// No description provided for @catalogMeterInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter width, height and price to see the estimate.'**
  String get catalogMeterInvalid;

  /// No description provided for @catalogMeterUnit.
  ///
  /// In en, this message translates to:
  /// **'m²'**
  String get catalogMeterUnit;

  /// No description provided for @adminFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminFilterAll;

  /// No description provided for @inventoryTabWarehouses.
  ///
  /// In en, this message translates to:
  /// **'Warehouses'**
  String get inventoryTabWarehouses;

  /// No description provided for @inventoryTabStocks.
  ///
  /// In en, this message translates to:
  /// **'Stock balances'**
  String get inventoryTabStocks;

  /// No description provided for @inventoryTabTransfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get inventoryTabTransfers;

  /// No description provided for @inventoryTabAudits.
  ///
  /// In en, this message translates to:
  /// **'Stock audits'**
  String get inventoryTabAudits;

  /// No description provided for @inventoryTabBatches.
  ///
  /// In en, this message translates to:
  /// **'Batches & expiry'**
  String get inventoryTabBatches;

  /// No description provided for @inventorySearchWarehouses.
  ///
  /// In en, this message translates to:
  /// **'Search warehouses or managers'**
  String get inventorySearchWarehouses;

  /// No description provided for @inventorySearchStocks.
  ///
  /// In en, this message translates to:
  /// **'Search products, SKU or warehouse'**
  String get inventorySearchStocks;

  /// No description provided for @inventorySearchTransfers.
  ///
  /// In en, this message translates to:
  /// **'Search transfers'**
  String get inventorySearchTransfers;

  /// No description provided for @inventorySearchAudits.
  ///
  /// In en, this message translates to:
  /// **'Search audits or counters'**
  String get inventorySearchAudits;

  /// No description provided for @inventorySearchBatches.
  ///
  /// In en, this message translates to:
  /// **'Search batches or products'**
  String get inventorySearchBatches;

  /// No description provided for @inventoryMetricWarehouses.
  ///
  /// In en, this message translates to:
  /// **'Warehouses'**
  String get inventoryMetricWarehouses;

  /// No description provided for @inventoryMetricProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get inventoryMetricProducts;

  /// No description provided for @inventoryMetricUnitsOnHand.
  ///
  /// In en, this message translates to:
  /// **'Units on hand'**
  String get inventoryMetricUnitsOnHand;

  /// No description provided for @inventoryMetricCapacityUsed.
  ///
  /// In en, this message translates to:
  /// **'Capacity used'**
  String get inventoryMetricCapacityUsed;

  /// No description provided for @inventoryMetricStockValue.
  ///
  /// In en, this message translates to:
  /// **'Stock value'**
  String get inventoryMetricStockValue;

  /// No description provided for @inventoryMetricSkus.
  ///
  /// In en, this message translates to:
  /// **'SKUs'**
  String get inventoryMetricSkus;

  /// No description provided for @inventoryMetricLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get inventoryMetricLowStock;

  /// No description provided for @inventoryMetricOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get inventoryMetricOutOfStock;

  /// No description provided for @inventoryMetricReorderValue.
  ///
  /// In en, this message translates to:
  /// **'Reorder value'**
  String get inventoryMetricReorderValue;

  /// No description provided for @inventoryMetricPendingTransfers.
  ///
  /// In en, this message translates to:
  /// **'Pending transfers'**
  String get inventoryMetricPendingTransfers;

  /// No description provided for @inventoryMetricUnitsInTransit.
  ///
  /// In en, this message translates to:
  /// **'Units in transit'**
  String get inventoryMetricUnitsInTransit;

  /// No description provided for @inventoryMetricReceivedTransfers.
  ///
  /// In en, this message translates to:
  /// **'Received transfers'**
  String get inventoryMetricReceivedTransfers;

  /// No description provided for @inventoryMetricLastTransfer.
  ///
  /// In en, this message translates to:
  /// **'Last transfer'**
  String get inventoryMetricLastTransfer;

  /// No description provided for @inventoryMetricOpenAudits.
  ///
  /// In en, this message translates to:
  /// **'Open audits'**
  String get inventoryMetricOpenAudits;

  /// No description provided for @inventoryMetricVarianceUnits.
  ///
  /// In en, this message translates to:
  /// **'Net variance'**
  String get inventoryMetricVarianceUnits;

  /// No description provided for @inventoryMetricClosedAudits.
  ///
  /// In en, this message translates to:
  /// **'Closed audits'**
  String get inventoryMetricClosedAudits;

  /// No description provided for @inventoryMetricNextAudit.
  ///
  /// In en, this message translates to:
  /// **'Next audit'**
  String get inventoryMetricNextAudit;

  /// No description provided for @inventoryMetricActiveBatches.
  ///
  /// In en, this message translates to:
  /// **'Active batches'**
  String get inventoryMetricActiveBatches;

  /// No description provided for @inventoryMetricExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get inventoryMetricExpiringSoon;

  /// No description provided for @inventoryMetricExpiredBatches.
  ///
  /// In en, this message translates to:
  /// **'Expired batches'**
  String get inventoryMetricExpiredBatches;

  /// No description provided for @inventoryMetricBatchValue.
  ///
  /// In en, this message translates to:
  /// **'Batch value'**
  String get inventoryMetricBatchValue;

  /// No description provided for @inventoryColWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get inventoryColWarehouse;

  /// No description provided for @inventoryColManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get inventoryColManager;

  /// No description provided for @inventoryColCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get inventoryColCapacity;

  /// No description provided for @inventoryColUtilization.
  ///
  /// In en, this message translates to:
  /// **'Utilization'**
  String get inventoryColUtilization;

  /// No description provided for @inventoryColProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get inventoryColProducts;

  /// No description provided for @inventoryColProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get inventoryColProduct;

  /// No description provided for @inventoryColSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get inventoryColSku;

  /// No description provided for @inventoryColOnHand.
  ///
  /// In en, this message translates to:
  /// **'On hand'**
  String get inventoryColOnHand;

  /// No description provided for @inventoryColReorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder at'**
  String get inventoryColReorder;

  /// No description provided for @inventoryColValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get inventoryColValue;

  /// No description provided for @inventoryColState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get inventoryColState;

  /// No description provided for @inventoryColTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get inventoryColTransfer;

  /// No description provided for @inventoryColRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get inventoryColRoute;

  /// No description provided for @inventoryColUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get inventoryColUnits;

  /// No description provided for @inventoryColDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get inventoryColDate;

  /// No description provided for @inventoryColAudit.
  ///
  /// In en, this message translates to:
  /// **'Audit'**
  String get inventoryColAudit;

  /// No description provided for @inventoryColCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get inventoryColCounter;

  /// No description provided for @inventoryColVariance.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get inventoryColVariance;

  /// No description provided for @inventoryColBatch.
  ///
  /// In en, this message translates to:
  /// **'Batch'**
  String get inventoryColBatch;

  /// No description provided for @inventoryColExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get inventoryColExpiry;

  /// No description provided for @inventoryColQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get inventoryColQuantity;

  /// No description provided for @inventoryColDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'Days left'**
  String get inventoryColDaysLeft;

  /// No description provided for @inventoryStateHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get inventoryStateHealthy;

  /// No description provided for @inventoryStateLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get inventoryStateLow;

  /// No description provided for @inventoryStateOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get inventoryStateOut;

  /// No description provided for @inventoryTransferDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get inventoryTransferDraft;

  /// No description provided for @inventoryTransferTransit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get inventoryTransferTransit;

  /// No description provided for @inventoryTransferReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get inventoryTransferReceived;

  /// No description provided for @inventoryAuditScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get inventoryAuditScheduled;

  /// No description provided for @inventoryAuditCounting.
  ///
  /// In en, this message translates to:
  /// **'Counting'**
  String get inventoryAuditCounting;

  /// No description provided for @inventoryAuditClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get inventoryAuditClosed;

  /// No description provided for @inventoryBatchValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get inventoryBatchValid;

  /// No description provided for @inventoryBatchExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring'**
  String get inventoryBatchExpiring;

  /// No description provided for @inventoryBatchExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get inventoryBatchExpired;

  /// No description provided for @inventoryCapacityRatio.
  ///
  /// In en, this message translates to:
  /// **'{used} / {capacity}'**
  String inventoryCapacityRatio(String used, String capacity);

  /// No description provided for @inventoryCapacityUsed.
  ///
  /// In en, this message translates to:
  /// **'{percent}% used'**
  String inventoryCapacityUsed(int percent);

  /// No description provided for @inventoryUnits.
  ///
  /// In en, this message translates to:
  /// **'{count} units'**
  String inventoryUnits(int count);

  /// No description provided for @inventoryDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String inventoryDaysLeft(int days);

  /// No description provided for @inventoryDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String inventoryDaysAgo(int days);

  /// No description provided for @inventoryLowStockItems.
  ///
  /// In en, this message translates to:
  /// **'{count} low-stock items'**
  String inventoryLowStockItems(int count);

  /// No description provided for @inventoryProductsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String inventoryProductsCount(int count);

  /// No description provided for @inventoryPlannedTransfersBody.
  ///
  /// In en, this message translates to:
  /// **'Transfer drafts will be saved to the backend once the transfers endpoint ships. Until then the drafts below are sample data and no movement is recorded.'**
  String get inventoryPlannedTransfersBody;

  /// No description provided for @inventoryPlannedAuditsBody.
  ///
  /// In en, this message translates to:
  /// **'Audit sessions are read-only for now: the counting workflow needs the audit endpoint. The sessions below are sample data.'**
  String get inventoryPlannedAuditsBody;

  /// No description provided for @salesTabPos.
  ///
  /// In en, this message translates to:
  /// **'Point of sale'**
  String get salesTabPos;

  /// No description provided for @salesTabPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get salesTabPayments;

  /// No description provided for @salesTabShifts.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get salesTabShifts;

  /// No description provided for @salesTabOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get salesTabOrders;

  /// No description provided for @salesTabCustomOrders.
  ///
  /// In en, this message translates to:
  /// **'Custom orders'**
  String get salesTabCustomOrders;

  /// No description provided for @salesTabPromotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get salesTabPromotions;

  /// No description provided for @salesSearchPos.
  ///
  /// In en, this message translates to:
  /// **'Search products or SKU'**
  String get salesSearchPos;

  /// No description provided for @salesSearchPayments.
  ///
  /// In en, this message translates to:
  /// **'Search payments, orders or customers'**
  String get salesSearchPayments;

  /// No description provided for @salesSearchShifts.
  ///
  /// In en, this message translates to:
  /// **'Search shifts or cashiers'**
  String get salesSearchShifts;

  /// No description provided for @salesSearchOrders.
  ///
  /// In en, this message translates to:
  /// **'Search orders or customers'**
  String get salesSearchOrders;

  /// No description provided for @salesSearchCustomOrders.
  ///
  /// In en, this message translates to:
  /// **'Search custom orders or customers'**
  String get salesSearchCustomOrders;

  /// No description provided for @salesSearchPromotions.
  ///
  /// In en, this message translates to:
  /// **'Search promotions or codes'**
  String get salesSearchPromotions;

  /// No description provided for @salesColPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get salesColPayment;

  /// No description provided for @salesColOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get salesColOrder;

  /// No description provided for @salesColCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get salesColCustomer;

  /// No description provided for @salesColMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get salesColMethod;

  /// No description provided for @salesColAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get salesColAmount;

  /// No description provided for @salesColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get salesColStatus;

  /// No description provided for @salesColDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get salesColDate;

  /// No description provided for @salesColShift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get salesColShift;

  /// No description provided for @salesColCashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get salesColCashier;

  /// No description provided for @salesColOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get salesColOpened;

  /// No description provided for @salesColClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get salesColClosed;

  /// No description provided for @salesColSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get salesColSales;

  /// No description provided for @salesColVariance.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get salesColVariance;

  /// No description provided for @salesColItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get salesColItems;

  /// No description provided for @salesColTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get salesColTotal;

  /// No description provided for @salesColCustomOrder.
  ///
  /// In en, this message translates to:
  /// **'Custom order'**
  String get salesColCustomOrder;

  /// No description provided for @salesColDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get salesColDimensions;

  /// No description provided for @salesColDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get salesColDeposit;

  /// No description provided for @salesColDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get salesColDue;

  /// No description provided for @salesColPromotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get salesColPromotion;

  /// No description provided for @salesColCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get salesColCode;

  /// No description provided for @salesColUses.
  ///
  /// In en, this message translates to:
  /// **'Uses'**
  String get salesColUses;

  /// No description provided for @salesColWindow.
  ///
  /// In en, this message translates to:
  /// **'Window'**
  String get salesColWindow;

  /// No description provided for @salesPayCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get salesPayCash;

  /// No description provided for @salesPayCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get salesPayCard;

  /// No description provided for @salesPayCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get salesPayCredit;

  /// No description provided for @salesPayWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get salesPayWallet;

  /// No description provided for @salesPayPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get salesPayPaid;

  /// No description provided for @salesPayPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get salesPayPending;

  /// No description provided for @salesPayRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get salesPayRefunded;

  /// No description provided for @salesPosCart.
  ///
  /// In en, this message translates to:
  /// **'Current sale'**
  String get salesPosCart;

  /// No description provided for @salesPosEmptyCart.
  ///
  /// In en, this message translates to:
  /// **'The cart is empty. Add a product to start a sale.'**
  String get salesPosEmptyCart;

  /// No description provided for @salesPosWalkIn.
  ///
  /// In en, this message translates to:
  /// **'Walk-in customer'**
  String get salesPosWalkIn;

  /// No description provided for @salesPosQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get salesPosQty;

  /// No description provided for @salesPosAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get salesPosAdd;

  /// No description provided for @salesPosRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get salesPosRemove;

  /// No description provided for @salesPosClear.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get salesPosClear;

  /// No description provided for @salesPosSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get salesPosSubtotal;

  /// No description provided for @salesPosVat.
  ///
  /// In en, this message translates to:
  /// **'VAT (14%)'**
  String get salesPosVat;

  /// No description provided for @salesPosTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get salesPosTotal;

  /// No description provided for @salesPosCharge.
  ///
  /// In en, this message translates to:
  /// **'Charge {amount}'**
  String salesPosCharge(String amount);

  /// No description provided for @salesPosChargeMessage.
  ///
  /// In en, this message translates to:
  /// **'Sample sale: no payment was processed.'**
  String get salesPosChargeMessage;

  /// No description provided for @salesMetricCartItems.
  ///
  /// In en, this message translates to:
  /// **'Cart items'**
  String get salesMetricCartItems;

  /// No description provided for @salesMetricCartSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Cart subtotal'**
  String get salesMetricCartSubtotal;

  /// No description provided for @salesMetricCartVat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get salesMetricCartVat;

  /// No description provided for @salesMetricCartTotal.
  ///
  /// In en, this message translates to:
  /// **'Total due'**
  String get salesMetricCartTotal;

  /// No description provided for @salesMetricCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get salesMetricCollected;

  /// No description provided for @salesMetricCardShare.
  ///
  /// In en, this message translates to:
  /// **'Card share'**
  String get salesMetricCardShare;

  /// No description provided for @salesMetricPendingCredit.
  ///
  /// In en, this message translates to:
  /// **'Pending credit'**
  String get salesMetricPendingCredit;

  /// No description provided for @salesMetricRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get salesMetricRefunds;

  /// No description provided for @salesShiftOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get salesShiftOpen;

  /// No description provided for @salesShiftClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get salesShiftClosed;

  /// No description provided for @salesMetricOpenShifts.
  ///
  /// In en, this message translates to:
  /// **'Open shifts'**
  String get salesMetricOpenShifts;

  /// No description provided for @salesMetricShiftSales.
  ///
  /// In en, this message translates to:
  /// **'Shift sales'**
  String get salesMetricShiftSales;

  /// No description provided for @salesMetricCashDrawer.
  ///
  /// In en, this message translates to:
  /// **'Cash in drawer'**
  String get salesMetricCashDrawer;

  /// No description provided for @salesMetricCashVariance.
  ///
  /// In en, this message translates to:
  /// **'Cash variance'**
  String get salesMetricCashVariance;

  /// No description provided for @salesOrderNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get salesOrderNew;

  /// No description provided for @salesOrderProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get salesOrderProcessing;

  /// No description provided for @salesOrderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get salesOrderDelivered;

  /// No description provided for @salesOrderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get salesOrderCancelled;

  /// No description provided for @salesMetricOpenOrders.
  ///
  /// In en, this message translates to:
  /// **'Open orders'**
  String get salesMetricOpenOrders;

  /// No description provided for @salesMetricOrderValue.
  ///
  /// In en, this message translates to:
  /// **'Order value'**
  String get salesMetricOrderValue;

  /// No description provided for @salesMetricDeliveredOrders.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get salesMetricDeliveredOrders;

  /// No description provided for @salesMetricCancelledOrders.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get salesMetricCancelledOrders;

  /// No description provided for @salesPlannedOrdersBody.
  ///
  /// In en, this message translates to:
  /// **'Order listing needs the sales order endpoint. The rows below are sample data and the create action stays disabled until the API ships.'**
  String get salesPlannedOrdersBody;

  /// No description provided for @salesCustomDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit paid'**
  String get salesCustomDeposit;

  /// No description provided for @salesCustomProduction.
  ///
  /// In en, this message translates to:
  /// **'In production'**
  String get salesCustomProduction;

  /// No description provided for @salesCustomReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get salesCustomReady;

  /// No description provided for @salesMetricOpenCustomOrders.
  ///
  /// In en, this message translates to:
  /// **'Open custom orders'**
  String get salesMetricOpenCustomOrders;

  /// No description provided for @salesMetricCustomDeposits.
  ///
  /// In en, this message translates to:
  /// **'Deposits held'**
  String get salesMetricCustomDeposits;

  /// No description provided for @salesMetricCustomReady.
  ///
  /// In en, this message translates to:
  /// **'Ready for pickup'**
  String get salesMetricCustomReady;

  /// No description provided for @salesMetricCustomOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get salesMetricCustomOverdue;

  /// No description provided for @salesPlannedCustomOrdersBody.
  ///
  /// In en, this message translates to:
  /// **'The custom order board needs the custom order endpoint. The cards below are sample data and the create action stays disabled until the API ships.'**
  String get salesPlannedCustomOrdersBody;

  /// No description provided for @salesPromoActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get salesPromoActive;

  /// No description provided for @salesPromoScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get salesPromoScheduled;

  /// No description provided for @salesPromoExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get salesPromoExpired;

  /// No description provided for @salesMetricActivePromotions.
  ///
  /// In en, this message translates to:
  /// **'Active promotions'**
  String get salesMetricActivePromotions;

  /// No description provided for @salesMetricPromoRedemptions.
  ///
  /// In en, this message translates to:
  /// **'Redemptions'**
  String get salesMetricPromoRedemptions;

  /// No description provided for @salesMetricPromoDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount given'**
  String get salesMetricPromoDiscount;

  /// No description provided for @salesMetricPromoExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get salesMetricPromoExpiring;

  /// No description provided for @salesPlannedPromotionsBody.
  ///
  /// In en, this message translates to:
  /// **'Promotion listing needs the promotions endpoint. The cards below are sample data and the create action stays disabled until the API ships.'**
  String get salesPlannedPromotionsBody;

  /// No description provided for @salesPromoOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String salesPromoOff(int percent);

  /// No description provided for @salesPromoWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter mattress sale'**
  String get salesPromoWinter;

  /// No description provided for @salesPromoPillowBundle.
  ///
  /// In en, this message translates to:
  /// **'Pillow bundle'**
  String get salesPromoPillowBundle;

  /// No description provided for @salesPromoBaseClearance.
  ///
  /// In en, this message translates to:
  /// **'Base clearance'**
  String get salesPromoBaseClearance;

  /// No description provided for @salesPromoVip.
  ///
  /// In en, this message translates to:
  /// **'VIP loyalty'**
  String get salesPromoVip;

  /// No description provided for @salesPromoNewHome.
  ///
  /// In en, this message translates to:
  /// **'New home bundle'**
  String get salesPromoNewHome;

  /// No description provided for @salesPromoHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel contract'**
  String get salesPromoHotel;

  /// No description provided for @salesPromoClearance.
  ///
  /// In en, this message translates to:
  /// **'Warehouse clearance'**
  String get salesPromoClearance;

  /// No description provided for @salesPromoRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan offer'**
  String get salesPromoRamadan;

  /// No description provided for @navOperations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get navOperations;

  /// No description provided for @operationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Operations & branches'**
  String get operationsTitle;

  /// No description provided for @operationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Internal tasks, branch load and customer holds'**
  String get operationsDescription;

  /// No description provided for @operationsFeature1.
  ///
  /// In en, this message translates to:
  /// **'Tasks for a person, a group or branch teams'**
  String get operationsFeature1;

  /// No description provided for @operationsFeature2.
  ///
  /// In en, this message translates to:
  /// **'Branch workload, overdue work and completion'**
  String get operationsFeature2;

  /// No description provided for @operationsFeature3.
  ///
  /// In en, this message translates to:
  /// **'Customer holds for goods and custom sizes'**
  String get operationsFeature3;

  /// No description provided for @opsTabTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get opsTabTasks;

  /// No description provided for @opsTabBranches.
  ///
  /// In en, this message translates to:
  /// **'Branch load'**
  String get opsTabBranches;

  /// No description provided for @opsTabHolds.
  ///
  /// In en, this message translates to:
  /// **'Customer holds'**
  String get opsTabHolds;

  /// No description provided for @opsSearchTasks.
  ///
  /// In en, this message translates to:
  /// **'Search tasks, people or branches'**
  String get opsSearchTasks;

  /// No description provided for @opsSearchBranches.
  ///
  /// In en, this message translates to:
  /// **'Search branches or managers'**
  String get opsSearchBranches;

  /// No description provided for @opsSearchHolds.
  ///
  /// In en, this message translates to:
  /// **'Search holds, customers or items'**
  String get opsSearchHolds;

  /// No description provided for @opsColTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get opsColTask;

  /// No description provided for @opsColAssignee.
  ///
  /// In en, this message translates to:
  /// **'Assignee'**
  String get opsColAssignee;

  /// No description provided for @opsColBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get opsColBranch;

  /// No description provided for @opsColPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get opsColPriority;

  /// No description provided for @opsColDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get opsColDue;

  /// No description provided for @opsColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get opsColStatus;

  /// No description provided for @opsColChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get opsColChecklist;

  /// No description provided for @opsColCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get opsColCustomer;

  /// No description provided for @opsColItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get opsColItem;

  /// No description provided for @opsColDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get opsColDeposit;

  /// No description provided for @opsColExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get opsColExpected;

  /// No description provided for @opsStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get opsStatusOpen;

  /// No description provided for @opsStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get opsStatusInProgress;

  /// No description provided for @opsStatusBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get opsStatusBlocked;

  /// No description provided for @opsStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get opsStatusDone;

  /// No description provided for @opsHoldWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get opsHoldWaiting;

  /// No description provided for @opsHoldArrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get opsHoldArrived;

  /// No description provided for @opsHoldReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get opsHoldReady;

  /// No description provided for @opsHoldCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get opsHoldCancelled;

  /// No description provided for @opsPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get opsPriorityLow;

  /// No description provided for @opsPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get opsPriorityNormal;

  /// No description provided for @opsPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get opsPriorityHigh;

  /// No description provided for @opsPriorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get opsPriorityUrgent;

  /// No description provided for @opsAssigneePerson.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get opsAssigneePerson;

  /// No description provided for @opsAssigneeGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get opsAssigneeGroup;

  /// No description provided for @opsAssigneeBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get opsAssigneeBranch;

  /// No description provided for @opsTaskDetail.
  ///
  /// In en, this message translates to:
  /// **'Task details'**
  String get opsTaskDetail;

  /// No description provided for @opsTaskConditions.
  ///
  /// In en, this message translates to:
  /// **'Context and conditions'**
  String get opsTaskConditions;

  /// No description provided for @opsTaskChecklist.
  ///
  /// In en, this message translates to:
  /// **'To-do list'**
  String get opsTaskChecklist;

  /// No description provided for @opsTaskChecklistEmpty.
  ///
  /// In en, this message translates to:
  /// **'No checklist items for this task.'**
  String get opsTaskChecklistEmpty;

  /// No description provided for @opsTaskChecklistProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String opsTaskChecklistProgress(int done, int total);

  /// No description provided for @opsAssignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get opsAssignedTo;

  /// No description provided for @opsBranchesLabel.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get opsBranchesLabel;

  /// No description provided for @opsDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get opsDueToday;

  /// No description provided for @opsDueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Due tomorrow'**
  String get opsDueTomorrow;

  /// No description provided for @opsDaysOverdue.
  ///
  /// In en, this message translates to:
  /// **'{days} days overdue'**
  String opsDaysOverdue(int days);

  /// No description provided for @opsDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String opsDaysLeft(int days);

  /// No description provided for @opsExpectedToday.
  ///
  /// In en, this message translates to:
  /// **'Expected today'**
  String get opsExpectedToday;

  /// No description provided for @opsMetricOpenTasks.
  ///
  /// In en, this message translates to:
  /// **'Open tasks'**
  String get opsMetricOpenTasks;

  /// No description provided for @opsMetricDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get opsMetricDueToday;

  /// No description provided for @opsMetricOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get opsMetricOverdue;

  /// No description provided for @opsMetricBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get opsMetricBlocked;

  /// No description provided for @opsMetricBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get opsMetricBranches;

  /// No description provided for @opsMetricBranchOpen.
  ///
  /// In en, this message translates to:
  /// **'Open tasks'**
  String get opsMetricBranchOpen;

  /// No description provided for @opsMetricBranchOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue tasks'**
  String get opsMetricBranchOverdue;

  /// No description provided for @opsMetricBranchHolds.
  ///
  /// In en, this message translates to:
  /// **'Waiting holds'**
  String get opsMetricBranchHolds;

  /// No description provided for @opsMetricWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting holds'**
  String get opsMetricWaiting;

  /// No description provided for @opsMetricArriving.
  ///
  /// In en, this message translates to:
  /// **'Arriving this week'**
  String get opsMetricArriving;

  /// No description provided for @opsMetricDeposits.
  ///
  /// In en, this message translates to:
  /// **'Deposits held'**
  String get opsMetricDeposits;

  /// No description provided for @opsMetricReady.
  ///
  /// In en, this message translates to:
  /// **'Ready for pickup'**
  String get opsMetricReady;

  /// No description provided for @opsNewTask.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get opsNewTask;

  /// No description provided for @opsCreateTask.
  ///
  /// In en, this message translates to:
  /// **'Create task'**
  String get opsCreateTask;

  /// No description provided for @opsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get opsClose;

  /// No description provided for @opsTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get opsTaskTitle;

  /// No description provided for @opsTaskTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What needs to happen?'**
  String get opsTaskTitleHint;

  /// No description provided for @opsTaskContext.
  ///
  /// In en, this message translates to:
  /// **'Context and conditions'**
  String get opsTaskContext;

  /// No description provided for @opsTaskContextHint.
  ///
  /// In en, this message translates to:
  /// **'Add the details and constraints the assignee needs'**
  String get opsTaskContextHint;

  /// No description provided for @opsAssignTo.
  ///
  /// In en, this message translates to:
  /// **'Assign to'**
  String get opsAssignTo;

  /// No description provided for @opsChooseAssignee.
  ///
  /// In en, this message translates to:
  /// **'Choose who owns the task'**
  String get opsChooseAssignee;

  /// No description provided for @opsChooseBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get opsChooseBranch;

  /// No description provided for @opsChecklistHint.
  ///
  /// In en, this message translates to:
  /// **'One step per line'**
  String get opsChecklistHint;

  /// No description provided for @opsDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get opsDueDate;

  /// No description provided for @opsNoAssignees.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one assignee.'**
  String get opsNoAssignees;

  /// No description provided for @opsNoBranches.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one branch.'**
  String get opsNoBranches;

  /// No description provided for @opsTaskCreated.
  ///
  /// In en, this message translates to:
  /// **'Task created.'**
  String get opsTaskCreated;

  /// No description provided for @opsTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a title for the task.'**
  String get opsTitleRequired;

  /// No description provided for @opsBranchManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get opsBranchManager;

  /// No description provided for @opsBranchOpenTasks.
  ///
  /// In en, this message translates to:
  /// **'{count} open'**
  String opsBranchOpenTasks(int count);

  /// No description provided for @opsBranchOverdueTasks.
  ///
  /// In en, this message translates to:
  /// **'{count} overdue'**
  String opsBranchOverdueTasks(int count);

  /// No description provided for @opsBranchHolds.
  ///
  /// In en, this message translates to:
  /// **'{count} holds'**
  String opsBranchHolds(int count);

  /// No description provided for @opsBranchTeam.
  ///
  /// In en, this message translates to:
  /// **'{count} people'**
  String opsBranchTeam(int count);

  /// No description provided for @opsBranchOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get opsBranchOnTrack;

  /// No description provided for @opsBranchBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get opsBranchBusy;

  /// No description provided for @opsBranchOverloaded.
  ///
  /// In en, this message translates to:
  /// **'Overloaded'**
  String get opsBranchOverloaded;

  /// No description provided for @opsBranchCompletion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get opsBranchCompletion;

  /// No description provided for @opsHoldStockItem.
  ///
  /// In en, this message translates to:
  /// **'Stock item'**
  String get opsHoldStockItem;

  /// No description provided for @opsHoldCustomSize.
  ///
  /// In en, this message translates to:
  /// **'Custom size'**
  String get opsHoldCustomSize;

  /// No description provided for @opsSizeCustom.
  ///
  /// In en, this message translates to:
  /// **'{width} × {length} cm'**
  String opsSizeCustom(int width, int length);

  /// No description provided for @opsPlannedHoldsTitle.
  ///
  /// In en, this message translates to:
  /// **'Holds awaiting the backend'**
  String get opsPlannedHoldsTitle;

  /// No description provided for @opsPlannedHoldsBody.
  ///
  /// In en, this message translates to:
  /// **'Reserving goods and custom sizes already works in the UI. Saving a hold will be enabled when the inventory endpoint exposes reservations.'**
  String get opsPlannedHoldsBody;

  /// No description provided for @opsPerson1.
  ///
  /// In en, this message translates to:
  /// **'Hala Mostafa'**
  String get opsPerson1;

  /// No description provided for @opsPerson2.
  ///
  /// In en, this message translates to:
  /// **'Rami Fouad'**
  String get opsPerson2;

  /// No description provided for @opsPerson3.
  ///
  /// In en, this message translates to:
  /// **'Dina Samir'**
  String get opsPerson3;

  /// No description provided for @opsPerson4.
  ///
  /// In en, this message translates to:
  /// **'Mostafa Adel'**
  String get opsPerson4;

  /// No description provided for @opsPerson5.
  ///
  /// In en, this message translates to:
  /// **'Nada Sherif'**
  String get opsPerson5;

  /// No description provided for @opsPerson6.
  ///
  /// In en, this message translates to:
  /// **'Sherif Kamel'**
  String get opsPerson6;

  /// No description provided for @opsGroup1.
  ///
  /// In en, this message translates to:
  /// **'Sales team'**
  String get opsGroup1;

  /// No description provided for @opsGroup2.
  ///
  /// In en, this message translates to:
  /// **'Warehouse team'**
  String get opsGroup2;

  /// No description provided for @opsGroup3.
  ///
  /// In en, this message translates to:
  /// **'Tailoring team'**
  String get opsGroup3;

  /// No description provided for @opsGroup4.
  ///
  /// In en, this message translates to:
  /// **'Support team'**
  String get opsGroup4;

  /// No description provided for @opsTask1Title.
  ///
  /// In en, this message translates to:
  /// **'Reset the Tanta showroom for the new collection'**
  String get opsTask1Title;

  /// No description provided for @opsTask1Context.
  ///
  /// In en, this message translates to:
  /// **'Move the old display stock to the back room, steam the fabric panels and photograph the result before the collection lands on Thursday.'**
  String get opsTask1Context;

  /// No description provided for @opsTask2Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm the Cairo weekend delivery slots'**
  String get opsTask2Title;

  /// No description provided for @opsTask2Context.
  ///
  /// In en, this message translates to:
  /// **'Call every order scheduled for Friday and Saturday, confirm the address and note any gate or elevator restrictions before the courier sheet is printed.'**
  String get opsTask2Context;

  /// No description provided for @opsTask3Title.
  ///
  /// In en, this message translates to:
  /// **'Finish the Alexandria custom size price sheet'**
  String get opsTask3Title;

  /// No description provided for @opsTask3Context.
  ///
  /// In en, this message translates to:
  /// **'Add the 2026 foam and cover costs, round each size to the nearest 50 EGP and send the sheet to the branch manager for approval.'**
  String get opsTask3Context;

  /// No description provided for @opsTask4Title.
  ///
  /// In en, this message translates to:
  /// **'Count the Mansoura mattress covers'**
  String get opsTask4Title;

  /// No description provided for @opsTask4Context.
  ///
  /// In en, this message translates to:
  /// **'The count is two weeks late. Count every size, log variances against the stock sheet and flag any cover that is still in a customer hold.'**
  String get opsTask4Context;

  /// No description provided for @opsTask5Title.
  ///
  /// In en, this message translates to:
  /// **'Receive the foam shipment at Tanta'**
  String get opsTask5Title;

  /// No description provided for @opsTask5Context.
  ///
  /// In en, this message translates to:
  /// **'Check the delivery note against the purchase order, inspect the rolls for tears and hand the signed note to accounting.'**
  String get opsTask5Context;

  /// No description provided for @opsTask6Title.
  ///
  /// In en, this message translates to:
  /// **'Resolve the Cairo hold for the 180×200 size'**
  String get opsTask6Title;

  /// No description provided for @opsTask6Context.
  ///
  /// In en, this message translates to:
  /// **'The customer paid a deposit three weeks ago. Confirm the supplier date, offer a loan unit and update the customer before the end of the day.'**
  String get opsTask6Context;

  /// No description provided for @opsTask7Title.
  ///
  /// In en, this message translates to:
  /// **'Follow up on the Alexandria delivery complaints'**
  String get opsTask7Title;

  /// No description provided for @opsTask7Context.
  ///
  /// In en, this message translates to:
  /// **'Three customers reported late arrivals last week. Call each one, log the reason and agree a goodwill gesture with support.'**
  String get opsTask7Context;

  /// No description provided for @opsTask8Title.
  ///
  /// In en, this message translates to:
  /// **'Price the Mansoura spring promotion'**
  String get opsTask8Title;

  /// No description provided for @opsTask8Context.
  ///
  /// In en, this message translates to:
  /// **'Build a bundle for two pillows and a protector, compare it with the Cairo promotion and keep the margin above 25 percent.'**
  String get opsTask8Context;

  /// No description provided for @opsTask9Title.
  ///
  /// In en, this message translates to:
  /// **'Agree the Tanta cash handover checklist'**
  String get opsTask9Title;

  /// No description provided for @opsTask9Context.
  ///
  /// In en, this message translates to:
  /// **'Meet the cashiers, close the gaps in the evening handover and update the branch board before the next shift.'**
  String get opsTask9Context;

  /// No description provided for @opsTask10Title.
  ///
  /// In en, this message translates to:
  /// **'Finish the Cairo custom order C-2214'**
  String get opsTask10Title;

  /// No description provided for @opsTask10Context.
  ///
  /// In en, this message translates to:
  /// **'The cover is cut. Check the stitching, wrap the mattress, call the customer and book the delivery slot.'**
  String get opsTask10Context;

  /// No description provided for @opsStep1.
  ///
  /// In en, this message translates to:
  /// **'Review the handover sheet'**
  String get opsStep1;

  /// No description provided for @opsStep2.
  ///
  /// In en, this message translates to:
  /// **'Check stock on hand'**
  String get opsStep2;

  /// No description provided for @opsStep3.
  ///
  /// In en, this message translates to:
  /// **'Call the customer'**
  String get opsStep3;

  /// No description provided for @opsStep4.
  ///
  /// In en, this message translates to:
  /// **'Confirm delivery slots'**
  String get opsStep4;

  /// No description provided for @opsStep5.
  ///
  /// In en, this message translates to:
  /// **'Update the price sheet'**
  String get opsStep5;

  /// No description provided for @opsStep6.
  ///
  /// In en, this message translates to:
  /// **'Count the units'**
  String get opsStep6;

  /// No description provided for @opsStep7.
  ///
  /// In en, this message translates to:
  /// **'Log any variance'**
  String get opsStep7;

  /// No description provided for @opsStep8.
  ///
  /// In en, this message translates to:
  /// **'Receive the shipment'**
  String get opsStep8;

  /// No description provided for @opsStep9.
  ///
  /// In en, this message translates to:
  /// **'Inspect the foam rolls'**
  String get opsStep9;

  /// No description provided for @opsStep10.
  ///
  /// In en, this message translates to:
  /// **'Notify the sales team'**
  String get opsStep10;

  /// No description provided for @opsStep11.
  ///
  /// In en, this message translates to:
  /// **'Prepare the fabric samples'**
  String get opsStep11;

  /// No description provided for @opsStep12.
  ///
  /// In en, this message translates to:
  /// **'Photograph the result'**
  String get opsStep12;

  /// No description provided for @opsStep13.
  ///
  /// In en, this message translates to:
  /// **'Book the courier'**
  String get opsStep13;

  /// No description provided for @opsStep14.
  ///
  /// In en, this message translates to:
  /// **'Print the size labels'**
  String get opsStep14;

  /// No description provided for @opsStep15.
  ///
  /// In en, this message translates to:
  /// **'Verify the deposit'**
  String get opsStep15;

  /// No description provided for @opsStep16.
  ///
  /// In en, this message translates to:
  /// **'Clear the counter area'**
  String get opsStep16;

  /// No description provided for @opsStep17.
  ///
  /// In en, this message translates to:
  /// **'Update the branch board'**
  String get opsStep17;

  /// No description provided for @opsStep18.
  ///
  /// In en, this message translates to:
  /// **'Confirm with the branch manager'**
  String get opsStep18;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
