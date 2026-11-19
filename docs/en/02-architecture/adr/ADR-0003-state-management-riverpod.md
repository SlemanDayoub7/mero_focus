# ADR-0003: Riverpod as the State Management Solution

**Status:** Accepted

## Context
The project needs a reactive state management system, easy to test (mocking/overriding dependencies), and able to support future extensibility (dynamically toggled features such as `mode_system` and `app_lock`) without heavy boilerplate.

## Decision
Adopt **Riverpod** (with `riverpod_generator`) as the unified state management solution across the entire project.

## Rejected Alternatives
- **Bloc/Cubit**: more common in traditional Clean Architecture tutorials with a very strict structure, but requires more boilerplate (separate events/states) per small feature — unnecessary overhead for a solo project at this stage.

## Rationale
- Dependency injection is built naturally into Riverpod, with no need for a separate DI library like `get_it`.
- Easy to override any provider during tests, simplifying unit/widget tests per feature.
- Reactivity fits well for multiple independently-changing states (timer, app lock, settings) without forcing them into one giant combined state.

## Consequences
- All providers are defined within the `presentation/` layer (or an additional `application/` layer if later needed as a coordination layer between domain and presentation).
- `riverpod_generator` requires `build_runner` as part of the dev workflow (documented in the technical setup section of the README).
