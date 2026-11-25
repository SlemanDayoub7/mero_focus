import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_environment.dart';
import 'core/database/app_database.dart';
import 'core/di/core_providers.dart';
import 'core/observability/crash_reporter.dart';

/// The single startup path shared by every entry point (`main*.dart`).
///
/// Only [environment] and [app] differ between entry points; initialization,
/// error wiring and provider overrides live here so the flavors contain no
/// duplicated logic (see `docs/en/03-process/build-flavors.md`).
Future<void> bootstrap({
  required AppEnvironment environment,
  required Widget app,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (environment.verboseLogging) {
    debugPrint('[${environment.name}] starting Mero Focus');
  }

  final preferences = await SharedPreferences.getInstance();
  final database = await openAppDatabase();
  const crashReporter = NoOpCrashReporter();

  // Wire error handlers once. Activating a real CrashReporter later (ADR-0008)
  // will not require touching any entry point again.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    crashReporter.recordError(
      details.exception,
      details.stack ?? StackTrace.empty,
      context: 'flutter/${environment.name}',
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    crashReporter.recordError(
      error,
      stack,
      context: 'platform/${environment.name}',
    );
    return true;
  };

  // ADR-0008: select a real analytics provider here based on
  // environment.analyticsEnabled once that decision is made.

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        appDatabaseProvider.overrideWithValue(database),
        appEnvironmentProvider.overrideWithValue(environment),
      ],
      child: app,
    ),
  );
}
