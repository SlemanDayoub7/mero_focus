import 'package:flutter/material.dart';

import '../../features/background_overlay/presentation/pages/background_permissions_page.dart';
import '../../features/capture/presentation/pages/placeholder_capture_page.dart';
import '../../features/pomodoro/presentation/pages/pomodoro_timer_page.dart';
import '../../features/review/presentation/pages/placeholder_review_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

/// Lightweight manual router on top of Navigator 1.0 (ADR-0007).
///
/// Every navigation goes through a named `toXxx` method — no free-text route
/// names or `Navigator.push` calls scattered across widgets.
abstract final class AppRouter {
  static const String home = '/';
  static const String backgroundPermissions = '/background-permissions';
  static const String pomodoro = '/pomodoro';
  static const String review = '/review';
  static const String capture = '/capture';
  static const String settings = '/settings';

  /// Routes below the root; `/` is owned by `MaterialApp.home`.
  static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
        backgroundPermissions: (_) => const BackgroundPermissionsPage(),
        pomodoro: (_) => const PomodoroTimerPage(),
        review: (_) => const PlaceholderReviewPage(),
        capture: (_) => const PlaceholderCapturePage(),
        settings: (_) => const SettingsPage(),
      };

  static Future<T?> toBackgroundPermissions<T extends Object?>(
          BuildContext context) =>
      Navigator.of(context).pushNamed<T>(backgroundPermissions);

  static Future<T?> toPomodoro<T extends Object?>(BuildContext context) =>
      Navigator.of(context).pushNamed<T>(pomodoro);

  static Future<T?> toReview<T extends Object?>(BuildContext context) =>
      Navigator.of(context).pushNamed<T>(review);

  static Future<T?> toCapture<T extends Object?>(BuildContext context) =>
      Navigator.of(context).pushNamed<T>(capture);

  static Future<T?> toSettings<T extends Object?>(BuildContext context) =>
      Navigator.of(context).pushNamed<T>(settings);
}
