# ADR-0002: Clean Architecture + Feature-First

**Status:** Accepted

## Context
The project needs high testability (unit/widget/integration), future extensibility (adding gamification modes, accounts/sync) without major rework, and the ability for collaborators to join later without friction.

## Decision
Adopt Clean Architecture (Domain / Data / Presentation layers) within a Feature-First organization (each feature owns its own folder with all three layers).

## Overall Structure
```
lib/
├── core/              # DI, database, routing, theme, error handling, utils
└── features/
    ├── pomodoro_timer/
    ├── habit_tracking/
    ├── statistics/
    ├── pdf_export/
    ├── app_lock/
    ├── background_overlay/
    ├── settings/
    └── mode_system/   # reserved structure, not active in the MVP — see ADR-0005
```
Each feature: `domain/` (entities, abstract repositories, usecases) + `data/` (models, datasources, repo implementations) + `presentation/` (pages, widgets, state).

## Rationale
- Isolating business logic (Domain) from implementation details (DB, UI) makes testing sensitive logic (statistics aggregation) easy, independent of the UI.
- Each feature can be developed and tested independently — important for solo work across multiple Git branches, and even more so once collaborators join.

## Consequences
- Higher boilerplate cost than a simple MVC approach, acceptable for long-term maintainability and testability.
- Any new feature (e.g. `mode_system` later) is added as a new independent folder following the same template, without touching existing features.
