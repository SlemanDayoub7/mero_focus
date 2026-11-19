# ADR-0008: Crash Reporting and Analytics (Without Breaking Offline-First)

**Status:** Proposed — final provider decision pending before implementation

## Context
The app is designed to work fully offline (a core principle, see `problem-statement.md`). At the same time, we need visibility into where crashes occur and basic usage patterns (which screens are actually used) without depending on full cloud sync.

## Decision
1. **Core app functionality never depends on internet connectivity, in any form.**
2. An abstraction layer (`core/observability/`) with a unified interface (`CrashReporter`, `AnalyticsTracker`) is built now, **without wiring it to an actual provider yet** — ensuring it can be added later without changing any consuming code.
3. Upon actual activation (a later decision), a provider that collects data locally and uploads only when internet is available is used (Firebase Crashlytics/Analytics, or a more privacy-respecting alternative such as self-hosted Sentry) — these tools are themselves "offline-first" by nature (local buffering, then opportunistic upload).

## Design (Abstraction Only, No Implementation Yet)

```dart
// core/observability/crash_reporter.dart
abstract class CrashReporter {
  void recordError(Object error, StackTrace stackTrace, {String? context});
}

// core/observability/analytics_tracker.dart
abstract class AnalyticsTracker {
  void logEvent(String name, {Map<String, Object?>? parameters});
}

// A no-op implementation (null object pattern) used until the provider decision is finalized
class NoOpCrashReporter implements CrashReporter {
  @override
  void recordError(Object error, StackTrace stackTrace, {String? context}) {}
}
```

`FlutterError.onError` and `PlatformDispatcher.instance.onError` are wired to `CrashReporter` from the start (even while it's a `NoOp`), so `main.dart` doesn't need changes later when a real provider is activated.

## Rationale
- Separates the technical decision (the interface) from the business/privacy decision (which provider, and when) — no external dependency is introduced before that decision is settled.
- Keeps the door open for a more privacy-respecting provider (self-hosted Sentry) if that proves important for the target audience.

## Consequences
- Once any provider is activated: **the privacy policy and the Google Play Data Safety form must be updated** to disclose the type of data collected (even if purely technical, with no personal information).
- This decision is not actually implemented (no Firebase/Sentry dependency added) before the pre-launch phase, unless an earlier need arises.
