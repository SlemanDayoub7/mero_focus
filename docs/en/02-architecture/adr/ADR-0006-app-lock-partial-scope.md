# ADR-0006: App-Lock Feature Scope — Partial Blocking Only (No Actual Exit Prevention)

**Status:** Accepted

## Context
The original idea included an "Absolute Focus Mode" with three layers: (1) blocking specific apps, (2) muting notifications, (3) actually preventing the user from exiting the session until it ends. It turned out that layer 3 technically requires a Screen Pinning / Lock Task mechanism that needs explicit manual approval from the user at the Android system level, and that 100% exit prevention is not technically possible for a regular Google Play app without "Device Owner" privileges, which are not appropriate here.

## Decision
The first release (MVP) implements **blocking specific apps only** during a session. The notification-muting and actual exit-prevention layers are not built at this stage.

## Technical Mechanism
- Monitor the current foreground app via `UsageStatsManager` (polling).
- Immediately show a blocking screen over any blocked app via `SYSTEM_ALERT_WINDOW`.

## Required Permissions
- `PACKAGE_USAGE_STATS` (Usage Access)
- `SYSTEM_ALERT_WINDOW` (draw over other apps)

## Google Play Publishing Note
Both permissions are sensitive permissions subject to separate manual review in Play Console (written justification + demonstration video). These must be prepared as part of the pre-launch phase (see the launch plan).

## Consequences
- No need to request Device Owner privileges or deal with the complexity of the Lock Task API at this stage.
- If a true "Absolute Focus Mode" is decided upon later, it will require a new ADR discussing the explicit user-consent flow for Screen Pinning.
