import '../../../../core/constants/defaults.dart';
import '../entities/focus_session.dart';
import '../entities/session_type.dart';
import '../entities/timer_snapshot.dart';
import '../entities/timer_transition.dart';

/// Pure transition functions for the Pomodoro timer.
///
/// No timers, no I/O, no Flutter — every rule here is deterministic and can be
/// unit tested directly. The Riverpod controller only schedules ticks and
/// persists the sessions produced here.
abstract final class PomodoroTimerEngine {
  static TimerSnapshot initial() => const TimerSnapshot(
        phase: SessionType.work,
        status: TimerStatus.idle,
        remaining: Duration(seconds: AppDefaults.workDurationSec),
        completedRounds: 0,
      );

  static TimerTransition start(TimerSnapshot state) {
    if (state.isRunning) return TimerTransition(state);
    return TimerTransition(
      state.copyWith(status: TimerStatus.running),
    );
  }

  static TimerTransition pause(TimerSnapshot state) {
    if (!state.isRunning) return TimerTransition(state);
    return TimerTransition(
      state.copyWith(status: TimerStatus.paused),
    );
  }

  static TimerTransition reset(TimerSnapshot state) {
    return TimerTransition(
      initial().copyWith(completedRounds: state.completedRounds),
    );
  }

  static TimerTransition tick(TimerSnapshot state, {required DateTime now}) {
    if (!state.isRunning) return TimerTransition(state);

    final remaining = state.remaining - const Duration(seconds: 1);
    if (remaining > Duration.zero) {
      return TimerTransition(state.copyWith(remaining: remaining));
    }

    final phaseDuration = state.phase.duration;
    final completedSession = FocusSession(
      startTime: now.subtract(phaseDuration),
      endTime: now,
      plannedDuration: phaseDuration,
      actualDuration: phaseDuration,
      sessionType: state.phase,
    );

    final next = _nextPhase(state);
    return TimerTransition(next, completedSession: completedSession);
  }

  static TimerSnapshot _nextPhase(TimerSnapshot state) {
    switch (state.phase) {
      case SessionType.work:
        final rounds = state.completedRounds + 1;
        final isLongBreak =
            rounds % AppDefaults.roundsBeforeLongBreak == 0;
        final phase = isLongBreak
            ? SessionType.longBreak
            : SessionType.shortBreak;
        return TimerSnapshot(
          phase: phase,
          status: TimerStatus.idle,
          remaining: phase.duration,
          completedRounds: rounds,
        );
      case SessionType.shortBreak:
      case SessionType.longBreak:
        return TimerSnapshot(
          phase: SessionType.work,
          status: TimerStatus.idle,
          remaining: SessionType.work.duration,
          completedRounds: state.completedRounds,
        );
    }
  }
}
