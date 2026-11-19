import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/localization/locale_keys.g.dart';

class PlaceholderReviewPage extends StatelessWidget {
  const PlaceholderReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(
        child: Text(
          context.translate(LocaleKeys.review),
          style: AppTypography.heading.copyWith(color: context.colors.onPrimaryContainer),
        ),
      ),
    );
  }
}
