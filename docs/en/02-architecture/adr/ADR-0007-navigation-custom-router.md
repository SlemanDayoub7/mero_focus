# ADR-0007: Lightweight Custom Router Instead of go_router

**Status:** Accepted

## Context
The MVP has a relatively small number of screens (timer, statistics, habits, settings, app-block screen). There is no current need for external deep links or complex nested navigation.

## Decision
Do not use `go_router`. Build a lightweight, manual `AppRouter` on top of the standard `Navigator` 1.0.

## Rationale
- `go_router` is known for issues with nested navigators and complex redirect logic — unjustified overhead for a small screen count.
- A manual, simple router means full control, zero hidden "magic" (implicit behavior), and easy testing (a simple `NavigatorObserver` instead of mocking a whole library).
- Aligns with the "zero hard-coding" principle: every screen transition goes through a clearly named function instead of scattered free-text route names.

## Proposed Design

```dart
// core/routing/app_router.dart
class AppRouter {
  AppRouter._();

  static void toStatistics(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StatisticsPage()),
    );
  }

  static void toSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  // ... remaining screens
}
```

Every navigation call in the app goes exclusively through `AppRouter.toXxx(context)`, never a `Navigator.push` scattered directly inside widgets.

## Re-evaluation
If genuinely complex navigation is needed later (nested tabs, deep links from external notifications), this decision should be reopened and `auto_route` specifically evaluated (code-generation approach, same family as Riverpod and Drift already used in the project) as a considered alternative — not `go_router`.
