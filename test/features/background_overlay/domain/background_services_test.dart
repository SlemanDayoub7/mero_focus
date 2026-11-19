import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/background_overlay/domain/entities/overlay_timer_data.dart';
import 'package:mero_focus/features/background_overlay/domain/repositories/background_services.dart';

void main() {
  group('BackgroundSessionPolicy', () {
    test('the foreground service follows the timer state', () {
      expect(
        BackgroundSessionPolicy.shouldRunForegroundService(timerRunning: true),
        isTrue,
      );
      expect(
        BackgroundSessionPolicy.shouldRunForegroundService(timerRunning: false),
        isFalse,
      );
    });

    test('the overlay requires both a running timer and a backgrounded app',
        () {
      expect(
        BackgroundSessionPolicy.shouldShowOverlay(
          timerRunning: true,
          appInBackground: true,
        ),
        isTrue,
      );
      expect(
        BackgroundSessionPolicy.shouldShowOverlay(
          timerRunning: true,
          appInBackground: false,
        ),
        isFalse,
      );
      expect(
        BackgroundSessionPolicy.shouldShowOverlay(
          timerRunning: false,
          appInBackground: true,
        ),
        isFalse,
      );
    });
  });

  group('OverlayTimerData', () {
    test('serializes for the overlay isolate and parses back', () {
      const data = OverlayTimerData(
        remainingSeconds: 125,
        phaseLabel: 'Focus',
        timeLabel: 'Time remaining',
      );

      final parsed = OverlayTimerData.fromJson(data.toJson());

      expect(parsed, isNotNull);
      expect(parsed!.remainingSeconds, 125);
      expect(parsed.phaseLabel, 'Focus');
      expect(parsed.timeLabel, 'Time remaining');
      expect(parsed.formattedTime, '02:05');
    });

    test('rejects malformed overlay payloads', () {
      expect(OverlayTimerData.fromJson(null), isNull);
      expect(OverlayTimerData.fromJson(<String, Object?>{'remainingSeconds': 1}), isNull);
    });
  });
}
