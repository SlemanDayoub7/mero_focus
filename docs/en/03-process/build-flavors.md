# Build Flavors — Dev / Release

## Goal
Separate the development environment (dev) from the release environment so a dev build can be installed alongside the real release build on the same device for testing, without conflict, and without leaking any dev-only settings (e.g. verbose logging) into the published version.

## Flavors

| Flavor | Application ID | Purpose |
|---|---|---|
| `dev` | `com.sleman.miro_focus.dev` | Daily development, verbose logging enabled, any analytics provider (ADR-0008) in test/disabled mode |
| `prod` | `com.sleman.miro_focus` | The version actually published on Google Play |

*(The actual application ID adopted by the project is `com.sleman.miro_focus`, with the `.dev` suffix for development. The published flavor is named `prod` because AGP forbids a product flavor sharing a name with the standard `release` build type.)*

## Technical Setup (Android)

Flavors are defined in `android/app/build.gradle.kts`:

```kotlin
android {
    namespace = "com.sleman.miro_focus"
    defaultConfig {
        applicationId = "com.sleman.miro_focus"
    }
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Mero Focus (Dev)")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "Mero Focus")
        }
    }
}
```

The manifest uses `android:label="@string/app_name"` so the label comes from the
flavor. The Kotlin `MainActivity` lives in package `com.sleman.miro_focus`,
matching the `namespace`.

## Running and Building

```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter build appbundle --flavor prod -t lib/main_release.dart
```

`lib/main_dev.dart` and `lib/main_release.dart` are two small files that only
select an `AppEnvironment` and hand the shared `MeroFocusApp` to `bootstrap()`
in `lib/bootstrap.dart` — **no logic duplication, just a different entry point.**
`bootstrap()` owns initialization, error wiring and the Riverpod overrides.
Plain `lib/main.dart` is kept as a backward-compatible dev entry point for
tooling that does not pass `-t`; always pass `-t lib/main_release.dart` for a
publishable build.

## Security Note
Any key/secret for an external provider (if Firebase is added later) is passed via `--dart-define` or config files not committed to Git (`google-services.json` per flavor in its own path), never hard-coded in the source.
