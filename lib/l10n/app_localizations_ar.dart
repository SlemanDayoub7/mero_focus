// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ميرو فوكس';

  @override
  String get home => 'الرئيسية';

  @override
  String get review => 'المراجعة';

  @override
  String get pomodoro => 'بومودورو';

  @override
  String get addEntry => 'إضافة عنصر';

  @override
  String get settings => 'الإعدادات';

  @override
  String get themeSection => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get languageSection => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get pomodoroWork => 'تركيز';

  @override
  String get pomodoroShortBreak => 'استراحة قصيرة';

  @override
  String get pomodoroLongBreak => 'استراحة طويلة';

  @override
  String get timerStart => 'ابدأ';

  @override
  String get timerPause => 'إيقاف مؤقت';

  @override
  String get timerReset => 'إعادة ضبط';

  @override
  String timerRound(int round) {
    return 'الجولة $round';
  }

  @override
  String get backgroundNotificationTitle => 'جلسة التركيز قيد التشغيل';

  @override
  String get backgroundNotificationText => 'اضغط للعودة إلى ميرو فوكس';

  @override
  String get overlayTimeLabel => 'الوقت المتبقي';

  @override
  String get backgroundPermissions => 'الخلفية والنافذة العائمة';

  @override
  String get backgroundPermissionsIntro =>
      'حافظ على تشغيل المؤقت وظهوره بعد مغادرة التطبيق.';

  @override
  String get overlayPermissionTitle => 'المؤقت العائم';

  @override
  String get overlayPermissionBody =>
      'اسمح لميرو فوكس بالرسم فوق التطبيقات الأخرى حتى يبقى مؤقت صغير مرئيًا عند التبديل بين التطبيقات.';

  @override
  String get overlayPermissionAction => 'منح إذن النافذة العائمة';

  @override
  String get batteryExemptionTitle => 'تحسين البطارية';

  @override
  String get batteryExemptionBody =>
      'بعض الأجهزة توقف مؤقتات الخلفية لتوفير الطاقة. استثنِ ميرو فوكس حتى لا تنقطع جلستك.';

  @override
  String get batteryExemptionAction => 'استثناء من التحسين';

  @override
  String get statusEnabled => 'مفعّل';

  @override
  String get statusDisabled => 'غير مفعّل';
}
