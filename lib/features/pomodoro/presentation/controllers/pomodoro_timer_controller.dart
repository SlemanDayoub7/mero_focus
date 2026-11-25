import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/core_providers.dart';
import '../../data/repositories/pomodoro_repository_impl.dart';
import '../../data/services/no_op_white_noise.dart';
import '../../data/services/timer_ticker.dart';
import '../../domain/engine/pomodoro_timer_engine.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/entities/planner_preferences.dart';
import '../../domain/entities/session_type.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/timer_config.dart';
import '../../domain/entities/timer_snapshot.dart';
import '../../domain/entities/timer_transition.dart';
import '../../domain/repositories/pomodoro_repository.dart';
import '../../domain/usecases/save_completed_session.dart';
import 'planner_providers.dart';
import 'subtasks_provider.dart';
import 'timer_extras_settings.dart';

final pomodoroRepositoryProvider = Provider<PomodoroRepository>((ref) {
  return PomodoroRepositoryImpl(ref.watch(appDatabaseProvider));
});

final saveCompletedSessionProvider = Provider<SaveCompletedSession>((ref) {
  return SaveCompletedSession(ref.watch(pomodoroRepositoryProvider));
});

final pomodoroTimerProvider =
    NotifierProvider<PomodoroTimerController, TimerSnapshot>(
  PomodoroTimerController.new,
);

/// Thin orchestrator: applies pure engine transitions, supplies the user's
/// preferences, attributes sessions to the active task and drives the
/// background/ambience ports. It owns no timer arithmetic.
class PomodoroTimerController extends Notifier<TimerSnapshot> {
  @override
  TimerSnapshot build() {
    final ticker = ref.watch(timerTickerProvider);
    ref.onDispose(ticker.stop);

    // Preferences load asynchronously and can be edited from the timer
    // screen; keep the idle countdown in sync with them.
    ref.listen<AsyncValue<PlannerPreferences>>(plannerPreferencesProvider, (
      _,
      next,
    ) {
      if (next is AsyncData<PlannerPreferences>) {
        state = PomodoroTimerEngine.syncDuration(
          state,
          config: TimerConfig.fromPreferences(next.value),
        );
        // Picking another ambience applies immediately while running.
        _syncAmbience();
      }
    });

    return PomodoroTimerEngine.initial(config: _config());
  }

  /// Re-reads the saved preferences into an idle countdown. Used right after
  /// a cold start (home-screen widget) before the first Start.
  void refreshDuration() {
    state = PomodoroTimerEngine.syncDuration(state, config: _config());
  }

  void start() {
    _apply(
      PomodoroTimerEngine.start(
        state,
        config: _config(),
        now: DateTime.now(),
      ),
    );
    _syncAmbience();
  }

  void pause() {
    _apply(PomodoroTimerEngine.pause(state, config: _config()));
    _syncAmbience();
  }

  /// Accepts the break offered after a completed focus session.
  void startBreak() {
    _apply(
      PomodoroTimerEngine.startBreak(
        state,
        config: _config(),
        now: DateTime.now(),
      ),
    );
  }

  /// Declines the offered break (or aborts an active one).
  void skipBreak() {
    _apply(PomodoroTimerEngine.skipBreak(state, config: _config()));
  }

  /// Ends focus early; logs a partial session when allowed by the config.
  void stop() {
    _apply(
      PomodoroTimerEngine.stop(
        state,
        config: _config(),
        now: DateTime.now(),
      ),
    );
    _syncAmbience();
  }

  void reset() {
    if (state.phase == SessionType.work &&
        (state.isRunning || state.isPaused)) {
      stop();
      return;
    }
    _apply(PomodoroTimerEngine.reset(state, config: _config()));
    _syncAmbience();
  }

  void _onTick() {
    _apply(
      PomodoroTimerEngine.tick(
        state,
        config: _config(),
        now: DateTime.now(),
      ),
      natural: true,
    );
  }

  void _apply(TimerTransition transition, {bool natural = false}) {
    state = transition.snapshot;

    final completed = transition.completedSession;
    if (completed != null) {
      // Only focus sessions are statistics; breaks are not persisted.
      if (completed.sessionType == SessionType.work) {
        unawaited(_saveWork(_attribute(completed)));
      }
      final port = ref.read(whiteNoisePortProvider);
      unawaited(port.stop());
      // The end sound marks a phase that ran out by itself, not a manual stop.
      if (natural && ref.read(timerExtrasProvider).endSoundEnabled) {
        unawaited(port.playEndChime());
      }
    }

    final ticker = ref.read(timerTickerProvider);
    if (state.isRunning && !ticker.isRunning) {
      ticker.start(_onTick);
    } else if (!state.isRunning && ticker.isRunning) {
      ticker.stop();
    }
  }

  /// Saves a focus session and, when a subtask of the active task's subject
  /// is selected, links the saved session to it.
  Future<void> _saveWork(FocusSession session) async {
    final subtaskId = _activeSubtaskId();
    final id = await ref.read(saveCompletedSessionProvider)(session);
    if (subtaskId != null) {
      await ref.read(subtaskLogProvider.notifier).add(id, subtaskId);
    }
  }

  String? _activeSubtaskId() {
    final subtask = ref.read(activeSubtaskProvider);
    final task = ref.read(activeTaskProvider);
    if (subtask == null || task == null) return null;
    return subtask.subjectId == task.subjectId ? subtask.id : null;
  }

  TimerConfig _config() {
    final async = ref.read(plannerPreferencesProvider);
    if (async is AsyncData<PlannerPreferences>) {
      return TimerConfig.fromPreferences(async.value);
    }
    return const TimerConfig();
  }

  /// Snapshots the active task (or its subject) into the session label so
  /// reports survive later task deletions.
  FocusSession _attribute(FocusSession session) {
    final task = ref.read(activeTaskProvider);
    if (task == null) return session;

    var label = task.title;
    final subjectId = task.subjectId;
    if (subjectId != null) {
      final subjectsAsync = ref.read(subjectsProvider);
      if (subjectsAsync is AsyncData<List<Subject>>) {
        for (final subject in subjectsAsync.value) {
          if (subject.id == subjectId) {
            label = subject.name;
            break;
          }
        }
      }
    }
    return session.withAttribution(label: label, taskId: task.id);
  }

  void _syncAmbience() {
    final soundId = _config().whiteNoiseSoundId;
    final port = ref.read(whiteNoisePortProvider);
    if (state.isRunning && soundId != null) {
      unawaited(port.play(soundId));
    } else {
      unawaited(port.stop());
    }
  }
}
