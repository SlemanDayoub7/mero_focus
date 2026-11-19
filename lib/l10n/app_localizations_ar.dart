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
}
