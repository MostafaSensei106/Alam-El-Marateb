// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get home => 'الرئيسية';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get welcome => 'مرحبًا';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgetPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get alm_el_marateb => 'عالم المراتب';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get phone => 'الهاتف';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get enterYourCredentialsToAccessYourAccount =>
      'أدخل بياناتك للوصول إلى حسابك.';

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get pleaseWait => 'يرجى الانتظار...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get info => 'معلومات';

  @override
  String get warning => 'تحذير';

  @override
  String get downloadFile => 'تنزيل الملف';

  @override
  String get fileAlreadySaved => 'الملف محفوظ بالفعل.';

  @override
  String fileSavedToDcim(String fileName) {
    return 'تم حفظ الملف في المعرض باسم $fileName.';
  }

  @override
  String fileSavedToDocuments(String fileName) {
    return 'تم حفظ الملف في المستندات باسم $fileName.';
  }

  @override
  String fileOpenedInBrowser(String fileName) {
    return 'تم فتح الملف في تبويب جديد بالمتصفح: $fileName.';
  }

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get internetConnectionRestored => 'تم استعادة الاتصال بالإنترنت';

  @override
  String get sessionExpired => 'انتهت الجلسة';

  @override
  String get sessionExpiredDescription =>
      'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get paid => 'مدفوع';

  @override
  String get unpaid => 'غير مدفوع';

  @override
  String get partial => 'مدفوع جزئيًا';

  @override
  String get httpNoInternet => 'لا يوجد اتصال بالإنترنت. يرجى التحقق من شبكتك.';

  @override
  String get httpRequestCancelled => 'تم إلغاء الطلب.';

  @override
  String get httpBadCertificate => 'تعذر التحقق من شهادة الخادم.';

  @override
  String get httpGatewayTimeout => 'استغرق الخادم وقتًا طويلاً للاستجابة.';

  @override
  String get httpInternalServerError => 'حدث خطأ داخلي في الخادم.';

  @override
  String get httpUnknownError => 'حدث خطأ غير معروف.';

  @override
  String get error_name_cant_be_empty => 'لا يمكن أن يكون الاسم فارغًا';

  @override
  String get error_name_invalid => 'الاسم غير صالح';

  @override
  String get error_name_too_short_at_least_3_characters =>
      'يجب أن يتكون الاسم من 3 أحرف على الأقل';

  @override
  String get error_name_too_long_maximum_20_characters =>
      'يجب ألا يتجاوز الاسم 20 حرفًا';

  @override
  String get error_name_invalid_special_characters =>
      'يحتوي الاسم على أحرف خاصة غير صالحة';

  @override
  String get error_name_emoji_not_allowed =>
      'لا يُسمح بالرموز التعبيرية في الاسم';

  @override
  String get error_email_cant_be_empty =>
      'لا يمكن أن يكون البريد الإلكتروني فارغًا';

  @override
  String get error_email_not_invalid_format =>
      'صيغة البريد الإلكتروني غير صالحة';

  @override
  String get error_email_contains_invalid_characters =>
      'يحتوي البريد الإلكتروني على أحرف غير صالحة';

  @override
  String get error_email_must_contain_at_symbol =>
      'يجب أن يحتوي البريد الإلكتروني على الرمز @';

  @override
  String get error_email_must_be_in_lowercase =>
      'يجب كتابة البريد الإلكتروني بأحرف صغيرة';

  @override
  String get error_email_emoji_not_allowed =>
      'لا يُسمح بالرموز التعبيرية في البريد الإلكتروني';

  @override
  String get error_arabic_not_allowed => 'لا يُسمح بالأحرف العربية';

  @override
  String get error_password_cant_be_empty =>
      'لا يمكن أن تكون كلمة المرور فارغة';

  @override
  String get error_password_must_be_at_least_8_characters_long =>
      'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String
  get error_password_must_contain_uppercase_lowercase_number_and_special_character =>
      'يجب أن تحتوي كلمة المرور على أحرف كبيرة وصغيرة ورقم ورمز خاص';

  @override
  String get error_phone_number_cant_be_empty =>
      'لا يمكن أن يكون رقم الهاتف فارغًا';

  @override
  String get error_phone_number_invalid => 'رقم الهاتف غير صالح';

  @override
  String get error_phone_number_min_length => 'رقم الهاتف قصير جدًا';

  @override
  String get error_address_line_cant_be_empty =>
      'لا يمكن أن يكون سطر العنوان فارغًا';

  @override
  String get error_address_line_too_long => 'سطر العنوان طويل جدًا';

  @override
  String get error_address_invalid_special_characters =>
      'يحتوي العنوان على أحرف خاصة غير صالحة';

  @override
  String get error_address_emoji_not_allowed =>
      'لا يُسمح بالرموز التعبيرية في العنوان';

  @override
  String get error_address_label_cant_be_empty =>
      'لا يمكن أن يكون وصف العنوان فارغًا';

  @override
  String get error_address_label_too_long => 'وصف العنوان طويل جدًا';

  @override
  String get error_city_cant_be_empty => 'لا يمكن أن تكون المدينة فارغة';

  @override
  String get error_city_too_long => 'اسم المدينة طويل جدًا';

  @override
  String get error_city_invalid_special_characters =>
      'تحتوي المدينة على أحرف خاصة غير صالحة';

  @override
  String get navDashboard => 'لوحة التحكم';

  @override
  String get navIdentity => 'الصلاحيات';

  @override
  String get navCatalog => 'الكتالوج';

  @override
  String get navInventory => 'المخزون';

  @override
  String get navSales => 'المبيعات';

  @override
  String get navPurchasing => 'المشتريات';

  @override
  String get navCrm => 'العملاء';

  @override
  String get navDelivery => 'التوصيل';

  @override
  String get navHr => 'الموظفون';

  @override
  String get navAccounting => 'المحاسبة';

  @override
  String get navMarketing => 'التسويق';

  @override
  String get navProfile => 'حسابي';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get expandNavigation => 'توسيع شريط التنقل';

  @override
  String get collapseNavigation => 'طي شريط التنقل';

  @override
  String get toggleTheme => 'تبديل المظهر';

  @override
  String get screenComingSoon => 'سيتم إضافة الشاشة لاحقًا.';

  @override
  String get dashboardTitle => 'التحليلات ولوحة التحكم';

  @override
  String get dashboardDescription => 'مؤشرات الأداء والتحليلات الإدارية';

  @override
  String get dashboardFeature1 => 'ملخص المبيعات والإيرادات والأرباح';

  @override
  String get dashboardFeature2 => 'مقارنة أداء الفروع';

  @override
  String get dashboardFeature3 => 'الخريطة الحرارية للمبيعات والطلبات';

  @override
  String get dashboardFeature4 => 'المنتجات الأكثر مبيعًا وسرعة حركتها';

  @override
  String get dashboardFeature5 => 'تحليل العملاء RFM';

  @override
  String get identityTitle => 'الهوية والصلاحيات';

  @override
  String get identityDescription => 'الفروع والمستخدمون والصلاحيات';

  @override
  String get identityFeature1 => 'إدارة الفروع والمعارض';

  @override
  String get identityFeature2 => 'المستخدمون والأدوار والصلاحيات';

  @override
  String get identityFeature3 => 'أسطول السيارات وسعات التحميل';

  @override
  String get catalogTitle => 'إدارة الكتالوج';

  @override
  String get catalogDescription => 'المنتجات والكتالوج والتسعير';

  @override
  String get catalogFeature1 => 'المنتجات والصور والترجمات والمواصفات';

  @override
  String get catalogFeature2 => 'التصنيفات والعلامات التجارية';

  @override
  String get catalogFeature3 => 'الخصائص والسمات والخيارات';

  @override
  String get catalogFeature4 => 'قوائم الأسعار وأسعار قنوات البيع';

  @override
  String get catalogFeature5 => 'تسعير المتر المربع والأشكال الخاصة';

  @override
  String get inventoryTitle => 'المخزون والمستودعات';

  @override
  String get inventoryDescription => 'المخازن وحركة المخزون والتكلفة';

  @override
  String get inventoryFeature1 => 'إدارة المخازن';

  @override
  String get inventoryFeature2 => 'أرصدة المخزون وتنبيهات النواقص';

  @override
  String get inventoryFeature3 => 'التحويلات بين المخازن';

  @override
  String get inventoryFeature4 => 'الجرد والتسويات المخزنية';

  @override
  String get inventoryFeature5 => 'الدفعات وتقييم المخزون FIFO';

  @override
  String get salesTitle => 'المبيعات ونقطة البيع';

  @override
  String get salesDescription => 'المبيعات ونقطة البيع والطلبات';

  @override
  String get salesFeature1 => 'نقطة البيع والباركود والخصومات';

  @override
  String get salesFeature2 => 'طرق الدفع: نقدي وبطاقة وآجل';

  @override
  String get salesFeature3 => 'فتح الورديات وتسليم النقدية وإغلاقها';

  @override
  String get salesFeature4 => 'الطلبات والمرتجعات والإلغاءات';

  @override
  String get salesFeature5 => 'الطلبات الخاصة والحجوزات والعربون';

  @override
  String get salesFeature6 => 'العروض الترويجية والكوبونات';

  @override
  String get purchasingTitle => 'المشتريات';

  @override
  String get purchasingDescription => 'الموردون وأوامر الشراء والتكاليف';

  @override
  String get purchasingFeature1 => 'الموردون وكشوف الحسابات';

  @override
  String get purchasingFeature2 => 'أوامر الشراء واستلام البضاعة';

  @override
  String get purchasingFeature3 => 'الشحنات والجمارك والتكاليف الإضافية';

  @override
  String get purchasingFeature4 => 'فواتير الموردين والأقساط والمدفوعات';

  @override
  String get crmTitle => 'علاقات العملاء';

  @override
  String get crmDescription => 'العملاء والضمان والشكاوى';

  @override
  String get crmFeature1 => 'سجل الضمانات';

  @override
  String get crmFeature2 => 'مطالبات العملاء والمعاينات والإصلاح';

  @override
  String get crmFeature3 => 'مراجعة تقييمات العملاء';

  @override
  String get crmFeature4 => 'الاستفسارات وأسئلة المنتجات';

  @override
  String get deliveryTitle => 'التوصيل';

  @override
  String get deliveryDescription => 'الرحلات والسائقون وتتبع التوصيل';

  @override
  String get deliveryFeature1 => 'إنشاء رحلات الشحن وتجميع الطلبات';

  @override
  String get deliveryFeature2 => 'تعيين السائق والسيارة';

  @override
  String get deliveryFeature3 => 'تحسين خطوط السير';

  @override
  String get deliveryFeature4 => 'التتبع المباشر ونقاط التوقف';

  @override
  String get deliveryFeature5 => 'إثبات التسليم بالصور أو التوقيع';

  @override
  String get hrTitle => 'الموارد البشرية';

  @override
  String get hrDescription => 'الموظفون والإجازات والرواتب';

  @override
  String get hrFeature1 => 'سجل الموظفين والبيانات الوظيفية';

  @override
  String get hrFeature2 => 'طلبات الإجازات';

  @override
  String get hrFeature3 => 'مسيرات الرواتب والتصدير إلى Excel';

  @override
  String get hrFeature4 => 'العمولات والسلف والخصومات';

  @override
  String get accountingTitle => 'المحاسبة والمالية';

  @override
  String get accountingDescription => 'الحسابات والخزائن والتقارير المالية';

  @override
  String get accountingFeature1 => 'شجرة الحسابات';

  @override
  String get accountingFeature2 => 'قيود اليومية ودفتر الأستاذ';

  @override
  String get accountingFeature3 => 'الخزائن والبنوك والتحويلات المالية';

  @override
  String get accountingFeature4 => 'المصروفات والشيكات';

  @override
  String get accountingFeature5 => 'قائمة الدخل والميزانية والتقارير الضريبية';

  @override
  String get marketingTitle => 'التسويق';

  @override
  String get marketingDescription => 'الحملات الترويجية';

  @override
  String get marketingFeature1 => 'حملات عجلة الحظ';

  @override
  String get marketingFeature2 => 'إدارة الجوائز وتفعيل الحملات';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileDescription => 'بيانات المدير الشخصية';

  @override
  String get profileFeature1 => 'بيانات الحساب الشخصي';

  @override
  String get profileFeature2 => 'تعديل الاسم وبيانات التواصل';

  @override
  String get profileFeature3 => 'تغيير كلمة المرور';

  @override
  String get profileFeature4 => 'مراجعة دور المستخدم وصلاحياته';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsDescription => 'إعدادات النظام والتطبيق';

  @override
  String get settingsFeature1 => 'اللغة والمظهر';

  @override
  String get settingsFeature2 => 'إعدادات الإشعارات';

  @override
  String get settingsFeature3 => 'إعدادات النظام العامة';

  @override
  String get adminWorkspace => 'مساحة إدارة المتجر';

  @override
  String get adminDisplayName => 'مصطفي محمود';

  @override
  String get adminRole => 'مدير عام';

  @override
  String get openAccountMenu => 'فتح قائمة الحساب';

  @override
  String get account => 'الحساب';

  @override
  String get myProfile => 'ملفي الشخصي';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signOutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get signOutConfirmMessage =>
      'ستحتاج إلى تسجيل الدخول مرة أخرى للوصول إلى مساحة الإدارة.';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get plannedScreens => 'الشاشات المخطط لها';

  @override
  String get interactivePrototype => 'نموذج تفاعلي';

  @override
  String get prototypeNotice =>
      'معاينة للتخطيط ببيانات تجريبية. سيتم ربط الشاشات بواجهة البيانات لاحقًا.';

  @override
  String get sampleData => 'بيانات تجريبية';

  @override
  String dashboardGreeting(String name) {
    return 'أهلًا بعودتك، $name';
  }

  @override
  String get dashboardSubtitle => 'إليك ما يحدث في متجرك اليوم.';

  @override
  String get dashboardRevenue => 'الإيرادات';

  @override
  String get dashboardOrders => 'الطلبات';

  @override
  String get dashboardCustomers => 'العملاء';

  @override
  String get dashboardLowStock => 'مخزون منخفض';

  @override
  String get dashboardRevenueChange => '+12.4% مقارنة بالأسبوع الماضي';

  @override
  String get dashboardOrdersChange => '+8.1% مقارنة بالأسبوع الماضي';

  @override
  String get dashboardCustomersChange => '+4.6% مقارنة بالأسبوع الماضي';

  @override
  String get dashboardLowStockChange => '6 أصناف تحتاج إلى متابعة';

  @override
  String get dashboardRevenueTrend => 'الإيرادات، آخر 7 أيام';

  @override
  String get dashboardAverageOrder => 'متوسط الطلب';

  @override
  String get dashboardTodaySales => 'اليوم';

  @override
  String get dashboardRecentOrders => 'أحدث الطلبات';

  @override
  String get dashboardQuickActions => 'إجراءات سريعة';

  @override
  String get dashboardViewAll => 'عرض الكل';

  @override
  String get dashboardOrder => 'الطلب';

  @override
  String get dashboardCustomer => 'العميل';

  @override
  String get dashboardStatus => 'الحالة';

  @override
  String get dashboardTotal => 'الإجمالي';

  @override
  String get dashboardStatusPaid => 'مدفوع';

  @override
  String get dashboardStatusPending => 'قيد الانتظار';

  @override
  String get dashboardStatusShipping => 'قيد التوصيل';

  @override
  String get dashboardNewSale => 'بيع جديد';

  @override
  String get dashboardAddProduct => 'إضافة منتج';

  @override
  String get dashboardNewCustomer => 'عميل جديد';

  @override
  String get dashboardCreateTrip => 'رحلة توصيل';

  @override
  String get profileAccountDetails => 'بيانات الحساب';

  @override
  String get profileFullName => 'الاسم الكامل';

  @override
  String get profileJobTitle => 'المسمى الوظيفي';

  @override
  String get profileEmail => 'البريد الإلكتروني';

  @override
  String get profilePhone => 'رقم الهاتف';

  @override
  String get profileBranch => 'الفرع';

  @override
  String get profileBranchValue => 'المعرض الرئيسي · طنطا';

  @override
  String get profileMemberSince => 'عضو منذ';

  @override
  String get profileMemberSinceValue => 'يناير 2024';

  @override
  String get profileEdit => 'تعديل الملف';

  @override
  String get profilePreferences => 'التفضيلات';

  @override
  String get profileSecurity => 'الأمان';

  @override
  String get profileChangePassword => 'تغيير كلمة المرور';

  @override
  String get profileChangePasswordDescription =>
      'استخدم كلمة مرور قوية لا تعيد استخدامها في مكان آخر.';

  @override
  String get profileTwoFactor => 'التحقق بخطوتين';

  @override
  String get profileTwoFactorDescription => 'اطلب رمز تحقق في كل جهاز جديد.';

  @override
  String get profileSessions => 'الجلسات النشطة';

  @override
  String get profileSessionsDescription =>
      'سجّل الخروج من كل الأجهزة عدا هذا الجهاز.';

  @override
  String get profilePermissions => 'الدور والصلاحيات';

  @override
  String get profilePermissionHint => 'وصول كامل إلى جميع وحدات مساحة العمل.';

  @override
  String get profilePermissionAll => 'جميع الوحدات';

  @override
  String get profileEditNotReady =>
      'سيتوفر تعديل الملف بعد ربط واجهة البيانات.';

  @override
  String get profilePasswordNotReady =>
      'سيتوفر تغيير كلمة المرور بعد ربط واجهة البيانات.';

  @override
  String get profileTwoFactorOn => 'تم تفعيل التحقق بخطوتين.';

  @override
  String get profileTwoFactorOff => 'تم إيقاف التحقق بخطوتين.';

  @override
  String get profileSessionsCleared => 'تم تسجيل الخروج من الجلسات الأخرى.';

  @override
  String get profileSignOutDevice => 'تسجيل الخروج من هذا الجهاز';

  @override
  String get settingsAppearanceHint => 'اختر شكل لوحة الإدارة.';

  @override
  String get settingsNotifications => 'الإشعارات';

  @override
  String get settingsNotificationsHint => 'اختر الأحداث التي تريد التنبيه بها.';

  @override
  String get settingsGeneral => 'عام';

  @override
  String get settingsGeneralHint => 'الإعدادات الافتراضية لكل مساحة العمل.';

  @override
  String get settingsNotificationOrders => 'الطلبات الجديدة';

  @override
  String get settingsNotificationOrdersHint => 'نبّهني عند إنشاء طلب.';

  @override
  String get settingsNotificationLowStock => 'المخزون المنخفض';

  @override
  String get settingsNotificationLowStockHint =>
      'نبّهني عندما يقل صنف عن حد إعادة الطلب.';

  @override
  String get settingsNotificationReviews => 'التقييمات الجديدة';

  @override
  String get settingsNotificationReviewsHint => 'نبّهني عند ترك عميل لتقييم.';

  @override
  String get settingsNotificationDigest => 'الملخص اليومي';

  @override
  String get settingsNotificationDigestHint => 'أرسل ملخصًا كل صباح.';

  @override
  String get settingsDefaultBranch => 'الفرع الافتراضي';

  @override
  String get settingsDefaultBranchHint => 'الفرع المحدد عند تسجيل الدخول.';

  @override
  String get settingsLandingPage => 'الصفحة الرئيسية';

  @override
  String get settingsLandingPageHint => 'أول شاشة بعد تسجيل الدخول.';

  @override
  String get settingsAutoRefresh => 'التحديث التلقائي للوحات';

  @override
  String get settingsAutoRefreshHint => 'تحديث المؤشرات كل 60 ثانية.';

  @override
  String get settingsSave => 'حفظ التغييرات';

  @override
  String get settingsSaved => 'تم حفظ الإعدادات.';

  @override
  String get settingsBranchMain => 'المعرض الرئيسي · طنطا';

  @override
  String get settingsBranchAlex => 'فرع الإسكندرية';

  @override
  String get settingsBranchGiza => 'فرع الجيزة';

  @override
  String get wireframeTableTitle => 'جدول بيانات';

  @override
  String get wireframeFormTitle => 'نموذج';

  @override
  String get wireframeStatsTitle => 'مؤشرات';

  @override
  String get wireframeCalendarTitle => 'تقويم';

  @override
  String get wireframeMapTitle => 'خريطة';

  @override
  String get wireframeBoardTitle => 'لوحة';

  @override
  String get wireframeListTitle => 'قائمة وتفاصيل';

  @override
  String get wireframeDetailTitle => 'تفاصيل السجل';

  @override
  String get wireframeToolbar => 'بحث وفلاتر وإجراءات';

  @override
  String get wireframeSearch => 'بحث';

  @override
  String get wireframeFilter => 'تصفية';

  @override
  String get wireframeNew => 'جديد';

  @override
  String get wireframeExport => 'تصدير';

  @override
  String get wireframeColumns => 'عمود';

  @override
  String get wireframeRows => 'صف';

  @override
  String get wireframeActions => 'إجراءات';

  @override
  String get wireframeField => 'حقل';

  @override
  String get wireframeValue => 'القيمة';

  @override
  String get wireframeSave => 'حفظ';

  @override
  String get wireframeCancel => 'إلغاء';

  @override
  String get wireframeChartArea => 'منطقة الرسم البياني';

  @override
  String get wireframeTableArea => 'منطقة الجدول';

  @override
  String get wireframeMapArea => 'المسار ونقاط التوقف';

  @override
  String get wireframeTimeline => 'الجدول الزمني';

  @override
  String get wireframeCard => 'بطاقة';

  @override
  String get wireframeMetric => 'مؤشر';

  @override
  String get wireframePreviewHint => 'معاينة التخطيط المخطط';

  @override
  String get hubScreens => 'الشاشات';

  @override
  String get hubSelectScreen => 'اختر شاشة لمعاينة تخطيطها المخطط.';

  @override
  String get currencyEgp => 'ج.م';

  @override
  String get sampleCustomer1 => 'منى عبد الرحمن';

  @override
  String get sampleCustomer2 => 'يوسف كمال';

  @override
  String get sampleCustomer3 => 'سلمى فتحي';

  @override
  String get sampleCustomer4 => 'كريم نبيل';

  @override
  String get dashboardChannelSplit => 'المبيعات حسب القناة';

  @override
  String get dashboardChannelStore => 'المتجر';

  @override
  String get dashboardChannelOnline => 'أونلاين';

  @override
  String get dashboardChannelWholesale => 'جملة';

  @override
  String get dashboardMonthlyTarget => 'هدف الشهر';

  @override
  String get dashboardTargetHint => 'تم تحقيق 74% من المستهدف الشهري';

  @override
  String get wireframeTableRef => 'المرجع';

  @override
  String get wireframeTableName => 'الاسم';

  @override
  String get wireframeTableStatus => 'الحالة';

  @override
  String get wireframeTableValue => 'القيمة';

  @override
  String get wireframeStatsSales => 'المبيعات';

  @override
  String get wireframeStatsOrders => 'الطلبات';

  @override
  String get wireframeStatsGrowth => 'النمو';

  @override
  String get wireframeStatsChartTitle => 'الأداء خلال الفترة';

  @override
  String get wireframeEventDelivery => 'توصيل طلبات';

  @override
  String get wireframeEventVisit => 'زيارة عميل';

  @override
  String get wireframeEventAudit => 'جرد مخزون';

  @override
  String get wireframeEventMeeting => 'اجتماع فريق';

  @override
  String get weekdaySat => 'السبت';

  @override
  String get weekdaySun => 'الأحد';

  @override
  String get weekdayMon => 'الإثنين';

  @override
  String get weekdayTue => 'الثلاثاء';

  @override
  String get weekdayWed => 'الأربعاء';

  @override
  String get weekdayThu => 'الخميس';

  @override
  String get weekdayFri => 'الجمعة';

  @override
  String sectionRecordsCount(int count) {
    return '$count سجل';
  }

  @override
  String paginationShowing(int from, int to, int total) {
    return 'عرض $from–$to من $total';
  }

  @override
  String get paginationPerPage => 'لكل صفحة';

  @override
  String get paginationPrevious => 'السابق';

  @override
  String get paginationNext => 'التالي';

  @override
  String paginationPageOf(int page, int pages) {
    return 'صفحة $page من $pages';
  }

  @override
  String get sectionEmptyTitle => 'لا توجد سجلات بعد';

  @override
  String get sectionEmptyMessage =>
      'ابدأ بإضافة أول سجل أو عدّل عوامل التصفية.';

  @override
  String get sectionNoResultsTitle => 'لا توجد نتائج مطابقة';

  @override
  String get sectionNoResultsMessage => 'جرّب كلمة بحث أخرى أو امسح البحث.';

  @override
  String get sectionClearSearch => 'مسح البحث';

  @override
  String get sectionDetailTitle => 'تفاصيل السجل';

  @override
  String get sectionSelectRecord => 'اختر سجلاً من القائمة لعرض تفاصيله.';

  @override
  String get sectionTimeline => 'سجل النشاط';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusInProgress => 'قيد التنفيذ';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get statusDelivered => 'تم التسليم';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusDraft => 'مسودة';

  @override
  String get formFieldName => 'الاسم';

  @override
  String get formFieldReference => 'المرجع';

  @override
  String get formFieldAmount => 'المبلغ';

  @override
  String get formFieldDate => 'التاريخ';

  @override
  String get formFieldNotes => 'ملاحظات';

  @override
  String get formFieldStatus => 'الحالة';

  @override
  String get formFieldBranch => 'الفرع';

  @override
  String get formSaveSuccess => 'تم حفظ التغييرات بنجاح';

  @override
  String get boardColumnNew => 'جديد';

  @override
  String get boardColumnInProgress => 'قيد التنفيذ';

  @override
  String get boardColumnDone => 'منجز';

  @override
  String get statsAverageOrder => 'متوسط الطلب';

  @override
  String get statsActiveCustomers => 'عملاء نشطون';

  @override
  String get statsConversion => 'معدل التحويل';

  @override
  String get calendarUpcoming => 'المواعيد القادمة';

  @override
  String get mapZone => 'المحافظة';

  @override
  String get mapOrders => 'الطلبات';

  @override
  String get mapRevenue => 'الإيراد';

  @override
  String get sampleProduct1 => 'قميص قطني كلاسيك';

  @override
  String get sampleProduct2 => 'حذاء جلد طبيعي';

  @override
  String get sampleProduct3 => 'حقيبة ظهر عملية';

  @override
  String get sampleProduct4 => 'ساعة يد أنيقة';

  @override
  String get sampleProduct5 => 'نظارة شمسية';

  @override
  String get sampleEmployee1 => 'أحمد سعيد';

  @override
  String get sampleEmployee2 => 'نهى مصطفى';

  @override
  String get sampleEmployee3 => 'خالد فؤاد';

  @override
  String get sampleEmployee4 => 'ريم حسن';

  @override
  String get sampleCampaign1 => 'عرض العيد';

  @override
  String get sampleCampaign2 => 'تخفيضات نهاية الأسبوع';

  @override
  String get sampleCampaign3 => 'حملة استرجاع العملاء';

  @override
  String get sampleCampaign4 => 'إطلاق المجموعة الجديدة';

  @override
  String get sampleBranch1 => 'فرع طنطا';

  @override
  String get sampleBranch2 => 'فرع القاهرة';

  @override
  String get sampleBranch3 => 'فرع الإسكندرية';

  @override
  String get sampleBranch4 => 'فرع المنصورة';
}
