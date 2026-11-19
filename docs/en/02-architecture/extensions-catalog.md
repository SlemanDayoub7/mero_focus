# Extensions Catalog

Fixed rule: **any frequently-used value (translation, theme, screen dimensions...) gets one unified extension, and the underlying API (`Theme.of`, `MediaQuery.of`, `AppLocalizations.of`...) is never called directly from any widget.** Every extension is registered in this file as soon as it's created.

| Extension | Location | Purpose | Returns |
|---|---|---|---|
| `L10nContext.l10n` | `core/l10n/l10n_context.dart` | Localized text | `AppLocalizations` |
| `AppThemeContext.appTheme` | `core/theme/app_theme_extension.dart` | Custom colors/spacing/background | `AppThemeExtension` |
| `ResponsiveContext.deviceType` / `.isTablet` / `.isLandscape` / `.screenWidth` | `core/responsive/breakpoints.dart` | Layout decisions based on screen size/orientation | `DeviceType` / `bool` / `double` |

## Rule for Adding New Extensions

Any new extension must:
1. Only be added if its value is used by more than one widget (otherwise it stays a local variable inside that widget).
2. Be registered in this table immediately, within the same PR that introduces it.
3. Always live under `core/` (no extension specific to a single feature, unless its use is genuinely confined to that feature, in which case it lives under `features/<feature>/presentation/extensions/`).
