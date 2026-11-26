import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/subtask.dart';

import '../../domain/entities/focus_session.dart';
import '../../domain/entities/session_type.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/task.dart';

import 'planner_providers.dart';
import 'subtasks_provider.dart';

/// Time spent and completed focus sessions for a task or a subject.
class FocusTotal {
  const FocusTotal({this.time = Duration.zero, this.sessions = 0});

  final Duration time;
  final int sessions;

  FocusTotal add(FocusSession session) {
    return FocusTotal(
      time: time + session.actualDuration,
      sessions: sessions + (session.completed ? 1 : 0),
    );
  }
}

/// Totals per task id, from focus sessions only (breaks are never stored).
Map<int, FocusTotal> totalsByTask(List<FocusSession> sessions) {
  final result = <int, FocusTotal>{};
  for (final session in sessions) {
    final taskId = session.taskId;
    if (session.sessionType != SessionType.work || taskId == null) continue;
    result[taskId] = (result[taskId] ?? const FocusTotal()).add(session);
  }
  return result;
}

/// Session ids that were spent on a subtask which no longer exists. Their
/// time is dropped from the subject totals.
Set<int> removedSubtaskSessionIds(
  List<SubtaskLogEntry> log,
  List<Subtask> subtasks,
) {
  final existing = <String>{for (final item in subtasks) item.id};
  return <int>{
    for (final entry in log)
      if (!existing.contains(entry.subtaskId)) entry.sessionId,
  };
}

/// Totals per subject id. A session belongs to a subject through its task;
/// when the task was deleted, the subject-name label saved on the session is
/// used instead, so history is kept. Sessions in [excludedSessionIds] (time
/// of removed subtasks) are skipped.
Map<int, FocusTotal> totalsBySubject(
  List<FocusSession> sessions,
  List<Task> tasks,
  List<Subject> subjects, {
  Set<int> excludedSessionIds = const <int>{},
}) {
  final subjectOfTask = <int, int>{};
  for (final task in tasks) {
    final id = task.id;
    final subjectId = task.subjectId;
    if (id != null && subjectId != null) subjectOfTask[id] = subjectId;
  }
  final subjectByName = <String, int>{};
  for (final subject in subjects) {
    final id = subject.id;
    if (id != null) subjectByName[subject.name] = id;
  }

  final result = <int, FocusTotal>{};
  for (final session in sessions) {
    if (session.sessionType != SessionType.work) continue;
    final sessionId = session.id;
    if (sessionId != null && excludedSessionIds.contains(sessionId)) continue;
    final taskId = session.taskId;
    final subjectId =
        (taskId != null ? subjectOfTask[taskId] : null) ??
        subjectByName[session.label];
    if (subjectId == null) continue;
    result[subjectId] = (result[subjectId] ?? const FocusTotal()).add(session);
  }
  return result;
}

/// Totals per existing subtask id.
Map<String, FocusTotal> totalsBySubtask(
  List<FocusSession> sessions,
  List<SubtaskLogEntry> log,
  List<Subtask> subtasks,
) {
  final existing = <String>{for (final item in subtasks) item.id};
  final subtaskOfSession = <int, String>{
    for (final entry in log)
      if (existing.contains(entry.subtaskId)) entry.sessionId: entry.subtaskId,
  };
  final result = <String, FocusTotal>{};
  for (final session in sessions) {
    if (session.sessionType != SessionType.work) continue;
    final sessionId = session.id;
    if (sessionId == null) continue;
    final subtaskId = subtaskOfSession[sessionId];
    if (subtaskId == null) continue;
    result[subtaskId] = (result[subtaskId] ?? const FocusTotal()).add(session);
  }
  return result;
}

final taskTotalsProvider = Provider<Map<int, FocusTotal>>((ref) {
  final sessions = ref.watch(focusSessionsProvider);
  if (sessions is! AsyncData<List<FocusSession>>) return const {};
  return totalsByTask(sessions.value);
});

final subjectTotalsProvider = Provider<Map<int, FocusTotal>>((ref) {
  final sessions = ref.watch(focusSessionsProvider);
  final tasks = ref.watch(tasksProvider);
  final subjects = ref.watch(subjectsProvider);
  if (sessions is! AsyncData<List<FocusSession>> ||
      tasks is! AsyncData<List<Task>> ||
      subjects is! AsyncData<List<Subject>>) {
    return const {};
  }
  return totalsBySubject(
    sessions.value,
    tasks.value,
    subjects.value,
    excludedSessionIds: removedSubtaskSessionIds(
      ref.watch(subtaskLogProvider),
      ref.watch(subtasksProvider),
    ),
  );
});

final subtaskTotalsProvider = Provider<Map<String, FocusTotal>>((ref) {
  final sessions = ref.watch(focusSessionsProvider);
  if (sessions is! AsyncData<List<FocusSession>>) return const {};
  return totalsBySubtask(
    sessions.value,
    ref.watch(subtaskLogProvider),
    ref.watch(subtasksProvider),
  );
});
