# First Release Scope (MVP)

## In Scope

| Feature | Notes |
|---|---|
| Configurable Pomodoro timer | Work/short-break/long-break duration, number of rounds before a long break |
| Basic habit tracking | Daily/custom-weekly frequency, daily completion logging |
| Simple visual themes | No modes/gamification system (see ADR-0005) |
| Customizable backgrounds | |
| Customizable sounds | White noise during the session + timer-end sound |
| Complete, detailed statistics | At hour, day, week, month, year, years, and custom-range granularity — fully free, with no restrictions |
| PDF export | Export statistics as PDF |
| Locking specific apps | Session-only. Partial blocking (see ADR-0006) — no actual exit prevention |
| Background floating window | Appears immediately when the app is backgrounded during an active session |
| Fully offline operation | A non-negotiable baseline requirement from day one |
| Lightweight, reliable performance | An explicit engineering priority, especially for the background service |
| Local backup/restore (Backup/Restore) | Export/import of all data as a single JSON file — part of the MVP itself, not deferred |

## Out of Scope (Deferred to Later Versions)

| Feature | Reason |
|---|---|
| Modes/gamification system (evolving characters) | Requires independent UX and evolution-system design. The data infrastructure is ready to receive it later without migration (ADR-0005) |
| Cloud accounts and sync | A fully optional feature later, multi-platform |
| Absolute Focus Mode (actual exit prevention + notification muting) | Android technical constraints requiring extra user consent (Screen Pinning) — see ADR-0006 |
| CSV/raw data export | A gap observed at a leading competitor (Focus To-Do), added as a later enhancement |
| iOS support | See ADR-0001 |

## Criteria for Revisiting Out-of-Scope Items

Any "out of scope" item is only reopened after:
1. The MVP has actually launched on Google Play.
2. Real usage feedback confirms (or rules out) the need for that specific item.
