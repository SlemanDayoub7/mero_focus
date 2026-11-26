import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// The single text theme used by every Material widget in the app.
///
/// Keeping one [TextTheme] avoids the old split between `AppTypography` and
/// widget defaults: explicit `Text(...)` styles inherit these sizes, and
/// user-selected text scaling still applies on top of them.
abstract final class AppTextStyles {
  static TextTheme themeFor(ColorScheme scheme) => TextTheme(
    displayLarge: AppTypography.display.copyWith(color: scheme.onSurface),
    displayMedium: AppTypography.heading.copyWith(color: scheme.onSurface),
    displaySmall: AppTypography.title.copyWith(color: scheme.onSurface),
    headlineLarge: AppTypography.heading.copyWith(color: scheme.onSurface),
    headlineMedium: AppTypography.title.copyWith(color: scheme.onSurface),
    headlineSmall: AppTypography.title.copyWith(color: scheme.onSurface),
    titleLarge: AppTypography.title.copyWith(color: scheme.onSurface),
    titleMedium: AppTypography.bodyStrong.copyWith(color: scheme.onSurface),
    titleSmall: AppTypography.label.copyWith(color: scheme.onSurface),
    bodyLarge: AppTypography.body.copyWith(color: scheme.onSurface),
    bodyMedium: AppTypography.body.copyWith(color: scheme.onSurface),
    bodySmall: AppTypography.caption.copyWith(color: scheme.onSurfaceVariant),
    labelLarge: AppTypography.bodyStrong.copyWith(color: scheme.onSurface),
    labelMedium: AppTypography.label.copyWith(color: scheme.onSurface),
    labelSmall: AppTypography.caption.copyWith(color: scheme.onSurfaceVariant),
  );

  static TextTheme get light => themeFor(AppColors.light);

  static TextTheme get dark => themeFor(AppColors.dark);
}
