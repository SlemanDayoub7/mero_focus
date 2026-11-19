import 'app.dart';
import 'bootstrap.dart';
import 'core/config/app_environment.dart';

/// Development entry point.
///
/// Build/run with:
/// `flutter run --flavor dev -t lib/main_dev.dart`
Future<void> main() => bootstrap(
      environment: AppEnvironment.dev,
      app: const MeroFocusApp(),
    );
