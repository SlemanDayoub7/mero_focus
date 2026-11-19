/// Build-time environment selected by the entry point (`main_dev.dart` /
/// `main_release.dart`). Mirrors the two Android product flavors documented in
/// `docs/en/03-process/build-flavors.md`.
///
/// This is configuration only — never a place for feature logic.
enum AppEnvironment {
  dev(
    name: 'dev',
    verboseLogging: true,
    analyticsEnabled: false,
  ),
  release(
    name: 'release',
    verboseLogging: false,
    analyticsEnabled: true,
  );

  const AppEnvironment({
    required this.name,
    required this.verboseLogging,
    required this.analyticsEnabled,
  });

  /// Value used in log/error context and in the Android flavor name.
  final String name;

  /// Enables verbose diagnostics in development builds only.
  final bool verboseLogging;

  /// Whether analytics should be collected once a provider is chosen
  /// (ADR-0008). No provider is wired yet, so this is configuration intent.
  final bool analyticsEnabled;

  bool get isDev => this == AppEnvironment.dev;

  bool get isRelease => this == AppEnvironment.release;
}
