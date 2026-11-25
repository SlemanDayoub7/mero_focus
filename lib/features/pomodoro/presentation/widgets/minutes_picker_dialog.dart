import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/l10n_context.dart';

const int kMinTimerMinutes = 1;
const int kMaxTimerMinutes = 500;

/// Wheel picker (1..500 minutes). Returns the chosen minutes or null.
Future<int?> showMinutesPicker(
  BuildContext context, {
  required String title,
  required int initialMinutes,
}) {
  return showDialog<int>(
    context: context,
    builder: (_) =>
        _MinutesPickerDialog(title: title, initialMinutes: initialMinutes),
  );
}

class _MinutesPickerDialog extends StatefulWidget {
  const _MinutesPickerDialog({
    required this.title,
    required this.initialMinutes,
  });

  final String title;
  final int initialMinutes;

  @override
  State<_MinutesPickerDialog> createState() => _MinutesPickerDialogState();
}

class _MinutesPickerDialogState extends State<_MinutesPickerDialog> {
  static const double _itemExtent = 48;

  late int _value = widget.initialMinutes.clamp(
    kMinTimerMinutes,
    kMaxTimerMinutes,
  );
  late final FixedExtentScrollController _controller =
      FixedExtentScrollController(initialItem: _value - kMinTimerMinutes);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(widget.title, textAlign: TextAlign.center),
      content: SizedBox(
        height: 200,
        width: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            IgnorePointer(
              child: Container(
                height: _itemExtent,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: _itemExtent,
              diameterRatio: 1.8,
              perspective: 0.004,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.selectionClick();
                setState(() => _value = index + kMinTimerMinutes);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: kMaxTimerMinutes - kMinTimerMinutes + 1,
                builder: (context, index) {
                  final minutes = index + kMinTimerMinutes;
                  final selected = minutes == _value;
                  return Center(
                    child: Text(
                      '$minutes',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w400,
                        color: selected
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_value),
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}
