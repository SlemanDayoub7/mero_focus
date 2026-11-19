import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/observability/analytics_tracker.dart';
import 'package:mero_focus/core/observability/crash_reporter.dart';

void main() {
  test('no-op crash reporter accepts errors without throwing', () {
    const reporter = NoOpCrashReporter();

    expect(
      () => reporter.recordError(
        StateError('boom'),
        StackTrace.empty,
        context: 'test',
      ),
      returnsNormally,
    );
  });

  test('no-op analytics tracker accepts events without throwing', () {
    const tracker = NoOpAnalyticsTracker();

    expect(
      () => tracker.logEvent('screen_view', parameters: {'name': 'home'}),
      returnsNormally,
    );
    expect(() => tracker.setCurrentScreen('home'), returnsNormally);
  });
}
