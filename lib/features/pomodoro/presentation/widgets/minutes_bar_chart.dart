import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../formatting/duration_labels.dart';

/// Dependency-free bar chart for the report buckets (24h/7d/31d/12m).
///
/// Bars are rounded, the tallest one is emphasised, and optional [labels]
/// (one per bar, empty string = no label) sit under the bars.
class MinutesBarChart extends StatelessWidget {
  const MinutesBarChart({super.key, required this.minutes, this.labels});

  final List<double> minutes;
  final List<String>? labels;

  static const double _barArea = 140;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = context.colors;
    final textStyle = Theme.of(context).textTheme.labelSmall;

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Duration(seconds: (peak * 60).round()).label(l10n),
          style: textStyle,
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: _barArea,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < minutes.length; i++)
                Expanded(
                  child: Semantics(
                    label:
                        '${l10n.reportRangeFocus}: '
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
                                ? scheme.surfaceContainerHighest
                                : i == peakIndex
                                ? scheme.primary
                                : scheme.primary.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(6),
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
          const SizedBox(height: 4),
          Row(
            children: [
              for (final name in names)
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                    style: textStyle,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
