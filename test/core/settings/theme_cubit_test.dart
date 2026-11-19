import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:mero_focus/core/settings/cubit/theme_cubit.dart';

class MockBox extends Mock implements Box {}

void main() {
  late MockBox box;

  setUp(() {
    box = MockBox();
  });

  group('ThemeCubit', () {
    test('initial state is ThemeMode.system by default', () {
      when(() => box.get('themeMode', defaultValue: 'system')).thenReturn('system');
      final cubit = ThemeCubit(box);
      expect(cubit.state, ThemeMode.system);
    });

    test('initial state loads stored value from box', () {
      when(() => box.get('themeMode', defaultValue: 'system')).thenReturn('dark');
      final cubit = ThemeCubit(box);
      expect(cubit.state, ThemeMode.dark);
    });

    blocTest<ThemeCubit, ThemeMode>(
      'emits ThemeMode.light and persists it when setThemeMode(light) is called',
      setUp: () {
        when(() => box.get('themeMode', defaultValue: 'system')).thenReturn('system');
        when(() => box.put(any(), any())).thenAnswer((_) async {});
      },
      build: () => ThemeCubit(box),
      act: (cubit) => cubit.setThemeMode(ThemeMode.light),
      expect: () => [ThemeMode.light],
      verify: (_) {
        verify(() => box.put('themeMode', 'light')).called(1);
      },
    );
  });
}
