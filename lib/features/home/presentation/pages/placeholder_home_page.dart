import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/localization/locale_keys.g.dart';

class PlaceholderHomePage extends StatelessWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = Breakpoints.isTablet(context.screenSize.width);
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? AppSpacing.xl : AppSpacing.lg),
          child: Text(
            context.translate(LocaleKeys.app_name),
            style: AppTypography.heading.copyWith(color: context.colors.primary),
          ),
        ),
      ),
    );
  }
}
