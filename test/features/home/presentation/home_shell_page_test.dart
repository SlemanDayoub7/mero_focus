import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mero_focus/core/settings/cubit/theme_cubit.dart';
import 'package:mero_focus/features/home/presentation/pages/home_shell_page.dart';

class FakeThemeCubit extends Cubit<ThemeMode> implements ThemeCubit {
  FakeThemeCubit() : super(ThemeMode.system);

  @override
  Box get settingsBox => throw UnimplementedError();

  @override
  void setThemeMode(ThemeMode mode) => emit(mode);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets(
    'bottom navigation labels follow the locale change without tapping a destination',
    (tester) async {
      late BuildContext appContext;

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('ar'), Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('ar'),
          child: BlocProvider<ThemeCubit>(
            create: (_) => FakeThemeCubit(),
            child: Builder(
              builder: (context) {
                appContext = context;
                return MaterialApp(
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  home: const HomeShellPage(),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await appContext.setLocale(const Locale('ar'));
      await tester.pumpAndSettle();

      expect(find.text('المراجعة'), findsWidgets);
      expect(find.text('Review'), findsNothing);

      await appContext.setLocale(const Locale('en'));
      await tester.pumpAndSettle();

      expect(find.text('Review'), findsWidgets);
      expect(find.text('المراجعة'), findsNothing);
    },
  );
}
