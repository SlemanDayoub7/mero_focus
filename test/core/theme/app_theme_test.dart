import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/theme/app_colors.dart';
import 'package:mero_focus/core/theme/app_theme.dart';

/// WCAG relative luminance of [color].
double _luminance(Color color) {
  double channel(double value) => value <= 0.03928
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

/// WCAG contrast ratio between [a] and [b] (1.0 .. 21.0).
double _contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

/// CIE L*a*b* coordinates of [color] (D65, 2 degree observer).
List<double> _lab(Color color) {
  double linear(double value) => value <= 0.04045
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4).toDouble();

  final r = linear(color.r);
  final g = linear(color.g);
  final b = linear(color.b);

  final x = (0.4124564 * r + 0.3575761 * g + 0.1804375 * b) / 0.95047;
  final y = 0.2126729 * r + 0.7151522 * g + 0.0721750 * b;
  final z = (0.0193339 * r + 0.1191920 * g + 0.9503041 * b) / 1.08883;

  double f(double t) =>
      t > 0.008856 ? math.pow(t, 1 / 3).toDouble() : 7.787 * t + 16 / 116;

  final fx = f(x);
  final fy = f(y);
  final fz = f(z);

  return [116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz)];
}

/// CIE76 colour difference between [a] and [b] (0 = identical, > 2.3 = visible
/// to the human eye, > 20 = clearly different colours).
double _deltaE76(Color a, Color b) {
  final la = _lab(a);
  final lb = _lab(b);
  return math.sqrt(
    math.pow(la[0] - lb[0], 2) +
        math.pow(la[1] - lb[1], 2) +
        math.pow(la[2] - lb[2], 2),
  );
}

void _expectAa(Color background, Color foreground, String role) {
  final ratio = _contrast(background, foreground);
  expect(
    ratio,
    greaterThanOrEqualTo(4.5),
    reason: '$role has a contrast ratio of ${ratio.toStringAsFixed(2)}:1',
  );
}

void main() {
  group('brand palette', () {
    test('matches the Sky Blue Budgie identity', () {
      expect(AppColors.skyBlue, const Color(0xFF4FA3D1));
      expect(AppColors.iceBlue, const Color(0xFF85C5E3));
      expect(AppColors.royalBlue, const Color(0xFF1A4B8C));
      expect(AppColors.charcoal, const Color(0xFF2C2C2C));
      expect(AppColors.pureWhite, const Color(0xFFFFFFFF));
      expect(AppColors.mutedYellow, const Color(0xFFC8B446));
    });
  });

  group('light scheme', () {
    final scheme = AppColors.light;

    test('maps the palette onto the Material 3 roles', () {
      expect(scheme.brightness, Brightness.light);
      expect(scheme.primary, AppColors.skyBlue);
      expect(scheme.onPrimary, AppColors.charcoal);
      expect(scheme.secondary, AppColors.royalBlue);
      expect(scheme.onSecondary, const Color(0xFFD3EBF7));
      expect(scheme.tertiary, AppColors.mutedYellow);
      expect(scheme.surface, AppColors.pureWhite);
      expect(scheme.onSurface, AppColors.charcoal);
      expect(scheme.primaryContainer, AppColors.iceBlue);
      expect(scheme.onPrimaryContainer, AppColors.royalBlue);
      expect(scheme.secondaryContainer, const Color(0xFFD3EBF7));
      expect(scheme.onSecondaryContainer, AppColors.royalBlue);
    });

    test('every text pair meets WCAG AA contrast', () {
      _expectAa(scheme.primary, scheme.onPrimary, 'primary/onPrimary');
      _expectAa(
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        'primaryContainer/onPrimaryContainer',
      );
      _expectAa(scheme.secondary, scheme.onSecondary, 'secondary/onSecondary');
      _expectAa(
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
        'secondaryContainer/onSecondaryContainer',
      );
      _expectAa(scheme.tertiary, scheme.onTertiary, 'tertiary/onTertiary');
      _expectAa(
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
        'tertiaryContainer/onTertiaryContainer',
      );
      _expectAa(scheme.surface, scheme.onSurface, 'surface/onSurface');
      _expectAa(
        scheme.surface,
        scheme.onSurfaceVariant,
        'surface/onSurfaceVariant',
      );
      _expectAa(
        scheme.surfaceContainerHighest,
        scheme.onSurface,
        'surfaceContainerHighest/onSurface',
      );
      _expectAa(
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
        'surfaceContainerHighest/onSurfaceVariant',
      );
      _expectAa(
        scheme.inverseSurface,
        scheme.onInverseSurface,
        'inverseSurface/onInverseSurface',
      );
      _expectAa(scheme.error, scheme.onError, 'error/onError');
    });

    test('outline stays visible on the surface (>= 3:1)', () {
      expect(
        _contrast(scheme.surface, scheme.outline),
        greaterThanOrEqualTo(3.0),
      );
    });
  });

  group('dark scheme', () {
    final scheme = AppColors.dark;

    test('maps the palette onto the Material 3 roles', () {
      expect(scheme.brightness, Brightness.dark);
      expect(scheme.primary, AppColors.skyBlue);
      expect(scheme.onPrimary, AppColors.charcoal);
      expect(scheme.secondary, AppColors.royalBlue);
      expect(scheme.onSecondary, const Color(0xFFD3EBF7));
      expect(scheme.tertiary, AppColors.mutedYellow);
      expect(scheme.surface, AppColors.charcoal);
      expect(scheme.onSurface, const Color(0xFFF2F2F2));
      expect(scheme.primaryContainer, AppColors.royalBlue);
      expect(scheme.onPrimaryContainer, const Color(0xFFD3EBF7));
      expect(scheme.secondaryContainer, const Color(0xFF1F4F79));
      expect(scheme.onSecondaryContainer, const Color(0xFFD3EBF7));
    });

    test('every text pair meets WCAG AA contrast', () {
      _expectAa(scheme.primary, scheme.onPrimary, 'primary/onPrimary');
      _expectAa(
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        'primaryContainer/onPrimaryContainer',
      );
      _expectAa(scheme.secondary, scheme.onSecondary, 'secondary/onSecondary');
      _expectAa(
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
        'secondaryContainer/onSecondaryContainer',
      );
      _expectAa(scheme.tertiary, scheme.onTertiary, 'tertiary/onTertiary');
      _expectAa(
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
        'tertiaryContainer/onTertiaryContainer',
      );
      _expectAa(scheme.surface, scheme.onSurface, 'surface/onSurface');
      _expectAa(
        scheme.surface,
        scheme.onSurfaceVariant,
        'surface/onSurfaceVariant',
      );
      _expectAa(
        scheme.surfaceContainerHighest,
        scheme.onSurface,
        'surfaceContainerHighest/onSurface',
      );
      _expectAa(
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
        'surfaceContainerHighest/onSurfaceVariant',
      );
      _expectAa(
        scheme.inverseSurface,
        scheme.onInverseSurface,
        'inverseSurface/onInverseSurface',
      );
      _expectAa(scheme.error, scheme.onError, 'error/onError');
    });

    test('outline stays visible on the surface (>= 3:1)', () {
      expect(
        _contrast(scheme.surface, scheme.outline),
        greaterThanOrEqualTo(3.0),
      );
    });
  });

  group('role distribution', () {
    test('primary and secondary are perceptually distinct in both schemes', () {
      for (final entry in <String, ColorScheme>{
        'light': AppColors.light,
        'dark': AppColors.dark,
      }.entries) {
        final distance = _deltaE76(entry.value.primary, entry.value.secondary);
        expect(
          distance,
          greaterThanOrEqualTo(20),
          reason: '${entry.key} primary/secondary dE76 is '
              '${distance.toStringAsFixed(1)}; they would read as the same '
              'colour',
        );
      }
    });

    test('secondary label is a soft brand tint, not plain white', () {
      for (final scheme in [AppColors.light, AppColors.dark]) {
        final ratio = _contrast(scheme.secondary, scheme.onSecondary);

        expect(
          scheme.onSecondary,
          isNot(AppColors.pureWhite),
          reason: 'pure white on Deep Royal is harsh at small sizes',
        );
        expect(
          ratio,
          greaterThanOrEqualTo(6.9),
          reason: 'secondary/onSecondary is only '
              '${ratio.toStringAsFixed(2)}:1 (target is the AAA ~7:1)',
        );
      }
    });
  });

  group('AppTheme', () {
    test('light theme is Material 3 and uses the light scheme', () {
      final theme = AppTheme.light;

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, AppColors.light.primary);
      expect(theme.colorScheme.surface, AppColors.light.surface);
      expect(theme.scaffoldBackgroundColor, AppColors.light.surface);
      expect(theme.appBarTheme.backgroundColor, AppColors.light.surface);
      expect(
        theme.navigationBarTheme.indicatorColor,
        AppColors.light.primaryContainer,
      );
      expect(
        theme.filledButtonTheme.style?.backgroundColor?.resolve(<WidgetState>{}),
        AppColors.light.primary,
      );
      expect(
        theme.filledButtonTheme.style?.foregroundColor?.resolve(<WidgetState>{}),
        AppColors.light.onPrimary,
      );
    });

    test('dark theme is Material 3 and uses the dark scheme', () {
      final theme = AppTheme.dark;

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, AppColors.dark.primary);
      expect(theme.colorScheme.surface, AppColors.dark.surface);
      expect(theme.scaffoldBackgroundColor, AppColors.dark.surface);
      expect(theme.appBarTheme.backgroundColor, AppColors.dark.surface);
      expect(
        theme.navigationBarTheme.indicatorColor,
        AppColors.dark.primaryContainer,
      );
      expect(
        theme.filledButtonTheme.style?.backgroundColor?.resolve(<WidgetState>{}),
        AppColors.dark.primary,
      );
      expect(
        theme.filledButtonTheme.style?.foregroundColor?.resolve(<WidgetState>{}),
        AppColors.dark.onPrimary,
      );
    });
  });
}
