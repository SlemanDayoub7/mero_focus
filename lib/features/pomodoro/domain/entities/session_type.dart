import '../../../../core/constants/defaults.dart';

/// The three phases of a Pomodoro cycle.
enum SessionType {
  work,
  shortBreak,
  longBreak;

  /// Stable integer stored in `FocusSessions.sessionType`.
  int get storageValue => switch (this) {
        SessionType.work => 0,
        SessionType.shortBreak => 1,
        SessionType.longBreak => 2,
      };

  static SessionType fromStorage(int value) => switch (value) {
        0 => SessionType.work,
        1 => SessionType.shortBreak,
        _ => SessionType.longBreak,
      };

  /// Configured duration of this phase.
  Duration get duration => switch (this) {
        SessionType.work =>
          const Duration(seconds: AppDefaults.workDurationSec),
        SessionType.shortBreak =>
          const Duration(seconds: AppDefaults.shortBreakSec),
        SessionType.longBreak =>
          const Duration(seconds: AppDefaults.longBreakSec),
      };
}
