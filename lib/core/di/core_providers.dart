import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_environment.dart';
import '../database/app_database.dart';
import '../observability/analytics_tracker.dart';
import '../observability/crash_reporter.dart';
import '../theme/app_accent.dart';

/// Selected by the entry point via `bootstrap()` and overridable in tests.
final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  throw UnimplementedError('appEnvironmentProvider must be overridden');
});

/// Observability ports (ADR-0008). No real provider is wired yet.
final crashReporterProvider = Provider<CrashReporter>((ref) {
  return const NoOpCrashReporter();
});

final analyticsTrackerProvider = Provider<AnalyticsTracker>((ref) {
  return const NoOpAnalyticsTracker();
});

/// Initialized in `main()` and overridden in widget tests.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// Initialized in `main()` and overridden in widget tests.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('appDatabaseProvider must be overridden');
});

/// The active UI locale. Persisted through [sharedPreferencesProvider].
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  static const _storageKey = 'locale';

  @override
  Locale build() {
    final code = ref.watch(sharedPreferencesProvider).getString(_storageKey);
    return code == 'en' ? const Locale('en') : const Locale('ar');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await ref
        .read(sharedPreferencesProvider)
        .setString(_storageKey, locale.languageCode);
  }
}

/// The user's theme selection. Persisted through [sharedPreferencesProvider].
///
/// Full `AppSettings` table integration lands with the settings feature rebuild;
/// the table itself is already defined in `core/database/tables.dart`.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _storageKey = 'theme_mode';

  @override
  ThemeMode build() {
    final value = ref.watch(sharedPreferencesProvider).getString(_storageKey);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(_storageKey, mode.name);
  }
}

/// The user's selected primary colour. Persisted through
/// [sharedPreferencesProvider] and applied to both themes by `AppTheme`.
final primaryAccentProvider =
    NotifierProvider<PrimaryAccentNotifier, AppAccent>(
  PrimaryAccentNotifier.new,
);

class PrimaryAccentNotifier extends Notifier<AppAccent> {
  static const _storageKey = 'primary_accent';

  @override
  AppAccent build() {
    final id = ref.watch(sharedPreferencesProvider).getString(_storageKey);
    return AppAccent.fromId(id);
  }

  Future<void> setAccent(AppAccent accent) async {
    state = accent;
    await ref.read(sharedPreferencesProvider).setString(_storageKey, accent.id);
  }
}
