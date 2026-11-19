import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/di/core_providers.dart';
import 'package:mero_focus/features/settings/presentation/pages/settings_page.dart';
import 'package:mero_focus/l10n/app_localizations.dart';
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

  testWidgets('tapping dark theme option updates themeModeProvider state',
      (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final darkTile = find.byType(RadioListTile<ThemeMode>).at(1);
    await tester.tap(darkTile);
    await tester.pumpAndSettle();

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });
}
