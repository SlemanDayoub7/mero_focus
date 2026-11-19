# Mero Focus — A Pomodoro + Habit Tracking App (Android)

> **Status:** Design and documentation phase — no implementation code yet.
> **Target Platform:** Android only (MVP)
> **Language/Framework:** Flutter + Dart
> **Architecture:** Clean Architecture + Feature-First

## Overview

A Pomodoro and habit-tracking app that works **fully offline**, with detailed statistics (at hour/day/week/month/year/custom-range granularity) that are **entirely free** — unlike most leading competitors (such as Focus To-Do), which lock this kind of analysis behind a paid subscription.

For the full problem statement and the research behind this decision, see:
[`docs/en/01-problem-and-research/problem-statement.md`](docs/en/01-problem-and-research/problem-statement.md)

## First Release Scope (MVP)

See [`docs/en/04-roadmap/mvp-scope.md`](docs/en/04-roadmap/mvp-scope.md) for the full, detailed list.

Quick summary:
- A configurable Pomodoro timer (work/break duration, number of rounds)
- Basic habit tracking
- Simple visual themes + customizable backgrounds and sounds (white noise + timer-end sound)
- Complete, detailed statistics — 100% free
- PDF export of statistics
- Locking specific apps during a session
- A floating overlay window the moment the app is backgrounded
- Fully offline operation
- Local backup/restore

**Deliberately deferred to later versions:** a "modes"/gamification system (evolving characters), cloud accounts and sync, an absolute focus mode (actual session exit prevention).

## Architecture

See [`docs/en/02-architecture/`](docs/en/02-architecture/) — documented design decisions (ADRs), the full data model, coding conventions, the UI foundation (theming/responsiveness/localization), the extensions catalog, and baseline diagrams.

## Workflow and Testing

See [`docs/en/03-process/`](docs/en/03-process/) for the Git/Branching strategy, build flavors (dev/release), and the testing strategy.

## Where to Actually Start

See [`docs/en/04-roadmap/build-order.md`](docs/en/04-roadmap/build-order.md) for the full build order, [`docs/en/04-roadmap/execution-plan.md`](docs/en/04-roadmap/execution-plan.md) for an AI-assisted execution plan, and [`docs/en/04-roadmap/pre-launch-checklist.md`](docs/en/04-roadmap/pre-launch-checklist.md) for everything that must be ready before publishing (Foreground Service, battery, privacy, signing...).

## Why This Project? (The Market Opportunity)

See [`docs/en/01-problem-and-research/competitor-research.md`](docs/en/01-problem-and-research/competitor-research.md).
