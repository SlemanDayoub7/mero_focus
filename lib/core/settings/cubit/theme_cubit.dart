import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box settingsBox;

  ThemeCubit(this.settingsBox) : super(_loadInitial(settingsBox));

  static ThemeMode _loadInitial(Box box) {
    final stored = box.get('themeMode', defaultValue: 'system') as String;
    return _fromString(stored);
  }

  void setThemeMode(ThemeMode mode) {
    settingsBox.put('themeMode', _toString(mode));
    emit(mode);
  }

  static ThemeMode _fromString(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _toString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
