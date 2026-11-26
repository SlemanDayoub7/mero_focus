import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../formatting/duration_labels.dart';

/// Dependency-free bar chart for the report buckets (24h/7d/31d/12m).
///
/// One bar is the peak: it is taller, uses the primary action colour, and is
/// always named by [peakLabel] above the chart so colour is never the only
/// signal. Optional [labels] sit under the bars; an empty string means no
/// label for that bucket.
class MinutesBarChart extends StatelessWidget {
  const MinutesBarChart({
    super.key,
    required this.minutes,
    required this.peakLabel,
    this.labels,
  });

  final List<double> minutes;
  final String peakLabel;
  final List<String>? labels;

  static const double _barArea = 160;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final caption = AppTypography.caption.copyWith(
      color: colors.onSurfaceVariant,
    );

    var peak = 0.0;
    var peakIndex = -1;
    for (var i = 0; i < minutes.length; i++) {
      if (minutes[i] > peak) {
        peak = minutes[i];
        peakIndex = i;
      }
    }
    final scale = peak <= 0 ? 1.0 : peak;
    final names = labels;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.trending_up, size: 20, color: colors.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(peakLabel, style: AppTypography.label)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: _barArea,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < minutes.length; i++)
                Expanded(
                  child: Semantics(
                    label: i == peakIndex && minutes[i] > 0
                        ? l10n.reportPeak(
                            Duration(
                              seconds: (minutes[i] * 60).round(),
                            ).label(l10n),
                          )
                        : '${l10n.reportRangeFocus}: '
                            '${Duration(seconds: (minutes[i] * 60).round()).label(l10n)}',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.5),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: minutes[i] <= 0
                              ? 4
                              : 6 + (minutes[i] / scale) * (_barArea - 6),
                          decoration: BoxDecoration(
                            color: minutes[i] <= 0
                                ? colors.surfaceContainerHighest
                                : i == peakIndex
                                ? colors.primary
                                : colors.primaryContainer,
                            border: i == peakIndex || minutes[i] <= 0
                                ? null
                                : Border.all(
                                    color: colors.outlineVariant,
                                    width: 1,
                                  ),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (names != null && names.length == minutes.length) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final name in names)
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: caption,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
