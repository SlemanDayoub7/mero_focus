# Execution Plan — AI-Assisted Implementation

## Guiding Principle

This plan is built around **focused work sessions** rather than fixed calendar dates, because actual completion speed depends on how many hours you have available per day, which we don't know in advance. A "session" here means one focused work period (roughly half a day), whether consumed in one sitting or spread out.

**Core assumption:** since the architecture and conventions (Clean Architecture, SOLID, zero hard-coding, per-feature DI) are already fully decided and documented (this very documentation), any AI tool you use (Claude Code, OpenCode, the browser version, or another model) has a clear, stable context to follow, instead of re-inventing architectural decisions every time — and this is exactly what makes adding each subsequent feature faster, not just equally fast.

## Tool Allocation by Task Type (Practical Recommendation)

| Task Type | Best-Fit Tool | Why |
|---|---|---|
| Building an entire project structure, editing several interrelated files at once (e.g. scaffolding a full feature across its three layers) | An agentic tool that edits files directly (Claude Code or OpenCode) | Actually executes the changes instead of manual copy/paste, and reads the existing code before editing |
| Discussing a new architectural decision, reviewing an ADR, resolving an ambiguous design problem | A chat/browser session with this full documentation as context | Deeper, iterative reasoning before committing to actual code |
| Repetitive-pattern boilerplate code (e.g. writing unit tests for several usecases following the same shape) | Any fast/economical model available to you | Doesn't need deep architectural reasoning, just following a fixed pattern shown by one example |
| Security/quality review before merging into main | A model strong at analysis (a final review pass before any PR) | A last checkpoint that deserves the highest quality available |

**Important practical rule in all cases:** give any AI tool you use the relevant ADR or convention file directly as context (e.g. `coding-conventions.md` before any widget-writing request), instead of relying on it remembering a previous conversation — this greatly reduces "drift" away from agreed conventions as sessions accumulate.

## Estimated Implementation Phases

| Phase | Content | Estimate (work sessions) |
|---|---|---|
| 0 | Project setup (`build-order.md` — Phase 0) | 1 session |
| 1 | Technical foundation: full Drift setup, theming, localization, responsiveness, routing (`AppRouter`) | 2–3 sessions |
| 2 | First feature: full `settings` (domain/data/presentation + tests) — establishes the template for everything after it | 1–2 sessions |
| 3 | `pomodoro_timer` (the timer + round logic + Foreground Service per ADR-0009) | 3–4 sessions (the most technically complex, due to the background service) |
| 4 | `habit_tracking` | 1–2 sessions |
| 5 | `statistics` (all time-aggregation levels + UI) | 2–3 sessions |
| 6 | `app_lock` (permissions + the blocking screen) | 2 sessions |
| 7 | `background_overlay` + actually wiring it to the Foreground Service from phase 3 | 1–2 sessions |
| 8 | `pdf_export` + the local Backup/Restore feature | 1–2 sessions |
| 9 | Final branding (icon, splash) + a thorough zero-hard-coding review | 1 session |
| 10 | The full pre-launch checklist (`pre-launch-checklist.md`) + testing on multiple real devices | 2–3 sessions (depends on how many real issues surface) |

**Rough total: ~17–25 focused work sessions** to reach an MVP that's actually ready for release (not just "working on your machine"). This is an estimate, not a firm commitment — phases 3 and 10 are the most likely to stretch, since they involve real technical complexity (the background service) or unpredictable discoveries (real-device testing).

## Progress-Tracking Criterion

Use the same "Definition of Done" documented in `testing-strategy.md` as the dividing line between phases: don't move to the next phase before the current one is built + tested + passing CI. This prevents silent "technical debt" accumulation that's hard to spot later amid AI-accelerated progress.
