import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/database/app_database.dart';
import 'package:mero_focus/core/di/core_providers.dart';
import 'package:mero_focus/core/theme/app_theme.dart';
import 'package:mero_focus/features/background_overlay/presentation/controllers/background_session_controller.dart';
import 'package:mero_focus/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../background_overlay/helpers/fake_background_services.dart';

/// Shared harness for planner widget tests. Uses an in-memory Drift database
/// and a real [ProviderContainer] so stream providers behave as in the app.
class PlannerTestHarness {
  PlannerTestHarness._(this.container, this.database);

  final ProviderContainer container;
  final AppDatabase database;

  static Future<PlannerTestHarness> create() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final database = AppDatabase.forTesting();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        appDatabaseProvider.overrideWithValue(database),
        foregroundTimerServiceProvider.overrideWithValue(
          FakeForegroundTimerService(),
        ),
        floatingOverlayServiceProvider.overrideWithValue(
          FakeFloatingOverlayService(),
        ),
        batteryOptimizationServiceProvider.overrideWithValue(
          FakeBatteryOptimizationService(),
        ),
      ],
    );
    return PlannerTestHarness._(container, database);
  }

  void dispose() {
    container.dispose();
    database.close();
  }

  Future<void> pumpPage(
    WidgetTester tester,
    Widget page, {
    Locale locale = const Locale('en'),
  }) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          theme: AppTheme.light,
          home: page,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }
}
