import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/constants/defaults.dart';
import 'package:mero_focus/core/database/app_database.dart';
import 'package:mero_focus/core/di/core_providers.dart';
import 'package:mero_focus/features/pomodoro/data/services/timer_ticker.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/session_type.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/timer_snapshot.dart';
import 'package:mero_focus/features/pomodoro/presentation/controllers/pomodoro_timer_controller.dart';

import '../../helpers/fake_timer_ticker.dart';

void main() {
  late ProviderContainer container;
  late FakeTimerTicker ticker;
  late AppDatabase database;
  late PomodoroTimerController controller;

  setUp(() {
    ticker = FakeTimerTicker();
    database = AppDatabase.forTesting();
    container = ProviderContainer(
      overrides: [
        timerTickerProvider.overrideWithValue(ticker),
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    controller = container.read(pomodoroTimerProvider.notifier);
  });

  tearDown(() {
    container.dispose();
    database.close();
  });

  TimerSnapshot state() => container.read(pomodoroTimerProvider);

  /// Seeds a near-complete running state through Riverpod's testing hook.
  void seedAlmostDone({SessionType phase = SessionType.work, int rounds = 0}) {
    // ignore: invalid_use_of_protected_member
    controller.state = TimerSnapshot(
      phase: phase,
      status: TimerStatus.running,
      remaining: const Duration(seconds: 1),
      completedRounds: rounds,
    );
  }

  test('starts idle and does not tick until started', () {
    expect(state().phase, SessionType.work);
    expect(state().isRunning, isFalse);
    expect(ticker.isRunning, isFalse);

    ticker.fireTick();
    expect(state().remaining, SessionType.work.duration);
  });

  test('start starts the ticker and pause stops it', () {
    controller.start();
    expect(state().isRunning, isTrue);
    expect(ticker.isRunning, isTrue);
    expect(ticker.startCount, 1);

    controller.pause();
    expect(state().status, TimerStatus.paused);
    expect(ticker.isRunning, isFalse);
    expect(ticker.stopCount, 1);
  });

  test('a tick decrements the remaining time', () {
    controller.start();
    ticker.fireTick();

    expect(
      state().remaining,
      const Duration(seconds: AppDefaults.workDurationSec - 1),
    );
  });

  test('completing a phase persists a session and advances the phase', () async {
    controller.start();
    seedAlmostDone();

    ticker.fireTick();

    expect(state().phase, SessionType.shortBreak);
    expect(state().completedRounds, 1);
    expect(ticker.isRunning, isFalse);

    final sessions = await container
        .read(pomodoroRepositoryProvider)
        .getSessions();
    expect(sessions, hasLength(1));
    expect(sessions.single.sessionType, SessionType.work);
  });

  test('reset restores the work phase and stops the ticker', () {
    controller.start();
    seedAlmostDone(phase: SessionType.shortBreak, rounds: 2);

    controller.reset();

    expect(state().phase, SessionType.work);
    expect(state().status, TimerStatus.idle);
    expect(state().remaining, SessionType.work.duration);
    expect(state().completedRounds, 2);
    expect(ticker.isRunning, isFalse);
  });

  test('disposing the controller stops the ticker', () {
    controller.start();
    expect(ticker.isRunning, isTrue);

    container.dispose();
    expect(ticker.isRunning, isFalse);
  });
}
