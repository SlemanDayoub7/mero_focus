import 'app.dart';
import 'bootstrap.dart';
import 'core/config/app_environment.dart';

/// Publishable entry point.
///
/// Build with:
/// `flutter build appbundle --flavor prod -t lib/main_release.dart`
Future<void> main() => bootstrap(
      environment: AppEnvironment.release,
      app: const MeroFocusApp(),
    );
