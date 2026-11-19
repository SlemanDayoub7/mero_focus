# App Icon (Adaptive Icon) and Splash Screen

## Adaptive Icon

Android (since version 8) requires a two-layer icon rather than a single image: `foreground` (the actual mark) and `background` (a color or pattern), so the system can crop it into different shapes (circle, square, rounded square...) depending on the device's launcher.

**Recommended tool:** the `flutter_launcher_icons` package — automatically generates all required sizes/densities from just two source images (foreground + background), instead of preparing them manually for every screen density.

**A small but worthwhile touch — Themed/Monochrome Icon:**
Since Android 13, the system supports "Themed Icons," where it takes a single-color (silhouette) icon and automatically tints it to match the device's wallpaper-based colors (Material You Dynamic Color), if the user enables that option. Preparing a simple `monochrome` version of the icon is a low-cost addition that gives a more polished impression on modern devices.

## Splash Screen

Since Android 12, the system has an official Splash Screen API, replacing older manual approaches (a temporary screen built in Flutter itself, which is prone to flicker/delay issues).

**Recommended tool:** the `flutter_native_splash` package — automatically handles the differences between Android 12+ (which has its own specific display and transition behavior from the system) and older versions, generating the required configuration for both from a single image and color definition.

## Tying This Back to the Existing Visual Identity

Colors used in the icon and splash screen must be sourced from the same base `AppThemeExtension` definition (see `ui-foundation-and-conventions.md`), not separate colors reinvented here — even though these assets are generated outside the normal UI build cycle (via the tools above, not as widgets).
