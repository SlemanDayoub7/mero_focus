# Problem Statement

## The Problem

Users of Pomodoro and habit-tracking apps face two core problems:

1. **Deep analysis of focus and habit patterns over time** (hour/day/week/month/year/custom range) is **locked behind a paid subscription** in most leading apps, even though this is exactly what users need to understand their own patterns and improve.
2. **UX limitations**: apps are either visually dry (just a countdown timer), or if they have a motivational layer (characters/themes), it's fixed and never changes.

## Proposed Solution

An Android app, **fully offline**, combining Pomodoro timing with habit tracking, featuring:
- Complete, detailed statistics **100% free** across all time granularities.
- A simple, lightweight, customizable experience (themes/backgrounds/sounds).
- Partial app-locking during sessions to reduce distraction.
- Lightweight, reliable performance — especially for the background/floating-window feature.

## Core Hypothesis

> If we offer the same depth of statistics that competitors lock behind paywalls, fully free, with a reliable and lightweight experience, we will attract the segment of users frustrated by free-tier limits of competitors — opening the door later to a different business model (e.g. paid collaborative/enterprise features, instead of gating core analytics).

## Early Success Criteria (post-launch)

- Week-1 and month-1 retention rate.
- Share of users who actually engage with the statistics screen (a proxy for whether this is the real differentiator).
- Google Play ratings compared to direct competitors.

## Scope Notes

- **No accounts, no sync in the MVP** — optional, later version only.
- **No modes/gamification system in the MVP** — the data model is designed to support it later without any migration (see `ADR-0005-mode-system-deferred.md`).
