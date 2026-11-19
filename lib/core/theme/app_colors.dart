import 'package:flutter/material.dart';

/// Global color system of Mero Focus.
///
/// Holds the brand palette of the "Sky Blue Budgie" identity and the two
/// Material 3 [ColorScheme]s derived from it (light & dark).
///
/// Roles are distributed by *function*, not by the brand label:
/// * Sky Blue   -> `primary`           main action color.
/// * Deep Royal -> `secondary`         second action color. It sits ~39 dE76
///                                     away from Sky Blue, so a secondary
///                                     button never reads as "another primary".
/// * Ice Blue   -> `primaryContainer`  soft brand surfaces (chips, navigation
///                                     indicator). It is a tint of Sky Blue, so
///                                     it must never carry an action on its own.
/// * Muted Yellow -> `tertiary`        highlight / attention.
/// * Charcoal & Pure White -> neutrals (ink & canvas).
///
/// Every role is declared explicitly so the app never falls back to the
/// Material baseline palette.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Brand palette
  // ---------------------------------------------------------------------------

  /// Primary / Sky Blue.
  static const Color skyBlue = Color(0xFF4FA3D1);

  /// Secondary / Ice Blue.
  static const Color iceBlue = Color(0xFF85C5E3);

  /// Accent / Deep Royal Blue.
  static const Color royalBlue = Color(0xFF1A4B8C);

  /// Neutral Dark / Charcoal.
  static const Color charcoal = Color(0xFF2C2C2C);

  /// Neutral Light / Pure White.
  static const Color pureWhite = Color(0xFFFFFFFF);

  /// Highlight / Muted Yellow.
  static const Color mutedYellow = Color(0xFFC8B446);

  // ---------------------------------------------------------------------------
  // Light scheme
  // ---------------------------------------------------------------------------

  /// Light [ColorScheme]: white canvas, charcoal ink, sky blue primary actions
  /// and deep royal secondary actions.
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: skyBlue,
    onPrimary: charcoal,
    primaryContainer: iceBlue,
    onPrimaryContainer: royalBlue,
    secondary: royalBlue,
    // A soft Ice tint reads calmer than pure white on Deep Royal (~7:1).
    onSecondary: Color(0xFFD3EBF7),
    secondaryContainer: Color(0xFFD3EBF7),
    onSecondaryContainer: royalBlue,
    tertiary: mutedYellow,
    onTertiary: charcoal,
    tertiaryContainer: Color(0xFFF5EDC8),
    onTertiaryContainer: Color(0xFF4A4210),
    error: Color(0xFFB3261E),
    onError: pureWhite,
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: pureWhite,
    onSurface: charcoal,
    surfaceDim: Color(0xFFDDE6EC),
    surfaceBright: pureWhite,
    surfaceContainerLowest: pureWhite,
    surfaceContainerLow: Color(0xFFF5FAFD),
    surfaceContainer: Color(0xFFEEF6FB),
    surfaceContainerHigh: Color(0xFFE6F1F8),
    surfaceContainerHighest: Color(0xFFD3EBF7),
    onSurfaceVariant: Color(0xFF4E6573),
    outline: Color(0xFF7797AA),
    outlineVariant: Color(0xFFC3DCEA),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: charcoal,
    onInverseSurface: Color(0xFFF2F2F2),
    inversePrimary: iceBlue,
    surfaceTint: skyBlue,
  );

  // ---------------------------------------------------------------------------
  // Dark scheme
  // ---------------------------------------------------------------------------

  /// Dark [ColorScheme]: charcoal canvas, near-white ink, sky blue primary
  /// actions and deep royal secondary actions.
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: skyBlue,
    onPrimary: charcoal,
    primaryContainer: royalBlue,
    onPrimaryContainer: Color(0xFFD3EBF7),
    secondary: royalBlue,
    // Same soft Ice tint as light mode: ~7:1 on Deep Royal.
    onSecondary: Color(0xFFD3EBF7),
    secondaryContainer: Color(0xFF1F4F79),
    onSecondaryContainer: Color(0xFFD3EBF7),
    tertiary: mutedYellow,
    onTertiary: charcoal,
    tertiaryContainer: Color(0xFF4A4210),
    onTertiaryContainer: Color(0xFFF5EDC8),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    surface: charcoal,
    onSurface: Color(0xFFF2F2F2),
    surfaceDim: Color(0xFF242424),
    surfaceBright: Color(0xFF3A3A3A),
    surfaceContainerLowest: Color(0xFF1F1F1F),
    surfaceContainerLow: Color(0xFF262626),
    surfaceContainer: charcoal,
    surfaceContainerHigh: Color(0xFF363636),
    surfaceContainerHighest: Color(0xFF404040),
    onSurfaceVariant: Color(0xFFC6CDD2),
    outline: Color(0xFF8E979C),
    outlineVariant: Color(0xFF4A4F53),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFF2F2F2),
    onInverseSurface: charcoal,
    inversePrimary: royalBlue,
    surfaceTint: skyBlue,
  );
}
