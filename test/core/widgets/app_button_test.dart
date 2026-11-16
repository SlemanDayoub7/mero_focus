import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/theme/app_theme.dart';
import 'package:mero_focus/core/widgets/app_button.dart';

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

/// CIE76 colour difference (0 = identical, >= 20 = clearly different).
double _deltaE76(Color a, Color b) {
  final la = _lab(a);
  final lb = _lab(b);
  return math.sqrt(
    math.pow(la[0] - lb[0], 2) +
        math.pow(la[1] - lb[1], 2) +
        math.pow(la[2] - lb[2], 2),
  );
}

/// WCAG relative luminance of [color].
double _luminance(Color color) {
  double channel(double value) => value <= 0.03928
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

/// WCAG contrast ratio between [a] and [b].
double _contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

Future<void> _pumpButtons(WidgetTester tester, ThemeData theme) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Column(
          children: [
            AppButton(label: 'primary', onPressed: () {}),
            AppButton(label: 'secondary', onPressed: () {}, isSecondary: true),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Resolved background colour of the [AppButton] showing [label].
Color _backgroundOf(WidgetTester tester, String label) {
  final button = tester.widget<FilledButton>(
    find.ancestor(
      of: find.text(label),
      matching: find.byType(FilledButton),
    ),
  );
  return button.style!.backgroundColor!.resolve(<WidgetState>{})!;
}

void main() {
  for (final entry in <String, ThemeData>{
    'light': AppTheme.light,
    'dark': AppTheme.dark,
  }.entries) {
    testWidgets('${entry.key}: primary and secondary buttons are clearly '
        'different', (tester) async {
      await _pumpButtons(tester, entry.value);

      final primary = _backgroundOf(tester, 'primary');
      final secondary = _backgroundOf(tester, 'secondary');

      expect(primary, entry.value.colorScheme.primary);
      expect(secondary, entry.value.colorScheme.secondary);

      final distance = _deltaE76(primary, secondary);
      expect(
        distance,
        greaterThanOrEqualTo(20),
        reason: 'the two buttons only differ by dE76 '
            '${distance.toStringAsFixed(1)}',
      );
    });

    testWidgets('${entry.key}: both buttons keep WCAG AA label contrast',
        (tester) async {
      await _pumpButtons(tester, entry.value);

      final scheme = entry.value.colorScheme;
      expect(
        _contrast(scheme.primary, scheme.onPrimary),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(scheme.secondary, scheme.onSecondary),
        greaterThanOrEqualTo(4.5),
      );
    });
  }
}
