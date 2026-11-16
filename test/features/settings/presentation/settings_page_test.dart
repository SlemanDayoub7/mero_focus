import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mero_focus/core/settings/cubit/theme_cubit.dart';
import 'package:mero_focus/features/settings/presentation/pages/settings_page.dart';

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

  testWidgets('tapping dark theme option updates ThemeCubit state', (tester) async {
    final fakeCubit = FakeThemeCubit();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar'),
        child: BlocProvider<ThemeCubit>.value(
          value: fakeCubit,
          child: Builder(
            builder: (context) => MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: const SettingsPage(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final darkTile = find.byType(RadioListTile<ThemeMode>).at(1);
    await tester.tap(darkTile);
    await tester.pumpAndSettle();

    expect(fakeCubit.state, ThemeMode.dark);
  });
}
