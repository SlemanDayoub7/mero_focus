# Build Flavors — Dev / Release

## Goal
Separate the development environment (dev) from the release environment so a dev build can be installed alongside the real release build on the same device for testing, without conflict, and without leaking any dev-only settings (e.g. verbose logging) into the published version.

## Flavors

| Flavor | Application ID | Purpose |
|---|---|---|
| `dev` | `com.sleman.miro_focus.dev` | Daily development, verbose logging enabled, any analytics provider (ADR-0008) in test/disabled mode |
| `release` | `com.sleman.miro_focus` | The version actually published on Google Play |

*(The actual application ID adopted by the project is `com.sleman.miro_focus`, with the `.dev` suffix for development)*

## Technical Setup (Android)

Flavors are defined in `android/app/build.gradle`:

```gradle
android {
    flavorDimensions "environment"
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            resValue "string", "app_name", "App (Dev)"
        }
        release {
            dimension "environment"
            resValue "string", "app_name", "App"
        }
    }
}
```

## Running and Building

```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter build appbundle --flavor release -t lib/main_release.dart
```

`lib/main_dev.dart` and `lib/main_release.dart` are two small files that only set environment-specific configuration (e.g. enabling/disabling the real `CrashReporter` from ADR-0008) before calling `runApp` from the shared `lib/app.dart` — **no logic duplication, just a different entry point.**

## Security Note
Any key/secret for an external provider (if Firebase is added later) is passed via `--dart-define` or config files not committed to Git (`google-services.json` per flavor in its own path), never hard-coded in the source.
