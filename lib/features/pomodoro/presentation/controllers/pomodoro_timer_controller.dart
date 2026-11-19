import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/core_providers.dart';
import '../../data/repositories/pomodoro_repository_impl.dart';
import '../../data/services/timer_ticker.dart';
import '../../domain/engine/pomodoro_timer_engine.dart';
import '../../domain/entities/timer_snapshot.dart';
import '../../domain/entities/timer_transition.dart';
import '../../domain/repositories/pomodoro_repository.dart';
import '../../domain/usecases/save_completed_session.dart';

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

/// Thin orchestrator: applies pure engine transitions, schedules ticks and
/// persists completed sessions.
class PomodoroTimerController extends Notifier<TimerSnapshot> {
  @override
  TimerSnapshot build() {
    final ticker = ref.watch(timerTickerProvider);
    ref.onDispose(ticker.stop);
    return PomodoroTimerEngine.initial();
  }

  void start() => _apply(PomodoroTimerEngine.start(state));

  void pause() => _apply(PomodoroTimerEngine.pause(state));

  void reset() => _apply(PomodoroTimerEngine.reset(state));

  void _onTick() {
    _apply(PomodoroTimerEngine.tick(state, now: DateTime.now()));
  }

  void _apply(TimerTransition transition) {
    state = transition.snapshot;

    final completed = transition.completedSession;
    if (completed != null) {
      unawaited(ref.read(saveCompletedSessionProvider)(completed));
    }

    final ticker = ref.read(timerTickerProvider);
    if (state.isRunning && !ticker.isRunning) {
      ticker.start(_onTick);
    } else if (!state.isRunning && ticker.isRunning) {
      ticker.stop();
    }
  }
}
