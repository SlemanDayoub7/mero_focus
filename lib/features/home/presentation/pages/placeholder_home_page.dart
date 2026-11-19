import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class PlaceholderHomePage extends StatelessWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? AppSpacing.xl : AppSpacing.lg),
          child: Text(
            context.l10n.appName,
            style: AppTypography.heading.copyWith(color: context.colors.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}
