import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';

/// A compact label/value card used by the planner summaries and reports.
///
/// The value is the largest element and the label always uses the accessible
/// `onSurfaceVariant` ink, so no metadata is rendered in a pale brand tint.
class PlannerStatTile extends StatelessWidget {
  const PlannerStatTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$label: $value',
      child: ExcludeSemantics(
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.all(AppSpacing.xs),
          color: context.colors.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 24, color: context.colors.primary),
                  const SizedBox(height: AppSpacing.sm),
                ],
                AppText(value, variant: AppTextVariant.heading),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  label,
                  variant: AppTextVariant.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
