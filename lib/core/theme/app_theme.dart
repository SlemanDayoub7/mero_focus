import 'package:flutter/material.dart';

import 'app_accent.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';
import 'app_theme_extension.dart';
import 'app_typography.dart';

/// Builds the app [ThemeData] for light and dark mode.
///
/// Both themes start from the [AppColors] schemes and one [TextTheme], so every
/// Material component stays accessible and every control is at least 48 dp
/// tall. The primary roles are replaced by the user-selected [AppAccent].
abstract final class AppTheme {
  /// Default themes kept for callers that do not watch the accent provider.
  static ThemeData get light => lightFor(AppAccent.defaultAccent);

  static ThemeData get dark => darkFor(AppAccent.defaultAccent);

  static ThemeData lightFor(AppAccent accent) =>
      _build(accent.schemeFor(Brightness.light));

  static ThemeData darkFor(AppAccent accent) =>
      _build(accent.schemeFor(Brightness.dark));

  static ThemeData _build(ColorScheme scheme) {
    final textTheme = AppTextStyles.themeFor(scheme);
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
    );
    // Every theme is glass: translucent black surfaces, white ink. Light and
    // dark mode differ only in the accent intensity, never in surface colour.
    final softOutline = BorderSide(
      color: Colors.white.withValues(alpha: 0.25),
      width: 1,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      fontFamily: AppTypography.family,
      textTheme: textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.22),
        thickness: 1,
        space: AppSpacing.md,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.glassInk,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: AppSpacing.md,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: const IconThemeData(color: AppColors.glassInk, size: 24),
        actionsIconTheme: const IconThemeData(
          color: AppColors.glassInk,
          size: 24,
        ),
        toolbarHeight: 64,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.glassSurface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium!.copyWith(
            color: selected
                ? scheme.onPrimaryContainer
                : AppColors.glassInkMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? scheme.onPrimaryContainer
                : AppColors.glassInkMuted,
            size: 24,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.12),
          disabledForegroundColor: AppColors.glassInkMuted,
          minimumSize: const Size(72, AppSpacing.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(72, AppSpacing.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.55),
            width: 1.5,
          ),
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(64, AppSpacing.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(
            AppSpacing.minTouchTarget,
            AppSpacing.minTouchTarget,
          ),
          foregroundColor: AppColors.glassInk,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            const Size(72, AppSpacing.controlHeight),
          ),
          textStyle: WidgetStateProperty.all(textTheme.labelMedium),
          shape: WidgetStateProperty.all(buttonShape),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.glassSurface,
        selectedColor: scheme.primaryContainer,
        disabledColor: AppColors.glassSurface,
        labelStyle: textTheme.labelMedium!.copyWith(color: AppColors.glassInk),
        secondaryLabelStyle: textTheme.labelMedium!.copyWith(
          color: scheme.onPrimaryContainer,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          side: softOutline,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        constraints: const BoxConstraints(minHeight: AppSpacing.controlHeight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: softOutline,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        hintStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.glassInkMuted,
        ),
        helperStyle: textTheme.bodySmall,
        errorStyle: textTheme.bodySmall?.copyWith(color: scheme.error),
      ),
      cardTheme: CardThemeData(
        color: AppColors.glassSurface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: softOutline,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.glassSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleMedium,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.glassSurface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearMinHeight: 6,
        linearTrackColor: Colors.white.withValues(alpha: 0.18),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.glassSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.glassInk,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppThemeExtension(
          focusPrimary: scheme.primary,
          focusBackground: AppColors.glassSurface,
          spacingUnit: AppSpacing.sm,
        ),
      ],
    );
  }
}
