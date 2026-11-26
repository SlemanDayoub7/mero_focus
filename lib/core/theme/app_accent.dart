import 'package:flutter/material.dart';

import 'app_colors.dart';

/// User-selectable primary colours.
///
/// Every accent is dark enough for white text in both light and dark mode, so
/// the glass surfaces keep the same white ink regardless of the chosen theme.
/// `labelKey` points at the localized name used by the Settings chooser.
enum AppAccent {
  royal(id: 'royal', labelKey: 'accentRoyal', color: Color(0xFF1A4B8C)),
  violet(id: 'violet', labelKey: 'accentViolet', color: Color(0xFF5B3FA8)),
  crimson(id: 'crimson', labelKey: 'accentCrimson', color: Color(0xFFA1264E)),
  amber(id: 'amber', labelKey: 'accentAmber', color: Color(0xFF8A4B00)),
  emerald(id: 'emerald', labelKey: 'accentEmerald', color: Color(0xFF14653F)),
  magenta(id: 'magenta', labelKey: 'accentMagenta', color: Color(0xFFA02A75)),
  indigo(id: 'indigo', labelKey: 'accentIndigo', color: Color(0xFF2F3F9E)),
  olive(id: 'olive', labelKey: 'accentOlive', color: Color(0xFF4F6B00)),
  teal(id: 'teal', labelKey: 'accentTeal', color: Color(0xFF0E6E85)),
  cyan(id: 'cyan', labelKey: 'accentCyan', color: Color(0xFF0E7490)),
  orange(id: 'orange', labelKey: 'accentOrange', color: Color(0xFFA34A00)),
  rose(id: 'rose', labelKey: 'accentRose', color: Color(0xFF9D3A63)),
  grass(id: 'grass', labelKey: 'accentGrass', color: Color(0xFF3F6B2A)),
  plum(id: 'plum', labelKey: 'accentPlum', color: Color(0xFF6B3A8C)),
  slate(id: 'slate', labelKey: 'accentSlate', color: Color(0xFF43546B)),
  copper(id: 'copper', labelKey: 'accentCopper', color: Color(0xFF8C4A2F));

  const AppAccent({
    required this.id,
    required this.labelKey,
    required this.color,
  });

  /// Stable id used for persistence.
  final String id;

  /// ARB key of the name shown in the Settings chooser.
  final String labelKey;

  /// The single accent colour, used as `primary` in both themes.
  final Color color;

  // Kept as getters so existing callers that preview the swatch keep working.
  Color get lightPrimary => color;
  Color get darkPrimary => color;
  Color get lightContainer => color;
  Color get darkContainer => color;
  Color get lightOnContainer => AppColors.glassInk;
  Color get darkOnContainer => AppColors.glassInk;

  /// The original brand accent; used when no preference has been saved.
  static const AppAccent defaultAccent = royal;

  static AppAccent fromId(String? id) {
    for (final accent in AppAccent.values) {
      if (accent.id == id) return accent;
    }
    return AppAccent.defaultAccent;
  }

  /// Overrides only the primary roles; the glass surfaces and white ink come
  /// from [AppColors] and stay identical in light and dark mode.
  ColorScheme schemeFor(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    return base.copyWith(
      primary: color,
      onPrimary: AppColors.glassInk,
      primaryContainer: color,
      onPrimaryContainer: AppColors.glassInk,
      surfaceTint: Colors.transparent,
      inversePrimary: color,
    );
  }
}
