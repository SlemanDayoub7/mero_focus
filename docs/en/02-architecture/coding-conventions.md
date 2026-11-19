# Coding Conventions

This document is mandatory for all code written in this project and must be checked in every Pull Request.

## 1. Widget Rules

- **Never call a widget as a private method** (e.g. `Widget _buildHeader() => ...`). Every logically independent piece of UI is always extracted as a real `class` extending `StatelessWidget` or `StatefulWidget`.
  - **Why:** a method-based widget cannot benefit from `const` constructors, nor from Flutter's selective rebuild mechanism (a widget-as-method is fully rebuilt whenever its parent rebuilds, whereas a widget-as-class can be `const` and skip rebuilding entirely if its inputs haven't changed).
- **One file per primary widget.** Small helper widgets with no plausible use outside one specific context may stay in the same file, but any widget with more than one potential use, or exceeding ~50 lines, moves to its own file.
- File naming: `snake_case` matching the `PascalCase` class name (e.g. `pomodoro_timer_display.dart` → `class PomodoroTimerDisplay`).

## 2. Abstraction — in Specific Cases, Not Everywhere

- **Domain/Data layer:** abstraction is always mandatory (repository interfaces in `domain/`, real implementation in `data/`) — necessary for testability (mocking) regardless of whether an alternative real implementation ever exists.
- **Presentation layer:** no extra abstraction unless there's a real reason (e.g. a shared contract needed by more than one widget). Avoid creating an `abstract class`/interface "just in case we need it later" — that's unjustified complexity (YAGNI).

## 3. SOLID Principles — Practical Application in This Project

| Principle | Application |
|---|---|
| **S**ingle Responsibility | Each usecase does exactly one thing (`GetDailyStatsUseCase`, `CompleteHabitUseCase`...). No "god" usecase doing several things |
| **O**pen/Closed | `mode_system` (ADR-0005) is designed so new modes are added as new files without modifying existing code |
| **L**iskov Substitution | Any implementation of a repository interface must be fully substitutable for any other implementation of the same interface without breaking expected behavior |
| **I**nterface Segregation | Repository interfaces are small and purpose-specific (no giant interface bundling all database operations) |
| **D**ependency Inversion | The Domain layer knows nothing about Drift or any implementation detail — it depends only on the abstract repository defined within it |

## 4. Dependency Injection — Per Feature

- There is no single, central, giant DI file for the whole app.
- Each feature has its own `<feature>_providers.dart` file within `presentation/` (or `application/` if needed) defining only its own Riverpod providers.
- Dependencies genuinely shared across features (e.g. the Drift database instance, or SharedPreferences) are defined once in `core/di/` and consumed via `ref.watch` from anywhere, without being redefined.

## 5. Naming

- Classes: `PascalCase`. Variables/functions: `camelCase`. Files: `snake_case`. Constants: `camelCase` with a clear prefix where helpful (`kDefaultWorkDuration`).
- Usecase names: verb + object (`StartFocusSession`, `GetWeeklyStatistics`). No vague generic names (`Manager`, `Helper`, `Handler`) without a precise statement of responsibility.

## 6. Zero Hard-coding

No literal value (text, color, dimension/spacing, duration) may be written directly inside a widget. Every value comes from:
- Text: localization files (see `ui-foundation-and-conventions.md`).
- Colors/spacing/typography: a dedicated `ThemeExtension` (see same document).
- Default logical values (e.g. default Pomodoro duration): `core/constants/` only, consumed from there everywhere.

## 7. Testing Is Mandatory at Completion

See `testing-strategy.md` — no PR is merged without at least unit tests for any new usecase.
