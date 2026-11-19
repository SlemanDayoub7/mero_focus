import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/background_overlay/presentation/controllers/background_session_controller.dart';
import 'package:mero_focus/features/background_overlay/presentation/pages/background_permissions_page.dart';
import 'package:mero_focus/l10n/app_localizations.dart';

import '../../helpers/fake_background_services.dart';

void main() {
  late FakeFloatingOverlayService overlay;
  late FakeBatteryOptimizationService battery;

  setUp(() {
    overlay = FakeFloatingOverlayService();
    battery = FakeBatteryOptimizationService();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          floatingOverlayServiceProvider.overrideWithValue(overlay),
          batteryOptimizationServiceProvider.overrideWithValue(battery),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: BackgroundPermissionsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('explains both permissions and requests them on tap',
      (tester) async {
    await pumpPage(tester);

    expect(find.text('Background & overlay'), findsOneWidget);
    expect(find.text('Floating timer'), findsOneWidget);
    expect(find.text('Battery optimization'), findsOneWidget);
    expect(find.text('Not enabled'), findsNWidgets(2));

    await tester.tap(find.text('Grant overlay permission'));
    await tester.pumpAndSettle();

    expect(overlay.permissionGranted, isTrue);
    expect(find.text('Enabled'), findsOneWidget);

    await tester.tap(find.text('Exempt from optimization'));
    await tester.pumpAndSettle();

    expect(battery.requestCalls, 1);
    expect(find.text('Enabled'), findsNWidgets(2));
  });

  testWidgets('uses Arabic strings when the locale is Arabic', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          floatingOverlayServiceProvider.overrideWithValue(overlay),
          batteryOptimizationServiceProvider.overrideWithValue(battery),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('ar'),
          home: BackgroundPermissionsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('الخلفية والنافذة العائمة'), findsOneWidget);
    expect(find.text('تحسين البطارية'), findsOneWidget);
  });
}
