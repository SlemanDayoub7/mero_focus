import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mero_focus/core/theme/app_colors.dart';
import 'package:mero_focus/core/theme/app_theme.dart';
import 'package:mero_focus/features/review/presentation/pages/placeholder_review_page.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets(
    'placeholder heading uses the accessible onPrimaryContainer role in both modes',
    (tester) async {
      final theme = ValueNotifier<ThemeData>(AppTheme.light);
      addTearDown(theme.dispose);

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en')],
          path: 'assets/translations',
          child: Builder(
            builder: (context) => ValueListenableBuilder<ThemeData>(
              valueListenable: theme,
              builder: (context, value, _) => MaterialApp(
                theme: value,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: const PlaceholderReviewPage(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      Text heading() => tester.widget<Text>(
            find.descendant(
              of: find.byType(PlaceholderReviewPage),
              matching: find.byType(Text),
            ),
          );

      expect(heading().style?.color, AppColors.light.onPrimaryContainer);

      theme.value = AppTheme.dark;
      await tester.pumpAndSettle();

      expect(heading().style?.color, AppColors.dark.onPrimaryContainer);
    },
  );
}
