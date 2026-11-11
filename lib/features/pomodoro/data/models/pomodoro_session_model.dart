import 'package:hive/hive.dart';

// NOTE: hive_generator is intentionally not used in this project.
// The Hive adapter for this model must be written and registered manually.
// TODO: add `toEntity()` / `fromEntity()` mapping.

/// Hive-persisted representation of a pomodoro session.
@HiveType(typeId: 2)
class PomodoroSessionModel {
  const PomodoroSessionModel({
    required this.id,
    required this.startedAt,
    required this.focusMinutes,
    required this.breakMinutes,
    required this.isCompleted,
    this.endedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startedAt;

  @HiveField(2)
  final int focusMinutes;

  @HiveField(3)
  final int breakMinutes;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final DateTime? endedAt;
}
