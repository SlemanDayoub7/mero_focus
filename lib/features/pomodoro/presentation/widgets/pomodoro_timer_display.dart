import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/timer_snapshot.dart';

/// Large, accessible countdown plus the current phase label.
class PomodoroTimerDisplay extends StatelessWidget {
  const PomodoroTimerDisplay({
    super.key,
    required this.snapshot,
    required this.phaseLabel,
  });

  final TimerSnapshot snapshot;
  final String phaseLabel;

  @override
  Widget build(BuildContext context) {
    final totalSeconds = snapshot.remaining.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final time =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          phaseLabel,
          variant: AppTextVariant.heading,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          label: time,
          child: ExcludeSemantics(
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: AppTypography.heading.copyWith(
                fontSize: 64,
                fontWeight: FontWeight.w700,
                color: context.colors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
