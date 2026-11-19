import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/config/app_environment.dart';
import 'package:mero_focus/core/di/core_providers.dart';

void main() {
  group('AppEnvironment', () {
    test('dev enables verbose logging and disables analytics', () {
      const environment = AppEnvironment.dev;

      expect(environment.name, 'dev');
      expect(environment.verboseLogging, isTrue);
      expect(environment.analyticsEnabled, isFalse);
      expect(environment.isDev, isTrue);
      expect(environment.isRelease, isFalse);
    });

    test('release keeps diagnostics quiet', () {
      const environment = AppEnvironment.release;

      expect(environment.name, 'release');
      expect(environment.verboseLogging, isFalse);
      expect(environment.analyticsEnabled, isTrue);
      expect(environment.isRelease, isTrue);
      expect(environment.isDev, isFalse);
    });

    test('both flavors are declared', () {
      expect(AppEnvironment.values, <AppEnvironment>[
        AppEnvironment.dev,
        AppEnvironment.release,
      ]);
    });
  });

  group('appEnvironmentProvider', () {
    test('can be overridden with the selected flavor', () {
      final container = ProviderContainer(
        overrides: [
          appEnvironmentProvider.overrideWithValue(AppEnvironment.release),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(appEnvironmentProvider), AppEnvironment.release);
    });

    test('throws a clear error when bootstrap forgot to override it', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(appEnvironmentProvider),
        throwsA(
          isA<Exception>().having(
            (exception) => exception.toString(),
            'message',
            contains('appEnvironmentProvider must be overridden'),
          ),
        ),
      );
    });
  });
}
