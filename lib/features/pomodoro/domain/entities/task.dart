import 'task_priority.dart';

/// A planner task that can be attached to a focus session.
class Task {
  const Task({
    this.id,
    required this.title,
    required this.createdAt,
    this.subjectId,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.estimatedPomodoros = 1,
    this.done = false,
    this.completedAt,
  });

  final int? id;
  final String title;
  final DateTime createdAt;
  final int? subjectId;
  final TaskPriority priority;
  final DateTime? dueDate;
  final int estimatedPomodoros;
  final bool done;
  final DateTime? completedAt;

  /// Due date, or the creation day when the user did not set one.
  DateTime get effectiveDue =>
      dueDate ?? DateTime(createdAt.year, createdAt.month, createdAt.day);

  Task copyWith({
    String? title,
    int? subjectId,
    bool clearSubject = false,
    TaskPriority? priority,
    DateTime? dueDate,
    bool clearDueDate = false,
    int? estimatedPomodoros,
    bool? done,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      subjectId: clearSubject ? null : (subjectId ?? this.subjectId),
      priority: priority ?? this.priority,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      done: done ?? this.done,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }
}
