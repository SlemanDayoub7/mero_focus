import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// One big primary action and an optional secondary one. The page decides
/// which actions make sense for the current timer state, so this widget
/// contains no timer logic. Theme styles give both buttons a 48 dp target;
/// the filled button is the only dominant action on the screen.
class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryIcon = Icons.play_arrow,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String primaryLabel;
  final VoidCallback onPrimary;
  final IconData primaryIcon;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final secondary = secondaryLabel;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          icon: Icon(primaryIcon),
          label: Text(primaryLabel),
          onPressed: onPrimary,
        ),
        if (secondary != null && onSecondary != null) ...[
          const SizedBox(height: AppSpacing.touchTargetGap),
          OutlinedButton(onPressed: onSecondary, child: Text(secondary)),
        ],
      ],
    );
  }
}
