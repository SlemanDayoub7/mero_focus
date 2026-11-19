import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/battery_optimization_service_impl.dart';
import '../../data/services/floating_overlay_service_impl.dart';
import '../../data/services/foreground_timer_service_impl.dart';
import '../../domain/entities/overlay_timer_data.dart';
import '../../domain/repositories/background_services.dart';

final foregroundTimerServiceProvider = Provider<ForegroundTimerService>((ref) {
  return ForegroundTimerServiceImpl();
});

final floatingOverlayServiceProvider = Provider<FloatingOverlayService>((ref) {
  return const FloatingOverlayServiceImpl();
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
      } else if (!shouldRun && state.serviceRunning) {
        await foreground.stop();
        state = state.copyWith(serviceRunning: false, clearError: true);
      }

      final shouldShow = BackgroundSessionPolicy.shouldShowOverlay(
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
        await overlay.update(overlayData);
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
