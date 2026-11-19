/// Abstraction for crash/error reporting.
///
/// The concrete provider is intentionally undecided (ADR-0008). The app is
/// wired to this interface from day one with a [NoOpCrashReporter] so a real
/// provider can be introduced later without changing consuming code.
abstract class CrashReporter {
  void recordError(Object error, StackTrace stackTrace, {String? context});
}

/// Null-object implementation used until a provider is chosen.
class NoOpCrashReporter implements CrashReporter {
  const NoOpCrashReporter();

  @override
  void recordError(Object error, StackTrace stackTrace, {String? context}) {}
}
