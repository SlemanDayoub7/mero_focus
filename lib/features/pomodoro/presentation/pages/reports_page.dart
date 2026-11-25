import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/entities/planner_preferences.dart';
import '../../domain/entities/session_type.dart';
import '../../domain/entities/stat_range.dart';
import '../../domain/stats/pomodoro_stats.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';
import '../controllers/report_export.dart';
import '../formatting/duration_labels.dart';
import '../widgets/minutes_bar_chart.dart';
import '../widgets/minutes_picker_dialog.dart';
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
          actions: [
            IconButton(
              tooltip: l10n.reportExportPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: () => unawaited(exportReportPdf(context, ref, _range)),
            ),
          ],
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

/// Rounded, borderless surface used by every report section.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// Consecutive days with focus, ending today (or yesterday when nothing has
/// been studied yet today, so the streak is not lost before the day ends).
int _streak(PomodoroStats stats, DateTime now) {
  final days = stats.secondsByDay(allTimeFrom, allTimeTo).keys.toSet();
  var cursor = startOfDay(now);
  if (!days.contains(cursor)) {
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
  }
  var count = 0;
  while (days.contains(cursor)) {
    count++;
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
  }
  return count;
}

List<String> _chartLabels(BuildContext context, StatRange range, DateTime now) {
  final count = range.bucketCount(now);
  final weekdays = MaterialLocalizations.of(context).narrowWeekdays;
  return List<String>.generate(count, (index) {
    switch (range) {
      case StatRange.day:
        return index % 6 == 0 ? '$index' : '';
      case StatRange.week:
        return weekdays[(DateTime.saturday + index) % 7];
      case StatRange.month:
        final day = index + 1;
        return (day == 1 || day % 5 == 0) ? '$day' : '';
      case StatRange.year:
        return '${index + 1}';
    }
  });
}

class PomodoroReport extends ConsumerWidget {
  const PomodoroReport({
    super.key,
    required this.range,
    required this.onRangeChanged,
  });

  final StatRange range;
  final ValueChanged<StatRange> onRangeChanged;

  Future<void> _editGoal(
    BuildContext context,
    WidgetRef ref,
    PlannerPreferences preferences,
  ) async {
    final minutes = await showMinutesPicker(
      context,
      title: context.l10n.reportDailyGoalEdit,
      initialMinutes: preferences.dailyGoalMinutes,
    );
    if (minutes == null) return;
    await ref
        .read(plannerActionsProvider)
        .savePreferences(preferences.copyWith(dailyGoalMinutes: minutes));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final sessionsAsync = ref.watch(focusSessionsProvider);
    final preferencesAsync = ref.watch(plannerPreferencesProvider);

    if (sessionsAsync is! AsyncData<List<FocusSession>> ||
        preferencesAsync is! AsyncData<PlannerPreferences>) {
      return const Center(child: CircularProgressIndicator());
    }
    final preferences = preferencesAsync.value;
    final stats = PomodoroStats(
      sessionsAsync.value,
      dailyGoalMinutes: preferences.dailyGoalMinutes,
    );
    final now = DateTime.now();
    final day = windowFor(StatRange.day, now);
    final week = windowFor(StatRange.week, now);
    final window = windowFor(range, now);
    final rangeTotal = stats.totalDuration(window.from, window.to);
    final rangeDays = stats.focusDays(window.from, window.to);
    final goalSeconds = preferences.dailyGoalMinutes * 60;
    final today = stats.totalDuration(day.from, day.to);
    final progress = goalSeconds == 0
        ? 0.0
        : (today.inSeconds / goalSeconds).clamp(0, 1).toDouble();
    final allTime = stats.totalDuration(allTimeFrom, allTimeTo);
    final recent = sessionsAsync.value
        .where((session) => session.sessionType == SessionType.work)
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    final summary = l10n.reportSummary(
      allTime.labelOf(context),
      '${stats.completedCount(allTimeFrom, allTimeTo)}',
      '${stats.focusDays(allTimeFrom, allTimeTo)}',
    );

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // --- Today vs. goal -------------------------------------------
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.72),
              ],
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => unawaited(_editGoal(context, ref, preferences)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            strokeCap: StrokeCap.round,
                            color: theme.colorScheme.onPrimary,
                            backgroundColor: theme.colorScheme.onPrimary
                                .withValues(alpha: 0.25),
                          ),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DefaultTextStyle.merge(
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.reportToday,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            today.labelOf(context),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.reportDailyGoal(
                              today.labelOf(context),
                              Duration(seconds: goalSeconds).labelOf(context),
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 14,
                                color: theme.colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.reportDailyGoalEdit,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // --- Key numbers ----------------------------------------------
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.9,
          children: [
            PlannerStatTile(
              icon: Icons.timer_outlined,
              label: l10n.reportTotalFocus,
              value: allTime.labelOf(context),
            ),
            PlannerStatTile(
              icon: Icons.date_range_outlined,
              label: l10n.reportThisWeek,
              value: stats.totalDuration(week.from, week.to).labelOf(context),
            ),
            PlannerStatTile(
              icon: Icons.check_circle_outline,
              label: l10n.reportCompletedCount,
              value: '${stats.completedCount(allTimeFrom, allTimeTo)}',
            ),
            PlannerStatTile(
              icon: Icons.local_fire_department_outlined,
              label: l10n.reportStreak,
              value: '${_streak(stats, now)}',
            ),
          ],
        ),

        // --- Chart ----------------------------------------------------
        _SectionCard(
          title: l10n.reportRangeFocus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatRangeSelector(selected: range, onChanged: onRangeChanged),
              const SizedBox(height: 16),
              MinutesBarChart(
                minutes: stats.bucketMinutes(range, now),
                labels: _chartLabels(context, range, now),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MiniFigure(
                      label: l10n.reportRangeFocus,
                      value: rangeTotal.labelOf(context),
                    ),
                  ),
                  Expanded(
                    child: _MiniFigure(
                      label: l10n.reportFocusDays,
                      value: '$rangeDays',
                    ),
                  ),
                  Expanded(
                    child: _MiniFigure(
                      label: l10n.reportAveragePerDay,
                      value: rangeDays == 0
                          ? Duration.zero.labelOf(context)
                          : Duration(
                              seconds: rangeTotal.inSeconds ~/ rangeDays,
                            ).labelOf(context),
                    ),
                  ),
                  Expanded(
                    child: _MiniFigure(
                      label: l10n.reportGoalDays,
                      value: '${stats.goalDays(window.from, window.to)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            icon: const Icon(Icons.copy, size: 18),
            label: Text(l10n.reportCopySummary),
            onPressed: () {
              unawaited(Clipboard.setData(ClipboardData(text: summary)));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.reportCopied)));
            },
          ),
        ),

        // --- Records --------------------------------------------------
        _SectionCard(
          title: l10n.reportRecords,
          child: recent.isEmpty
              ? Text(l10n.reportNoData)
              : Column(
                  children: [
                    for (final session in recent.take(50))
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          session.completed
                              ? Icons.check_circle
                              : Icons.timelapse,
                          size: 20,
                          color: session.completed
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                        ),
                        title: Text(
                          session.label.isEmpty
                              ? _phaseLabel(session.sessionType, l10n)
                              : session.label,
                        ),
                        subtitle: Text(
                          '${session.startTime.year}/${session.startTime.month}/${session.startTime.day}  '
                          '${session.startTime.hour.toString().padLeft(2, '0')}:'
                          '${session.startTime.minute.toString().padLeft(2, '0')}',
                        ),
                        trailing: Text(
                          session.actualDuration.labelOf(context),
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _MiniFigure extends StatelessWidget {
  const _MiniFigure({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall,
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
    final theme = Theme.of(context);
    final sessionsAsync = ref.watch(focusSessionsProvider);
    final preferencesAsync = ref.watch(plannerPreferencesProvider);

    if (sessionsAsync is! AsyncData<List<FocusSession>> ||
        preferencesAsync is! AsyncData<PlannerPreferences>) {
      return const Center(child: CircularProgressIndicator());
    }
    final preferences = preferencesAsync.value;
    final stats = PomodoroStats(
      sessionsAsync.value,
      dailyGoalMinutes: preferences.dailyGoalMinutes,
    );
    final window = windowFor(range, DateTime.now());
    final byLabel =
        stats.secondsByLabel(window.from, window.to).entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final maxValue = byLabel.isEmpty ? 1 : byLabel.first.value;
    final total = byLabel.fold<int>(0, (sum, entry) => sum + entry.value);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        StatRangeSelector(selected: range, onChanged: onRangeChanged),
        const SizedBox(height: 12),
        if (byLabel.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(l10n.reportNoData),
            ),
          )
        else
          _SectionCard(
            title: l10n.reportRangeFocus,
            child: Column(
              children: [
                for (final entry in byLabel)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.key.isEmpty
                                    ? l10n.reportUntitled
                                    : entry.key,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                            Text(
                              '${Duration(seconds: entry.value).labelOf(context)}'
                              '  •  ${total == 0 ? 0 : (entry.value * 100 / total).round()}%',
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: entry.value / maxValue,
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
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
