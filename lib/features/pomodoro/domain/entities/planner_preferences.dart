import '../../../../core/constants/defaults.dart';

/// Default daily focus goal: 3 hours. The user can change it from the reports.
const int kDefaultDailyGoalMinutes = 180;

/// Pomodoro-specific slice of the single `AppSettings` row.
class PlannerPreferences {
  const PlannerPreferences({
    this.focusDuration = const Duration(seconds: AppDefaults.workDurationSec),
    this.shortBreakDuration = const Duration(
      seconds: AppDefaults.shortBreakSec,
    ),
    this.longBreakDuration = const Duration(seconds: AppDefaults.longBreakSec),
    this.roundsBeforeLongBreak = AppDefaults.roundsBeforeLongBreak,
    this.maxDuration = const Duration(seconds: AppDefaults.maxDurationSec),
    this.dailyGoalMinutes = kDefaultDailyGoalMinutes,
    this.strictMode = false,
    this.countUp = false,
    this.whiteNoiseSoundId,
    this.backgroundId = AppDefaults.backgroundId,
    this.studentMode = false,
    this.studentPromptSeen = false,
  });

  final Duration focusDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int roundsBeforeLongBreak;
  final Duration maxDuration;
  final int dailyGoalMinutes;
  final bool strictMode;
  final bool countUp;
  final String? whiteNoiseSoundId;
  final String backgroundId;
  final bool studentMode;
  final bool studentPromptSeen;

  PlannerPreferences copyWith({
    Duration? focusDuration,
    Duration? shortBreakDuration,
    Duration? longBreakDuration,
    int? roundsBeforeLongBreak,
    Duration? maxDuration,
    int? dailyGoalMinutes,
    bool? strictMode,
    bool? countUp,
    String? whiteNoiseSoundId,
    bool clearWhiteNoiseSoundId = false,
    String? backgroundId,
    bool? studentMode,
    bool? studentPromptSeen,
  }) {
    return PlannerPreferences(
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      roundsBeforeLongBreak:
          roundsBeforeLongBreak ?? this.roundsBeforeLongBreak,
      maxDuration: maxDuration ?? this.maxDuration,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      strictMode: strictMode ?? this.strictMode,
      countUp: countUp ?? this.countUp,
      whiteNoiseSoundId: clearWhiteNoiseSoundId
          ? null
          : (whiteNoiseSoundId ?? this.whiteNoiseSoundId),
      backgroundId: backgroundId ?? this.backgroundId,
      studentMode: studentMode ?? this.studentMode,
      studentPromptSeen: studentPromptSeen ?? this.studentPromptSeen,
    );
  }
}
