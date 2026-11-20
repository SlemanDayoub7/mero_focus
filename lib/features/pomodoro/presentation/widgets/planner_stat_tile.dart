import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_text.dart';

/// A compact label/value card used by the planner summaries and reports.
class PlannerStatTile extends StatelessWidget {
  const PlannerStatTile({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
