import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';

/// Honest empty state for the review tab: no business logic, one next step.
class PlaceholderReviewPage extends StatelessWidget {
  const PlaceholderReviewPage({super.key, this.onGoToTimer});

  /// Supplied by the tab host so the action switches tabs instead of pushing
  /// a second copy of the app.
  final VoidCallback? onGoToTimer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline_outlined,
              size: AppSpacing.xxl,
              color: context.colors.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.comingSoonTitle,
              textAlign: TextAlign.center,
              style: AppTypography.heading.copyWith(
                color: context.colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(l10n.comingSoonBody, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.pomodoro,
              icon: Icons.timer_outlined,
              isSecondary: true,
              onPressed:
                  onGoToTimer ?? () => unawaited(AppRouter.toPomodoro(context)),
            ),
          ],
        ),
      ),
    );
  }
}
