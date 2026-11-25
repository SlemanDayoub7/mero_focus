import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../domain/entities/study_goal.dart';
import '../controllers/goals_provider.dart';
import '../sheets/goal_sheets.dart';

/// Row of the student's goals at the top of the tasks screen. Each goal shows
/// its name and, when it has an end date, the days left (it decreases by
/// itself every day). Tap a dated goal for the quick plan; the pencil edits.
class GoalsCard extends ConsumerWidget {
  const GoalsCard({super.key});

  void _edit(BuildContext context, {StudyGoal? goal}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => GoalEditSheet(initial: goal),
    );
  }

  void _open(BuildContext context, StudyGoal goal) {
    if (goal.date == null) {
      _edit(context, goal: goal);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => GoalPlanSheet(goal: goal),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final goals = ref.watch(goalsProvider);
    final now = DateTime.now();

    // Dated goals first (soonest on top), then the open-ended ones.
    final sorted = <StudyGoal>[...goals]
      ..sort((a, b) {
        final da = a.date;
        final db = b.date;
        if (da != null && db != null) return da.compareTo(db);
        if (da != null) return -1;
        if (db != null) return 1;
        return 0;
      });

    String headline(StudyGoal goal) {
      final days = goal.daysLeft(now);
      if (days == null) return l10n.goalNoDate;
      if (days < 0) return l10n.examPassed;
      if (days == 0) return l10n.examToday;
      return l10n.examDaysLeft(days);
    }

    return SizedBox(
      height: 88,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        children: [
          for (final goal in sorted)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: SizedBox(
                width: 210,
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: scheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _open(context, goal),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        14,
                        8,
                        2,
                        8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleSmall?.copyWith(
                                    color: scheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  headline(goal),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: scheme.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.examEdit,
                            color: scheme.onPrimaryContainer,
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () => _edit(context, goal: goal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(
            width: goals.isEmpty ? 260 : 120,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              color: scheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _edit(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.flag_outlined),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.goalsAdd,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
