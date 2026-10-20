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
  String get alm_el_marateb => 'علم المراتب';

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
}
