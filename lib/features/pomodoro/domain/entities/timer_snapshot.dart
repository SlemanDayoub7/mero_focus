import 'session_type.dart';

/// Lifecycle of the current timer phase.
enum TimerStatus { idle, running, paused }

/// Immutable view of the timer at a point in time.
class TimerSnapshot {
  const TimerSnapshot({
    required this.phase,
    required this.status,
    required this.remaining,
    required this.completedRounds,
  });

  final SessionType phase;
  final TimerStatus status;
  final Duration remaining;
  final int completedRounds;

  bool get isRunning => status == TimerStatus.running;

  TimerSnapshot copyWith({
    SessionType? phase,
    TimerStatus? status,
    Duration? remaining,
    int? completedRounds,
  }) {
    return TimerSnapshot(
      phase: phase ?? this.phase,
      status: status ?? this.status,
      remaining: remaining ?? this.remaining,
      completedRounds: completedRounds ?? this.completedRounds,
    );
  }
}
