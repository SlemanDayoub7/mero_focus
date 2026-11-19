# ADR-0001: Target Android Only for the First Release

**Status:** Accepted

## Context
The project is solo at the start (with possible collaborators joining later), and the goal is a fast, reliable launch rather than splitting effort across two platforms.

## Decision
Target Android only, fully, for the MVP and beyond until stated otherwise. No iOS support currently.

## Rationale
- Some core features (locking specific apps, a floating background window) rely on Android-specific permissions and APIs (`PACKAGE_USAGE_STATS`, `SYSTEM_ALERT_WINDOW`) with no direct iOS equivalent.
- Simplifies the development, testing, and release cycle to a single platform.

## Consequences
- Freedom to use Android-specific Flutter plugins/platform channels without worrying about iOS compatibility.
- Any future decision about permissions or background services is evaluated purely against Android constraints.
- Future iOS support, if pursued, will require redesigning the app-lock and floating-overlay features from scratch (iOS system constraints are fundamentally different).
