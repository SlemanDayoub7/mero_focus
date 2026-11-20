import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/entities/planner_preferences.dart';
import '../../domain/entities/session_type.dart';
import '../../domain/entities/stat_range.dart';
import '../../domain/stats/pomodoro_stats.dart';
import '../controllers/planner_providers.dart';
import '../formatting/duration_labels.dart';
import '../widgets/minutes_bar_chart.dart';
import '../widgets/planner_stat_tile.dart';
import '../widgets/stat_range_selector.dart';

/// Pomodoro and task reports over a shared day/week/month/year range.
class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  StatRange _range = StatRange.week;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        appBar: AppAppBar(
          title: l10n.reports,
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.reportsPomodoro),
              Tab(text: l10n.reportsTasks),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PomodoroReport(
              range: _range,
              onRangeChanged: (value) => setState(() => _range = value),
            ),
            TasksReport(
              range: _range,
              onRangeChanged: (value) => setState(() => _range = value),
            ),
          ],
        ),
      ),
    );
  }
}

class PomodoroReport extends ConsumerWidget {
  const PomodoroReport({
    super.key,
    required this.range,
    required this.onRangeChanged,
  });

  final StatRange range;
  final ValueChanged<StatRange> onRangeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sessionsAsync = ref.watch(focusSessionsProvider);
    final preferencesAsync = ref.watch(plannerPreferencesProvider);

    if (sessionsAsync is! AsyncData<List<FocusSession>>) {
      return const Center(child: CircularProgressIndicator());
    }
    final preferences = preferencesAsync is AsyncData<PlannerPreferences>
        ? preferencesAsync.value
        : const PlannerPreferences();
    final stats = PomodoroStats(
      sessionsAsync.value,
      dailyGoalMinutes: preferences.dailyGoalMinutes,
    );
    final now = DateTime.now();
    final day = windowFor(StatRange.day, now);
    final week = windowFor(StatRange.week, now);
    final window = windowFor(range, now);
    final rangeSeconds = stats.totalDuration(window.from, window.to);
    final rangeDays = stats.focusDays(window.from, window.to);
    final goalSeconds = preferences.dailyGoalMinutes * 60;
    final todaySeconds = stats.totalDuration(day.from, day.to);
    final recent = [...sessionsAsync.value]
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    final summary = l10n.reportSummary(
      stats.totalDuration(allTimeFrom, allTimeTo).labelOf(context),
      '${stats.completedCount(allTimeFrom, allTimeTo)}',
      '${stats.focusDays(allTimeFrom, allTimeTo)}',
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
          children: [
            PlannerStatTile(
              label: l10n.reportTotalFocus,
              value: stats
                  .totalDuration(allTimeFrom, allTimeTo)
                  .labelOf(context),
            ),
            PlannerStatTile(
              label: l10n.reportThisWeek,
              value: stats.totalDuration(week.from, week.to).labelOf(context),
            ),
            PlannerStatTile(
              label: l10n.reportToday,
              value: todaySeconds.labelOf(context),
            ),
            PlannerStatTile(
              label: l10n.reportCompletedCount,
              value: '${stats.completedCount(allTimeFrom, allTimeTo)}',
            ),
            PlannerStatTile(
              label: l10n.reportCompletedWeek,
              value: '${stats.completedCount(week.from, week.to)}',
            ),
            PlannerStatTile(
              label: l10n.reportCompletedToday,
              value: '${stats.completedCount(day.from, day.to)}',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppText(
          l10n.reportDailyGoal(
            todaySeconds.labelOf(context),
            Duration(seconds: goalSeconds).labelOf(context),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(
          value: goalSeconds == 0
              ? 0
              : (todaySeconds.inSeconds / goalSeconds).clamp(0, 1).toDouble(),
          minHeight: 8,
        ),
        const SizedBox(height: AppSpacing.md),
        StatRangeSelector(selected: range, onChanged: onRangeChanged),
        const SizedBox(height: AppSpacing.sm),
        MinutesBarChart(minutes: stats.bucketMinutes(range, now)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            SizedBox(
              width: 110,
              child: PlannerStatTile(
                label: l10n.reportRangeFocus,
                value: rangeSeconds.labelOf(context),
              ),
            ),
            SizedBox(
              width: 110,
              child: PlannerStatTile(
                label: l10n.reportFocusDays,
                value: '$rangeDays',
              ),
            ),
            SizedBox(
              width: 110,
              child: PlannerStatTile(
                label: l10n.reportAveragePerDay,
                value: rangeDays == 0
                    ? Duration.zero.labelOf(context)
                    : Duration(
                        seconds: rangeSeconds.inSeconds ~/ rangeDays,
                      ).labelOf(context),
              ),
            ),
            SizedBox(
              width: 110,
              child: PlannerStatTile(
                label: l10n.reportGoalDays,
                value: '${stats.goalDays(window.from, window.to)}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          icon: const Icon(Icons.copy),
          label: Text(l10n.reportCopySummary),
          onPressed: () {
            unawaited(Clipboard.setData(ClipboardData(text: summary)));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.reportCopied)));
          },
        ),
        const Divider(height: AppSpacing.xl),
        AppText(l10n.reportRecords, variant: AppTextVariant.heading),
        for (final session in recent.take(50))
          ListTile(
            dense: true,
            leading: Icon(
              session.completed ? Icons.check_circle : Icons.timelapse,
              size: 18,
            ),
            title: AppText(
              session.label.isEmpty
                  ? _phaseLabel(session.sessionType, l10n)
                  : session.label,
            ),
            subtitle: AppText(
              '${session.startTime.year}/${session.startTime.month}/${session.startTime.day}  '
              '${session.startTime.hour.toString().padLeft(2, '0')}:'
              '${session.startTime.minute.toString().padLeft(2, '0')}',
              variant: AppTextVariant.caption,
            ),
            trailing: AppText(session.actualDuration.labelOf(context)),
          ),
      ],
    );
  }
}

class TasksReport extends ConsumerWidget {
  const TasksReport({
    super.key,
    required this.range,
    required this.onRangeChanged,
  });

  final StatRange range;
  final ValueChanged<StatRange> onRangeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sessionsAsync = ref.watch(focusSessionsProvider);
    final preferencesAsync = ref.watch(plannerPreferencesProvider);

    if (sessionsAsync is! AsyncData<List<FocusSession>>) {
      return const Center(child: CircularProgressIndicator());
    }
    final preferences = preferencesAsync is AsyncData<PlannerPreferences>
        ? preferencesAsync.value
        : const PlannerPreferences();
    final stats = PomodoroStats(
      sessionsAsync.value,
      dailyGoalMinutes: preferences.dailyGoalMinutes,
    );
    final window = windowFor(range, DateTime.now());
    final byLabel =
        stats.secondsByLabel(window.from, window.to).entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final maxValue = byLabel.isEmpty ? 1 : byLabel.first.value;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        StatRangeSelector(selected: range, onChanged: onRangeChanged),
        const SizedBox(height: AppSpacing.md),
        if (byLabel.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: AppText(l10n.reportNoData),
            ),
          ),
        for (final entry in byLabel)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        entry.key.isEmpty ? l10n.reportUntitled : entry.key,
                      ),
                    ),
                    AppText(Duration(seconds: entry.value).labelOf(context)),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                LinearProgressIndicator(
                  value: entry.value / maxValue,
                  minHeight: 8,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

String _phaseLabel(SessionType type, AppLocalizations l10n) {
  return switch (type) {
    SessionType.work => l10n.pomodoroWork,
    SessionType.shortBreak => l10n.pomodoroShortBreak,
    SessionType.longBreak => l10n.pomodoroLongBreak,
  };
}
