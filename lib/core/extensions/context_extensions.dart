import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

extension ContextExtensions on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
  Size get screenSize => MediaQuery.sizeOf(this);
  Orientation get orientation => MediaQuery.orientationOf(this);
}

extension LocalizationExtensions on BuildContext {
  String translate(String key, {List<String>? args}) => key.tr(args: args);
  Future<void> changeLocale(Locale locale) => setLocale(locale);
  Locale get currentLocale => locale;
}
