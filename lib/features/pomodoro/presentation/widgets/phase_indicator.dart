import 'package:flutter/material.dart';

import '../../../../core/constants/defaults.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/session_type.dart';

/// Shows where the current phase sits in the cycle of rounds before a long
/// break. One segment per configured round keeps this in sync with
/// `AppDefaults.roundsBeforeLongBreak`.
class PhaseIndicator extends StatelessWidget {
  const PhaseIndicator({
    super.key,
    required this.phase,
    required this.completedRounds,
    required this.phaseLabel,
    required this.roundLabel,
  });

  final SessionType phase;
  final int completedRounds;
  final String phaseLabel;
  final String roundLabel;

  @override
  Widget build(BuildContext context) {
    final filled = phase == SessionType.longBreak
        ? AppDefaults.roundsBeforeLongBreak
        : completedRounds % AppDefaults.roundsBeforeLongBreak;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(phaseLabel),
            const SizedBox(width: AppSpacing.sm),
            AppText(roundLabel, variant: AppTextVariant.caption),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          label: roundLabel,
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0;
                    index < AppDefaults.roundsBeforeLongBreak;
                    index++)
                  Container(
                    width: 24,
                    height: 6,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs / 2,
                    ),
                    decoration: BoxDecoration(
                      color: index < filled
                          ? context.colors.primary
                          : context.colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSpacing.xs / 2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
