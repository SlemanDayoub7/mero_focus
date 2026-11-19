import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/theme/app_theme.dart';
import 'package:mero_focus/core/theme/app_theme_extension.dart';

void main() {
  test('both themes register the AppThemeExtension', () {
    for (final theme in <ThemeData>[AppTheme.light, AppTheme.dark]) {
      expect(theme.extension<AppThemeExtension>(), isNotNull);
    }
  });

  test('copyWith keeps unchanged values', () {
    const extension = AppThemeExtension(
      focusPrimary: Colors.blue,
      focusBackground: Colors.white,
      spacingUnit: 8,
      backgroundAssetId: 'default',
    );

    final updated = extension.copyWith(focusPrimary: Colors.red);

    expect(updated.focusPrimary, Colors.red);
    expect(updated.focusBackground, Colors.white);
    expect(updated.spacingUnit, 8);
    expect(updated.backgroundAssetId, 'default');
  });

  testWidgets('context.appTheme exposes the registered extension',
      (tester) async {
    late AppThemeExtension resolved;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) {
            resolved = context.appTheme;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolved.spacingUnit, greaterThan(0));
    expect(resolved.focusPrimary, AppTheme.light.colorScheme.primary);
  });
}
