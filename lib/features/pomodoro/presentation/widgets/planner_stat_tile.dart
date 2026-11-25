import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_text.dart';

/// A compact label/value card used by the planner summaries and reports.
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(4),
      color: context.colors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: context.colors.primary),
              const SizedBox(height: 4),
            ],
            AppText(value, variant: AppTextVariant.heading),
            const SizedBox(height: 4),
            AppText(
              label,
              variant: AppTextVariant.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
