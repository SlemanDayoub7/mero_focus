import 'focus_session.dart';
import 'timer_snapshot.dart';

/// Result of applying an event to the timer: the new state plus an optional
/// session that must be persisted (when a phase just completed).
class TimerTransition {
  const TimerTransition(this.snapshot, {this.completedSession});

  final TimerSnapshot snapshot;
  final FocusSession? completedSession;
}
