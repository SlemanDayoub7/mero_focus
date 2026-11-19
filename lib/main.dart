import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/di/core_providers.dart';
import 'core/observability/crash_reporter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final database = await openAppDatabase();
  const crashReporter = NoOpCrashReporter();

  // Wire error handlers once, so activating a real provider later (ADR-0008)
  // does not require touching this file again.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    crashReporter.recordError(
      details.exception,
      details.stack ?? StackTrace.empty,
      context: 'flutter',
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    crashReporter.recordError(error, stack, context: 'platform');
    return true;
  };

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: const MeroFocusApp(),
    ),
  );
}
