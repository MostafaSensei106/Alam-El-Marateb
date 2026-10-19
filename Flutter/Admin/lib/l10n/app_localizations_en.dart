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
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get password => 'Password';

  @override
  String get forgetPassword => 'Forget password?';

  @override
  String get email => 'E-Mail';

  @override
  String get alm_el_marateb => 'Alm-El-Marateb';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get phone => 'Phone';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get enterYourCredentialsToAccessYourAccount =>
      'Enter your credentials to access your account.';

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

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navIdentity => 'Identity';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navSales => 'Sales';

  @override
  String get navPurchasing => 'Purchasing';

  @override
  String get navCrm => 'CRM';

  @override
  String get navDelivery => 'Delivery';

  @override
  String get navHr => 'HR';

  @override
  String get navAccounting => 'Accounting';

  @override
  String get navMarketing => 'Marketing';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get expandNavigation => 'Expand navigation';

  @override
  String get collapseNavigation => 'Collapse navigation';

  @override
  String get toggleTheme => 'Toggle theme';

  @override
  String get screenComingSoon => 'This screen will be added soon.';

  @override
  String get dashboardTitle => 'Analytics & Dashboard';

  @override
  String get dashboardDescription =>
      'Key performance indicators and administrative analytics';

  @override
  String get dashboardFeature1 => 'Sales, revenue and profit summary';

  @override
  String get dashboardFeature2 => 'Branch performance comparison';

  @override
  String get dashboardFeature3 => 'Sales and orders heat map';

  @override
  String get dashboardFeature4 => 'Best-selling products and turnover speed';

  @override
  String get dashboardFeature5 => 'Customer RFM analysis';

  @override
  String get identityTitle => 'Identity & Access';

  @override
  String get identityDescription => 'Branches, users and permissions';

  @override
  String get identityFeature1 => 'Manage branches and showrooms';

  @override
  String get identityFeature2 => 'Users, roles and permissions';

  @override
  String get identityFeature3 => 'Vehicle fleet and load capacities';

  @override
  String get catalogTitle => 'Catalog Management';

  @override
  String get catalogDescription => 'Products, catalog and pricing';

  @override
  String get catalogFeature1 =>
      'Products, images, translations and specifications';

  @override
  String get catalogFeature2 => 'Categories and brands';

  @override
  String get catalogFeature3 => 'Attributes, traits and options';

  @override
  String get catalogFeature4 => 'Price lists and sales channel prices';

  @override
  String get catalogFeature5 => 'Square meter pricing and custom shapes';

  @override
  String get inventoryTitle => 'Inventory & Warehouse';

  @override
  String get inventoryDescription => 'Warehouses, stock movement and cost';

  @override
  String get inventoryFeature1 => 'Manage warehouses';

  @override
  String get inventoryFeature2 => 'Stock balances and low-stock alerts';

  @override
  String get inventoryFeature3 => 'Transfers between warehouses';

  @override
  String get inventoryFeature4 => 'Stock counts and adjustments';

  @override
  String get inventoryFeature5 => 'Batches and FIFO inventory valuation';

  @override
  String get salesTitle => 'Sales & POS';

  @override
  String get salesDescription => 'Sales, point of sale and orders';

  @override
  String get salesFeature1 => 'Point of sale, barcode and discounts';

  @override
  String get salesFeature2 => 'Payment methods: cash, card and credit';

  @override
  String get salesFeature3 => 'Open shifts, cash handover and closing';

  @override
  String get salesFeature4 => 'Orders, returns and cancellations';

  @override
  String get salesFeature5 => 'Special orders, reservations and deposits';

  @override
  String get salesFeature6 => 'Promotions and coupons';

  @override
  String get purchasingTitle => 'Purchasing';

  @override
  String get purchasingDescription => 'Suppliers, purchase orders and costs';

  @override
  String get purchasingFeature1 => 'Suppliers and account statements';

  @override
  String get purchasingFeature2 => 'Purchase orders and goods receipt';

  @override
  String get purchasingFeature3 => 'Shipments, customs and additional costs';

  @override
  String get purchasingFeature4 =>
      'Supplier invoices, installments and payments';

  @override
  String get crmTitle => 'Customer Relations';

  @override
  String get crmDescription => 'Customers, warranty and complaints';

  @override
  String get crmFeature1 => 'Warranty registry';

  @override
  String get crmFeature2 => 'Customer claims, inspections and repairs';

  @override
  String get crmFeature3 => 'Customer review moderation';

  @override
  String get crmFeature4 => 'Inquiries and product questions';

  @override
  String get deliveryTitle => 'Delivery';

  @override
  String get deliveryDescription => 'Trips, drivers and delivery tracking';

  @override
  String get deliveryFeature1 => 'Create delivery trips and group orders';

  @override
  String get deliveryFeature2 => 'Assign driver and vehicle';

  @override
  String get deliveryFeature3 => 'Route optimization';

  @override
  String get deliveryFeature4 => 'Live tracking and stops';

  @override
  String get deliveryFeature5 => 'Proof of delivery by photo or signature';

  @override
  String get hrTitle => 'Human Resources';

  @override
  String get hrDescription => 'Employees, leave and payroll';

  @override
  String get hrFeature1 => 'Employee records and job data';

  @override
  String get hrFeature2 => 'Leave requests';

  @override
  String get hrFeature3 => 'Payroll runs and Excel export';

  @override
  String get hrFeature4 => 'Commissions, advances and deductions';

  @override
  String get accountingTitle => 'Accounting & Finance';

  @override
  String get accountingDescription =>
      'Accounts, treasuries and financial reports';

  @override
  String get accountingFeature1 => 'Chart of accounts';

  @override
  String get accountingFeature2 => 'Journal entries and general ledger';

  @override
  String get accountingFeature3 => 'Treasuries, banks and fund transfers';

  @override
  String get accountingFeature4 => 'Expenses and checks';

  @override
  String get accountingFeature5 =>
      'Income statement, balance sheet and tax reports';

  @override
  String get marketingTitle => 'Marketing';

  @override
  String get marketingDescription => 'Promotional campaigns';

  @override
  String get marketingFeature1 => 'Wheel of fortune campaigns';

  @override
  String get marketingFeature2 => 'Prize management and campaign activation';

  @override
  String get profileTitle => 'Admin Profile';

  @override
  String get profileDescription => 'The administrator\'s personal data';

  @override
  String get profileFeature1 => 'Personal account details';

  @override
  String get profileFeature2 => 'Edit name and contact details';

  @override
  String get profileFeature3 => 'Change password';

  @override
  String get profileFeature4 => 'Review user role and permissions';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDescription => 'System and application settings';

  @override
  String get settingsFeature1 => 'Language and appearance';

  @override
  String get settingsFeature2 => 'Notification settings';

  @override
  String get settingsFeature3 => 'General system settings';
}
