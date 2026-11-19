import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/background_overlay/domain/entities/overlay_timer_data.dart';
import 'package:mero_focus/features/background_overlay/presentation/controllers/background_session_controller.dart';

import '../../helpers/fake_background_services.dart';

void main() {
  late ProviderContainer container;
  late FakeForegroundTimerService foreground;
  late FakeFloatingOverlayService overlay;
  late FakeBatteryOptimizationService battery;
  late BackgroundSessionController controller;

  setUp(() {
    foreground = FakeForegroundTimerService();
    overlay = FakeFloatingOverlayService();
    battery = FakeBatteryOptimizationService();
    container = ProviderContainer(
      overrides: [
        foregroundTimerServiceProvider.overrideWithValue(foreground),
        floatingOverlayServiceProvider.overrideWithValue(overlay),
        batteryOptimizationServiceProvider.overrideWithValue(battery),
      ],
    );
    controller = container.read(backgroundSessionProvider.notifier);
  });

  tearDown(() => container.dispose());

  Future<void> sync({required bool running, required bool backgrounded}) =>
      controller.sync(
        timerRunning: running,
        appInBackground: backgrounded,
        notificationTitle: 'Focus session running',
        notificationText: 'Tap to return',
        overlayData: const OverlayTimerData(
          remainingSeconds: 60,
          phaseLabel: 'Focus',
          timeLabel: 'Time remaining',
        ),
      );

  test('initial state has no service or overlay', () {
    final state = container.read(backgroundSessionProvider);
    expect(state.serviceRunning, isFalse);
    expect(state.overlayVisible, isFalse);
    expect(state.hasError, isFalse);
  });

  test('a running timer starts the foreground service exactly once', () async {
    await sync(running: true, backgrounded: false);
    await sync(running: true, backgrounded: false);

    expect(foreground.startCalls, 1);
    expect(foreground.lastTitle, 'Focus session running');
    expect(overlay.showCalls, 0);
    expect(container.read(backgroundSessionProvider).serviceRunning, isTrue);
  });

  test('backgrounding shows the overlay and ticks only update it', () async {
    await sync(running: true, backgrounded: false);
    await sync(running: true, backgrounded: true);
    await sync(running: true, backgrounded: true);

    expect(overlay.showCalls, 1);
    expect(overlay.updateCalls, 1);
    expect(overlay.lastData?.remainingSeconds, 60);
    expect(container.read(backgroundSessionProvider).overlayVisible, isTrue);
  });

  test('returning to the foreground closes the overlay but keeps the service',
      () async {
    await sync(running: true, backgrounded: true);
    await sync(running: true, backgrounded: false);

    expect(overlay.closeCalls, 1);
    expect(foreground.stopCalls, 0);
    expect(container.read(backgroundSessionProvider).overlayVisible, isFalse);
    expect(container.read(backgroundSessionProvider).serviceRunning, isTrue);
  });

  test('stopping the timer stops the foreground service', () async {
    await sync(running: true, backgrounded: true);
    await sync(running: false, backgrounded: false);

    expect(foreground.stopCalls, 1);
    expect(overlay.closeCalls, 1);
    final state = container.read(backgroundSessionProvider);
    expect(state.serviceRunning, isFalse);
    expect(state.overlayVisible, isFalse);
  });

  test('a failed foreground start is reported without showing the overlay',
      () async {
    foreground.startSucceeds = false;

    await sync(running: true, backgrounded: true);

    final state = container.read(backgroundSessionProvider);
    expect(state.lastError, 'foreground_start_failed');
    expect(overlay.showCalls, 0);
  });

  test('permission requests update their providers', () async {
    expect(await container.read(overlayPermissionGrantedProvider.future), isFalse);
    expect(
      await container.read(batteryExemptionGrantedProvider.future),
      isFalse,
    );

    expect(await controller.requestOverlayPermission(), isTrue);
    expect(await controller.requestBatteryExemption(), isTrue);

    await container.pump();
    expect(await container.read(overlayPermissionGrantedProvider.future), isTrue);
    expect(await container.read(batteryExemptionGrantedProvider.future), isTrue);
    expect(battery.requestCalls, 1);
  });
}
