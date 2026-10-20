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
}
