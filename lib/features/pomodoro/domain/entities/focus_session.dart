import 'session_type.dart';

/// A completed focus/break session, persisted as raw data for later statistics.
class FocusSession {
  const FocusSession({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.plannedDuration,
    required this.actualDuration,
    required this.sessionType,
    this.completed = true,
    this.completionPercentage = 100,
  });

  final int? id;
  final DateTime startTime;
  final DateTime endTime;
  final Duration plannedDuration;
  final Duration actualDuration;
  final SessionType sessionType;
  final bool completed;
  final int completionPercentage;
}
