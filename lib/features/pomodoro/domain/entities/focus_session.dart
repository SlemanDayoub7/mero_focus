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
    this.label = '',
    this.taskId,
  });

  final int? id;
  final DateTime startTime;
  final DateTime endTime;
  final Duration plannedDuration;
  final Duration actualDuration;
  final SessionType sessionType;
  final bool completed;
  final int completionPercentage;

  /// Snapshot of the subject/task name, kept even after those records are gone.
  final String label;
  final int? taskId;

  /// Attaches the active task snapshot before persistence.
  ///
  /// Reports keep working after the task is deleted because the label is
  /// copied into this immutable session.
  FocusSession withAttribution({required String label, int? taskId}) {
    return FocusSession(
      id: id,
      startTime: startTime,
      endTime: endTime,
      plannedDuration: plannedDuration,
      actualDuration: actualDuration,
      sessionType: sessionType,
      completed: completed,
      completionPercentage: completionPercentage,
      label: label,
      taskId: taskId,
    );
  }
}
