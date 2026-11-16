import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/localization/locale_keys.g.dart';

class PlaceholderPomodoroPage extends StatelessWidget {
  const PlaceholderPomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(
        child: Text(
          context.translate(LocaleKeys.pomodoro),
          style: AppTypography.heading.copyWith(color: context.colors.onPrimaryContainer),
        ),
      ),
    );
  }
}
