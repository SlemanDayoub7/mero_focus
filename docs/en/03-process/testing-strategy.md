# Testing Strategy

Every feature (`features/<feature>/`) has a matching test folder (`test/features/<feature>/`) mirroring the same layer structure.

## Test Levels

| Level | Covers | Tools |
|---|---|---|
| **Unit Tests** | The entire Domain layer: usecases, statistics aggregation logic, habit frequency logic. Top priority — the goal is near-100% coverage specifically here | `flutter_test` + `mocktail` |
| **Repository Tests** | How the repository interacts with the local datasource (Drift), with the datasource mocked | `mocktail` |
| **Widget Tests** | The timer screen, statistics/filter screens, habit management screen | `flutter_test` |
| **Integration Tests** | Full scenarios: start a session → complete it → verify it's recorded in the database → verify it appears correctly in statistics | `integration_test` |
| **Golden Tests** (optional, added gradually) | Visual stability of themes/backgrounds across updates | `golden_toolkit` |

## Definition of Done per Feature

A feature is not considered complete unless:
1. Functional code is fully implemented.
2. At least unit tests exist for any new usecases.
3. Relevant documentation is updated (a new ADR if an architectural decision changed, or `data-model.md` updated if the schema changed).

This rule applies from the very first feature, even in solo work, so it becomes a fixed habit before any collaborator joins.

## CI
See `git-workflow.md` for details on integrating tests with GitHub Actions.
