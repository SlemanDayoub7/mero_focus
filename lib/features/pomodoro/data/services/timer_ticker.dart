import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstraction over the one-second tick source, so controller tests can drive
/// ticks deterministically without waiting on real time (ADR-friendly DI).
abstract class TimerTicker {
  bool get isRunning;

  void start(void Function() onTick);

  void stop();
}

/// Production ticker backed by [Timer.periodic].
class PeriodicTimerTicker implements TimerTicker {
  Timer? _timer;

  @override
  bool get isRunning => _timer != null;

  @override
  void start(void Function() onTick) {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => onTick());
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}

final timerTickerProvider = Provider<TimerTicker>((ref) {
  return PeriodicTimerTicker();
});
