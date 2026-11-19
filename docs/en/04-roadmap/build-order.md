# Build Order — Where to Actually Start

The rule: **no feature is written before the foundation (Core) is ready**, since every later feature depends on it (theming, localization, DB, DI, responsiveness).

## Phase 0 — Project Setup (Day-1 Tasks)

- [ ] `flutter create` + clean up the default template (remove the `counter` demo).
- [ ] Create the empty folder structure per `ADR-0002` (`core/`, `features/<each feature as an empty placeholder folder>`).
- [ ] Add core dependencies to `pubspec.yaml`:
  - `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, `build_runner`
  - `drift`, `drift_dev`, `sqlite3_flutter_libs`, `path_provider`, `path`
  - `flutter_localizations` (SDK), `intl`
  - `pdf`, `printing` (for PDF export)
  - `permission_handler`
  - Dev: `flutter_lints`, `mocktail`, `flutter_test` (SDK), `riverpod_lint`, `custom_lint`
- [ ] Configure `analysis_options.yaml` with strict rules (`flutter_lints` + `riverpod_lint` fully enabled).
- [ ] Initialize the Git repo + first commit + create the `main` branch + push to GitHub.
- [ ] Enable protection on the `main` branch (see the updated `git-workflow.md`).
- [ ] Create a GitHub Actions workflow: `flutter analyze` + `flutter test` on every push/PR.
- [ ] Copy this `docs/` folder into the project root.

## Phase 1 — Technical Foundation (Core) Before Any Real Screen

- [ ] Set up Drift: define the six tables (`data-model.md`) + first migration.
- [ ] Set up the theme system: `AppThemeExtension` + `themeSettingsProvider` + wire it to the `AppSettings` table.
- [ ] Set up localization: basic `app_en.arb` and `app_ar.arb` files (even if still empty of real strings) + generate `AppLocalizations` + the `L10nContext` extension.
- [ ] Set up the responsiveness utility: the `ResponsiveContext` extension.
- [ ] Set up `core/routing/` (see ADR-0007 — a manual lightweight router).
- [ ] Write the first real unit test (even a trivial one) to confirm the test environment actually works before continuing.

## Phase 2 — First Real Feature: Settings

We start with `settings` specifically (not `pomodoro_timer`) because it:
- Is the simplest feature in terms of business logic.
- Is used to prove out the complete Clean Architecture template (domain/data/presentation + DI + tests) on a small example before applying it to more complex features.
- Other features (theme, sound, app lock) will actually read from it, so it's best to have it ready first.

## Phase 3 Onward — Functional Features, in Order

1. `pomodoro_timer` (the timer itself + round logic)
2. `habit_tracking`
3. `statistics` (depends on data from the previous two phases)
4. `app_lock` (partial blocking — ADR-0006)
5. `background_overlay`
6. `pdf_export` (depends on `statistics` being ready)

## Criterion for Moving Between Phases

We don't move to the next phase before the current one is: (1) built, (2) covered by baseline unit tests, (3) passing CI. This is the same "Definition of Done" documented in `testing-strategy.md`, applied here at the level of major phases as well.
