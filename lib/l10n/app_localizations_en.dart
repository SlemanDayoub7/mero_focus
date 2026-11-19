// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mero Focus';

  @override
  String get home => 'Home';

  @override
  String get review => 'Review';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get addEntry => 'Add Entry';

  @override
  String get settings => 'Settings';

  @override
  String get themeSection => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get languageSection => 'Language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get pomodoroWork => 'Focus';

  @override
  String get pomodoroShortBreak => 'Short break';

  @override
  String get pomodoroLongBreak => 'Long break';

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerReset => 'Reset';

  @override
  String timerRound(int round) {
    return 'Round $round';
  }
}
