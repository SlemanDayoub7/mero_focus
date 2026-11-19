import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/database/app_database.dart';
import 'package:mero_focus/core/di/core_providers.dart';
import 'package:mero_focus/features/background_overlay/presentation/controllers/background_session_controller.dart';
import 'package:mero_focus/features/pomodoro/data/services/timer_ticker.dart';
import 'package:mero_focus/features/pomodoro/presentation/pages/pomodoro_timer_page.dart';
import 'package:mero_focus/l10n/app_localizations.dart';

import '../../../background_overlay/helpers/fake_background_services.dart';
import '../../helpers/fake_timer_ticker.dart';

void main() {
  late FakeTimerTicker ticker;
  late AppDatabase database;
  late FakeForegroundTimerService foreground;
  late FakeFloatingOverlayService overlay;
  late FakeBatteryOptimizationService battery;

  setUp(() {
    ticker = FakeTimerTicker();
    database = AppDatabase.forTesting();
    foreground = FakeForegroundTimerService();
    overlay = FakeFloatingOverlayService();
    battery = FakeBatteryOptimizationService();
  });

  tearDown(() => database.close());

  Future<void> pumpPage(WidgetTester tester, Locale locale) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timerTickerProvider.overrideWithValue(ticker),
          appDatabaseProvider.overrideWithValue(database),
          foregroundTimerServiceProvider.overrideWithValue(foreground),
          floatingOverlayServiceProvider.overrideWithValue(overlay),
          batteryOptimizationServiceProvider.overrideWithValue(battery),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          home: const PomodoroTimerPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the initial English timer and starts on tap',
      (tester) async {
    await pumpPage(tester, const Locale('en'));

    expect(find.text('Pomodoro'), findsOneWidget);
    expect(find.text('Focus'), findsWidgets);
    expect(find.text('Round 1'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Pause'), findsNothing);

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('Pause'), findsOneWidget);
    expect(ticker.isRunning, isTrue);

    ticker.fireTick();
    await tester.pumpAndSettle();

    expect(find.text('24:59'), findsOneWidget);

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(ticker.isRunning, isFalse);
  });

  testWidgets('uses localized phase and control labels in Arabic',
      (tester) async {
    await pumpPage(tester, const Locale('ar'));

    expect(find.text('بومودورو'), findsOneWidget);
    expect(find.text('تركيز'), findsWidgets);
    expect(find.text('الجولة 1'), findsOneWidget);
    expect(find.text('ابدأ'), findsOneWidget);
    expect(find.text('إعادة ضبط'), findsOneWidget);
  });
}
