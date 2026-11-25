import '../../../../core/constants/defaults.dart';
import 'planner_preferences.dart';
import 'session_type.dart';

/// Immutable timer rules passed into the pure engine.
///
/// Keeping these separate from [TimerSnapshot] means changing a preference
/// never silently mutates a running session; the controller supplies the
/// current config explicitly on every transition.
class TimerConfig {
  const TimerConfig({
    this.focusDuration = const Duration(seconds: AppDefaults.workDurationSec),
    this.shortBreakDuration = const Duration(
      seconds: AppDefaults.shortBreakSec,
    ),
    this.longBreakDuration = const Duration(
      seconds: AppDefaults.longBreakSec,
    ),
    this.roundsBeforeLongBreak = AppDefaults.roundsBeforeLongBreak,
    this.maxDuration = const Duration(seconds: AppDefaults.maxDurationSec),
    this.strictMode = false,
    this.countUp = false,
    this.whiteNoiseSoundId,
  });

  final Duration focusDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int roundsBeforeLongBreak;
  final Duration maxDuration;
  final bool strictMode;
  final bool countUp;
  final String? whiteNoiseSoundId;

  factory TimerConfig.fromPreferences(PlannerPreferences preferences) {
    return TimerConfig(
      focusDuration: preferences.focusDuration,
      shortBreakDuration: preferences.shortBreakDuration,
      longBreakDuration: preferences.longBreakDuration,
      roundsBeforeLongBreak: preferences.roundsBeforeLongBreak,
      maxDuration: preferences.maxDuration,
      strictMode: preferences.strictMode,
      countUp: preferences.countUp,
      whiteNoiseSoundId: preferences.whiteNoiseSoundId,
    );
  }

  Duration durationFor(SessionType type) {
    return switch (type) {
      SessionType.work => focusDuration,
      SessionType.shortBreak => shortBreakDuration,
      SessionType.longBreak => longBreakDuration,
    };
  }
}
