# ADR-0009: Foreground Service as a Mandatory Foundation for Background Operation and the Floating Window

**Status:** Accepted — mandatory, no alternative

## Context
The core feature "the moment we background the app, it immediately becomes a floating window" requires the timer and the floating-overlay service to keep running after the user leaves the app. Android 8+ kills any regular background process within seconds of it leaving the foreground, **unless it is officially registered as a Foreground Service** with a persistent notification visible to the user (this is mandatory system behavior, not a design choice).

## Decision
Build a real Foreground Service (via a platform channel or a dedicated plugin) from the very first development phase of the `background_overlay` feature, not as a later enhancement.

## Technical Requirements
- `FOREGROUND_SERVICE` permission in `AndroidManifest.xml`.
- Starting with Android 14 (API 34): the service **type** (`foregroundServiceType`) must be explicitly declared — the closest fit here is `specialUse` with a written justification submitted later during Google Play review, or whatever classification the latest Android guidance specifies at implementation time (these rules change between Android versions and must be checked against official docs when implementation actually begins).
- A persistent notification is mandatory while the service runs — it cannot be fully hidden, and this is, incidentally, expected and familiar behavior to users of similar timer apps.
- `SYSTEM_ALERT_WINDOW` permission (already documented in ADR-0006) to display the floating window itself over other apps.

## Dependency on Battery-Optimization Exemption
Even with a correct Foreground Service, some devices (especially those with aggressive battery management from certain manufacturers) may still kill the service. Therefore: **a clear in-app flow must be built explaining to the user the importance of exempting the app from "Battery Optimization"** and guiding them to the appropriate system screen (`ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`). This is documented as a separate item in `pre-launch-checklist.md`.

## Consequences
- The `background_overlay` feature is designed from day one around the existence of a Foreground Service, not as a layer added on top of an already-finished design — this is a foundational architectural decision, not a detail.
- Actual continuity (the service stays alive, the floating window stays visible) must be tested on real devices from multiple manufacturers before launch, since "killing background processes" behavior varies significantly between Samsung, Xiaomi, and others compared to stock Android (AOSP).
