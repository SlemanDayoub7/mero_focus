# UI Foundation: Theming, Responsiveness, Localization

This foundation is built **before** any actual feature, because every later screen depends on it directly.

## 1. Theming — Easy App-Wide Switching

We use `ThemeExtension<T>` on top of standard `ThemeData` to define our own design values (not natively available in Material):

```dart
// core/theme/app_theme_extension.dart
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color focusPrimary;
  final Color focusBackground;
  final double spacingUnit; // base spacing unit (e.g. 8.0)
  final String backgroundAssetId; // user-selected background

  const AppThemeExtension({
    required this.focusPrimary,
    required this.focusBackground,
    required this.spacingUnit,
    required this.backgroundAssetId,
  });

  @override
  AppThemeExtension copyWith({...}) => ...;

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) => ...;
}

// Unified access via a BuildContext extension — never call Theme.of(context).extension<...> directly anywhere
extension AppThemeContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
```

**Switching mechanism:** a `themeSettingsProvider` (Riverpod) holds the user's current selection (primary color, background, light/dark), read from the `AppSettings` table (see `data-model.md`) and persisted there on any change. Any widget consuming `context.appTheme` automatically updates the moment the setting changes, with no additional manual wiring.

**Zero hard-coded colors:** any color in the app is read from `context.appTheme.xxx`, never a direct `Color(0xFF...)` inside a widget.

## 2. Responsiveness — Mobile/Tablet, Portrait/Landscape

Rather than relying on a heavy external library (to avoid accuracy/performance issues of some scaling packages), we build a simple utility:

```dart
// core/responsive/breakpoints.dart
enum DeviceType { mobile, tablet }

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  Orientation get orientation => MediaQuery.orientationOf(this);
  DeviceType get deviceType =>
      screenWidth >= 600 ? DeviceType.tablet : DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isLandscape => orientation == Orientation.landscape;
}
```

**Fixed design rule:** every screen is built with `LayoutBuilder` + `Flex`/`Wrap`/`Expanded` instead of fixed pixel dimensions. Where a genuinely different layout is needed between mobile and tablet (e.g. a single list vs. two columns), the decision is made via `context.isTablet` and `context.isLandscape` combined, within the same parent widget, without duplicating the entire screen's logic.

## 3. Localization — No Hard-coded Text, Ever

We use Flutter's official solution (`flutter_localizations` + ARB files) instead of free-text third-party libraries (such as `easy_localization`), because **ARB-based generation gives compile-time checking**: any missing key is caught immediately, unlike a free-text key lookup that can silently fail with a typo.

```
lib/l10n/
├── app_en.arb
└── app_ar.arb
```

Access from anywhere via a unified `BuildContext` extension (exactly as requested):

```dart
// core/l10n/l10n_context.dart
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// Usage in any widget:
Text(context.l10n.startFocusSession)
```

**Adding a new language later = adding a new `app_xx.arb` file only**, with zero code changes — this satisfies the requirement to "support any language added later."

## 4. No Hard-coding — Practical Summary

| Type | Defined In | Consumed As |
|---|---|---|
| Text | `lib/l10n/app_*.arb` | `context.l10n.key` |
| Colors | `AppThemeExtension` | `context.appTheme.colorName` |
| Spacing/dimensions | `AppThemeExtension.spacingUnit` or `core/constants/spacing.dart` | `context.appTheme.spacingUnit * n` |
| Default logical values (e.g. default Pomodoro duration) | `core/constants/defaults.dart` | direct import, never duplicated elsewhere |

## 5. Performance

- `const` constructors for every widget that doesn't depend on mutable state — naturally enforced since every widget is extracted as a class (see `coding-conventions.md`, item 1), this becomes natural rather than extra effort.
- Avoid unnecessary `Opacity`/`ClipRRect` in long lists (the statistics screen will show data-dense lists/charts) — use `RepaintBoundary` around complex chart elements.
- Always use `ListView.builder`/`SliverList` for long lists (session history, habit history), never `ListView(children: [...])` with unbounded data.
