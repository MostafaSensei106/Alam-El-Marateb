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
  String get httpNoInternet =>
      'يبدو أنك غير متصل بالإنترنت. يرجى الاتصال بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get httpConnectionFailed =>
      'تعذر الوصول إلى الخادم. قد يكون غير متاح مؤقتًا.';

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
  String get httpDnsFailure =>
      'تعذر العثور على الخادم. تحقق من العنوان واتصالك بالإنترنت.';

  @override
  String get httpConnectionRefused =>
      'رفض الخادم الاتصال. قد يكون متوقفًا عن العمل.';

  @override
  String get httpServerUnreachable =>
      'تعذر الوصول إلى الخادم. قد يكون متوقفًا أو محظورًا بواسطة جدار حماية.';

  @override
  String get httpCorsBlocked =>
      'لم يكتمل الطلب. قد يكون الخادم متوقفًا أو غير قابل للوصول، وقد يكون المتصفح قد حظره لأسباب أمنية (CORS).';

  @override
  String get httpMixedContentBlocked =>
      'هذه الصفحة آمنة لكن عنوان الخادم غير آمن. لا يمكن لصفحة HTTPS الاتصال بخادم HTTP.';

  @override
  String get httpConnectionTimeout =>
      'انتهت مهلة الاتصال بالخادم. يرجى المحاولة مرة أخرى.';

  @override
  String get httpReceiveTimeout =>
      'استغرق الخادم وقتًا طويلاً للاستجابة. يرجى المحاولة مرة أخرى.';

  @override
  String get httpSendTimeout =>
      'انتهت مهلة إرسال الطلب. يرجى المحاولة مرة أخرى.';

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
  String get settingsFeature4 => 'معلومات التطبيق';

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
  String get rememberMe => 'تذكرني';

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
  String get appInfoAppName => 'اسم التطبيق';

  @override
  String get appInfoPackageName => 'اسم الحزمة';

  @override
  String get appInfoVersion => 'الإصدار';

  @override
  String get appInfoBuildNumber => 'رقم البناء';

  @override
  String get appInfoBuildMode => 'وضع البناء';

  @override
  String get appInfoBuildModeDebug => 'تطوير';

  @override
  String get appInfoBuildModeRelease => 'إصدار';

  @override
  String get appInfoOperatingSystem => 'نظام التشغيل';

  @override
  String get appInfoOperatingSystemVersion => 'إصدار النظام';

  @override
  String get appInfoFlutterVersion => 'إصدار Flutter';

  @override
  String get appInfoFlutterChannel => 'قناة Flutter';

  @override
  String get appInfoDartVersion => 'إصدار Dart';

  @override
  String get appInfoDartChannel => 'قناة Dart';

  @override
  String get appInfoInstallDate => 'تاريخ التثبيت';

  @override
  String get appInfoUpdateDate => 'آخر تحديث';

  @override
  String get appInfoInstaller => 'مصدر التثبيت';

  @override
  String get appInfoUnknown => 'غير متاح';

  @override
  String get appInfoCopy => 'نسخ التفاصيل';

  @override
  String get appInfoCopied => 'تم نسخ معلومات التطبيق.';

  @override
  String get appInfoUnavailableTitle => 'معلومات التطبيق غير متاحة';

  @override
  String get appInfoUnavailableBody =>
      'خدمة معلومات التطبيق غير متاحة في هذه الجلسة.';

  @override
  String get appInfoSectionApplication => 'التطبيق';

  @override
  String get appInfoSectionApplicationHint => 'بيانات نسخة الإدارة المثبتة.';

  @override
  String get appInfoSectionRuntime => 'بيئة التشغيل';

  @override
  String get appInfoSectionRuntimeHint =>
      'إصدارات Flutter وDart ونظام التشغيل.';

  @override
  String get appInfoSectionDistribution => 'التوزيع';

  @override
  String get appInfoSectionDistributionHint => 'مصدر التثبيت ووقت التحديث.';

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
  String get sectionRecordNote =>
      'تم إنشاء هذا السجل من لوحة التحكم، ويمكن تعديل بياناته أو أرشفته في أي وقت.';

  @override
  String get sectionCreatedAt => 'تاريخ الإنشاء';

  @override
  String get sectionLastUpdate => 'آخر تحديث';

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

  @override
  String get dashboardSubtitleBranches =>
      'أداء علم المراتب عبر الفروع والمخزون والعملاء.';

  @override
  String get dashboardPeriod => 'الفترة';

  @override
  String get dashboardLast7Days => 'آخر ٧ أيام';

  @override
  String get dashboardLast30Days => 'آخر ٣٠ يومًا';

  @override
  String get dashboardLast90Days => 'آخر ٩٠ يومًا';

  @override
  String get dashboardBranchFilter => 'الفرع';

  @override
  String get dashboardAllBranches => 'كل الفروع';

  @override
  String get dashboardRefresh => 'تحديث';

  @override
  String get dashboardExport => 'تصدير';

  @override
  String get dashboardExportHint =>
      'سيتوفر التصدير بعد ربط لوحة التحكم بالواجهة البرمجية.';

  @override
  String get dashboardRefreshed =>
      'تم تحديث لوحة التحكم بأحدث البيانات التجريبية.';

  @override
  String dashboardUpdated(String time) {
    return 'آخر تحديث $time';
  }

  @override
  String get dashboardSampleBadge => 'بيانات تجريبية';

  @override
  String get dashboardSampleNote =>
      'بيانات تجريبية على شكل واجهة التحليلات. الإضافات الخاصة بـ Flutter موثّقة في dashboard-flutter-features.md.';

  @override
  String dashboardActionHint(String action) {
    return 'سيتم فتح «$action» هنا بعد ربط إجراءات لوحة التحكم.';
  }

  @override
  String dashboardOpenModuleHint(String module) {
    return 'افتح وحدة «$module» للمتابعة.';
  }

  @override
  String get dashboardClose => 'إغلاق';

  @override
  String get dashboardKpiRevenue => 'صافي الإيرادات';

  @override
  String get dashboardKpiProfit => 'الربح الإجمالي';

  @override
  String get dashboardKpiOrders => 'الطلبات';

  @override
  String get dashboardKpiAverageOrder => 'متوسط الطلب';

  @override
  String get dashboardKpiCustomers => 'العملاء النشطون';

  @override
  String get dashboardKpiLowStock => 'أصناف قاربت على النفاد';

  @override
  String dashboardVsPrevious(String value) {
    return '$value مقارنة بالفترة السابقة';
  }

  @override
  String get dashboardNoChange => 'دون تغيير عن الفترة السابقة';

  @override
  String get dashboardRevenueProfit => 'الإيرادات والأرباح';

  @override
  String get dashboardRevenueProfitHint => 'الأداء اليومي للفترة المحددة';

  @override
  String get dashboardProfit => 'الربح الإجمالي';

  @override
  String dashboardMargin(String value) {
    return 'هامش $value';
  }

  @override
  String dashboardOrdersCount(String value) {
    return '$value طلب';
  }

  @override
  String dashboardUnitsCount(String value) {
    return '$value وحدة';
  }

  @override
  String get dashboardPreviousPeriod => 'مقارنة بالفترة السابقة';

  @override
  String get dashboardOperations => 'تنبيهات التشغيل';

  @override
  String get dashboardOperationsHint => 'بنود تحتاج متابعة من فريق التشغيل';

  @override
  String get dashboardLowStockAlert => 'أصناف تحت حد الطلب';

  @override
  String get dashboardLowStockAlertHint => 'أقل من نقطة إعادة الطلب';

  @override
  String get dashboardPendingTransfers => 'تحويلات معلّقة';

  @override
  String get dashboardPendingTransfersHint => 'بانتظار الإرسال أو الاستلام';

  @override
  String get dashboardOpenAudits => 'جرد مخزون مفتوح';

  @override
  String get dashboardOpenAuditsHint => 'عمليات جرد لم تُغلق بعد';

  @override
  String get dashboardStockByWarehouse => 'المخزون حسب المخزن';

  @override
  String get dashboardStockHint => 'الكمية والقيمة في كل مخزن';

  @override
  String get dashboardStockTotal => 'إجمالي قيمة المخزون';

  @override
  String dashboardStockQuantity(String value) {
    return '$value وحدة';
  }

  @override
  String dashboardWarehouses(String value) {
    return '$value مستودعات';
  }

  @override
  String get dashboardBranchPerformance => 'أداء الفروع';

  @override
  String get dashboardBranchHint => 'الإيراد والربح والطلبات لكل فرع';

  @override
  String get dashboardBranchProfit => 'الربح';

  @override
  String get dashboardBranchOrders => 'الطلبات';

  @override
  String dashboardBranchShare(String value) {
    return '$value من الإيراد';
  }

  @override
  String get dashboardShare => 'الحصة';

  @override
  String get dashboardWarehouse => 'المخزن';

  @override
  String get dashboardNoBranches => 'لا توجد بيانات فروع لهذا الفلتر.';

  @override
  String get dashboardVelocity => 'حركة المخزون';

  @override
  String get dashboardVelocityHint =>
      'المبيعات خلال ٣٠ يومًا مقابل التغطية المتاحة';

  @override
  String get dashboardVariant => 'الصنف';

  @override
  String get dashboardSold30d => 'مبيعات ٣٠ يومًا';

  @override
  String get dashboardCurrentQty => 'المتاح';

  @override
  String get dashboardDaysOfCover => 'التغطية';

  @override
  String get dashboardCoverOut => 'نفد المخزون';

  @override
  String get dashboardCoverLow => 'أعد الطلب الآن';

  @override
  String get dashboardCoverHealthy => 'جيد';

  @override
  String dashboardCoverDays(String value) {
    return '$value يومًا';
  }

  @override
  String get dashboardTopProducts => 'أفضل المنتجات';

  @override
  String get dashboardTopProductsHint =>
      'الأكثر مبيعًا بالإيراد خلال الفترة المحددة';

  @override
  String get dashboardTopProductQty => 'الوحدات';

  @override
  String get dashboardTopProductRevenue => 'الإيراد';

  @override
  String get dashboardTopProductShare => 'الحصة';

  @override
  String get dashboardRfm => 'تحليل RFM للعملاء';

  @override
  String get dashboardRfmHint => 'الحداثة والتكرار والقيمة النقدية';

  @override
  String get dashboardRfmCustomers => 'العملاء';

  @override
  String get dashboardRfmMonetary => 'القيمة النقدية';

  @override
  String get dashboardRfmChampions => 'الأبطال';

  @override
  String get dashboardRfmLoyal => 'مخلصون';

  @override
  String get dashboardRfmPotential => 'محتملون للولاء';

  @override
  String get dashboardRfmNew => 'عملاء جدد';

  @override
  String get dashboardRfmAtRisk => 'معرضون للفقد';

  @override
  String get dashboardRfmLost => 'مفقودون';

  @override
  String get dashboardGeo => 'الطلبات حسب المحافظة';

  @override
  String get dashboardGeoHint => 'طلب التوصيل عبر محافظات مصر';

  @override
  String get dashboardGeoTop => 'أعلى محافظة';

  @override
  String get dashboardInquiries => 'استفسارات العملاء';

  @override
  String get dashboardInquiriesHint => 'أحدث أسئلة المنتجات من صالة العرض';

  @override
  String get dashboardInquiryBought => 'تم الشراء';

  @override
  String get dashboardInquiryPrice => 'سؤال عن السعر';

  @override
  String get dashboardInquiryNoStock => 'غير متوفر';

  @override
  String get dashboardInquiryJustAsking => 'استفسار فقط';

  @override
  String dashboardInquiriesCount(String value) {
    return '$value استفسار';
  }

  @override
  String get dashboardTopAsked => 'المنتجات الأكثر سؤالًا';

  @override
  String get dashboardTopAskedHint => 'الأسئلة والمبيعات الفائتة حسب المنتج';

  @override
  String get dashboardAsked => 'مرات السؤال';

  @override
  String get dashboardNoStockAsked => 'نفد المخزون';

  @override
  String get dashboardPriceAsked => 'أسئلة السعر';

  @override
  String get dashboardAuditTrail => 'سجل التغييرات';

  @override
  String get dashboardAuditHint => 'أحدث التغييرات في المخزون والمبيعات';

  @override
  String dashboardAuditBy(String actor) {
    return 'بواسطة $actor';
  }

  @override
  String get dashboardAuditTransfer => 'تحويل مخزون';

  @override
  String get dashboardAuditAdjustment => 'تسوية مخزون';

  @override
  String get dashboardAuditPrice => 'تغيير سعر';

  @override
  String get dashboardAuditShift => 'إغلاق وردية';

  @override
  String get dashboardAuditWarranty => 'مطالبة ضمان';

  @override
  String get dashboardAuditPurchase => 'استلام مشتريات';

  @override
  String dashboardAuditTransferDetail(String qty, String from, String to) {
    return '$qty وحدة من $from إلى $to';
  }

  @override
  String dashboardAuditAdjustmentDetail(String variant, String diff) {
    return '$variant بعد تعديل $diff';
  }

  @override
  String dashboardAuditPriceDetail(
    String product,
    String oldPrice,
    String newPrice,
  ) {
    return '$product: $oldPrice ← $newPrice';
  }

  @override
  String dashboardAuditShiftDetail(String branch, String variance) {
    return '$branch أُغلقت بفرق $variance';
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
  String get dashboardTopCustomers => 'أفضل العملاء';

  @override
  String get dashboardTopCustomersHint => 'مرتبون حسب الإنفاق الكلي والولاء';

  @override
  String get dashboardCustomerSearch => 'ابحث بالاسم أو الهاتف';

  @override
  String get dashboardCustomerProfile => 'ملف العميل 360';

  @override
  String dashboardCustomerSince(String date) {
    return 'عميل منذ $date';
  }

  @override
  String get dashboardCustomerContact => 'بيانات الاتصال';

  @override
  String get dashboardCustomerAddresses => 'العناوين';

  @override
  String get dashboardCustomerWarranties => 'الضمانات والمطالبات';

  @override
  String get dashboardCustomerLoyalty => 'الولاء';

  @override
  String get dashboardCustomerNotes => 'ملاحظات';

  @override
  String get dashboardCustomerSpend => 'إجمالي الإنفاق';

  @override
  String get dashboardCustomerAvgOrder => 'متوسط الطلب';

  @override
  String get dashboardCustomerPoints => 'النقاط';

  @override
  String get dashboardCustomerTier => 'الفئة';

  @override
  String get dashboardCustomerRfm => 'شريحة RFM';

  @override
  String get dashboardCustomerPreferred => 'القناة المفضلة';

  @override
  String get dashboardPreferredBranch => 'الفرع المفضل';

  @override
  String get dashboardCustomerRecentOrders => 'أحدث الطلبات';

  @override
  String get dashboardCustomerNoOrders => 'لا توجد طلبات مسجلة.';

  @override
  String get dashboardCustomerNoClaims => 'لا توجد مطالبات ضمان مسجلة.';

  @override
  String get dashboardCustomerNoAddresses => 'لا توجد عناوين محفوظة.';

  @override
  String dashboardWarrantyExpires(String date) {
    return 'ينتهي $date';
  }

  @override
  String dashboardWarrantyPurchased(String date) {
    return 'تم الشراء $date';
  }

  @override
  String get dashboardWarrantyExpiry => 'ينتهي في';

  @override
  String get dashboardClaimOpen => 'مفتوحة';

  @override
  String get dashboardClaimInspection => 'فحص';

  @override
  String get dashboardClaimResolved => 'تم الحل';

  @override
  String get dashboardTierBronze => 'برونزية';

  @override
  String get dashboardTierSilver => 'فضية';

  @override
  String get dashboardTierGold => 'ذهبية';

  @override
  String get dashboardTierPlatinum => 'بلاتينية';

  @override
  String dashboardOrderCount(String value) {
    return '$value طلب';
  }

  @override
  String get dashboardCustomerNote1 =>
      'تفضل المراتب الطبية مقاس 160×200 وتؤكد الزيارة عبر واتساب.';

  @override
  String get dashboardCustomerNote2 =>
      'حساب مؤسسي: طلب ١٢ مرتبة لفندق في طنطا ويحتاج فاتورة ضريبية.';

  @override
  String get dashboardCustomerNote3 =>
      'اشتكى من تأخر التوصيل سابقًا؛ يُفضّل تأكيد الميعاد قبل يوم.';

  @override
  String get dashboardCustomerNote4 =>
      'مهتم بعروض التقسيط ويطلب متابعة عند توفر دفعة جديدة.';

  @override
  String get dashboardRecentOrdersHint => 'أحدث المبيعات عبر كل الفروع';

  @override
  String get dashboardOrderDate => 'التاريخ';

  @override
  String get dashboardOrderChannel => 'القناة';

  @override
  String get dashboardQuickActionsHint => 'اختصارات للكاشير والإدارة';

  @override
  String get dashboardStockTransfer => 'تحويل مخزون';

  @override
  String get dashboardNewPurchase => 'أمر شراء';

  @override
  String get dashboardChannelShowroom => 'صالة العرض';

  @override
  String get dashboardChannelPhone => 'الهاتف';

  @override
  String get dashboardChannelWhatsapp => 'واتساب';

  @override
  String get statusPaid => 'مدفوع';

  @override
  String get warehouseTanta => 'مخزن طنطا الرئيسي';

  @override
  String get warehouseCairo => 'مخزن القاهرة';

  @override
  String get warehouseAlex => 'مخزن الإسكندرية';

  @override
  String get warehouseMansoura => 'مخزن المنصورة';

  @override
  String get govGharbia => 'الغربية';

  @override
  String get govCairo => 'القاهرة';

  @override
  String get govAlexandria => 'الإسكندرية';

  @override
  String get govDakahlia => 'الدقهلية';

  @override
  String get govMenoufia => 'المنوفية';

  @override
  String get govQalyubia => 'القليوبية';

  @override
  String get govSharqia => 'الشرقية';

  @override
  String get govBeheira => 'البحيرة';

  @override
  String get categoryMattress => 'مراتب';

  @override
  String get categoryPillow => 'وسائد';

  @override
  String get categoryBase => 'قواعد أسرّة';

  @override
  String get categoryAccessory => 'ملحقات';

  @override
  String get supplierDeltaFoam => 'دلتا فوم';

  @override
  String get supplierSleepTech => 'سليب تك';

  @override
  String get product1 => 'مرتبة طبية 160×200';

  @override
  String get product2 => 'مرتبة ميموري فوم 180×200';

  @override
  String get product3 => 'مرتبة سوست 150×195';

  @override
  String get product4 => 'مرتبة أطفال 120×190';

  @override
  String get product5 => 'وسادة لاتكس 50×70';

  @override
  String get product6 => 'وسادة ميموري';

  @override
  String get product7 => 'قاعدة سرير خشبية 160×200';

  @override
  String get product8 => 'قاعدة سرير منجدة 180×200';

  @override
  String get product9 => 'غطاء مرتبة مقاوم للماء';

  @override
  String get product10 => 'طقم شراشف قطن';

  @override
  String get product11 => 'مرتبة بيضاوية حسب المقاس';

  @override
  String get product12 => 'مرتبة فندقية 200×200';

  @override
  String get customer1 => 'منى عبد الرحمن';

  @override
  String get customer2 => 'يوسف كمال';

  @override
  String get customer3 => 'سلمى فتحي';

  @override
  String get customer4 => 'كريم نبيل';

  @override
  String get customer5 => 'هنا طارق';

  @override
  String get customer6 => 'عمر شريف';

  @override
  String get customer7 => 'نور عادل';

  @override
  String get customer8 => 'أحمد فتحي';

  @override
  String get customer9 => 'مريم حسام';

  @override
  String get customer10 => 'تامر سعيد';

  @override
  String dashboardWeek(String value) {
    return 'الأسبوع $value';
  }

  @override
  String get dashboardInquiryNote1 => 'هل المرتبة الطبية متوفرة مقاس 160×200؟';

  @override
  String get dashboardInquiryNote2 => 'ما الفرق بين الميموري فوم والسوست؟';

  @override
  String get dashboardInquiryNote3 => 'محتاج سعر قاعدة السرير المنجدة.';

  @override
  String get dashboardInquiryNote4 => 'هل يوجد تقسيط بدون فائدة؟';

  @override
  String get dashboardInquiryNote5 => 'المرتبة البيضاوية بتاخد كم يوم تصنيع؟';

  @override
  String get dashboardInquiryNote6 => 'محتاج مراتب فندقية 200×200 بكمية.';

  @override
  String get dashboardClaimIssue1 => 'هبوط في الجانب الأيسر';

  @override
  String get dashboardClaimIssue2 => 'سحاب الغطاء مكسور';

  @override
  String get dashboardClaimIssue3 => 'تم توصيل مقاس مختلف';

  @override
  String get dashboardClaimIssue4 => 'صوت من وحدة السوست';

  @override
  String get addressHome => 'المنزل';

  @override
  String get addressWork => 'العمل';

  @override
  String get addressFamily => 'منزل العائلة';

  @override
  String get addressLine1 => '١٢ شارع الجيش، طنطا';

  @override
  String get addressLine2 => 'مدينة نصر، القاهرة';

  @override
  String get addressLine3 => 'سموحة، الإسكندرية';

  @override
  String get addressLine4 => 'المشاية، المنصورة';

  @override
  String get dashboardProduct => 'المنتج';

  @override
  String get dashboardGovernorate => 'المحافظة';

  @override
  String get dashboardItems => 'عدد القطع';

  @override
  String get dashboardUnits => 'الوحدات';

  @override
  String get dashboardIssue => 'المشكلة';

  @override
  String get dashboardEmpty => 'لا توجد سجلات مطابقة لهذا الفلتر.';

  @override
  String get dashboardAction => 'الإجراء';

  @override
  String get dashboardOutcome => 'النتيجة';

  @override
  String get dashboardDetails => 'التفاصيل';

  @override
  String get dashboardTime => 'الوقت';

  @override
  String get identityFeature4 => 'الأدوار ومصفوفة الصلاحيات';

  @override
  String get availabilityLive => 'بيانات مباشرة';

  @override
  String get availabilityPlanned => 'قيد التطوير';

  @override
  String get availabilityLocal => 'محلي';

  @override
  String get permissionsTitle => 'مصفوفة الصلاحيات';

  @override
  String get permissionsHint =>
      'اختر دوراً ثم امنح كل وحدة صلاحياتها. تُحفظ التغييرات على هذا الجهاز فقط.';

  @override
  String get permissionsReset => 'استعادة الافتراضي';

  @override
  String get permissionsModuleColumn => 'الوحدة';

  @override
  String get permissionsActionView => 'عرض';

  @override
  String get permissionsActionCreate => 'إنشاء';

  @override
  String get permissionsActionEdit => 'تعديل';

  @override
  String get permissionsActionDelete => 'حذف';

  @override
  String get permissionsRoleAdmin => 'مدير النظام';

  @override
  String get permissionsRoleManager => 'مدير';

  @override
  String get permissionsRoleCashier => 'كاشير';

  @override
  String get permissionsRoleWarehouse => 'المخزن';

  @override
  String get plannedNoticeTitle => 'شاشة مخططة';

  @override
  String get plannedNoticeBody =>
      'هذه الشاشة جاهزة تصميمياً، لكن نقطة النهاية الخاصة بها في الخادم غير متاحة بعد. القيم أدناه بيانات تجريبية والحفظ معطّل.';

  @override
  String get adminSampleActionMessage => 'إجراء تجريبي: لم يتم حفظ أي بيانات.';

  @override
  String get catalogTabProducts => 'المنتجات';

  @override
  String get catalogTabCategories => 'الفئات';

  @override
  String get catalogTabAttributes => 'الخصائص';

  @override
  String get catalogTabPrices => 'قوائم الأسعار';

  @override
  String get catalogTabMeter => 'تسعير المتر';

  @override
  String get catalogSearchProducts => 'ابحث في المنتجات أو رمز الصنف';

  @override
  String get catalogSearchAttributes => 'ابحث في الخصائص';

  @override
  String get catalogSearchPrices => 'ابحث في بنود الأسعار';

  @override
  String get catalogMetricProducts => 'المنتجات';

  @override
  String get catalogMetricLowStock => 'مخزون منخفض';

  @override
  String get catalogMetricAveragePrice => 'متوسط السعر';

  @override
  String get catalogMetricStockValue => 'قيمة المخزون';

  @override
  String get catalogMetricCategories => 'الفئات';

  @override
  String get catalogMetricCategoryProducts => 'منتجات مصنفة';

  @override
  String get catalogMetricTopCategory => 'أكبر فئة';

  @override
  String get catalogMetricAttributes => 'الخصائص';

  @override
  String get catalogMetricValues => 'القيم';

  @override
  String get catalogMetricRequired => 'إلزامية';

  @override
  String get catalogMetricPriceLists => 'قوائم الأسعار';

  @override
  String get catalogMetricChannels => 'قنوات البيع';

  @override
  String get catalogMetricAverageMargin => 'متوسط الهامش';

  @override
  String get catalogMetricEntries => 'بنود الأسعار';

  @override
  String get catalogColProduct => 'المنتج';

  @override
  String get catalogColSku => 'رمز الصنف';

  @override
  String get catalogColCategory => 'الفئة';

  @override
  String get catalogColPrice => 'السعر';

  @override
  String get catalogColStock => 'المخزون';

  @override
  String get catalogColValues => 'القيم';

  @override
  String get catalogColUsage => 'المنتجات';

  @override
  String get catalogColRequirement => 'الإلزام';

  @override
  String get catalogColPriceList => 'قائمة الأسعار';

  @override
  String get catalogColChannel => 'القناة';

  @override
  String get catalogColMargin => 'الهامش';

  @override
  String get catalogStockIn => 'متوفر';

  @override
  String get catalogStockLow => 'منخفض';

  @override
  String get catalogStockOut => 'غير متوفر';

  @override
  String get catalogCategoryShareLabel => 'الحصة من الكتالوج';

  @override
  String catalogCategoryProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتج',
      one: 'منتج واحد',
      zero: 'لا توجد منتجات',
    );
    return '$_temp0';
  }

  @override
  String get catalogAttributeSize => 'المقاس';

  @override
  String get catalogAttributeColor => 'اللون';

  @override
  String get catalogAttributeMaterial => 'الخامة';

  @override
  String get catalogAttributeFirmness => 'درجة الثبات';

  @override
  String get catalogAttributeWarranty => 'الضمان';

  @override
  String get catalogValueSize1 => '160 × 200';

  @override
  String get catalogValueSize2 => '180 × 200';

  @override
  String get catalogValueSize3 => '150 × 195';

  @override
  String get catalogValueColor1 => 'أبيض';

  @override
  String get catalogValueColor2 => 'بيج';

  @override
  String get catalogValueColor3 => 'رمادي';

  @override
  String get catalogValueMaterial1 => 'قطن';

  @override
  String get catalogValueMaterial2 => 'فوم';

  @override
  String get catalogValueMaterial3 => 'لاتكس';

  @override
  String get catalogValueFirmness1 => 'ناعم';

  @override
  String get catalogValueFirmness2 => 'متوسط';

  @override
  String get catalogValueFirmness3 => 'ثابت';

  @override
  String get catalogValueWarranty1 => 'سنة واحدة';

  @override
  String get catalogValueWarranty2 => '5 سنوات';

  @override
  String get catalogRequired => 'إلزامي';

  @override
  String get catalogOptional => 'اختياري';

  @override
  String get catalogPriceListRetail => 'التجزئة';

  @override
  String get catalogPriceListWholesale => 'الجملة';

  @override
  String get catalogPriceListOnline => 'الإنترنت';

  @override
  String get catalogChannelShowroom => 'المعرض';

  @override
  String get catalogChannelWeb => 'المتجر الإلكتروني';

  @override
  String get catalogChannelWholesale => 'الجملة';

  @override
  String get catalogMeterDimensions => 'المقاس والشكل';

  @override
  String get catalogMeterPricing => 'مدخلات السعر';

  @override
  String get catalogMeterSummary => 'التقدير المباشر';

  @override
  String get catalogMeterWidth => 'العرض (سم)';

  @override
  String get catalogMeterHeight => 'الطول (سم)';

  @override
  String get catalogMeterRate => 'سعر المتر المربع';

  @override
  String get catalogMeterWaste => 'الهالك (%)';

  @override
  String get catalogMeterShape => 'الشكل';

  @override
  String get catalogShapeRectangle => 'مستطيل';

  @override
  String get catalogShapeRound => 'دائري';

  @override
  String get catalogShapeLShape => 'على شكل L';

  @override
  String get catalogMeterArea => 'المساحة';

  @override
  String get catalogMeterBasePrice => 'السعر الأساسي';

  @override
  String get catalogMeterWasteCost => 'قيمة الهالك';

  @override
  String get catalogMeterTotal => 'السعر التقديري';

  @override
  String get catalogMeterHint => 'يتحدث أثناء الكتابة';

  @override
  String get catalogMeterInvalid => 'أدخل العرض والطول والسعر لعرض التقدير.';

  @override
  String get catalogMeterUnit => 'م²';

  @override
  String get adminFilterAll => 'الكل';

  @override
  String get inventoryTabWarehouses => 'المخازن';

  @override
  String get inventoryTabStocks => 'أرصدة المخزون';

  @override
  String get inventoryTabTransfers => 'التحويلات';

  @override
  String get inventoryTabAudits => 'جرد المخزون';

  @override
  String get inventoryTabBatches => 'الدفعات والصلاحية';

  @override
  String get inventorySearchWarehouses => 'ابحث عن مخزن أو مسؤول';

  @override
  String get inventorySearchStocks => 'ابحث عن منتج أو رمز أو مخزن';

  @override
  String get inventorySearchTransfers => 'ابحث عن التحويلات';

  @override
  String get inventorySearchAudits => 'ابحث عن الجرد أو المعدّين';

  @override
  String get inventorySearchBatches => 'ابحث عن دفعة أو منتج';

  @override
  String get inventoryMetricWarehouses => 'المخازن';

  @override
  String get inventoryMetricProducts => 'المنتجات';

  @override
  String get inventoryMetricUnitsOnHand => 'الوحدات المتاحة';

  @override
  String get inventoryMetricCapacityUsed => 'السعة المستخدمة';

  @override
  String get inventoryMetricStockValue => 'قيمة المخزون';

  @override
  String get inventoryMetricSkus => 'أصناف';

  @override
  String get inventoryMetricLowStock => 'مخزون منخفض';

  @override
  String get inventoryMetricOutOfStock => 'نفد المخزون';

  @override
  String get inventoryMetricReorderValue => 'قيمة إعادة الطلب';

  @override
  String get inventoryMetricPendingTransfers => 'تحويلات معلقة';

  @override
  String get inventoryMetricUnitsInTransit => 'وحدات في الطريق';

  @override
  String get inventoryMetricReceivedTransfers => 'تحويلات مستلمة';

  @override
  String get inventoryMetricLastTransfer => 'آخر تحويل';

  @override
  String get inventoryMetricOpenAudits => 'جرد مفتوح';

  @override
  String get inventoryMetricVarianceUnits => 'صافي الفرق';

  @override
  String get inventoryMetricClosedAudits => 'جرد مغلق';

  @override
  String get inventoryMetricNextAudit => 'الجرد القادم';

  @override
  String get inventoryMetricActiveBatches => 'دفعات نشطة';

  @override
  String get inventoryMetricExpiringSoon => 'قرب الانتهاء';

  @override
  String get inventoryMetricExpiredBatches => 'دفعات منتهية';

  @override
  String get inventoryMetricBatchValue => 'قيمة الدفعات';

  @override
  String get inventoryColWarehouse => 'المخزن';

  @override
  String get inventoryColManager => 'المسؤول';

  @override
  String get inventoryColCapacity => 'السعة';

  @override
  String get inventoryColUtilization => 'الاستخدام';

  @override
  String get inventoryColProducts => 'المنتجات';

  @override
  String get inventoryColProduct => 'المنتج';

  @override
  String get inventoryColSku => 'الرمز';

  @override
  String get inventoryColOnHand => 'المتاح';

  @override
  String get inventoryColReorder => 'حد إعادة الطلب';

  @override
  String get inventoryColValue => 'القيمة';

  @override
  String get inventoryColState => 'الحالة';

  @override
  String get inventoryColTransfer => 'التحويل';

  @override
  String get inventoryColRoute => 'المسار';

  @override
  String get inventoryColUnits => 'الوحدات';

  @override
  String get inventoryColDate => 'التاريخ';

  @override
  String get inventoryColAudit => 'الجرد';

  @override
  String get inventoryColCounter => 'المعدّ';

  @override
  String get inventoryColVariance => 'الفرق';

  @override
  String get inventoryColBatch => 'الدفعة';

  @override
  String get inventoryColExpiry => 'الصلاحية';

  @override
  String get inventoryColQuantity => 'الكمية';

  @override
  String get inventoryColDaysLeft => 'الأيام المتبقية';

  @override
  String get inventoryStateHealthy => 'جيد';

  @override
  String get inventoryStateLow => 'منخفض';

  @override
  String get inventoryStateOut => 'نافد';

  @override
  String get inventoryTransferDraft => 'مسودة';

  @override
  String get inventoryTransferTransit => 'في الطريق';

  @override
  String get inventoryTransferReceived => 'مستلم';

  @override
  String get inventoryAuditScheduled => 'مجدول';

  @override
  String get inventoryAuditCounting => 'جارٍ الجرد';

  @override
  String get inventoryAuditClosed => 'مغلق';

  @override
  String get inventoryBatchValid => 'صالح';

  @override
  String get inventoryBatchExpiring => 'قارب الانتهاء';

  @override
  String get inventoryBatchExpired => 'منتهي';

  @override
  String inventoryCapacityRatio(String used, String capacity) {
    return '$used / $capacity';
  }

  @override
  String inventoryCapacityUsed(int percent) {
    return '$percent% مستخدم';
  }

  @override
  String inventoryUnits(int count) {
    return '$count وحدة';
  }

  @override
  String inventoryDaysLeft(int days) {
    return '$days يوم';
  }

  @override
  String inventoryDaysAgo(int days) {
    return 'منذ $days يوم';
  }

  @override
  String inventoryLowStockItems(int count) {
    return '$count أصناف منخفضة';
  }

  @override
  String inventoryProductsCount(int count) {
    return '$count منتج';
  }

  @override
  String get inventoryPlannedTransfersBody =>
      'ستُحفظ مسودات التحويل في الخادم عند توفر واجهة التحويلات. حتى ذلك الحين المسودات أدناه بيانات تجريبية ولا يُسجل أي حركة.';

  @override
  String get inventoryPlannedAuditsBody =>
      'جلسات الجرد للقراءة فقط حالياً: يحتاج سير عمل الجرد إلى واجهة الجرد. الجلسات أدناه بيانات تجريبية.';

  @override
  String get salesTabPos => 'نقطة البيع';

  @override
  String get salesTabPayments => 'المدفوعات';

  @override
  String get salesTabShifts => 'الورديات';

  @override
  String get salesTabOrders => 'الطلبات';

  @override
  String get salesTabCustomOrders => 'الطلبات المخصصة';

  @override
  String get salesTabPromotions => 'العروض';

  @override
  String get salesSearchPos => 'ابحث عن منتج أو رمز SKU';

  @override
  String get salesSearchPayments => 'ابحث في المدفوعات أو الطلبات أو العملاء';

  @override
  String get salesSearchShifts => 'ابحث في الورديات أو أمناء الصندوق';

  @override
  String get salesSearchOrders => 'ابحث في الطلبات أو العملاء';

  @override
  String get salesSearchCustomOrders => 'ابحث في الطلبات المخصصة أو العملاء';

  @override
  String get salesSearchPromotions => 'ابحث في العروض أو الأكواد';

  @override
  String get salesColPayment => 'الدفعة';

  @override
  String get salesColOrder => 'الطلب';

  @override
  String get salesColCustomer => 'العميل';

  @override
  String get salesColMethod => 'طريقة الدفع';

  @override
  String get salesColAmount => 'المبلغ';

  @override
  String get salesColStatus => 'الحالة';

  @override
  String get salesColDate => 'التاريخ';

  @override
  String get salesColShift => 'الوردية';

  @override
  String get salesColCashier => 'أمين الصندوق';

  @override
  String get salesColOpened => 'الفتح';

  @override
  String get salesColClosed => 'الإغلاق';

  @override
  String get salesColSales => 'المبيعات';

  @override
  String get salesColVariance => 'الفرق';

  @override
  String get salesColItems => 'العناصر';

  @override
  String get salesColTotal => 'الإجمالي';

  @override
  String get salesColCustomOrder => 'الطلب المخصص';

  @override
  String get salesColDimensions => 'المقاسات';

  @override
  String get salesColDeposit => 'العربون';

  @override
  String get salesColDue => 'الاستحقاق';

  @override
  String get salesColPromotion => 'العرض';

  @override
  String get salesColCode => 'الكود';

  @override
  String get salesColUses => 'الاستخدامات';

  @override
  String get salesColWindow => 'الفترة';

  @override
  String get salesPayCash => 'نقدي';

  @override
  String get salesPayCard => 'بطاقة';

  @override
  String get salesPayCredit => 'آجل';

  @override
  String get salesPayWallet => 'محفظة';

  @override
  String get salesPayPaid => 'مدفوعة';

  @override
  String get salesPayPending => 'معلقة';

  @override
  String get salesPayRefunded => 'مستردة';

  @override
  String get salesPosCart => 'البيع الحالي';

  @override
  String get salesPosEmptyCart => 'السلة فارغة. أضف منتجًا لبدء البيع.';

  @override
  String get salesPosWalkIn => 'عميل نقدي';

  @override
  String get salesPosQty => 'الكمية';

  @override
  String get salesPosAdd => 'أضف إلى السلة';

  @override
  String get salesPosRemove => 'إزالة';

  @override
  String get salesPosClear => 'إفراغ السلة';

  @override
  String get salesPosSubtotal => 'المجموع الفرعي';

  @override
  String get salesPosVat => 'ضريبة القيمة المضافة (١٤٪)';

  @override
  String get salesPosTotal => 'الإجمالي';

  @override
  String salesPosCharge(String amount) {
    return 'تحصيل $amount';
  }

  @override
  String get salesPosChargeMessage => 'بيع تجريبي: لم تُعالج أي دفعة.';

  @override
  String get salesMetricCartItems => 'عناصر السلة';

  @override
  String get salesMetricCartSubtotal => 'المجموع الفرعي';

  @override
  String get salesMetricCartVat => 'ضريبة القيمة المضافة';

  @override
  String get salesMetricCartTotal => 'المطلوب';

  @override
  String get salesMetricCollected => 'المحصّل';

  @override
  String get salesMetricCardShare => 'حصة البطاقات';

  @override
  String get salesMetricPendingCredit => 'آجل معلق';

  @override
  String get salesMetricRefunds => 'المستردات';

  @override
  String get salesShiftOpen => 'مفتوحة';

  @override
  String get salesShiftClosed => 'مغلقة';

  @override
  String get salesMetricOpenShifts => 'ورديات مفتوحة';

  @override
  String get salesMetricShiftSales => 'مبيعات الورديات';

  @override
  String get salesMetricCashDrawer => 'النقد في الدرج';

  @override
  String get salesMetricCashVariance => 'فرق النقد';

  @override
  String get salesOrderNew => 'جديد';

  @override
  String get salesOrderProcessing => 'قيد التنفيذ';

  @override
  String get salesOrderDelivered => 'تم التسليم';

  @override
  String get salesOrderCancelled => 'ملغي';

  @override
  String get salesMetricOpenOrders => 'طلبات مفتوحة';

  @override
  String get salesMetricOrderValue => 'قيمة الطلبات';

  @override
  String get salesMetricDeliveredOrders => 'تم تسليمها';

  @override
  String get salesMetricCancelledOrders => 'ملغاة';

  @override
  String get salesPlannedOrdersBody =>
      'قائمة الطلبات تحتاج إلى واجهة الطلبات في الخادم. الصفوف أدناه بيانات تجريبية ويبقى إنشاء الطلب معطّلًا حتى تشغيل الواجهة.';

  @override
  String get salesCustomDeposit => 'تم دفع العربون';

  @override
  String get salesCustomProduction => 'قيد التصنيع';

  @override
  String get salesCustomReady => 'جاهز';

  @override
  String get salesMetricOpenCustomOrders => 'طلبات مخصصة مفتوحة';

  @override
  String get salesMetricCustomDeposits => 'عرابين محتجزة';

  @override
  String get salesMetricCustomReady => 'جاهز للاستلام';

  @override
  String get salesMetricCustomOverdue => 'متأخرة';

  @override
  String get salesPlannedCustomOrdersBody =>
      'لوحة الطلبات المخصصة تحتاج إلى واجهة الطلبات المخصصة. البطاقات أدناه بيانات تجريبية ويبقى إنشاء الطلب معطّلًا حتى تشغيل الواجهة.';

  @override
  String get salesPromoActive => 'نشط';

  @override
  String get salesPromoScheduled => 'مجدول';

  @override
  String get salesPromoExpired => 'منتهي';

  @override
  String get salesMetricActivePromotions => 'عروض نشطة';

  @override
  String get salesMetricPromoRedemptions => 'مرات الاستخدام';

  @override
  String get salesMetricPromoDiscount => 'قيمة الخصومات';

  @override
  String get salesMetricPromoExpiring => 'تنتهي قريبًا';

  @override
  String get salesPlannedPromotionsBody =>
      'قائمة العروض تحتاج إلى واجهة العروض. البطاقات أدناه بيانات تجريبية ويبقى إنشاء العرض معطّلًا حتى تشغيل الواجهة.';

  @override
  String salesPromoOff(int percent) {
    return 'خصم $percent%';
  }

  @override
  String get salesPromoWinter => 'تخفيضات الشتاء للمراتب';

  @override
  String get salesPromoPillowBundle => 'باقة الوسائد';

  @override
  String get salesPromoBaseClearance => 'تصفية القواعد';

  @override
  String get salesPromoVip => 'ولاء كبار العملاء';

  @override
  String get salesPromoNewHome => 'باقة المنزل الجديد';

  @override
  String get salesPromoHotel => 'عقد الفنادق';

  @override
  String get salesPromoClearance => 'تصفية المخزن';

  @override
  String get salesPromoRamadan => 'عرض رمضان';

  @override
  String get navOperations => 'العمليات';

  @override
  String get operationsTitle => 'العمليات والفروع';

  @override
  String get operationsDescription =>
      'المهام الداخلية وحمل الفروع وحجوزات العملاء';

  @override
  String get operationsFeature1 => 'مهام لشخص أو مجموعة أو فرق الفروع';

  @override
  String get operationsFeature2 => 'عبء العمل بالفروع والمتأخرات ونسبة الإنجاز';

  @override
  String get operationsFeature3 => 'حجوزات العملاء للبضائع والمقاسات المخصصة';

  @override
  String get opsTabTasks => 'المهام';

  @override
  String get opsTabBranches => 'حمل الفروع';

  @override
  String get opsTabHolds => 'حجوزات العملاء';

  @override
  String get opsSearchTasks => 'ابحث في المهام أو الأشخاص أو الفروع';

  @override
  String get opsSearchBranches => 'ابحث في الفروع أو المديرين';

  @override
  String get opsSearchHolds => 'ابحث في الحجوزات أو العملاء أو الأصناف';

  @override
  String get opsColTask => 'المهمة';

  @override
  String get opsColAssignee => 'المسند إليه';

  @override
  String get opsColBranch => 'الفرع';

  @override
  String get opsColPriority => 'الأولوية';

  @override
  String get opsColDue => 'الاستحقاق';

  @override
  String get opsColStatus => 'الحالة';

  @override
  String get opsColChecklist => 'قائمة الخطوات';

  @override
  String get opsColCustomer => 'العميل';

  @override
  String get opsColItem => 'الصنف';

  @override
  String get opsColDeposit => 'العربون';

  @override
  String get opsColExpected => 'الوصول المتوقع';

  @override
  String get opsStatusOpen => 'مفتوحة';

  @override
  String get opsStatusInProgress => 'قيد التنفيذ';

  @override
  String get opsStatusBlocked => 'متوقفة';

  @override
  String get opsStatusDone => 'مكتملة';

  @override
  String get opsHoldWaiting => 'في الانتظار';

  @override
  String get opsHoldArrived => 'وصل';

  @override
  String get opsHoldReady => 'جاهز';

  @override
  String get opsHoldCancelled => 'ملغي';

  @override
  String get opsPriorityLow => 'منخفضة';

  @override
  String get opsPriorityNormal => 'عادية';

  @override
  String get opsPriorityHigh => 'مرتفعة';

  @override
  String get opsPriorityUrgent => 'عاجلة';

  @override
  String get opsAssigneePerson => 'شخص';

  @override
  String get opsAssigneeGroup => 'مجموعة';

  @override
  String get opsAssigneeBranch => 'فرع';

  @override
  String get opsTaskDetail => 'تفاصيل المهمة';

  @override
  String get opsTaskConditions => 'السياق والشروط';

  @override
  String get opsTaskChecklist => 'قائمة المهام';

  @override
  String get opsTaskChecklistEmpty => 'لا توجد خطوات لهذه المهمة.';

  @override
  String opsTaskChecklistProgress(int done, int total) {
    return 'تم $done من $total';
  }

  @override
  String get opsAssignedTo => 'مسندة إلى';

  @override
  String get opsBranchesLabel => 'الفروع';

  @override
  String get opsDueToday => 'مستحقة اليوم';

  @override
  String get opsDueTomorrow => 'مستحقة غدًا';

  @override
  String opsDaysOverdue(int days) {
    return 'متأخرة $days يومًا';
  }

  @override
  String opsDaysLeft(int days) {
    return 'متبقي $days يومًا';
  }

  @override
  String get opsExpectedToday => 'متوقع وصوله اليوم';

  @override
  String get opsMetricOpenTasks => 'مهام مفتوحة';

  @override
  String get opsMetricDueToday => 'مستحقة اليوم';

  @override
  String get opsMetricOverdue => 'متأخرة';

  @override
  String get opsMetricBlocked => 'متوقفة';

  @override
  String get opsMetricBranches => 'الفروع';

  @override
  String get opsMetricBranchOpen => 'مهام مفتوحة';

  @override
  String get opsMetricBranchOverdue => 'مهام متأخرة';

  @override
  String get opsMetricBranchHolds => 'حجوزات منتظرة';

  @override
  String get opsMetricWaiting => 'حجوزات منتظرة';

  @override
  String get opsMetricArriving => 'تصل هذا الأسبوع';

  @override
  String get opsMetricDeposits => 'عرابين محتجزة';

  @override
  String get opsMetricReady => 'جاهزة للاستلام';

  @override
  String get opsNewTask => 'مهمة جديدة';

  @override
  String get opsCreateTask => 'إنشاء المهمة';

  @override
  String get opsClose => 'إغلاق';

  @override
  String get opsTaskTitle => 'عنوان المهمة';

  @override
  String get opsTaskTitleHint => 'ما المطلوب تنفيذه؟';

  @override
  String get opsTaskContext => 'السياق والشروط';

  @override
  String get opsTaskContextHint =>
      'أضف التفاصيل والقيود التي يحتاجها المسند إليه';

  @override
  String get opsAssignTo => 'الإسناد إلى';

  @override
  String get opsChooseAssignee => 'اختر من يتولى المهمة';

  @override
  String get opsChooseBranch => 'الفرع';

  @override
  String get opsChecklistHint => 'خطوة واحدة في كل سطر';

  @override
  String get opsDueDate => 'تاريخ الاستحقاق';

  @override
  String get opsNoAssignees => 'اختر مسندًا إليه واحدًا على الأقل.';

  @override
  String get opsNoBranches => 'اختر فرعًا واحدًا على الأقل.';

  @override
  String get opsTaskCreated => 'تم إنشاء المهمة.';

  @override
  String get opsTitleRequired => 'أضف عنوانًا للمهمة.';

  @override
  String get opsBranchManager => 'المدير';

  @override
  String opsBranchOpenTasks(int count) {
    return '$count مفتوحة';
  }

  @override
  String opsBranchOverdueTasks(int count) {
    return '$count متأخرة';
  }

  @override
  String opsBranchHolds(int count) {
    return '$count حجوزات';
  }

  @override
  String opsBranchTeam(int count) {
    return '$count أشخاص';
  }

  @override
  String get opsBranchOnTrack => 'منتظم';

  @override
  String get opsBranchBusy => 'مزدحم';

  @override
  String get opsBranchOverloaded => 'محمّل زيادة';

  @override
  String get opsBranchCompletion => 'الإنجاز';

  @override
  String get opsHoldStockItem => 'صنف من المخزن';

  @override
  String get opsHoldCustomSize => 'مقاس مخصص';

  @override
  String opsSizeCustom(int width, int length) {
    return '$width × $length سم';
  }

  @override
  String get opsPlannedHoldsTitle => 'حجوزات بانتظار الواجهة الخلفية';

  @override
  String get opsPlannedHoldsBody =>
      'حجز البضائع والمقاسات المخصصة يعمل في الواجهة. سيتم تشغيل حفظ الحجز عند إتاحة واجهة الحجوزات في المخزون.';

  @override
  String get opsPerson1 => 'هالة مصطفى';

  @override
  String get opsPerson2 => 'رامي فؤاد';

  @override
  String get opsPerson3 => 'دينا سمير';

  @override
  String get opsPerson4 => 'مصطفى عادل';

  @override
  String get opsPerson5 => 'ندى شريف';

  @override
  String get opsPerson6 => 'شريف كامل';

  @override
  String get opsGroup1 => 'فريق البيع';

  @override
  String get opsGroup2 => 'فريق المخزن';

  @override
  String get opsGroup3 => 'فريق التنجيد';

  @override
  String get opsGroup4 => 'فريق الدعم';

  @override
  String get opsTask1Title => 'تجهيز معرض طنطا للمجموعة الجديدة';

  @override
  String get opsTask1Context =>
      'انقل معروضات المخزن القديمة إلى الغرفة الخلفية، وبخّر ألواح القماش وصوّر النتيجة قبل وصول المجموعة يوم الخميس.';

  @override
  String get opsTask2Title => 'تأكيد مواعيد تسليم عطلة القاهرة';

  @override
  String get opsTask2Context =>
      'اتصل بكل طلب مجدول الجمعة والسبت، وأكد العنوان وسجل أي قيود على البوابة أو المصعد قبل طباعة ورقة المندوب.';

  @override
  String get opsTask3Title => 'إنهاء جدول أسعار المقاسات المخصصة للإسكندرية';

  @override
  String get opsTask3Context =>
      'أضف تكاليف الإسفنج والأغلفة لعام 2026، وقرّب سعر كل مقاس إلى أقرب 50 جنيهًا وأرسل الجدول لمدير الفرع للاعتماد.';

  @override
  String get opsTask4Title => 'جرد أغلفة المراتب في المنصورة';

  @override
  String get opsTask4Context =>
      'الجرد متأخر أسبوعين. اجرد كل مقاس، وسجل الفروق مقابل ورقة المخزون وحدد أي غلاف ما زال محتجزًا لعميل.';

  @override
  String get opsTask5Title => 'استلام شحنة الإسفنج في طنطا';

  @override
  String get opsTask5Context =>
      'طابق إذن التسليم مع أمر الشراء، وافحص اللفائف من التمزق وسلّم الإذن الموقّع للحسابات.';

  @override
  String get opsTask6Title => 'إنهاء حجز القاهرة لمقاس 180×200';

  @override
  String get opsTask6Context =>
      'دفع العميل العربون منذ ثلاثة أسابيع. أكد موعد المورد، واعرض وحدة بديلة وحدّث العميل قبل نهاية اليوم.';

  @override
  String get opsTask7Title => 'متابعة شكاوى التسليم في الإسكندرية';

  @override
  String get opsTask7Context =>
      'أبلغ ثلاثة عملاء عن تأخر التسليم الأسبوع الماضي. اتصل بكل منهم، وسجل السبب واتفق على تعويض رمزي مع الدعم.';

  @override
  String get opsTask8Title => 'تسعير عرض الربيع في المنصورة';

  @override
  String get opsTask8Context =>
      'أنشئ باقة لوسادتين وغطاء واقٍ، وقارنها بعرض القاهرة وحافظ على هامش أعلى من 25 بالمائة.';

  @override
  String get opsTask9Title => 'اعتماد قائمة تسليم النقد في طنطا';

  @override
  String get opsTask9Context =>
      'قابل أمناء الصندوق، وأغلق الثغرات في تسليم المساء وحدّث لوحة الفرع قبل الوردية التالية.';

  @override
  String get opsTask10Title => 'إنهاء الطلب المخصص C-2214 في القاهرة';

  @override
  String get opsTask10Context =>
      'تم قص الغلاف. افحص الخياطة، وغلّف المرتبة واتصل بالعميل واحجز موعد التسليم.';

  @override
  String get opsStep1 => 'راجع ورقة التسليم';

  @override
  String get opsStep2 => 'تحقق من المخزون المتاح';

  @override
  String get opsStep3 => 'اتصل بالعميل';

  @override
  String get opsStep4 => 'أكد مواعيد التسليم';

  @override
  String get opsStep5 => 'حدّث جدول الأسعار';

  @override
  String get opsStep6 => 'اجرد الوحدات';

  @override
  String get opsStep7 => 'سجل أي فروق';

  @override
  String get opsStep8 => 'استلم الشحنة';

  @override
  String get opsStep9 => 'افحص لفائف الإسفنج';

  @override
  String get opsStep10 => 'أبلغ فريق البيع';

  @override
  String get opsStep11 => 'جهّز عينات القماش';

  @override
  String get opsStep12 => 'صوّر النتيجة';

  @override
  String get opsStep13 => 'احجز المندوب';

  @override
  String get opsStep14 => 'اطبع ملصقات المقاسات';

  @override
  String get opsStep15 => 'تحقق من العربون';

  @override
  String get opsStep16 => 'أفرغ منطقة الكاشير';

  @override
  String get opsStep17 => 'حدّث لوحة الفرع';

  @override
  String get opsStep18 => 'أكد مع مدير الفرع';
}
