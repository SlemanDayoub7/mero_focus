import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';

/// One card holding the four planner figures.
///
/// Every cell shows the value first and its description underneath. Durations
/// stay numeric (`HH:MM`) with no localized "hours"/"minutes" words inside the
/// value itself.
class TasksSummaryCard extends StatelessWidget {
  const TasksSummaryCard({
    super.key,
    required this.estimated,
    required this.toDo,
    required this.elapsed,
    required this.completed,
  });

  final Duration estimated;
  final int toDo;
  final Duration elapsed;
  final int completed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      color: AppColors.glassSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            _cell(
              caption: l10n.tasksRemainingTime,
              value: formatHhMm(estimated),
              semantics: '${l10n.tasksRemainingTime}: ${formatHhMm(estimated)}',
            ),
            _divider(colors.outlineVariant),
            _cell(
              caption: l10n.tasksToDoCount,
              value: '$toDo',
              semantics: '${l10n.tasksToDoCount}: $toDo',
            ),
            _divider(colors.outlineVariant),
            _cell(
              caption: l10n.tasksElapsedTime,
              value: formatHhMm(elapsed),
              semantics: '${l10n.tasksElapsedTime}: ${formatHhMm(elapsed)}',
            ),
            _divider(colors.outlineVariant),
            _cell(
              caption: l10n.tasksCompletedCount,
              value: '$completed',
              semantics: '${l10n.tasksCompletedCount}: $completed',
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(Color color) => VerticalDivider(
    width: 1,
    color: color.withValues(alpha: 0.5),
    indent: AppSpacing.sm,
    endIndent: AppSpacing.sm,
  );

  Widget _cell({
    required String caption,
    required String value,
    required String semantics,
  }) {
    return Expanded(
      child: Semantics(
        container: true,
        label: semantics,
        child: ExcludeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                value,
                variant: AppTextVariant.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                caption,
                variant: AppTextVariant.label,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// `2h 05m` becomes `02:05`. Hours are never truncated when >= 100.
  static String formatHhMm(Duration value) {
    final totalMinutes = value.inSeconds ~/ 60;
    final safeMinutes = totalMinutes < 0 ? 0 : totalMinutes;
    final hours = safeMinutes ~/ 60;
    final minutes = safeMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
