import 'package:mero_focus/features/background_overlay/domain/entities/overlay_timer_data.dart';
import 'package:mero_focus/features/background_overlay/domain/repositories/background_services.dart';

class FakeForegroundTimerService implements ForegroundTimerService {
  bool _running = false;
  int startCalls = 0;
  int stopCalls = 0;
  bool startSucceeds = true;
  String? lastTitle;
  String? lastText;

  @override
  Future<bool> initialize() async => true;

  @override
  Future<bool> start({
    required String notificationTitle,
    required String notificationText,
  }) async {
    startCalls++;
    lastTitle = notificationTitle;
    lastText = notificationText;
    if (!startSucceeds) return false;
    _running = true;
    return true;
  }

  @override
  Future<bool> stop() async {
    stopCalls++;
    _running = false;
    return true;
  }

  @override
  Future<bool> get isRunning async => _running;
}

class FakeFloatingOverlayService implements FloatingOverlayService {
  bool _active = false;
  bool permissionGranted = false;
  int showCalls = 0;
  int updateCalls = 0;
  int closeCalls = 0;
  OverlayTimerData? lastData;

  @override
  Future<bool> isPermissionGranted() async => permissionGranted;

  @override
  Future<bool> requestPermission() async {
    permissionGranted = true;
    return true;
  }

  @override
  Future<bool> show({
    required String notificationTitle,
    required String notificationText,
    required OverlayTimerData data,
  }) async {
    showCalls++;
    lastData = data;
    _active = true;
    return true;
  }

  @override
  Future<bool> update(OverlayTimerData data) async {
    updateCalls++;
    lastData = data;
    return true;
  }

  @override
  Future<bool> close() async {
    closeCalls++;
    _active = false;
    return true;
  }

  @override
  Future<bool> get isActive async => _active;
}

class FakeBatteryOptimizationService implements BatteryOptimizationService {
  bool exempt = false;
  int requestCalls = 0;

  @override
  Future<bool> isExempt() async => exempt;

  @override
  Future<bool> requestExemption() async {
    requestCalls++;
    exempt = true;
    return true;
  }
}
