import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../../domain/repositories/background_services.dart';

/// Uses the foreground-task plugin's Android helpers, which issue
/// `ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` / open the OEM settings screen.
class BatteryOptimizationServiceImpl implements BatteryOptimizationService {
  const BatteryOptimizationServiceImpl();

  @override
  Future<bool> isExempt() =>
      FlutterForegroundTask.isIgnoringBatteryOptimizations;

  @override
  Future<bool> requestExemption() =>
      FlutterForegroundTask.requestIgnoreBatteryOptimization();
}
