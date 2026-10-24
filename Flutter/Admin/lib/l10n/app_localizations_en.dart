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

  @override
  String get settingsFeature4 => 'App info';

  @override
  String get adminWorkspace => 'Admin workspace';

  @override
  String get adminDisplayName => 'Mostafa Mahmoud';

  @override
  String get adminRole => 'Super administrator';

  @override
  String get openAccountMenu => 'Open account menu';

  @override
  String get account => 'Account';

  @override
  String get myProfile => 'My profile';

  @override
  String get signOut => 'Sign out';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get signOutConfirmMessage =>
      'You will need to sign in again to access the admin workspace.';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get plannedScreens => 'Planned screens';

  @override
  String get interactivePrototype => 'Interactive prototype';

  @override
  String get prototypeNotice =>
      'Layout preview with sample data. Screens will be connected to the API next.';

  @override
  String get sampleData => 'Sample data';

  @override
  String dashboardGreeting(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get dashboardSubtitle =>
      'Here is what is happening across your store today.';

  @override
  String get dashboardRevenue => 'Revenue';

  @override
  String get dashboardOrders => 'Orders';

  @override
  String get dashboardCustomers => 'Customers';

  @override
  String get dashboardLowStock => 'Low stock';

  @override
  String get dashboardRevenueChange => '+12.4% vs last week';

  @override
  String get dashboardOrdersChange => '+8.1% vs last week';

  @override
  String get dashboardCustomersChange => '+4.6% vs last week';

  @override
  String get dashboardLowStockChange => '6 items need attention';

  @override
  String get dashboardRevenueTrend => 'Revenue, last 7 days';

  @override
  String get dashboardAverageOrder => 'Average order';

  @override
  String get dashboardTodaySales => 'Today';

  @override
  String get dashboardRecentOrders => 'Recent orders';

  @override
  String get dashboardQuickActions => 'Quick actions';

  @override
  String get dashboardViewAll => 'View all';

  @override
  String get dashboardOrder => 'Order';

  @override
  String get dashboardCustomer => 'Customer';

  @override
  String get dashboardStatus => 'Status';

  @override
  String get dashboardTotal => 'Total';

  @override
  String get dashboardStatusPaid => 'Paid';

  @override
  String get dashboardStatusPending => 'Pending';

  @override
  String get dashboardStatusShipping => 'Shipping';

  @override
  String get dashboardNewSale => 'New sale';

  @override
  String get dashboardAddProduct => 'Add product';

  @override
  String get dashboardNewCustomer => 'New customer';

  @override
  String get dashboardCreateTrip => 'Delivery trip';

  @override
  String get profileAccountDetails => 'Account details';

  @override
  String get profileFullName => 'Full name';

  @override
  String get profileJobTitle => 'Job title';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileBranch => 'Branch';

  @override
  String get profileBranchValue => 'Main showroom · Tanta';

  @override
  String get profileMemberSince => 'Member since';

  @override
  String get profileMemberSinceValue => 'January 2024';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profileSecurity => 'Security';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profileChangePasswordDescription =>
      'Use a strong password you don\'t reuse elsewhere.';

  @override
  String get profileTwoFactor => 'Two-factor authentication';

  @override
  String get profileTwoFactorDescription =>
      'Ask for a verification code on every new device.';

  @override
  String get profileSessions => 'Active sessions';

  @override
  String get profileSessionsDescription =>
      'Sign out of every device except this one.';

  @override
  String get profilePermissions => 'Role & permissions';

  @override
  String get profilePermissionHint =>
      'Full access to every module in the workspace.';

  @override
  String get profilePermissionAll => 'All modules';

  @override
  String get profileEditNotReady =>
      'Profile editing will be enabled once the API is connected.';

  @override
  String get profilePasswordNotReady =>
      'Password changes will be enabled once the API is connected.';

  @override
  String get profileTwoFactorOn => 'Two-factor authentication enabled.';

  @override
  String get profileTwoFactorOff => 'Two-factor authentication disabled.';

  @override
  String get profileSessionsCleared => 'Other sessions were signed out.';

  @override
  String get profileSignOutDevice => 'Sign out from this device';

  @override
  String get settingsAppearanceHint => 'Choose how the admin panel looks.';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsHint =>
      'Pick the events you want to be alerted about.';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsGeneralHint =>
      'Defaults that apply to the whole workspace.';

  @override
  String get settingsNotificationOrders => 'New orders';

  @override
  String get settingsNotificationOrdersHint =>
      'Alert me when an order is placed.';

  @override
  String get settingsNotificationLowStock => 'Low stock';

  @override
  String get settingsNotificationLowStockHint =>
      'Alert me when an item drops below its reorder point.';

  @override
  String get settingsNotificationReviews => 'New reviews';

  @override
  String get settingsNotificationReviewsHint =>
      'Alert me when a customer leaves a review.';

  @override
  String get settingsNotificationDigest => 'Daily digest';

  @override
  String get settingsNotificationDigestHint => 'Send a summary every morning.';

  @override
  String get settingsDefaultBranch => 'Default branch';

  @override
  String get settingsDefaultBranchHint =>
      'The branch selected when you sign in.';

  @override
  String get settingsLandingPage => 'Landing page';

  @override
  String get settingsLandingPageHint => 'The first screen after sign-in.';

  @override
  String get settingsAutoRefresh => 'Auto-refresh dashboards';

  @override
  String get settingsAutoRefreshHint => 'Refresh KPIs every 60 seconds.';

  @override
  String get settingsSave => 'Save changes';

  @override
  String get settingsSaved => 'Settings saved.';

  @override
  String get settingsBranchMain => 'Main showroom · Tanta';

  @override
  String get settingsBranchAlex => 'Alexandria branch';

  @override
  String get settingsBranchGiza => 'Giza branch';

  @override
  String get appInfoAppName => 'App name';

  @override
  String get appInfoPackageName => 'Package name';

  @override
  String get appInfoVersion => 'Version';

  @override
  String get appInfoBuildNumber => 'Build number';

  @override
  String get appInfoBuildMode => 'Build mode';

  @override
  String get appInfoBuildModeDebug => 'Debug';

  @override
  String get appInfoBuildModeRelease => 'Release';

  @override
  String get appInfoOperatingSystem => 'Operating system';

  @override
  String get appInfoOperatingSystemVersion => 'OS version';

  @override
  String get appInfoFlutterVersion => 'Flutter version';

  @override
  String get appInfoFlutterChannel => 'Flutter channel';

  @override
  String get appInfoDartVersion => 'Dart version';

  @override
  String get appInfoDartChannel => 'Dart channel';

  @override
  String get appInfoInstallDate => 'Installed on';

  @override
  String get appInfoUpdateDate => 'Updated on';

  @override
  String get appInfoInstaller => 'Installer';

  @override
  String get appInfoUnknown => 'Not reported';

  @override
  String get appInfoCopy => 'Copy details';

  @override
  String get appInfoCopied => 'App details copied.';

  @override
  String get appInfoUnavailableTitle => 'App information unavailable';

  @override
  String get appInfoUnavailableBody =>
      'The app information service is not available in this session.';

  @override
  String get appInfoSectionApplication => 'Application';

  @override
  String get appInfoSectionApplicationHint =>
      'Identity of the installed admin build.';

  @override
  String get appInfoSectionRuntime => 'Runtime';

  @override
  String get appInfoSectionRuntimeHint =>
      'Flutter, Dart and the host platform.';

  @override
  String get appInfoSectionDistribution => 'Distribution';

  @override
  String get appInfoSectionDistributionHint =>
      'Install source and update timing.';

  @override
  String get wireframeTableTitle => 'Data table';

  @override
  String get wireframeFormTitle => 'Form';

  @override
  String get wireframeStatsTitle => 'Metrics';

  @override
  String get wireframeCalendarTitle => 'Calendar';

  @override
  String get wireframeMapTitle => 'Map';

  @override
  String get wireframeBoardTitle => 'Board';

  @override
  String get wireframeListTitle => 'List & detail';

  @override
  String get wireframeDetailTitle => 'Record details';

  @override
  String get wireframeToolbar => 'Search, filters and actions';

  @override
  String get wireframeSearch => 'Search';

  @override
  String get wireframeFilter => 'Filter';

  @override
  String get wireframeNew => 'New';

  @override
  String get wireframeExport => 'Export';

  @override
  String get wireframeColumns => 'Column';

  @override
  String get wireframeRows => 'Row';

  @override
  String get wireframeActions => 'Actions';

  @override
  String get wireframeField => 'Field';

  @override
  String get wireframeValue => 'Value';

  @override
  String get wireframeSave => 'Save';

  @override
  String get wireframeCancel => 'Cancel';

  @override
  String get wireframeChartArea => 'Chart area';

  @override
  String get wireframeTableArea => 'Table area';

  @override
  String get wireframeMapArea => 'Route and stops';

  @override
  String get wireframeTimeline => 'Timeline';

  @override
  String get wireframeCard => 'Card';

  @override
  String get wireframeMetric => 'Metric';

  @override
  String get wireframePreviewHint => 'Preview of the planned layout';

  @override
  String get hubScreens => 'Screens';

  @override
  String get hubSelectScreen =>
      'Select a screen to preview its planned layout.';

  @override
  String get currencyEgp => 'EGP';

  @override
  String get sampleCustomer1 => 'Mona Abdelrahman';

  @override
  String get sampleCustomer2 => 'Youssef Kamal';

  @override
  String get sampleCustomer3 => 'Salma Fathy';

  @override
  String get sampleCustomer4 => 'Karim Nabil';

  @override
  String get dashboardChannelSplit => 'Sales by channel';

  @override
  String get dashboardChannelStore => 'Store';

  @override
  String get dashboardChannelOnline => 'Online';

  @override
  String get dashboardChannelWholesale => 'Wholesale';

  @override
  String get dashboardMonthlyTarget => 'Monthly target';

  @override
  String get dashboardTargetHint => '74% of the monthly target achieved';

  @override
  String get wireframeTableRef => 'Reference';

  @override
  String get wireframeTableName => 'Name';

  @override
  String get wireframeTableStatus => 'Status';

  @override
  String get wireframeTableValue => 'Value';

  @override
  String get wireframeStatsSales => 'Sales';

  @override
  String get wireframeStatsOrders => 'Orders';

  @override
  String get wireframeStatsGrowth => 'Growth';

  @override
  String get wireframeStatsChartTitle => 'Performance over time';

  @override
  String get wireframeEventDelivery => 'Order delivery';

  @override
  String get wireframeEventVisit => 'Customer visit';

  @override
  String get wireframeEventAudit => 'Stock audit';

  @override
  String get wireframeEventMeeting => 'Team meeting';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String sectionRecordsCount(int count) {
    return '$count records';
  }

  @override
  String paginationShowing(int from, int to, int total) {
    return 'Showing $from–$to of $total';
  }

  @override
  String get paginationPerPage => 'Per page';

  @override
  String get paginationPrevious => 'Previous';

  @override
  String get paginationNext => 'Next';

  @override
  String paginationPageOf(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get sectionEmptyTitle => 'No records yet';

  @override
  String get sectionEmptyMessage =>
      'Add your first record or adjust the filters.';

  @override
  String get sectionNoResultsTitle => 'No matching results';

  @override
  String get sectionNoResultsMessage =>
      'Try a different search term or clear the search.';

  @override
  String get sectionClearSearch => 'Clear search';

  @override
  String get sectionDetailTitle => 'Record details';

  @override
  String get sectionSelectRecord =>
      'Pick a record from the list to see its details.';

  @override
  String get sectionTimeline => 'Activity timeline';

  @override
  String get sectionRecordNote =>
      'This record was created from the dashboard. You can edit or archive it at any time.';

  @override
  String get sectionCreatedAt => 'Created';

  @override
  String get sectionLastUpdate => 'Last update';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusActive => 'Active';

  @override
  String get statusDraft => 'Draft';

  @override
  String get formFieldName => 'Name';

  @override
  String get formFieldReference => 'Reference';

  @override
  String get formFieldAmount => 'Amount';

  @override
  String get formFieldDate => 'Date';

  @override
  String get formFieldNotes => 'Notes';

  @override
  String get formFieldStatus => 'Status';

  @override
  String get formFieldBranch => 'Branch';

  @override
  String get formSaveSuccess => 'Changes saved successfully';

  @override
  String get boardColumnNew => 'New';

  @override
  String get boardColumnInProgress => 'In progress';

  @override
  String get boardColumnDone => 'Done';

  @override
  String get statsAverageOrder => 'Average order';

  @override
  String get statsActiveCustomers => 'Active customers';

  @override
  String get statsConversion => 'Conversion rate';

  @override
  String get calendarUpcoming => 'Upcoming appointments';

  @override
  String get mapZone => 'Governorate';

  @override
  String get mapOrders => 'Orders';

  @override
  String get mapRevenue => 'Revenue';

  @override
  String get sampleProduct1 => 'Classic cotton shirt';

  @override
  String get sampleProduct2 => 'Genuine leather shoes';

  @override
  String get sampleProduct3 => 'Practical backpack';

  @override
  String get sampleProduct4 => 'Elegant wristwatch';

  @override
  String get sampleProduct5 => 'Sunglasses';

  @override
  String get sampleEmployee1 => 'Ahmed Saeed';

  @override
  String get sampleEmployee2 => 'Noha Mostafa';

  @override
  String get sampleEmployee3 => 'Khaled Fouad';

  @override
  String get sampleEmployee4 => 'Reem Hassan';

  @override
  String get sampleCampaign1 => 'Eid offer';

  @override
  String get sampleCampaign2 => 'Weekend discounts';

  @override
  String get sampleCampaign3 => 'Customer win-back campaign';

  @override
  String get sampleCampaign4 => 'New collection launch';

  @override
  String get sampleBranch1 => 'Tanta branch';

  @override
  String get sampleBranch2 => 'Cairo branch';

  @override
  String get sampleBranch3 => 'Alexandria branch';

  @override
  String get sampleBranch4 => 'Mansoura branch';

  @override
  String get dashboardSubtitleBranches =>
      'Alam El Marateb performance across branches, stock and customers.';

  @override
  String get dashboardPeriod => 'Period';

  @override
  String get dashboardLast7Days => 'Last 7 days';

  @override
  String get dashboardLast30Days => 'Last 30 days';

  @override
  String get dashboardLast90Days => 'Last 90 days';

  @override
  String get dashboardBranchFilter => 'Branch';

  @override
  String get dashboardAllBranches => 'All branches';

  @override
  String get dashboardRefresh => 'Refresh';

  @override
  String get dashboardExport => 'Export';

  @override
  String get dashboardExportHint =>
      'Export will be available once the dashboard API is connected.';

  @override
  String get dashboardRefreshed =>
      'Dashboard refreshed with the latest sample data.';

  @override
  String dashboardUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String get dashboardSampleBadge => 'Sample data';

  @override
  String get dashboardSampleNote =>
      'Sample data shaped like the analytics API. Flutter-only additions are documented in dashboard-flutter-features.md.';

  @override
  String dashboardActionHint(String action) {
    return '\"$action\" will open here once dashboard actions are connected.';
  }

  @override
  String dashboardOpenModuleHint(String module) {
    return 'Open the $module module to continue.';
  }

  @override
  String get dashboardClose => 'Close';

  @override
  String get dashboardKpiRevenue => 'Net revenue';

  @override
  String get dashboardKpiProfit => 'Gross profit';

  @override
  String get dashboardKpiOrders => 'Orders';

  @override
  String get dashboardKpiAverageOrder => 'Average order';

  @override
  String get dashboardKpiCustomers => 'Active customers';

  @override
  String get dashboardKpiLowStock => 'Low-stock variants';

  @override
  String dashboardVsPrevious(String value) {
    return '$value vs previous period';
  }

  @override
  String get dashboardNoChange => 'No change vs previous period';

  @override
  String get dashboardRevenueProfit => 'Revenue & profit';

  @override
  String get dashboardRevenueProfitHint =>
      'Daily performance for the selected period';

  @override
  String get dashboardProfit => 'Gross profit';

  @override
  String dashboardMargin(String value) {
    return '$value margin';
  }

  @override
  String dashboardOrdersCount(String value) {
    return '$value orders';
  }

  @override
  String dashboardUnitsCount(String value) {
    return '$value units';
  }

  @override
  String get dashboardPreviousPeriod => 'vs previous period';

  @override
  String get dashboardOperations => 'Operational alerts';

  @override
  String get dashboardOperationsHint =>
      'Items that need attention from the operations team';

  @override
  String get dashboardLowStockAlert => 'Low-stock variants';

  @override
  String get dashboardLowStockAlertHint => 'Below the reorder point';

  @override
  String get dashboardPendingTransfers => 'Pending transfers';

  @override
  String get dashboardPendingTransfersHint => 'Waiting for dispatch or receipt';

  @override
  String get dashboardOpenAudits => 'Open stock audits';

  @override
  String get dashboardOpenAuditsHint => 'Counts that are not closed yet';

  @override
  String get dashboardStockByWarehouse => 'Stock by warehouse';

  @override
  String get dashboardStockHint => 'Quantity and valuation per warehouse';

  @override
  String get dashboardStockTotal => 'Total stock value';

  @override
  String dashboardStockQuantity(String value) {
    return '$value units';
  }

  @override
  String dashboardWarehouses(String value) {
    return '$value warehouses';
  }

  @override
  String get dashboardBranchPerformance => 'Branch performance';

  @override
  String get dashboardBranchHint => 'Revenue, profit and orders per branch';

  @override
  String get dashboardBranchProfit => 'Profit';

  @override
  String get dashboardBranchOrders => 'Orders';

  @override
  String dashboardBranchShare(String value) {
    return '$value of revenue';
  }

  @override
  String get dashboardShare => 'Share';

  @override
  String get dashboardWarehouse => 'Warehouse';

  @override
  String get dashboardNoBranches => 'No branch data for this filter.';

  @override
  String get dashboardVelocity => 'Stock velocity';

  @override
  String get dashboardVelocityHint =>
      'Sold in the last 30 days versus available cover';

  @override
  String get dashboardVariant => 'Variant';

  @override
  String get dashboardSold30d => 'Sold 30d';

  @override
  String get dashboardCurrentQty => 'Available';

  @override
  String get dashboardDaysOfCover => 'Cover';

  @override
  String get dashboardCoverOut => 'Out of stock';

  @override
  String get dashboardCoverLow => 'Reorder now';

  @override
  String get dashboardCoverHealthy => 'Healthy';

  @override
  String dashboardCoverDays(String value) {
    return '$value days';
  }

  @override
  String get dashboardTopProducts => 'Top products';

  @override
  String get dashboardTopProductsHint =>
      'Best sellers by revenue for the selected period';

  @override
  String get dashboardTopProductQty => 'Units';

  @override
  String get dashboardTopProductRevenue => 'Revenue';

  @override
  String get dashboardTopProductShare => 'Share';

  @override
  String get dashboardRfm => 'Customer RFM';

  @override
  String get dashboardRfmHint => 'Recency, frequency and monetary value';

  @override
  String get dashboardRfmCustomers => 'Customers';

  @override
  String get dashboardRfmMonetary => 'Monetary';

  @override
  String get dashboardRfmChampions => 'Champions';

  @override
  String get dashboardRfmLoyal => 'Loyal';

  @override
  String get dashboardRfmPotential => 'Potential loyalists';

  @override
  String get dashboardRfmNew => 'New customers';

  @override
  String get dashboardRfmAtRisk => 'At risk';

  @override
  String get dashboardRfmLost => 'Lost';

  @override
  String get dashboardGeo => 'Orders by governorate';

  @override
  String get dashboardGeoHint => 'Delivery demand across Egypt';

  @override
  String get dashboardGeoTop => 'Top governorate';

  @override
  String get dashboardInquiries => 'Customer inquiries';

  @override
  String get dashboardInquiriesHint =>
      'Latest product questions from the floor';

  @override
  String get dashboardInquiryBought => 'Bought';

  @override
  String get dashboardInquiryPrice => 'Price question';

  @override
  String get dashboardInquiryNoStock => 'Out of stock';

  @override
  String get dashboardInquiryJustAsking => 'Just asking';

  @override
  String dashboardInquiriesCount(String value) {
    return '$value inquiries';
  }

  @override
  String get dashboardTopAsked => 'Most asked products';

  @override
  String get dashboardTopAskedHint => 'Questions and missed sales by product';

  @override
  String get dashboardAsked => 'Asked';

  @override
  String get dashboardNoStockAsked => 'No stock';

  @override
  String get dashboardPriceAsked => 'Price asks';

  @override
  String get dashboardAuditTrail => 'Audit trail';

  @override
  String get dashboardAuditHint => 'Recent changes across inventory and sales';

  @override
  String dashboardAuditBy(String actor) {
    return 'by $actor';
  }

  @override
  String get dashboardAuditTransfer => 'Stock transfer';

  @override
  String get dashboardAuditAdjustment => 'Stock adjustment';

  @override
  String get dashboardAuditPrice => 'Price change';

  @override
  String get dashboardAuditShift => 'Shift closed';

  @override
  String get dashboardAuditWarranty => 'Warranty claim';

  @override
  String get dashboardAuditPurchase => 'Purchase receipt';

  @override
  String dashboardAuditTransferDetail(String qty, String from, String to) {
    return '$qty units from $from to $to';
  }

  @override
  String dashboardAuditAdjustmentDetail(String variant, String diff) {
    return '$variant adjusted by $diff';
  }

  @override
  String dashboardAuditPriceDetail(
    String product,
    String oldPrice,
    String newPrice,
  ) {
    return '$product: $oldPrice to $newPrice';
  }

  @override
  String dashboardAuditShiftDetail(String branch, String variance) {
    return '$branch closed with $variance variance';
  }

  @override
  String dashboardAuditWarrantyDetail(String customer, String product) {
    return '$customer · $product';
  }

  @override
  String dashboardAuditPurchaseDetail(String supplier, String amount) {
    return '$supplier · $amount';
  }

  @override
  String get dashboardTopCustomers => 'Top customers';

  @override
  String get dashboardTopCustomersHint =>
      'Ranked by lifetime spend and loyalty';

  @override
  String get dashboardCustomerSearch => 'Search by name or phone';

  @override
  String get dashboardCustomerProfile => 'Customer 360';

  @override
  String dashboardCustomerSince(String date) {
    return 'Customer since $date';
  }

  @override
  String get dashboardCustomerContact => 'Contact';

  @override
  String get dashboardCustomerAddresses => 'Addresses';

  @override
  String get dashboardCustomerWarranties => 'Warranties & claims';

  @override
  String get dashboardCustomerLoyalty => 'Loyalty';

  @override
  String get dashboardCustomerNotes => 'Notes';

  @override
  String get dashboardCustomerSpend => 'Lifetime spend';

  @override
  String get dashboardCustomerAvgOrder => 'Average order';

  @override
  String get dashboardCustomerPoints => 'Points';

  @override
  String get dashboardCustomerTier => 'Tier';

  @override
  String get dashboardCustomerRfm => 'RFM segment';

  @override
  String get dashboardCustomerPreferred => 'Preferred channel';

  @override
  String get dashboardPreferredBranch => 'Preferred branch';

  @override
  String get dashboardCustomerRecentOrders => 'Recent orders';

  @override
  String get dashboardCustomerNoOrders => 'No orders on record.';

  @override
  String get dashboardCustomerNoClaims => 'No warranty claims on record.';

  @override
  String get dashboardCustomerNoAddresses => 'No saved addresses.';

  @override
  String dashboardWarrantyExpires(String date) {
    return 'Expires $date';
  }

  @override
  String dashboardWarrantyPurchased(String date) {
    return 'Purchased $date';
  }

  @override
  String get dashboardWarrantyExpiry => 'Expires';

  @override
  String get dashboardClaimOpen => 'Open';

  @override
  String get dashboardClaimInspection => 'Inspection';

  @override
  String get dashboardClaimResolved => 'Resolved';

  @override
  String get dashboardTierBronze => 'Bronze';

  @override
  String get dashboardTierSilver => 'Silver';

  @override
  String get dashboardTierGold => 'Gold';

  @override
  String get dashboardTierPlatinum => 'Platinum';

  @override
  String dashboardOrderCount(String value) {
    return '$value orders';
  }

  @override
  String get dashboardCustomerNote1 =>
      'Prefers medical mattresses in 160×200 and confirms visits on WhatsApp.';

  @override
  String get dashboardCustomerNote2 =>
      'Corporate account: ordered 12 mattresses for a Tanta hotel and needs a tax invoice.';

  @override
  String get dashboardCustomerNote3 =>
      'Complained about a late delivery before; confirm the slot one day ahead.';

  @override
  String get dashboardCustomerNote4 =>
      'Interested in instalments and asked to be called when a new batch arrives.';

  @override
  String get dashboardRecentOrdersHint => 'Latest sales across every branch';

  @override
  String get dashboardOrderDate => 'Date';

  @override
  String get dashboardOrderChannel => 'Channel';

  @override
  String get dashboardQuickActionsHint =>
      'Shortcuts for the counter and back office';

  @override
  String get dashboardStockTransfer => 'Stock transfer';

  @override
  String get dashboardNewPurchase => 'Purchase order';

  @override
  String get dashboardChannelShowroom => 'Showroom';

  @override
  String get dashboardChannelPhone => 'Phone';

  @override
  String get dashboardChannelWhatsapp => 'WhatsApp';

  @override
  String get statusPaid => 'Paid';

  @override
  String get warehouseTanta => 'Tanta main warehouse';

  @override
  String get warehouseCairo => 'Cairo warehouse';

  @override
  String get warehouseAlex => 'Alexandria warehouse';

  @override
  String get warehouseMansoura => 'Mansoura warehouse';

  @override
  String get govGharbia => 'Gharbia';

  @override
  String get govCairo => 'Cairo';

  @override
  String get govAlexandria => 'Alexandria';

  @override
  String get govDakahlia => 'Dakahlia';

  @override
  String get govMenoufia => 'Menoufia';

  @override
  String get govQalyubia => 'Qalyubia';

  @override
  String get govSharqia => 'Sharqia';

  @override
  String get govBeheira => 'Beheira';

  @override
  String get categoryMattress => 'Mattresses';

  @override
  String get categoryPillow => 'Pillows';

  @override
  String get categoryBase => 'Bed bases';

  @override
  String get categoryAccessory => 'Accessories';

  @override
  String get supplierDeltaFoam => 'Delta Foam';

  @override
  String get supplierSleepTech => 'Sleep Tech';

  @override
  String get product1 => 'Orthopedic mattress 160×200';

  @override
  String get product2 => 'Memory foam mattress 180×200';

  @override
  String get product3 => 'Spring mattress 150×195';

  @override
  String get product4 => 'Kids mattress 120×190';

  @override
  String get product5 => 'Latex pillow 50×70';

  @override
  String get product6 => 'Memory pillow';

  @override
  String get product7 => 'Wooden bed base 160×200';

  @override
  String get product8 => 'Upholstered bed base 180×200';

  @override
  String get product9 => 'Waterproof mattress protector';

  @override
  String get product10 => 'Cotton bed sheet set';

  @override
  String get product11 => 'Custom oval mattress';

  @override
  String get product12 => 'Hotel mattress 200×200';

  @override
  String get customer1 => 'Mona Abdelrahman';

  @override
  String get customer2 => 'Youssef Kamal';

  @override
  String get customer3 => 'Salma Fathy';

  @override
  String get customer4 => 'Karim Nabil';

  @override
  String get customer5 => 'Hana Tarek';

  @override
  String get customer6 => 'Omar Sherif';

  @override
  String get customer7 => 'Nour Adel';

  @override
  String get customer8 => 'Ahmed Fathy';

  @override
  String get customer9 => 'Mariam Hossam';

  @override
  String get customer10 => 'Tamer Said';

  @override
  String dashboardWeek(String value) {
    return 'Week $value';
  }

  @override
  String get dashboardInquiryNote1 =>
      'Is the orthopedic mattress available in 160×200?';

  @override
  String get dashboardInquiryNote2 =>
      'What is the difference between memory foam and spring?';

  @override
  String get dashboardInquiryNote3 =>
      'I need the price of the upholstered bed base.';

  @override
  String get dashboardInquiryNote4 => 'Do you offer interest-free instalments?';

  @override
  String get dashboardInquiryNote5 =>
      'How many days does a custom oval mattress take?';

  @override
  String get dashboardInquiryNote6 =>
      'I need hotel mattresses 200×200 in bulk.';

  @override
  String get dashboardClaimIssue1 => 'Sagging on the left side';

  @override
  String get dashboardClaimIssue2 => 'Broken zip on the cover';

  @override
  String get dashboardClaimIssue3 => 'Wrong size delivered';

  @override
  String get dashboardClaimIssue4 => 'Noise from the spring unit';

  @override
  String get addressHome => 'Home';

  @override
  String get addressWork => 'Work';

  @override
  String get addressFamily => 'Family home';

  @override
  String get addressLine1 => '12 El Geish Street, Tanta';

  @override
  String get addressLine2 => 'Nasr City, Cairo';

  @override
  String get addressLine3 => 'Smouha, Alexandria';

  @override
  String get addressLine4 => 'El Mashaya, Mansoura';

  @override
  String get dashboardProduct => 'Product';

  @override
  String get dashboardGovernorate => 'Governorate';

  @override
  String get dashboardItems => 'Items';

  @override
  String get dashboardUnits => 'Units';

  @override
  String get dashboardIssue => 'Issue';

  @override
  String get dashboardEmpty => 'No records match this filter.';

  @override
  String get dashboardAction => 'Action';

  @override
  String get dashboardOutcome => 'Outcome';

  @override
  String get dashboardDetails => 'Details';

  @override
  String get dashboardTime => 'Time';

  @override
  String get identityFeature4 => 'Roles and the permissions matrix';

  @override
  String get availabilityLive => 'Live data';

  @override
  String get availabilityPlanned => 'Planned';

  @override
  String get availabilityLocal => 'Local';

  @override
  String get permissionsTitle => 'Permissions matrix';

  @override
  String get permissionsHint =>
      'Pick a role, then grant each module its capabilities. Changes are saved on this device only.';

  @override
  String get permissionsReset => 'Restore defaults';

  @override
  String get permissionsModuleColumn => 'Module';

  @override
  String get permissionsActionView => 'View';

  @override
  String get permissionsActionCreate => 'Create';

  @override
  String get permissionsActionEdit => 'Edit';

  @override
  String get permissionsActionDelete => 'Delete';

  @override
  String get permissionsRoleAdmin => 'Administrator';

  @override
  String get permissionsRoleManager => 'Manager';

  @override
  String get permissionsRoleCashier => 'Cashier';

  @override
  String get permissionsRoleWarehouse => 'Warehouse';

  @override
  String get plannedNoticeTitle => 'Planned screen';

  @override
  String get plannedNoticeBody =>
      'This screen is designed and ready, but its backend endpoint is not available yet. The values below are sample data and saving is disabled.';

  @override
  String get adminSampleActionMessage => 'Sample action: no data was saved.';

  @override
  String get catalogTabProducts => 'Products';

  @override
  String get catalogTabCategories => 'Categories';

  @override
  String get catalogTabAttributes => 'Attributes';

  @override
  String get catalogTabPrices => 'Price sheets';

  @override
  String get catalogTabMeter => 'Meter pricing';

  @override
  String get catalogSearchProducts => 'Search products or SKU';

  @override
  String get catalogSearchAttributes => 'Search attributes';

  @override
  String get catalogSearchPrices => 'Search price entries';

  @override
  String get catalogMetricProducts => 'Products';

  @override
  String get catalogMetricLowStock => 'Low stock';

  @override
  String get catalogMetricAveragePrice => 'Average price';

  @override
  String get catalogMetricStockValue => 'Stock value';

  @override
  String get catalogMetricCategories => 'Categories';

  @override
  String get catalogMetricCategoryProducts => 'Categorized products';

  @override
  String get catalogMetricTopCategory => 'Largest category';

  @override
  String get catalogMetricAttributes => 'Attributes';

  @override
  String get catalogMetricValues => 'Values';

  @override
  String get catalogMetricRequired => 'Required';

  @override
  String get catalogMetricPriceLists => 'Price lists';

  @override
  String get catalogMetricChannels => 'Channels';

  @override
  String get catalogMetricAverageMargin => 'Average margin';

  @override
  String get catalogMetricEntries => 'Price entries';

  @override
  String get catalogColProduct => 'Product';

  @override
  String get catalogColSku => 'SKU';

  @override
  String get catalogColCategory => 'Category';

  @override
  String get catalogColPrice => 'Price';

  @override
  String get catalogColStock => 'Stock';

  @override
  String get catalogColValues => 'Values';

  @override
  String get catalogColUsage => 'Products';

  @override
  String get catalogColRequirement => 'Requirement';

  @override
  String get catalogColPriceList => 'Price list';

  @override
  String get catalogColChannel => 'Channel';

  @override
  String get catalogColMargin => 'Margin';

  @override
  String get catalogStockIn => 'In stock';

  @override
  String get catalogStockLow => 'Low stock';

  @override
  String get catalogStockOut => 'Out of stock';

  @override
  String get catalogCategoryShareLabel => 'Share of catalog';

  @override
  String catalogCategoryProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
      zero: 'No products',
    );
    return '$_temp0';
  }

  @override
  String get catalogAttributeSize => 'Size';

  @override
  String get catalogAttributeColor => 'Color';

  @override
  String get catalogAttributeMaterial => 'Material';

  @override
  String get catalogAttributeFirmness => 'Firmness';

  @override
  String get catalogAttributeWarranty => 'Warranty';

  @override
  String get catalogValueSize1 => '160 × 200';

  @override
  String get catalogValueSize2 => '180 × 200';

  @override
  String get catalogValueSize3 => '150 × 195';

  @override
  String get catalogValueColor1 => 'White';

  @override
  String get catalogValueColor2 => 'Beige';

  @override
  String get catalogValueColor3 => 'Grey';

  @override
  String get catalogValueMaterial1 => 'Cotton';

  @override
  String get catalogValueMaterial2 => 'Foam';

  @override
  String get catalogValueMaterial3 => 'Latex';

  @override
  String get catalogValueFirmness1 => 'Soft';

  @override
  String get catalogValueFirmness2 => 'Medium';

  @override
  String get catalogValueFirmness3 => 'Firm';

  @override
  String get catalogValueWarranty1 => '1 year';

  @override
  String get catalogValueWarranty2 => '5 years';

  @override
  String get catalogRequired => 'Required';

  @override
  String get catalogOptional => 'Optional';

  @override
  String get catalogPriceListRetail => 'Retail';

  @override
  String get catalogPriceListWholesale => 'Wholesale';

  @override
  String get catalogPriceListOnline => 'Online';

  @override
  String get catalogChannelShowroom => 'Showroom';

  @override
  String get catalogChannelWeb => 'Web store';

  @override
  String get catalogChannelWholesale => 'Wholesale';

  @override
  String get catalogMeterDimensions => 'Dimensions and shape';

  @override
  String get catalogMeterPricing => 'Pricing inputs';

  @override
  String get catalogMeterSummary => 'Live estimate';

  @override
  String get catalogMeterWidth => 'Width (cm)';

  @override
  String get catalogMeterHeight => 'Height (cm)';

  @override
  String get catalogMeterRate => 'Price per m²';

  @override
  String get catalogMeterWaste => 'Waste (%)';

  @override
  String get catalogMeterShape => 'Shape';

  @override
  String get catalogShapeRectangle => 'Rectangle';

  @override
  String get catalogShapeRound => 'Round';

  @override
  String get catalogShapeLShape => 'L-shape';

  @override
  String get catalogMeterArea => 'Area';

  @override
  String get catalogMeterBasePrice => 'Base price';

  @override
  String get catalogMeterWasteCost => 'Waste cost';

  @override
  String get catalogMeterTotal => 'Estimated price';

  @override
  String get catalogMeterHint => 'Updates as you type';

  @override
  String get catalogMeterInvalid =>
      'Enter width, height and price to see the estimate.';

  @override
  String get catalogMeterUnit => 'm²';

  @override
  String get adminFilterAll => 'All';

  @override
  String get inventoryTabWarehouses => 'Warehouses';

  @override
  String get inventoryTabStocks => 'Stock balances';

  @override
  String get inventoryTabTransfers => 'Transfers';

  @override
  String get inventoryTabAudits => 'Stock audits';

  @override
  String get inventoryTabBatches => 'Batches & expiry';

  @override
  String get inventorySearchWarehouses => 'Search warehouses or managers';

  @override
  String get inventorySearchStocks => 'Search products, SKU or warehouse';

  @override
  String get inventorySearchTransfers => 'Search transfers';

  @override
  String get inventorySearchAudits => 'Search audits or counters';

  @override
  String get inventorySearchBatches => 'Search batches or products';

  @override
  String get inventoryMetricWarehouses => 'Warehouses';

  @override
  String get inventoryMetricProducts => 'Products';

  @override
  String get inventoryMetricUnitsOnHand => 'Units on hand';

  @override
  String get inventoryMetricCapacityUsed => 'Capacity used';

  @override
  String get inventoryMetricStockValue => 'Stock value';

  @override
  String get inventoryMetricSkus => 'SKUs';

  @override
  String get inventoryMetricLowStock => 'Low stock';

  @override
  String get inventoryMetricOutOfStock => 'Out of stock';

  @override
  String get inventoryMetricReorderValue => 'Reorder value';

  @override
  String get inventoryMetricPendingTransfers => 'Pending transfers';

  @override
  String get inventoryMetricUnitsInTransit => 'Units in transit';

  @override
  String get inventoryMetricReceivedTransfers => 'Received transfers';

  @override
  String get inventoryMetricLastTransfer => 'Last transfer';

  @override
  String get inventoryMetricOpenAudits => 'Open audits';

  @override
  String get inventoryMetricVarianceUnits => 'Net variance';

  @override
  String get inventoryMetricClosedAudits => 'Closed audits';

  @override
  String get inventoryMetricNextAudit => 'Next audit';

  @override
  String get inventoryMetricActiveBatches => 'Active batches';

  @override
  String get inventoryMetricExpiringSoon => 'Expiring soon';

  @override
  String get inventoryMetricExpiredBatches => 'Expired batches';

  @override
  String get inventoryMetricBatchValue => 'Batch value';

  @override
  String get inventoryColWarehouse => 'Warehouse';

  @override
  String get inventoryColManager => 'Manager';

  @override
  String get inventoryColCapacity => 'Capacity';

  @override
  String get inventoryColUtilization => 'Utilization';

  @override
  String get inventoryColProducts => 'Products';

  @override
  String get inventoryColProduct => 'Product';

  @override
  String get inventoryColSku => 'SKU';

  @override
  String get inventoryColOnHand => 'On hand';

  @override
  String get inventoryColReorder => 'Reorder at';

  @override
  String get inventoryColValue => 'Value';

  @override
  String get inventoryColState => 'State';

  @override
  String get inventoryColTransfer => 'Transfer';

  @override
  String get inventoryColRoute => 'Route';

  @override
  String get inventoryColUnits => 'Units';

  @override
  String get inventoryColDate => 'Date';

  @override
  String get inventoryColAudit => 'Audit';

  @override
  String get inventoryColCounter => 'Counter';

  @override
  String get inventoryColVariance => 'Variance';

  @override
  String get inventoryColBatch => 'Batch';

  @override
  String get inventoryColExpiry => 'Expiry';

  @override
  String get inventoryColQuantity => 'Quantity';

  @override
  String get inventoryColDaysLeft => 'Days left';

  @override
  String get inventoryStateHealthy => 'Healthy';

  @override
  String get inventoryStateLow => 'Low';

  @override
  String get inventoryStateOut => 'Out';

  @override
  String get inventoryTransferDraft => 'Draft';

  @override
  String get inventoryTransferTransit => 'In transit';

  @override
  String get inventoryTransferReceived => 'Received';

  @override
  String get inventoryAuditScheduled => 'Scheduled';

  @override
  String get inventoryAuditCounting => 'Counting';

  @override
  String get inventoryAuditClosed => 'Closed';

  @override
  String get inventoryBatchValid => 'Valid';

  @override
  String get inventoryBatchExpiring => 'Expiring';

  @override
  String get inventoryBatchExpired => 'Expired';

  @override
  String inventoryCapacityRatio(String used, String capacity) {
    return '$used / $capacity';
  }

  @override
  String inventoryCapacityUsed(int percent) {
    return '$percent% used';
  }

  @override
  String inventoryUnits(int count) {
    return '$count units';
  }

  @override
  String inventoryDaysLeft(int days) {
    return '$days days';
  }

  @override
  String inventoryDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String inventoryLowStockItems(int count) {
    return '$count low-stock items';
  }

  @override
  String inventoryProductsCount(int count) {
    return '$count products';
  }

  @override
  String get inventoryPlannedTransfersBody =>
      'Transfer drafts will be saved to the backend once the transfers endpoint ships. Until then the drafts below are sample data and no movement is recorded.';

  @override
  String get inventoryPlannedAuditsBody =>
      'Audit sessions are read-only for now: the counting workflow needs the audit endpoint. The sessions below are sample data.';

  @override
  String get salesTabPos => 'Point of sale';

  @override
  String get salesTabPayments => 'Payments';

  @override
  String get salesTabShifts => 'Shifts';

  @override
  String get salesTabOrders => 'Orders';

  @override
  String get salesTabCustomOrders => 'Custom orders';

  @override
  String get salesTabPromotions => 'Promotions';

  @override
  String get salesSearchPos => 'Search products or SKU';

  @override
  String get salesSearchPayments => 'Search payments, orders or customers';

  @override
  String get salesSearchShifts => 'Search shifts or cashiers';

  @override
  String get salesSearchOrders => 'Search orders or customers';

  @override
  String get salesSearchCustomOrders => 'Search custom orders or customers';

  @override
  String get salesSearchPromotions => 'Search promotions or codes';

  @override
  String get salesColPayment => 'Payment';

  @override
  String get salesColOrder => 'Order';

  @override
  String get salesColCustomer => 'Customer';

  @override
  String get salesColMethod => 'Method';

  @override
  String get salesColAmount => 'Amount';

  @override
  String get salesColStatus => 'Status';

  @override
  String get salesColDate => 'Date';

  @override
  String get salesColShift => 'Shift';

  @override
  String get salesColCashier => 'Cashier';

  @override
  String get salesColOpened => 'Opened';

  @override
  String get salesColClosed => 'Closed';

  @override
  String get salesColSales => 'Sales';

  @override
  String get salesColVariance => 'Variance';

  @override
  String get salesColItems => 'Items';

  @override
  String get salesColTotal => 'Total';

  @override
  String get salesColCustomOrder => 'Custom order';

  @override
  String get salesColDimensions => 'Dimensions';

  @override
  String get salesColDeposit => 'Deposit';

  @override
  String get salesColDue => 'Due';

  @override
  String get salesColPromotion => 'Promotion';

  @override
  String get salesColCode => 'Code';

  @override
  String get salesColUses => 'Uses';

  @override
  String get salesColWindow => 'Window';

  @override
  String get salesPayCash => 'Cash';

  @override
  String get salesPayCard => 'Card';

  @override
  String get salesPayCredit => 'Credit';

  @override
  String get salesPayWallet => 'Wallet';

  @override
  String get salesPayPaid => 'Paid';

  @override
  String get salesPayPending => 'Pending';

  @override
  String get salesPayRefunded => 'Refunded';

  @override
  String get salesPosCart => 'Current sale';

  @override
  String get salesPosEmptyCart =>
      'The cart is empty. Add a product to start a sale.';

  @override
  String get salesPosWalkIn => 'Walk-in customer';

  @override
  String get salesPosQty => 'Qty';

  @override
  String get salesPosAdd => 'Add to cart';

  @override
  String get salesPosRemove => 'Remove';

  @override
  String get salesPosClear => 'Clear cart';

  @override
  String get salesPosSubtotal => 'Subtotal';

  @override
  String get salesPosVat => 'VAT (14%)';

  @override
  String get salesPosTotal => 'Total';

  @override
  String salesPosCharge(String amount) {
    return 'Charge $amount';
  }

  @override
  String get salesPosChargeMessage => 'Sample sale: no payment was processed.';

  @override
  String get salesMetricCartItems => 'Cart items';

  @override
  String get salesMetricCartSubtotal => 'Cart subtotal';

  @override
  String get salesMetricCartVat => 'VAT';

  @override
  String get salesMetricCartTotal => 'Total due';

  @override
  String get salesMetricCollected => 'Collected';

  @override
  String get salesMetricCardShare => 'Card share';

  @override
  String get salesMetricPendingCredit => 'Pending credit';

  @override
  String get salesMetricRefunds => 'Refunds';

  @override
  String get salesShiftOpen => 'Open';

  @override
  String get salesShiftClosed => 'Closed';

  @override
  String get salesMetricOpenShifts => 'Open shifts';

  @override
  String get salesMetricShiftSales => 'Shift sales';

  @override
  String get salesMetricCashDrawer => 'Cash in drawer';

  @override
  String get salesMetricCashVariance => 'Cash variance';

  @override
  String get salesOrderNew => 'New';

  @override
  String get salesOrderProcessing => 'Processing';

  @override
  String get salesOrderDelivered => 'Delivered';

  @override
  String get salesOrderCancelled => 'Cancelled';

  @override
  String get salesMetricOpenOrders => 'Open orders';

  @override
  String get salesMetricOrderValue => 'Order value';

  @override
  String get salesMetricDeliveredOrders => 'Delivered';

  @override
  String get salesMetricCancelledOrders => 'Cancelled';

  @override
  String get salesPlannedOrdersBody =>
      'Order listing needs the sales order endpoint. The rows below are sample data and the create action stays disabled until the API ships.';

  @override
  String get salesCustomDeposit => 'Deposit paid';

  @override
  String get salesCustomProduction => 'In production';

  @override
  String get salesCustomReady => 'Ready';

  @override
  String get salesMetricOpenCustomOrders => 'Open custom orders';

  @override
  String get salesMetricCustomDeposits => 'Deposits held';

  @override
  String get salesMetricCustomReady => 'Ready for pickup';

  @override
  String get salesMetricCustomOverdue => 'Overdue';

  @override
  String get salesPlannedCustomOrdersBody =>
      'The custom order board needs the custom order endpoint. The cards below are sample data and the create action stays disabled until the API ships.';

  @override
  String get salesPromoActive => 'Active';

  @override
  String get salesPromoScheduled => 'Scheduled';

  @override
  String get salesPromoExpired => 'Expired';

  @override
  String get salesMetricActivePromotions => 'Active promotions';

  @override
  String get salesMetricPromoRedemptions => 'Redemptions';

  @override
  String get salesMetricPromoDiscount => 'Discount given';

  @override
  String get salesMetricPromoExpiring => 'Expiring soon';

  @override
  String get salesPlannedPromotionsBody =>
      'Promotion listing needs the promotions endpoint. The cards below are sample data and the create action stays disabled until the API ships.';

  @override
  String salesPromoOff(int percent) {
    return '$percent% off';
  }

  @override
  String get salesPromoWinter => 'Winter mattress sale';

  @override
  String get salesPromoPillowBundle => 'Pillow bundle';

  @override
  String get salesPromoBaseClearance => 'Base clearance';

  @override
  String get salesPromoVip => 'VIP loyalty';

  @override
  String get salesPromoNewHome => 'New home bundle';

  @override
  String get salesPromoHotel => 'Hotel contract';

  @override
  String get salesPromoClearance => 'Warehouse clearance';

  @override
  String get salesPromoRamadan => 'Ramadan offer';

  @override
  String get navOperations => 'Operations';

  @override
  String get operationsTitle => 'Operations & branches';

  @override
  String get operationsDescription =>
      'Internal tasks, branch load and customer holds';

  @override
  String get operationsFeature1 =>
      'Tasks for a person, a group or branch teams';

  @override
  String get operationsFeature2 =>
      'Branch workload, overdue work and completion';

  @override
  String get operationsFeature3 => 'Customer holds for goods and custom sizes';

  @override
  String get opsTabTasks => 'Tasks';

  @override
  String get opsTabBranches => 'Branch load';

  @override
  String get opsTabHolds => 'Customer holds';

  @override
  String get opsSearchTasks => 'Search tasks, people or branches';

  @override
  String get opsSearchBranches => 'Search branches or managers';

  @override
  String get opsSearchHolds => 'Search holds, customers or items';

  @override
  String get opsColTask => 'Task';

  @override
  String get opsColAssignee => 'Assignee';

  @override
  String get opsColBranch => 'Branch';

  @override
  String get opsColPriority => 'Priority';

  @override
  String get opsColDue => 'Due';

  @override
  String get opsColStatus => 'Status';

  @override
  String get opsColChecklist => 'Checklist';

  @override
  String get opsColCustomer => 'Customer';

  @override
  String get opsColItem => 'Item';

  @override
  String get opsColDeposit => 'Deposit';

  @override
  String get opsColExpected => 'Expected';

  @override
  String get opsStatusOpen => 'Open';

  @override
  String get opsStatusInProgress => 'In progress';

  @override
  String get opsStatusBlocked => 'Blocked';

  @override
  String get opsStatusDone => 'Done';

  @override
  String get opsHoldWaiting => 'Waiting';

  @override
  String get opsHoldArrived => 'Arrived';

  @override
  String get opsHoldReady => 'Ready';

  @override
  String get opsHoldCancelled => 'Cancelled';

  @override
  String get opsPriorityLow => 'Low';

  @override
  String get opsPriorityNormal => 'Normal';

  @override
  String get opsPriorityHigh => 'High';

  @override
  String get opsPriorityUrgent => 'Urgent';

  @override
  String get opsAssigneePerson => 'Person';

  @override
  String get opsAssigneeGroup => 'Group';

  @override
  String get opsAssigneeBranch => 'Branch';

  @override
  String get opsTaskDetail => 'Task details';

  @override
  String get opsTaskConditions => 'Context and conditions';

  @override
  String get opsTaskChecklist => 'To-do list';

  @override
  String get opsTaskChecklistEmpty => 'No checklist items for this task.';

  @override
  String opsTaskChecklistProgress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get opsAssignedTo => 'Assigned to';

  @override
  String get opsBranchesLabel => 'Branches';

  @override
  String get opsDueToday => 'Due today';

  @override
  String get opsDueTomorrow => 'Due tomorrow';

  @override
  String opsDaysOverdue(int days) {
    return '$days days overdue';
  }

  @override
  String opsDaysLeft(int days) {
    return '$days days left';
  }

  @override
  String get opsExpectedToday => 'Expected today';

  @override
  String get opsMetricOpenTasks => 'Open tasks';

  @override
  String get opsMetricDueToday => 'Due today';

  @override
  String get opsMetricOverdue => 'Overdue';

  @override
  String get opsMetricBlocked => 'Blocked';

  @override
  String get opsMetricBranches => 'Branches';

  @override
  String get opsMetricBranchOpen => 'Open tasks';

  @override
  String get opsMetricBranchOverdue => 'Overdue tasks';

  @override
  String get opsMetricBranchHolds => 'Waiting holds';

  @override
  String get opsMetricWaiting => 'Waiting holds';

  @override
  String get opsMetricArriving => 'Arriving this week';

  @override
  String get opsMetricDeposits => 'Deposits held';

  @override
  String get opsMetricReady => 'Ready for pickup';

  @override
  String get opsNewTask => 'New task';

  @override
  String get opsCreateTask => 'Create task';

  @override
  String get opsClose => 'Close';

  @override
  String get opsTaskTitle => 'Task title';

  @override
  String get opsTaskTitleHint => 'What needs to happen?';

  @override
  String get opsTaskContext => 'Context and conditions';

  @override
  String get opsTaskContextHint =>
      'Add the details and constraints the assignee needs';

  @override
  String get opsAssignTo => 'Assign to';

  @override
  String get opsChooseAssignee => 'Choose who owns the task';

  @override
  String get opsChooseBranch => 'Branch';

  @override
  String get opsChecklistHint => 'One step per line';

  @override
  String get opsDueDate => 'Due date';

  @override
  String get opsNoAssignees => 'Pick at least one assignee.';

  @override
  String get opsNoBranches => 'Pick at least one branch.';

  @override
  String get opsTaskCreated => 'Task created.';

  @override
  String get opsTitleRequired => 'Add a title for the task.';

  @override
  String get opsBranchManager => 'Manager';

  @override
  String opsBranchOpenTasks(int count) {
    return '$count open';
  }

  @override
  String opsBranchOverdueTasks(int count) {
    return '$count overdue';
  }

  @override
  String opsBranchHolds(int count) {
    return '$count holds';
  }

  @override
  String opsBranchTeam(int count) {
    return '$count people';
  }

  @override
  String get opsBranchOnTrack => 'On track';

  @override
  String get opsBranchBusy => 'Busy';

  @override
  String get opsBranchOverloaded => 'Overloaded';

  @override
  String get opsBranchCompletion => 'Completion';

  @override
  String get opsHoldStockItem => 'Stock item';

  @override
  String get opsHoldCustomSize => 'Custom size';

  @override
  String opsSizeCustom(int width, int length) {
    return '$width × $length cm';
  }

  @override
  String get opsPlannedHoldsTitle => 'Holds awaiting the backend';

  @override
  String get opsPlannedHoldsBody =>
      'Reserving goods and custom sizes already works in the UI. Saving a hold will be enabled when the inventory endpoint exposes reservations.';

  @override
  String get opsPerson1 => 'Hala Mostafa';

  @override
  String get opsPerson2 => 'Rami Fouad';

  @override
  String get opsPerson3 => 'Dina Samir';

  @override
  String get opsPerson4 => 'Mostafa Adel';

  @override
  String get opsPerson5 => 'Nada Sherif';

  @override
  String get opsPerson6 => 'Sherif Kamel';

  @override
  String get opsGroup1 => 'Sales team';

  @override
  String get opsGroup2 => 'Warehouse team';

  @override
  String get opsGroup3 => 'Tailoring team';

  @override
  String get opsGroup4 => 'Support team';

  @override
  String get opsTask1Title => 'Reset the Tanta showroom for the new collection';

  @override
  String get opsTask1Context =>
      'Move the old display stock to the back room, steam the fabric panels and photograph the result before the collection lands on Thursday.';

  @override
  String get opsTask2Title => 'Confirm the Cairo weekend delivery slots';

  @override
  String get opsTask2Context =>
      'Call every order scheduled for Friday and Saturday, confirm the address and note any gate or elevator restrictions before the courier sheet is printed.';

  @override
  String get opsTask3Title => 'Finish the Alexandria custom size price sheet';

  @override
  String get opsTask3Context =>
      'Add the 2026 foam and cover costs, round each size to the nearest 50 EGP and send the sheet to the branch manager for approval.';

  @override
  String get opsTask4Title => 'Count the Mansoura mattress covers';

  @override
  String get opsTask4Context =>
      'The count is two weeks late. Count every size, log variances against the stock sheet and flag any cover that is still in a customer hold.';

  @override
  String get opsTask5Title => 'Receive the foam shipment at Tanta';

  @override
  String get opsTask5Context =>
      'Check the delivery note against the purchase order, inspect the rolls for tears and hand the signed note to accounting.';

  @override
  String get opsTask6Title => 'Resolve the Cairo hold for the 180×200 size';

  @override
  String get opsTask6Context =>
      'The customer paid a deposit three weeks ago. Confirm the supplier date, offer a loan unit and update the customer before the end of the day.';

  @override
  String get opsTask7Title => 'Follow up on the Alexandria delivery complaints';

  @override
  String get opsTask7Context =>
      'Three customers reported late arrivals last week. Call each one, log the reason and agree a goodwill gesture with support.';

  @override
  String get opsTask8Title => 'Price the Mansoura spring promotion';

  @override
  String get opsTask8Context =>
      'Build a bundle for two pillows and a protector, compare it with the Cairo promotion and keep the margin above 25 percent.';

  @override
  String get opsTask9Title => 'Agree the Tanta cash handover checklist';

  @override
  String get opsTask9Context =>
      'Meet the cashiers, close the gaps in the evening handover and update the branch board before the next shift.';

  @override
  String get opsTask10Title => 'Finish the Cairo custom order C-2214';

  @override
  String get opsTask10Context =>
      'The cover is cut. Check the stitching, wrap the mattress, call the customer and book the delivery slot.';

  @override
  String get opsStep1 => 'Review the handover sheet';

  @override
  String get opsStep2 => 'Check stock on hand';

  @override
  String get opsStep3 => 'Call the customer';

  @override
  String get opsStep4 => 'Confirm delivery slots';

  @override
  String get opsStep5 => 'Update the price sheet';

  @override
  String get opsStep6 => 'Count the units';

  @override
  String get opsStep7 => 'Log any variance';

  @override
  String get opsStep8 => 'Receive the shipment';

  @override
  String get opsStep9 => 'Inspect the foam rolls';

  @override
  String get opsStep10 => 'Notify the sales team';

  @override
  String get opsStep11 => 'Prepare the fabric samples';

  @override
  String get opsStep12 => 'Photograph the result';

  @override
  String get opsStep13 => 'Book the courier';

  @override
  String get opsStep14 => 'Print the size labels';

  @override
  String get opsStep15 => 'Verify the deposit';

  @override
  String get opsStep16 => 'Clear the counter area';

  @override
  String get opsStep17 => 'Update the branch board';

  @override
  String get opsStep18 => 'Confirm with the branch manager';
}
