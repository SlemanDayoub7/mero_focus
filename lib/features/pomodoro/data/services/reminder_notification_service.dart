import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/entities/scheduled_item.dart';

final reminderServiceProvider = Provider<ReminderNotificationService>((ref) {
  final service = ReminderNotificationService();
  ref.onDispose(service.dispose);
  return service;
});

/// Local (offline) notifications for study reminders. Every call swallows
/// platform errors: a missing permission or plugin must never crash the app.
class ReminderNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<String> _taps = StreamController<String>.broadcast();

  Future<void>? _initFuture;
  Future<void>? _chain;

  /// Payloads of notifications the user tapped while the app was running.
  Stream<String> get taps => _taps.stream;

  Future<void> init() => _initFuture ??= _doInit();

  Future<void> _doInit() async {
    try {
      await _plugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (payload != null && !_taps.isClosed) _taps.add(payload);
        },
      );
    } catch (_) {}
  }

  /// Payload of the notification that launched the app from a closed state.
  Future<String?> launchPayload() async {
    try {
      await init();
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details != null && details.didNotificationLaunchApp) {
        return details.notificationResponse?.payload;
      }
    } catch (_) {}
    return null;
  }

  Future<bool> notificationsEnabled() async {
    try {
      await init();
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.areNotificationsEnabled() ?? true;
    } catch (_) {
      return true;
    }
  }

  Future<bool> requestPermission() async {
    try {
      await init();
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? true;
    } catch (_) {
      return false;
    }
  }

  /// Replaces every pending notification with [items]. Calls are queued so
  /// two refreshes can never interleave.
  Future<void> replaceAll(
    List<ScheduledItem> items, {
    required String channelName,
    required String channelDescription,
  }) {
    final previous = _chain ?? Future<void>.value();
    final next = previous.then(
      (_) => _replace(items, channelName, channelDescription),
    );
    _chain = next;
    return next;
  }

  Future<void> _replace(
    List<ScheduledItem> items,
    String channelName,
    String channelDescription,
  ) async {
    try {
      await init();
      final pending = await _plugin.pendingNotificationRequests();
      for (final request in pending) {
        await _plugin.cancel(request.id);
      }

      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          'study_reminders',
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      );
      for (final item in items) {
        // Absolute instant: correct whatever the device time zone is.
        await _plugin.zonedSchedule(
          item.id,
          item.title,
          item.body,
          tz.TZDateTime.from(item.when, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: item.payload,
        );
      }
    } catch (_) {}
  }

  void dispose() {
    unawaited(_taps.close());
  }
}
