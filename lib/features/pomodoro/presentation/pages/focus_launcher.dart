import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/session_type.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/timer_snapshot.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';
import '../controllers/pomodoro_timer_controller.dart';
import '../controllers/subtasks_provider.dart';
import 'pomodoro_timer_page.dart';

/// Makes sure a focus phase is running: waits for the saved durations, leaves
/// a break if one is showing, then starts when idle or paused.
Future<void> _beginFocus(WidgetRef ref) async {
  // After a cold start the preferences may not be loaded yet; starting
  // before that would use the default 25 minutes.
  await ref.read(plannerPreferencesProvider.future);

  final controller = ref.read(pomodoroTimerProvider.notifier);
  var snapshot = ref.read(pomodoroTimerProvider);

  final inBreak =
      snapshot.phase != SessionType.work &&
      (snapshot.isBreakOffer || snapshot.isRunning || snapshot.isPaused);
  if (inBreak) {
    controller.skipBreak();
    snapshot = ref.read(pomodoroTimerProvider);
  }
  if (snapshot.status == TimerStatus.idle) controller.refreshDuration();

  snapshot = ref.read(pomodoroTimerProvider);
  final canStart =
      snapshot.phase == SessionType.work &&
      (snapshot.status == TimerStatus.idle || snapshot.isPaused);
  if (canStart) controller.start();
}

/// Opens the Pomodoro screen on [navigator].
Future<void> pushTimerPage(NavigatorState navigator) {
  return navigator.push<void>(
    MaterialPageRoute<void>(builder: (_) => const PomodoroTimerPage()),
  );
}

/// Selects the task (and optional subtask) and starts the timer, without
/// navigating. Use [pushTimerPage] afterwards.
Future<void> prepareFocusOnTask(
  WidgetRef ref,
  int taskId, {
  String? subtaskId,
}) async {
  // Selecting a task clears the subtask, so the subtask is set afterwards.
  ref.read(activeTaskIdProvider.notifier).select(taskId);
  ref.read(activeSubtaskIdProvider.notifier).select(subtaskId);
  await _beginFocus(ref);
}

/// Adds (or reuses) today's task for [subject], then prepares focus on it.
Future<void> prepareFocusForSubject(
  WidgetRef ref,
  Subject subject, {
  String? subtaskId,
}) async {
  final taskId = await ref.read(plannerActionsProvider).taskForSubject(subject);
  await prepareFocusOnTask(ref, taskId, subtaskId: subtaskId);
}

/// Selects [taskId] as the current task, starts the timer immediately and
/// opens the Pomodoro screen.
Future<void> startFocusOnTask(
  BuildContext context,
  WidgetRef ref,
  int taskId, {
  String? subtaskId,
}) async {
  await prepareFocusOnTask(ref, taskId, subtaskId: subtaskId);
  if (!context.mounted) return;
  await pushTimerPage(Navigator.of(context));
}

/// Tapping a fixed task adds (or reuses) today's task for it and starts focus.
Future<void> startFocusForSubject(
  BuildContext context,
  WidgetRef ref,
  Subject subject, {
  String? subtaskId,
}) async {
  await prepareFocusForSubject(ref, subject, subtaskId: subtaskId);
  if (!context.mounted) return;
  await pushTimerPage(Navigator.of(context));
}

/// Entry point for the Android home-screen Pomodoro widget: starts the timer
/// right away and shows the Pomodoro screen on top of the home page.
Future<void> startPomodoroFromWidget(
  BuildContext context,
  WidgetRef ref,
) async {
  await _beginFocus(ref);
  if (!context.mounted) return;
  final navigator = Navigator.of(context);
  navigator.popUntil((route) => route.isFirst);
  await pushTimerPage(navigator);
}

/// Entry point for a tapped reminder notification. With a linked fixed task
/// it starts today's task for it; otherwise a general session. If a session
/// is already running it only shows the timer, so nothing gets re-attributed.
Future<void> startFocusFromReminder(
  BuildContext context,
  WidgetRef ref, {
  Subject? subject,
}) async {
  final running = ref.read(pomodoroTimerProvider).isRunning;
  if (!running) {
    if (subject != null) {
      await prepareFocusForSubject(ref, subject);
    } else {
      await _beginFocus(ref);
    }
  }
  if (!context.mounted) return;
  final navigator = Navigator.of(context);
  navigator.popUntil((route) => route.isFirst);
  await pushTimerPage(navigator);
}
