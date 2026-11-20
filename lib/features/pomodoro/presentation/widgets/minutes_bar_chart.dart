import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../formatting/duration_labels.dart';

/// Dependency-free bar chart for the report buckets (24h/7d/31d/12m).
class MinutesBarChart extends StatelessWidget {
  const MinutesBarChart({super.key, required this.minutes});

  final List<double> minutes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    var peak = 1.0;
    for (final value in minutes) {
      if (value > peak) peak = value;
    }

    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var index = 0; index < minutes.length; index++)
            Expanded(
              child: Semantics(
                label:
                    '${l10n.reportRangeFocus}: '
                    '${Duration(seconds: (minutes[index] * 60).round()).label(l10n)}',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 4 + (minutes[index] / peak) * 148,
                      decoration: BoxDecoration(
                        color: context.colors.primary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppSpacing.xs),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
