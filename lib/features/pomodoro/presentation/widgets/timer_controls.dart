import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// One big primary action and an optional secondary one. The page decides
/// which actions make sense for the current timer state, so this widget
/// contains no timer logic.
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
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(60),
            shape: const StadiumBorder(),
            textStyle: Theme.of(context).textTheme.titleMedium,
          ),
          icon: Icon(primaryIcon, size: 28),
          label: Text(primaryLabel),
          onPressed: onPrimary,
        ),
        if (secondary != null && onSecondary != null) ...[
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: const StadiumBorder(),
            ),
            onPressed: onSecondary,
            child: Text(secondary),
          ),
        ],
      ],
    );
  }
}
