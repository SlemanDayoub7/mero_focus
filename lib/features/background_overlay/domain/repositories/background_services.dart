import '../entities/overlay_timer_data.dart';

/// Platform-agnostic port for the Android foreground service (ADR-0009).
abstract class ForegroundTimerService {
  Future<bool> initialize();

  Future<bool> start({
    required String notificationTitle,
    required String notificationText,
  });

  Future<bool> stop();

  Future<bool> get isRunning;
}

/// Platform-agnostic port for the floating timer window.
abstract class FloatingOverlayService {
  Future<bool> isPermissionGranted();

  Future<bool> requestPermission();

  Future<bool> show({
    required String notificationTitle,
    required String notificationText,
    required OverlayTimerData data,
  });

  Future<bool> update(OverlayTimerData data);

  Future<bool> close();

  Future<bool> get isActive;
}

/// Platform-agnostic port for the battery-optimization exemption flow.
abstract class BatteryOptimizationService {
  Future<bool> isExempt();

  /// Opens the system dialog/settings for
  /// `ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`.
  Future<bool> requestExemption();
}

/// Pure decision rules for coordinating the timer with app lifecycle.
abstract final class BackgroundSessionPolicy {
  static bool shouldRunForegroundService({required bool timerRunning}) =>
      timerRunning;

  static bool shouldShowOverlay({
    required bool timerRunning,
    required bool appInBackground,
  }) =>
      timerRunning && appInBackground;
}
