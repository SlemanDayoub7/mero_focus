import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

/// Start/Pause toggle and Reset. Callbacks come from the controller so this
/// widget contains no timer logic and is trivially widget-testable.
class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.isRunning,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.startLabel,
    required this.pauseLabel,
    required this.resetLabel,
  });

  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final String startLabel;
  final String pauseLabel;
  final String resetLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AppButton(
            label: isRunning ? pauseLabel : startLabel,
            onPressed: isRunning ? onPause : onStart,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppButton(
            label: resetLabel,
            onPressed: onReset,
            isSecondary: true,
          ),
        ),
      ],
    );
  }
}
