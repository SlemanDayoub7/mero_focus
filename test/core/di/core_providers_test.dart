import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/di/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;
  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'theme_mode': 'dark',
      'locale': 'en',
    });
    preferences = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    );
  });

  tearDown(() => container.dispose());

  test('themeModeProvider reads the persisted value', () {
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  test('themeModeProvider persists a new selection', () async {
    await container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);

    expect(container.read(themeModeProvider), ThemeMode.light);
    expect(preferences.getString('theme_mode'), 'light');
  });

  test('localeProvider reads the persisted value', () {
    expect(container.read(localeProvider), const Locale('en'));
  });

  test('localeProvider persists a new selection', () async {
    await container.read(localeProvider.notifier).setLocale(const Locale('ar'));

    expect(container.read(localeProvider), const Locale('ar'));
    expect(preferences.getString('locale'), 'ar');
  });

  test('observability providers return no-op implementations', () {
    expect(container.read(crashReporterProvider), isNotNull);
    expect(container.read(analyticsTrackerProvider), isNotNull);
  });
}
