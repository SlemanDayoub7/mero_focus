/// Default logical values used across the app.
///
/// These are the single source of truth for initial settings; no widget or
/// usecase may duplicate them as literals (see coding-conventions.md).
abstract final class AppDefaults {
  static const int workDurationSec = 1500;
  static const int shortBreakSec = 300;
  static const int longBreakSec = 900;
  static const int roundsBeforeLongBreak = 4;

  static const String themeId = 'default';
  static const String backgroundId = 'default';
  static const String timerEndSoundId = 'default_bell';
}
