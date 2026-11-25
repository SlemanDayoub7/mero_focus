import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/battery_optimization_service_impl.dart';
import '../../data/services/floating_overlay_service_impl.dart';
import '../../data/services/foreground_timer_service_impl.dart';
import '../../domain/entities/overlay_timer_data.dart';
import '../../domain/repositories/background_services.dart';

final foregroundTimerServiceProvider = Provider<ForegroundTimerService>((ref) {
  return ForegroundTimerServiceImpl();
});

// Stateful (remembers whether it opened an overlay), so not const.
final floatingOverlayServiceProvider = Provider<FloatingOverlayService>((ref) {
  return FloatingOverlayServiceImpl();
});

final batteryOptimizationServiceProvider =
    Provider<BatteryOptimizationService>((ref) {
  return const BatteryOptimizationServiceImpl();
});

final overlayPermissionGrantedProvider = FutureProvider<bool>((ref) {
  return ref.watch(floatingOverlayServiceProvider).isPermissionGranted();
});

final batteryExemptionGrantedProvider = FutureProvider<bool>((ref) {
  return ref.watch(batteryOptimizationServiceProvider).isExempt();
});

/// Whether the user wants the floating timer over other apps. Off by
/// default: the notification already shows the live time, and the overlay
/// permission is only requested when the user switches this on.
final overlayEnabledProvider = NotifierProvider<OverlayEnabledNotifier, bool>(
  OverlayEnabledNotifier.new,
);

class OverlayEnabledNotifier extends Notifier<bool> {
  static const String _key = 'overlay_enabled';
  bool _disposed = false;

  @override
  bool build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(_load());
    return false;
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed) return;
      state = prefs.getBool(_key) ?? false;
    } catch (_) {}
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}

class BackgroundSessionState {
  const BackgroundSessionState({
    this.serviceRunning = false,
    this.overlayVisible = false,
    this.lastError,
  });

  final bool serviceRunning;
  final bool overlayVisible;
  final String? lastError;

  bool get hasError => lastError != null;

  BackgroundSessionState copyWith({
    bool? serviceRunning,
    bool? overlayVisible,
    String? lastError,
    bool clearError = false,
  }) {
    return BackgroundSessionState(
      serviceRunning: serviceRunning ?? this.serviceRunning,
      overlayVisible: overlayVisible ?? this.overlayVisible,
      lastError: clearError ? null : lastError ?? this.lastError,
    );
  }
}

final backgroundSessionProvider =
    NotifierProvider<BackgroundSessionController, BackgroundSessionState>(
  BackgroundSessionController.new,
);

/// Coordinates the foreground service and floating window with the timer and
/// app lifecycle. All platform calls go through the ports above, so tests can
/// drive the coordinator with fakes.
class BackgroundSessionController extends Notifier<BackgroundSessionState> {
  Future<void>? _inFlight;

  @override
  BackgroundSessionState build() => const BackgroundSessionState();

  /// Serializes syncs so a tick arriving during a platform call cannot start
  /// two services or two overlays at once.
  Future<void> sync({
    required bool timerRunning,
    required bool appInBackground,
    required String notificationTitle,
    required String notificationText,
    required OverlayTimerData overlayData,
  }) {
    final previous = _inFlight ?? Future<void>.value();
    final next = previous.then(
      (_) => _sync(
        timerRunning: timerRunning,
        appInBackground: appInBackground,
        notificationTitle: notificationTitle,
        notificationText: notificationText,
        overlayData: overlayData,
      ),
    );
    _inFlight = next;
    return next;
  }

  Future<void> _sync({
    required bool timerRunning,
    required bool appInBackground,
    required String notificationTitle,
    required String notificationText,
    required OverlayTimerData overlayData,
  }) async {
    final foreground = ref.read(foregroundTimerServiceProvider);
    final overlay = ref.read(floatingOverlayServiceProvider);

    try {
      final shouldRun = BackgroundSessionPolicy.shouldRunForegroundService(
        timerRunning: timerRunning,
      );
      if (shouldRun && !state.serviceRunning) {
        if (!await foreground.start(
          notificationTitle: notificationTitle,
          notificationText: notificationText,
        )) {
          state = state.copyWith(lastError: 'foreground_start_failed');
          return;
        }
        state = state.copyWith(serviceRunning: true, clearError: true);
      } else if (shouldRun) {
        // Keep the notification showing the live time.
        await foreground.update(
          notificationTitle: notificationTitle,
          notificationText: notificationText,
        );
      } else if (state.serviceRunning) {
        await foreground.stop();
        state = state.copyWith(serviceRunning: false, clearError: true);
      }

      final shouldShow =
          ref.read(overlayEnabledProvider) &&
          BackgroundSessionPolicy.shouldShowOverlay(
            timerRunning: timerRunning,
            appInBackground: appInBackground,
          );
      if (shouldShow && !state.overlayVisible) {
        final shown = await overlay.show(
          notificationTitle: notificationTitle,
          notificationText: notificationText,
          data: overlayData,
        );
        state = state.copyWith(overlayVisible: shown);
      } else if (shouldShow && state.overlayVisible) {
        final stillThere = await overlay.update(overlayData);
        if (!stillThere) state = state.copyWith(overlayVisible: false);
      } else if (!shouldShow && state.overlayVisible) {
        await overlay.close();
        state = state.copyWith(overlayVisible: false);
      }
    } catch (error) {
      state = state.copyWith(lastError: error.toString());
    }
  }

  Future<bool> requestOverlayPermission() async {
    final granted =
        await ref.read(floatingOverlayServiceProvider).requestPermission();
    ref.invalidate(overlayPermissionGrantedProvider);
    return granted;
  }

  Future<bool> requestBatteryExemption() async {
    final granted =
        await ref.read(batteryOptimizationServiceProvider).requestExemption();
    ref.invalidate(batteryExemptionGrantedProvider);
    return granted;
  }
}
