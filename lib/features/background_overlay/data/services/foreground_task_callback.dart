import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Entry point invoked in the foreground-service isolate.
///
/// The service exists to keep the app process alive; the timer itself keeps
/// running in the main isolate, so this handler intentionally does no work.
@pragma('vm:entry-point')
void foregroundTaskCallback() {
  FlutterForegroundTask.setTaskHandler(KeepAliveTaskHandler());
}

class KeepAliveTaskHandler extends TaskHandler {

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}
}
