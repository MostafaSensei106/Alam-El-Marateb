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
}
