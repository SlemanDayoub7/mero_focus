import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
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
import '../widgets/stat_range_selector.dart';

enum _ReportAction { pdf, copy }

/// Pomodoro and task reports over a shared day/week/month/year range.
class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  StatRange _range = StatRange.week;
  bool _exporting = false;

  Future<void> _export() async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      await exportReportPdf(context, ref, _range);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _copySummary() async {
    final l10n = context.l10n;
    final sessions = ref.read(focusSessionsProvider);
    final preferences = ref.read(plannerPreferencesProvider);
    if (sessions is! AsyncData<List<FocusSession>> ||
        preferences is! AsyncData<PlannerPreferences>) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorLoadFailed)));
      return;
    }
    final stats = PomodoroStats(
      sessions.value,
      dailyGoalMinutes: preferences.value.dailyGoalMinutes,
    );
    final allTime = stats.totalDuration(allTimeFrom, allTimeTo);
    final summary = l10n.reportSummary(
      allTime.labelOf(context),
      '${stats.completedCount(allTimeFrom, allTimeTo)}',
      '${stats.focusDays(allTimeFrom, allTimeTo)}',
    );
    await Clipboard.setData(ClipboardData(text: summary));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.reportCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        applySafeArea: false,
        transparentBackground: true,
        appBar: AppAppBar(
          transparentDegree: 0.7,
          title: l10n.reports,
          actions: [
            PopupMenuButton<_ReportAction>(
              tooltip: l10n.actionMore,
              icon: const Icon(Icons.more_vert),
              onSelected: (action) => switch (action) {
                _ReportAction.pdf => unawaited(_export()),
                _ReportAction.copy => unawaited(_copySummary()),
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: _ReportAction.pdf,
                  height: AppSpacing.minTouchTarget,
                  enabled: !_exporting,
                  child: Text(l10n.reportExportPdf),
                ),
                PopupMenuItem(
                  value: _ReportAction.copy,
                  height: AppSpacing.minTouchTarget,
                  child: Text(l10n.reportCopySummary),
                ),
              ],
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

/// Loading and failure states for both report tabs. Every failure offers the
/// same next step, so a reader never has to guess what to do.
class _ReportStatus extends StatelessWidget {
  const _ReportStatus({
    required this.title,
    this.body,
    this.onRetry,
    this.loading = false,
  });

  final String title;
  final String? body;
  final VoidCallback? onRetry;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 3),
              )
            else
              Icon(Icons.error_outline, size: 32, color: colors.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: AppTypography.title,
              textAlign: TextAlign.center,
            ),
            if (body != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                body!,
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.actionRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void _retryReports(WidgetRef ref) {
  ref.invalidate(focusSessionsProvider);
  ref.invalidate(plannerPreferencesProvider);
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
    final colors = context.colors;
    final sessionsAsync = ref.watch(focusSessionsProvider);
    final preferencesAsync = ref.watch(plannerPreferencesProvider);

    final sources = <AsyncValue<Object>>[sessionsAsync, preferencesAsync];
    if (sources.any((value) => value.hasError)) {
      return _ReportStatus(
        title: l10n.errorLoadFailed,
        body: l10n.errorGeneric,
        onRetry: () => _retryReports(ref),
      );
    }
    if (sources.any((value) => !value.hasValue)) {
      return _ReportStatus(loading: true, title: l10n.statusLoading);
    }

    final preferences = preferencesAsync.value!;
    final stats = PomodoroStats(
      sessionsAsync.value!,
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
    final recent =
        sessionsAsync.value!
            .where((session) => session.sessionType == SessionType.work)
            .toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));

    final buckets = stats.bucketMinutes(range, now);
    var peak = 0.0;
    for (final value in buckets) {
      if (value > peak) peak = value;
    }
    final peakLabel = l10n.reportPeak(
      Duration(seconds: (peak * 60).round()).labelOf(context),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // One chart tells the story; the figures below only support it.
        Text(l10n.reportTotalFocus, style: AppTypography.title),
        const SizedBox(height: AppSpacing.md),
        StatRangeSelector(selected: range, onChanged: onRangeChanged),
        const SizedBox(height: AppSpacing.lg),
        MinutesBarChart(
          minutes: buckets,
          labels: _chartLabels(context, range, now),
          peakLabel: peakLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        Divider(height: 1, color: colors.outlineVariant),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: _MiniFigure(
                label: l10n.reportStreak,
                value: '${_streak(stats, now)}',
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        // Today's goal stays quiet: one row, one secondary edit affordance.
        Semantics(
          button: true,
          label: l10n.reportDailyGoalEdit,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            onTap: () => unawaited(_editGoal(context, ref, preferences)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      strokeCap: StrokeCap.round,
                      color: colors.primary,
                      backgroundColor: colors.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.reportToday,
                          style: AppTypography.caption.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          today.labelOf(context),
                          style: AppTypography.heading,
                        ),
                        Text(
                          l10n.reportDailyGoal(
                            today.labelOf(context),
                            Duration(seconds: goalSeconds).labelOf(context),
                          ),
                          style: AppTypography.body,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
        Text(l10n.reportRecords, style: AppTypography.title),
        const SizedBox(height: AppSpacing.sm),
        if (recent.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              l10n.reportNoData,
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
          )
        else
          Column(
            children: [
              for (final session in recent.take(50)) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    session.completed
                        ? Icons.check_circle_outline
                        : Icons.timelapse_outlined,
                    color: session.completed
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                  title: Text(
                    session.label.isEmpty
                        ? _phaseLabel(session.sessionType, l10n)
                        : session.label,
                    style: AppTypography.body,
                  ),
                  subtitle: Text(
                    '${session.startTime.year}/${session.startTime.month}/${session.startTime.day}  '
                    '${session.startTime.hour.toString().padLeft(2, '0')}:'
                    '${session.startTime.minute.toString().padLeft(2, '0')}',
                    style: AppTypography.caption.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  trailing: Text(
                    session.actualDuration.labelOf(context),
                    style: AppTypography.label,
                  ),
                ),
                Divider(height: 1, color: colors.outlineVariant),
              ],
            ],
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
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, textAlign: TextAlign.center, style: AppTypography.title),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(color: colors.onSurfaceVariant),
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
    final colors = context.colors;
    final sessionsAsync = ref.watch(focusSessionsProvider);
    final preferencesAsync = ref.watch(plannerPreferencesProvider);

    final sources = <AsyncValue<Object>>[sessionsAsync, preferencesAsync];
    if (sources.any((value) => value.hasError)) {
      return _ReportStatus(
        title: l10n.errorLoadFailed,
        body: l10n.errorGeneric,
        onRetry: () => _retryReports(ref),
      );
    }
    if (sources.any((value) => !value.hasValue)) {
      return _ReportStatus(loading: true, title: l10n.statusLoading);
    }

    final preferences = preferencesAsync.value!;
    final stats = PomodoroStats(
      sessionsAsync.value!,
      dailyGoalMinutes: preferences.dailyGoalMinutes,
    );
    final window = windowFor(range, DateTime.now());
    final byLabel =
        stats.secondsByLabel(window.from, window.to).entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final maxValue = byLabel.isEmpty ? 1 : byLabel.first.value;
    final total = byLabel.fold<int>(0, (sum, entry) => sum + entry.value);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        StatRangeSelector(selected: range, onChanged: onRangeChanged),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.reportBySubject, style: AppTypography.title),
        const SizedBox(height: AppSpacing.md),
        if (byLabel.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              l10n.reportNoData,
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
          )
        else
          Column(
            children: [
              for (final entry in byLabel) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.key.isEmpty ? l10n.reportUntitled : entry.key,
                            style: AppTypography.body,
                          ),
                        ),
                        Text(
                          '${Duration(seconds: entry.value).labelOf(context)}'
                          '  •  ${total == 0 ? 0 : (entry.value * 100 / total).round()}%',
                          style: AppTypography.caption.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    LinearProgressIndicator(
                      value: entry.value / maxValue,
                      minHeight: 6,
                      color: colors.primary,
                      backgroundColor: colors.primaryContainer,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Divider(height: 1, color: colors.outlineVariant),
                ),
              ],
            ],
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
