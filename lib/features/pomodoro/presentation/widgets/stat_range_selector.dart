import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../domain/entities/stat_range.dart';

/// Single source for the day/week/month/year choice on both report tabs.
class StatRangeSelector extends StatelessWidget {
  const StatRangeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final StatRange selected;
  final ValueChanged<StatRange> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SegmentedButton<StatRange>(
      segments: [
        ButtonSegment(
          value: StatRange.day,
          label: Text(l10n.rangeDay),
          tooltip: l10n.rangeDay,
        ),
        ButtonSegment(
          value: StatRange.week,
          label: Text(l10n.rangeWeek),
          tooltip: l10n.rangeWeek,
        ),
        ButtonSegment(
          value: StatRange.month,
          label: Text(l10n.rangeMonth),
          tooltip: l10n.rangeMonth,
        ),
        ButtonSegment(
          value: StatRange.year,
          label: Text(l10n.rangeYear),
          tooltip: l10n.rangeYear,
        ),
      ],
      selected: {selected},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
