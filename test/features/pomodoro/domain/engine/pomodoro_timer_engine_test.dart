import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/constants/defaults.dart';
import 'package:mero_focus/features/pomodoro/domain/engine/pomodoro_timer_engine.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/session_type.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/timer_snapshot.dart';

void main() {
  group('PomodoroTimerEngine', () {
    test('initial state is an idle work phase at the configured duration', () {
      final state = PomodoroTimerEngine.initial();

      expect(state.phase, SessionType.work);
      expect(state.status, TimerStatus.idle);
      expect(state.remaining, const Duration(seconds: AppDefaults.workDurationSec));
      expect(state.completedRounds, 0);
      expect(state.isRunning, isFalse);
    });

    test('start and pause only change status', () {
      final initial = PomodoroTimerEngine.initial();

      final started = PomodoroTimerEngine.start(initial).snapshot;
      expect(started.status, TimerStatus.running);
      expect(started.remaining, initial.remaining);
      expect(started.completedRounds, initial.completedRounds);

      final paused = PomodoroTimerEngine.pause(started).snapshot;
      expect(paused.status, TimerStatus.paused);
      expect(paused.remaining, initial.remaining);

      // Repeated events are idempotent.
      expect(
        PomodoroTimerEngine.start(started).snapshot.remaining,
        initial.remaining,
      );
      expect(
        PomodoroTimerEngine.pause(paused).snapshot.status,
        TimerStatus.paused,
      );
    });

    test('reset restores the work phase but keeps completed rounds', () {
      final state = PomodoroTimerEngine.initial().copyWith(
        phase: SessionType.shortBreak,
        status: TimerStatus.running,
        remaining: const Duration(seconds: 12),
        completedRounds: 2,
      );

      final reset = PomodoroTimerEngine.reset(state).snapshot;

      expect(reset.phase, SessionType.work);
      expect(reset.status, TimerStatus.idle);
      expect(reset.remaining, const Duration(seconds: AppDefaults.workDurationSec));
      expect(reset.completedRounds, 2);
    });

    test('tick decrements remaining by one second while running', () {
      final state = PomodoroTimerEngine.initial().copyWith(
        status: TimerStatus.running,
      );

      final transition = PomodoroTimerEngine.tick(
        state,
        now: DateTime(2026, 1, 1),
      );

      expect(transition.completedSession, isNull);
      expect(
        transition.snapshot.remaining,
        const Duration(seconds: AppDefaults.workDurationSec - 1),
      );
      expect(transition.snapshot.status, TimerStatus.running);
    });

    test('tick is a no-op while idle or paused', () {
      for (final status in [TimerStatus.idle, TimerStatus.paused]) {
        final state = PomodoroTimerEngine.initial().copyWith(status: status);
        final transition = PomodoroTimerEngine.tick(
          state,
          now: DateTime(2026, 1, 1),
        );
        expect(transition.snapshot, same(state));
        expect(transition.completedSession, isNull);
      }
    });

    test('completing work records a session and starts a short break', () {
      final now = DateTime(2026, 1, 1, 12);
      final almostDone = PomodoroTimerEngine.initial().copyWith(
        status: TimerStatus.running,
        remaining: const Duration(seconds: 1),
      );

      final transition = PomodoroTimerEngine.tick(almostDone, now: now);

      final session = transition.completedSession!;
      expect(session.sessionType, SessionType.work);
      expect(session.startTime, now.subtract(SessionType.work.duration));
      expect(session.endTime, now);
      expect(session.plannedDuration, SessionType.work.duration);
      expect(session.actualDuration, SessionType.work.duration);
      expect(session.completed, isTrue);
      expect(session.completionPercentage, 100);

      expect(transition.snapshot.phase, SessionType.shortBreak);
      expect(transition.snapshot.status, TimerStatus.idle);
      expect(transition.snapshot.remaining, SessionType.shortBreak.duration);
      expect(transition.snapshot.completedRounds, 1);
    });

    test('the fourth work session starts a long break', () {
      final almostDone = PomodoroTimerEngine.initial().copyWith(
        status: TimerStatus.running,
        remaining: const Duration(seconds: 1),
        completedRounds: AppDefaults.roundsBeforeLongBreak - 1,
      );

      final transition = PomodoroTimerEngine.tick(
        almostDone,
        now: DateTime(2026, 1, 1),
      );

      expect(transition.snapshot.phase, SessionType.longBreak);
      expect(transition.snapshot.completedRounds, AppDefaults.roundsBeforeLongBreak);
      expect(transition.snapshot.remaining, SessionType.longBreak.duration);
      expect(transition.completedSession?.sessionType, SessionType.work);
    });

    test('a completed break returns to work without incrementing rounds', () {
      final almostDone = PomodoroTimerEngine.initial().copyWith(
        phase: SessionType.longBreak,
        status: TimerStatus.running,
        remaining: const Duration(seconds: 1),
        completedRounds: 4,
      );

      final transition = PomodoroTimerEngine.tick(
        almostDone,
        now: DateTime(2026, 1, 1),
      );

      expect(transition.snapshot.phase, SessionType.work);
      expect(transition.snapshot.completedRounds, 4);
      expect(transition.snapshot.remaining, SessionType.work.duration);
      expect(transition.completedSession?.sessionType, SessionType.longBreak);
    });

    test('phase storage values round-trip', () {
      for (final phase in SessionType.values) {
        expect(SessionType.fromStorage(phase.storageValue), phase);
      }
    });
  });
}
