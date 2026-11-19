import 'app.dart';
import 'bootstrap.dart';
import 'core/config/app_environment.dart';

/// Backward-compatible default entry point used by plain `flutter run` and by
/// tooling that does not pass `-t`. It uses the dev environment; publishable
/// builds must target `lib/main_release.dart` with `--flavor prod`.
///
/// See `docs/en/03-process/build-flavors.md`.
Future<void> main() => bootstrap(
      environment: AppEnvironment.dev,
      app: const MeroFocusApp(),
    );
