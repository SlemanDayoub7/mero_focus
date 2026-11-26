import 'session_type.dart';

/// Lifecycle of the current timer phase.
enum TimerStatus { idle, running, paused, breakOffer }

/// Immutable view of the timer at a point in time.
///
/// [remaining] is meaningful in countdown mode. [elapsed] is meaningful in
/// count-up focus mode. The engine keeps both consistent so the UI can render
/// either without extra state.
class TimerSnapshot {
  const TimerSnapshot({
    required this.phase,
    required this.status,
    required this.remaining,
    required this.completedRounds,
    this.elapsed = Duration.zero,
    this.phaseStartedAt,
  });

  final SessionType phase;
  final TimerStatus status;
  final Duration remaining;
  final int completedRounds;

  /// Time accumulated in the current phase (advanced every running tick).
  final Duration elapsed;

  /// Wall-clock time when the current phase first started running.
  /// Preserved across pause/resume; cleared when a new phase begins.
  final DateTime? phaseStartedAt;

  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;
  bool get isBreakOffer => status == TimerStatus.breakOffer;

  TimerSnapshot copyWith({
    SessionType? phase,
    TimerStatus? status,
    Duration? remaining,
    int? completedRounds,
    Duration? elapsed,
    DateTime? phaseStartedAt,
    bool clearPhaseStartedAt = false,
  }) {
    return TimerSnapshot(
      phase: phase ?? this.phase,
      status: status ?? this.status,
      remaining: remaining ?? this.remaining,
      completedRounds: completedRounds ?? this.completedRounds,
      elapsed: elapsed ?? this.elapsed,
      phaseStartedAt: clearPhaseStartedAt
          ? null
          : (phaseStartedAt ?? this.phaseStartedAt),
    );
  }
}
