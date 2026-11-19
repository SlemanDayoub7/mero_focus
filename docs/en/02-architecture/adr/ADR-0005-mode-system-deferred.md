# ADR-0005: Defer the "Modes" (Gamification) System While Keeping the Data Model Future-Ready

**Status:** Accepted

## Context
The original project concept included multiple switchable visual "modes" (dragons, birds, cats...) that evolve as the user progresses, on two layers: daily evolution (within a session) and long-term cumulative evolution. This feature was later deferred from the first release in favor of a simpler, lighter scope resembling Focus To-Do's core functionality, while keeping the door open to add it later **without losing existing users' data and without a risky migration**.

## Decision
1. The `mode_system` feature is **not** actually built in the MVP (no UI, no mode-state storage).
2. **No "level" or "evolution stage" is ever stored** as an independent field in the database.
3. Core data tables (`focus_sessions`, `habit_logs`) remain **entirely raw facts**: dates, durations, completion status — with no reference to any mode or level.
4. Any future modes system computes level/evolution **dynamically (derived)** from the existing raw data, at render time, via a pure function reading from `focus_sessions` and `habit_logs`.

## Rationale
- Keeps the first release lighter and faster to ship (no extra mode tables or logic).
- Eliminates the need for any future data migration: a long-time user who has accumulated hundreds of focus hours will automatically appear at an advanced level the moment a modes system is activated later, because the computation is based on their real usage history, not on mode data that would need to be migrated.
- Fully separates "facts" logic (what the user actually did) from "motivational presentation" logic (how we visually display that), allowing multiple different motivational presentation layers to be built on top of the same data in the future without conflict.

## Consequences
- The `features/mode_system/` folder remains present in the architecture layout (ADR-0002) as a reserved placeholder, but empty of actual implementation in the MVP.
- Any future work in this direction starts with a new ADR documenting the design of the computation functions (`calculateLevel`, `calculateEvolutionStage`, etc.) without needing to modify the existing `focus_sessions` or `habit_logs` tables.
