import 'package:flutter/material.dart';

import '../../../../core/constants/defaults.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/session_type.dart';

/// A rounded phase pill (Focus / Break) with the round label, and one
/// segment per configured round before a long break, so it follows the
/// user's `roundsBeforeLongBreak` preference. Ink is always at full opacity;
/// the segments also carry a spoken label rather than relying on color.
class PhaseIndicator extends StatelessWidget {
  const PhaseIndicator({
    super.key,
    required this.phase,
    required this.completedRounds,
    required this.phaseLabel,
    required this.roundLabel,
    this.roundsBeforeLongBreak = AppDefaults.roundsBeforeLongBreak,
  });

  final SessionType phase;
  final int completedRounds;
  final String phaseLabel;
  final String roundLabel;
  final int roundsBeforeLongBreak;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isWork = phase == SessionType.work;
    final pillColor = isWork
        ? colors.primaryContainer
        : colors.tertiaryContainer;
    final onPill = isWork
        ? colors.onPrimaryContainer
        : colors.onTertiaryContainer;

    final total = roundsBeforeLongBreak < 1 ? 1 : roundsBeforeLongBreak;
    final filled = phase == SessionType.longBreak
        ? total
        : completedRounds % total;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(AppSpacing.xl),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isWork ? Icons.school_outlined : Icons.free_breakfast_outlined,
                size: 18,
                color: onPill,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                phaseLabel,
                style: AppTypography.label.copyWith(color: onPill),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                roundLabel,
                style: AppTypography.caption.copyWith(color: onPill),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          // The dots are decorative; this label carries the round progress
          // ("Round 3, Round 4") for screen readers.
          label: '$roundLabel, ${l10n.timerRound(total)}',
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < total; index++)
                  Container(
                    width: AppSpacing.lg,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: index < filled
                          ? colors.primary
                          : colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSpacing.xs),
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
