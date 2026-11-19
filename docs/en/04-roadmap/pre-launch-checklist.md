# Pre-Launch Checklist

Items that aren't directly business logic, but ignoring them either blocks publishing outright or breaks the experience on real devices. This entire list is reviewed before the first Google Play release, and some items (marked ⚠️) must be built into the architecture from now.

## Core Technical (Affects Architecture — Must Be Ready Now)

- [ ] ⚠️ **Foreground Service** correctly designed and implemented (ADR-0009) — without it, the background feature won't work reliably.
- [ ] ⚠️ **Battery-optimization exemption**: an in-app flow asking the user to exempt the app from Battery Optimization, with a clear explanation before asking.
- [x] **Local Backup/Restore**: a core MVP feature itself (see `mvp-scope.md`), not a deferred checklist item — the export/import screen must be ready and tested before launch.
- [ ] Accessibility: support for system font scaling, clear `Semantics` for interactive elements (timer buttons, habit lists).

## Branding and Store Presence

- [ ] Adaptive icon for all required sizes.
- [ ] A splash screen compatible with the new Android 12+ splash system.
- [ ] Store screenshots and description text — written once the final UI stabilizes.

## Security and Configuration

- [ ] ⚠️ The signing keystore is managed securely, entirely outside Git (`.gitignore` includes `key.properties` and `.jks`/`.keystore` files).
- [ ] Build Flavors (dev/release) ready (see `build-flavors.md`).
- [ ] Review ProGuard/R8 rules (especially given Drift/sqlite plugins) to ensure the minified release build isn't broken.

## Legal and Privacy

- [ ] ⚠️ **A published Privacy Policy** with its link ready — mandatory for any Google Play app, and even more so here given the sensitive Usage Access and Overlay permissions.
- [ ] Accurately complete the **Data Safety** form on Play Console (even if "no data collected" currently — updated once any analytics is activated per ADR-0008).
- [ ] A written justification (+ a video if required) for the `PACKAGE_USAGE_STATS` and `SYSTEM_ALERT_WINDOW` sensitive-permission review process on Play Console (see ADR-0006).

## Pre-Launch Testing

- [ ] Test Foreground Service continuity on real devices from more than one manufacturer (especially Samsung and Xiaomi, known for aggressive battery management compared to stock Android).
- [ ] Test responsiveness on a real or emulated tablet, in both Portrait and Landscape.
- [ ] Test language switching (once more than one `.arb` file exists) to catch any forgotten hard-coded text.
