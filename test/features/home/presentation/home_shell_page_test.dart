import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/app.dart';
import 'package:mero_focus/core/di/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    );
  });

  tearDown(() => container.dispose());

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

      expect(find.text('المراجعة'), findsWidgets);
      expect(find.text('Review'), findsNothing);

      await container.read(localeProvider.notifier).setLocale(const Locale('en'));
      await tester.pumpAndSettle();

      expect(find.text('Review'), findsWidgets);
      expect(find.text('المراجعة'), findsNothing);
    },
  );
}
