import 'package:flutter/material.dart';

/// Project-specific design values that are not part of Material's
/// [ColorScheme]. Always consumed via `context.appTheme`.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.focusPrimary,
    required this.focusBackground,
    required this.spacingUnit,
    this.backgroundAssetId = 'default',
  });

  /// Primary color of the focus/timer experience.
  final Color focusPrimary;

  /// Background color of the focus/timer experience.
  final Color focusBackground;

  /// Base spacing unit; all spacing is a multiple of this value.
  final double spacingUnit;

  /// Identifier of the user-selected background asset.
  final String backgroundAssetId;

  @override
  AppThemeExtension copyWith({
    Color? focusPrimary,
    Color? focusBackground,
    double? spacingUnit,
    String? backgroundAssetId,
  }) {
    return AppThemeExtension(
      focusPrimary: focusPrimary ?? this.focusPrimary,
      focusBackground: focusBackground ?? this.focusBackground,
      spacingUnit: spacingUnit ?? this.spacingUnit,
      backgroundAssetId: backgroundAssetId ?? this.backgroundAssetId,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      focusPrimary: Color.lerp(focusPrimary, other.focusPrimary, t)!,
      focusBackground: Color.lerp(focusBackground, other.focusBackground, t)!,
      spacingUnit: spacingUnit + (other.spacingUnit - spacingUnit) * t,
      backgroundAssetId: t < 0.5 ? backgroundAssetId : other.backgroundAssetId,
    );
  }
}

/// Unified access to [AppThemeExtension]; never call
/// `Theme.of(context).extension<AppThemeExtension>()` directly.
extension AppThemeContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
