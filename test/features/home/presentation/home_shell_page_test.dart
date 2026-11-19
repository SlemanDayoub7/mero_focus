import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/app.dart';
import 'package:mero_focus/core/database/app_database.dart';
import 'package:mero_focus/core/di/core_providers.dart';
import 'package:mero_focus/features/background_overlay/presentation/controllers/background_session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../background_overlay/helpers/fake_background_services.dart';

void main() {
  late ProviderContainer container;
  late AppDatabase database;
  late FakeForegroundTimerService foreground;
  late FakeFloatingOverlayService overlay;
  late FakeBatteryOptimizationService battery;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    database = AppDatabase.forTesting();
    foreground = FakeForegroundTimerService();
    overlay = FakeFloatingOverlayService();
    battery = FakeBatteryOptimizationService();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        appDatabaseProvider.overrideWithValue(database),
        foregroundTimerServiceProvider.overrideWithValue(foreground),
        floatingOverlayServiceProvider.overrideWithValue(overlay),
        batteryOptimizationServiceProvider.overrideWithValue(battery),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    database.close();
  });

  testWidgets(
    'bottom navigation labels follow the locale change without tapping a destination',
    (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MeroFocusApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('بومودورو'), findsWidgets);
      expect(find.text('المراجعة'), findsWidgets);
      expect(find.text('Pomodoro'), findsNothing);
      expect(find.text('Review'), findsNothing);

      await container.read(localeProvider.notifier).setLocale(const Locale('en'));
      await tester.pumpAndSettle();

      expect(find.text('Pomodoro'), findsWidgets);
      expect(find.text('Review'), findsWidgets);
      expect(find.text('بومودورو'), findsNothing);
      expect(find.text('المراجعة'), findsNothing);
    },
  );

  testWidgets('the pomodoro tab shows the timer', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MeroFocusApp(),
      ),
    );
    await tester.pumpAndSettle();

    // The timer is the first destination and is built by IndexedStack.
    expect(find.text('25:00'), findsOneWidget);
    // Default locale is Arabic; the timer controls must follow it.
    expect(find.text('ابدأ'), findsOneWidget);
  });
}
