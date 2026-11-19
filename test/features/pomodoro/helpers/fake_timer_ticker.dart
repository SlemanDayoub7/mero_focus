import 'package:mero_focus/features/pomodoro/data/services/timer_ticker.dart';

/// Controllable tick source for controller and widget tests.
class FakeTimerTicker implements TimerTicker {
  void Function()? _onTick;
  bool _isRunning = false;
  int startCount = 0;
  int stopCount = 0;

  @override
  bool get isRunning => _isRunning;

  @override
  void start(void Function() onTick) {
    _isRunning = true;
    _onTick = onTick;
    startCount++;
  }

  @override
  void stop() {
    _isRunning = false;
    _onTick = null;
    stopCount++;
  }

  /// Simulates one one-second tick from the platform-agnostic source.
  void fireTick() => _onTick?.call();
}
