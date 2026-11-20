import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/di/core_providers.dart';
import 'package:mero_focus/core/routing/app_router.dart';
import 'package:mero_focus/features/settings/presentation/pages/settings_page.dart';
import 'package:mero_focus/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('routes map declares every named destination', () {
    expect(
      AppRouter.routes.keys,
      containsAll(<String>[
        AppRouter.review,
        AppRouter.capture,
        AppRouter.settings,
        AppRouter.tasks,
        AppRouter.doneTasks,
        AppRouter.subjects,
        AppRouter.reports,
      ]),
    );
  });

  testWidgets('toSettings navigates through the named route', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          routes: Map<String, WidgetBuilder>.fromEntries(
            AppRouter.routes.entries.where(
              (entry) => entry.key != AppRouter.home,
            ),
          ),
          home: const SizedBox.shrink(key: Key('home')),
        ),
      ),
    );

    AppRouter.toSettings(tester.element(find.byKey(const Key('home'))));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
