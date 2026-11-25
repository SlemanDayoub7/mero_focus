import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../../domain/repositories/background_services.dart';
import 'foreground_task_callback.dart';

/// Wraps `flutter_foreground_task` behind the app's own port (ADR-0009).
class ForegroundTimerServiceImpl implements ForegroundTimerService {
  ForegroundTimerServiceImpl();

  static const int serviceId = 1001;
  static const String notificationChannelId = 'pomodoro_timer';

  bool _initialized = false;

  @override
  Future<bool> initialize() async {
    if (_initialized) return true;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: notificationChannelId,
        channelName: 'Focus timer',
        channelDescription: 'Keeps the focus timer running in the background.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        // The countdown lives in the main isolate; the service only keeps the
        // process alive, so no repeating callback is needed.
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
    _initialized = true;
    return true;
  }

  @override
  Future<bool> start({
    required String notificationTitle,
    required String notificationText,
  }) async {
    await initialize();
    if (await isRunning) return true;
    final result = await FlutterForegroundTask.startService(
      serviceId: serviceId,
      serviceTypes: const [ForegroundServiceTypes.specialUse],
      notificationTitle: notificationTitle,
      notificationText: notificationText,
      notificationInitialRoute: '/',
      callback: foregroundTaskCallback,
    );
    return result is ServiceRequestSuccess;
  }

  @override
  Future<bool> update({
    required String notificationTitle,
    required String notificationText,
  }) async {
    final result = await FlutterForegroundTask.updateService(
      notificationTitle: notificationTitle,
      notificationText: notificationText,
    );
    return result is ServiceRequestSuccess;
  }

  @override
  Future<bool> stop() async {
    if (!await isRunning) return true;
    final result = await FlutterForegroundTask.stopService();
    return result is ServiceRequestSuccess;
  }

  @override
  Future<bool> get isRunning => FlutterForegroundTask.isRunningService;
}
