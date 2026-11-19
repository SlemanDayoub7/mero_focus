import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_typography.dart';

class PlaceholderReviewPage extends StatelessWidget {
  const PlaceholderReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(
        child: Text(
          context.l10n.review,
          style: AppTypography.heading.copyWith(color: context.colors.onPrimaryContainer),
        ),
      ),
    );
  }
}
