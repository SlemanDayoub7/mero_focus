import '../entities/focus_session.dart';
import '../entities/session_type.dart';
import '../entities/timer_config.dart';
import '../entities/timer_snapshot.dart';
import '../entities/timer_transition.dart';

/// Pure transition functions for the Pomodoro timer.
///
/// No timers, no I/O, no Flutter — every rule here is deterministic and can be
/// unit tested directly. The Riverpod controller only schedules ticks and
/// persists the sessions produced here.
///
/// All functions accept an optional [TimerConfig]; the default matches app
/// defaults so callers that do not care about preferences stay simple.
abstract final class PomodoroTimerEngine {
  static const _oneSecond = Duration(seconds: 1);
  static const _minimumLoggedSeconds = Duration(seconds: 60);

  static TimerSnapshot initial({TimerConfig config = const TimerConfig()}) {
    return TimerSnapshot(
      phase: SessionType.work,
      status: TimerStatus.idle,
      remaining: config.focusDuration,
      completedRounds: 0,
    );
  }

  /// Re-reads the phase duration after the user changed it. Only an idle
  /// phase or a pending break offer is touched; a running or paused session
  /// keeps the duration it started with.
  static TimerSnapshot syncDuration(
    TimerSnapshot state, {
    required TimerConfig config,
  }) {
    final editable =
        state.status == TimerStatus.idle || state.status == TimerStatus.breakOffer;
    if (!editable) return state;
    final target = config.durationFor(state.phase);
    if (target == state.remaining) return state;
    return state.copyWith(remaining: target);
  }

  static TimerTransition start(
    TimerSnapshot state, {
    TimerConfig config = const TimerConfig(),
    DateTime? now,
  }) {
    if (state.isRunning || state.isBreakOffer) return TimerTransition(state);
    return TimerTransition(
      state.copyWith(
        status: TimerStatus.running,
        phaseStartedAt: state.phaseStartedAt ?? now ?? DateTime.now(),
      ),
    );
  }

  /// Strict mode deliberately refuses to pause a running *focus* session.
  /// Breaks can always be paused.
  static TimerTransition pause(
    TimerSnapshot state, {
    TimerConfig config = const TimerConfig(),
  }) {
    if (!state.isRunning) return TimerTransition(state);
    if (config.strictMode && state.phase == SessionType.work) {
      return TimerTransition(state);
    }
    return TimerTransition(state.copyWith(status: TimerStatus.paused));
  }

  static TimerTransition reset(
    TimerSnapshot state, {
    TimerConfig config = const TimerConfig(),
  }) {
    return TimerTransition(
      initial(config: config).copyWith(completedRounds: state.completedRounds),
    );
  }

  static TimerTransition tick(
    TimerSnapshot state, {
    required DateTime now,
    TimerConfig config = const TimerConfig(),
  }) {
    if (!state.isRunning) return TimerTransition(state);

    final elapsed = state.elapsed + _oneSecond;
    final remaining = state.remaining - _oneSecond;
    if (remaining > Duration.zero) {
      return TimerTransition(
        state.copyWith(elapsed: elapsed, remaining: remaining),
      );
    }

    final completed = FocusSession(
      startTime: state.phaseStartedAt ?? now.subtract(elapsed),
      endTime: now,
      plannedDuration: config.durationFor(state.phase),
      actualDuration: elapsed,
      sessionType: state.phase,
    );
    return TimerTransition(
      _nextPhase(state, config),
      completedSession: completed,
    );
  }

  /// Accepts the break offered after a completed focus session.
  static TimerTransition startBreak(
    TimerSnapshot state, {
    required DateTime now,
    TimerConfig config = const TimerConfig(),
  }) {
    if (!state.isBreakOffer) return TimerTransition(state);
    return TimerTransition(
      TimerSnapshot(
        phase: state.phase,
        status: TimerStatus.running,
        remaining: config.durationFor(state.phase),
        completedRounds: state.completedRounds,
        phaseStartedAt: now,
      ),
    );
  }

  /// Declines the offered break (or aborts an active one) and returns to idle.
  static TimerTransition skipBreak(
    TimerSnapshot state, {
    TimerConfig config = const TimerConfig(),
  }) {
    if (state.phase == SessionType.work && !state.isBreakOffer) {
      return TimerTransition(state);
    }
    return TimerTransition(
      initial(config: config).copyWith(completedRounds: state.completedRounds),
    );
  }

  /// Ends a focus session early. A partial session is only logged when at
  /// least a minute was focused and strict mode is off.
  static TimerTransition stop(
    TimerSnapshot state, {
    required DateTime now,
    TimerConfig config = const TimerConfig(),
  }) {
    if (state.phase != SessionType.work ||
        (!state.isRunning && !state.isPaused)) {
      return TimerTransition(state);
    }

    FocusSession? partial;
    if (!config.strictMode && state.elapsed >= _minimumLoggedSeconds) {
      final plannedSeconds = config.focusDuration.inSeconds;
      final percentage = plannedSeconds == 0
          ? 0
          : ((state.elapsed.inSeconds * 100) ~/ plannedSeconds).clamp(0, 100);
      partial = FocusSession(
        startTime: state.phaseStartedAt ?? now.subtract(state.elapsed),
        endTime: now,
        plannedDuration: config.focusDuration,
        actualDuration: state.elapsed,
        sessionType: SessionType.work,
        completed: false,
        completionPercentage: percentage,
      );
    }

    return TimerTransition(
      initial(config: config).copyWith(completedRounds: state.completedRounds),
      completedSession: partial,
    );
  }

  static TimerSnapshot _nextPhase(TimerSnapshot state, TimerConfig config) {
    switch (state.phase) {
      case SessionType.work:
        final rounds = state.completedRounds + 1;
        final isLongBreak = rounds % config.roundsBeforeLongBreak == 0;
        final phase = isLongBreak
            ? SessionType.longBreak
            : SessionType.shortBreak;
        return TimerSnapshot(
          phase: phase,
          status: TimerStatus.breakOffer,
          remaining: config.durationFor(phase),
          completedRounds: rounds,
        );
      case SessionType.shortBreak:
      case SessionType.longBreak:
        return initial(config: config).copyWith(
          completedRounds: state.completedRounds,
        );
    }
  }
}
