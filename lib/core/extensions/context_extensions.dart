import 'package:flutter/material.dart';

/// General-purpose `BuildContext` shortcuts.
///
/// Localization, theming and responsiveness each have their own dedicated
/// extension (see `core/l10n`, `core/theme` and `core/responsive`).
extension ContextExtensions on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textStyles => Theme.of(this).textTheme;

  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
}
