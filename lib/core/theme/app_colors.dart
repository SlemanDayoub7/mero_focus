import 'package:flutter/material.dart';

/// Global color system of Mero Focus.
///
/// Brand hues are preserved, but roles follow WCAG contrast rather than the
/// decorative identity labels:
/// * Deep Royal is `primary` — 8.65:1 on white, safe for buttons and text.
/// * Deep Teal is `secondary` — 5.85:1 on white and 34.6 dE76 away from
///   Deep Royal, so the two action colors never read as the same blue.
/// * Sky Blue and Ice Blue are accents/containers only: 2.8:1 on white, so
///   they must never carry small text or stand alone as an action color.
/// * Muted Yellow is `tertiary` — only used with charcoal ink (6.7:1).
///
/// Never instantiate a `Color(0xFF...)` in a widget. If a color is needed,
/// add it here or use the theme's [ColorScheme].
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Brand palette
  // ---------------------------------------------------------------------------

  /// Sky Blue — decorative accent / large surfaces only.
  static const Color skyBlue = Color(0xFF4FA3D1);

  /// Ice Blue — soft brand surface, never an action color on light surfaces.
  static const Color iceBlue = Color(0xFF85C5E3);

  /// Deep Royal Blue — accessible primary action and link color.
  static const Color royalBlue = Color(0xFF1A4B8C);

  /// Deep Teal — accessible secondary action color, deliberately shifted
  /// away from Deep Royal so the two actions stay perceptually distinct.
  static const Color deepTeal = Color(0xFF0E6E85);

  /// Neutral Dark / Charcoal — ink on light surfaces.
  static const Color charcoal = Color(0xFF2C2C2C);

  /// Neutral Light / Pure White — canvas on light surfaces.
  static const Color pureWhite = Color(0xFFFFFFFF);

  /// Highlight / Muted Yellow — used only with charcoal ink.
  static const Color mutedYellow = Color(0xFFC8B446);

  // ---------------------------------------------------------------------------
  // Glass surfaces — the same in light and dark mode
  // ---------------------------------------------------------------------------

  /// Opaque canvas for pushed routes: they must not reveal the shell's image.
  static const Color appCanvas = Color(0xFF101216);

  /// Translucent black used by cards, containers, sheets and other surfaces.
  /// Equivalent to `Colors.black.withOpacity(0.5)`.
  static const Color glassSurface = Color(0x80000000);

  /// Softer scrim placed directly on top of the background image.
  static const Color glassScrim = Color(0x59000000);

  /// White ink stays readable on a translucent black surface in both themes.
  static const Color glassInk = pureWhite;

  /// Slightly softer white for metadata on the same glass surface.
  static const Color glassInkMuted = Color(0xDEFFFFFF);

  /// Errors are foreground accents on dark glass, not pale light-mode boxes.
  static const Color glassError = Color(0xFFFF9A8F);

  /// Red-tinted glass used by error notices.
  static const Color glassErrorContainer = Color(0x80B3261E);

  // ---------------------------------------------------------------------------
  // Light scheme — same glass surfaces as dark, with white ink
  // ---------------------------------------------------------------------------

  /// Light mode: the same translucent-black glass and white ink as dark mode.
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: royalBlue,
    onPrimary: pureWhite,
    primaryContainer: Color(0xFFD3EBF7),
    onPrimaryContainer: royalBlue,
    secondary: deepTeal,
    onSecondary: pureWhite,
    secondaryContainer: Color(0xFFD5EFF0),
    onSecondaryContainer: Color(0xFF0B4F5C),
    tertiary: mutedYellow,
    onTertiary: charcoal,
    tertiaryContainer: Color(0xFFF5EDC8),
    onTertiaryContainer: Color(0xFF4A4210),
    error: glassError,
    onError: charcoal,
    errorContainer: glassErrorContainer,
    onErrorContainer: glassInk,
    surface: glassSurface,
    onSurface: glassInk,
    surfaceDim: glassSurface,
    surfaceBright: glassSurface,
    surfaceContainerLowest: glassSurface,
    surfaceContainerLow: glassSurface,
    surfaceContainer: glassSurface,
    surfaceContainerHigh: glassSurface,
    surfaceContainerHighest: glassSurface,
    onSurfaceVariant: glassInkMuted,
    outline: glassInkMuted,
    outlineVariant: Color(0x66FFFFFF),
    shadow: charcoal,
    scrim: glassScrim,
    inverseSurface: glassSurface,
    onInverseSurface: glassInk,
    inversePrimary: iceBlue,
    surfaceTint: royalBlue,
  );

  // ---------------------------------------------------------------------------
  // Dark scheme — contrast checked against charcoal / near-white
  // ---------------------------------------------------------------------------

  /// Dark mode: translucent-black glass and white ink over the background.
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: iceBlue,
    onPrimary: charcoal,
    primaryContainer: royalBlue,
    onPrimaryContainer: Color(0xFFD3EBF7),
    secondary: Color(0xFF8CE0CF),
    onSecondary: charcoal,
    secondaryContainer: Color(0xFF104C55),
    onSecondaryContainer: Color(0xFFD5EFF0),
    tertiary: mutedYellow,
    onTertiary: charcoal,
    tertiaryContainer: Color(0xFF4A4210),
    onTertiaryContainer: Color(0xFFF5EDC8),
    error: glassError,
    onError: charcoal,
    errorContainer: glassErrorContainer,
    onErrorContainer: glassInk,
    surface: glassSurface,
    onSurface: glassInk,
    surfaceDim: glassSurface,
    surfaceBright: glassSurface,
    surfaceContainerLowest: glassSurface,
    surfaceContainerLow: glassSurface,
    surfaceContainer: glassSurface,
    surfaceContainerHigh: glassSurface,
    surfaceContainerHighest: glassSurface,
    onSurfaceVariant: glassInkMuted,
    outline: glassInkMuted,
    outlineVariant: Color(0x66FFFFFF),
    shadow: charcoal,
    scrim: glassScrim,
    inverseSurface: glassSurface,
    onInverseSurface: glassInk,
    inversePrimary: royalBlue,
    surfaceTint: iceBlue,
  );
}
