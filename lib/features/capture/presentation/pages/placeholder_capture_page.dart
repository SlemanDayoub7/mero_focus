import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_typography.dart';

class PlaceholderCapturePage extends StatelessWidget {
  const PlaceholderCapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(
        child: Text(
          context.l10n.addEntry,
          style: AppTypography.heading.copyWith(color: context.colors.onPrimaryContainer),
        ),
      ),
    );
  }
}
