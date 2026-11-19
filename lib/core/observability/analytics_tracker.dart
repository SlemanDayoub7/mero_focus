/// Abstraction for privacy-respecting, offline-first analytics (ADR-0008).
abstract class AnalyticsTracker {
  void logEvent(String name, {Map<String, Object?> parameters});

  void setCurrentScreen(String name);
}

/// Null-object implementation used until a provider is chosen.
class NoOpAnalyticsTracker implements AnalyticsTracker {
  const NoOpAnalyticsTracker();

  @override
  void logEvent(String name, {Map<String, Object?> parameters = const {}}) {}

  @override
  void setCurrentScreen(String name) {}
}
