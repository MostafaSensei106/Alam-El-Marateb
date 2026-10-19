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
