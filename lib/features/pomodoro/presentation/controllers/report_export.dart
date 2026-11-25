import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../data/services/report_image_renderer.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/entities/planner_preferences.dart';
import '../../domain/entities/stat_range.dart';
import '../../domain/stats/pomodoro_stats.dart';
import '../formatting/duration_labels.dart';
import 'planner_providers.dart';
import 'timer_extras_settings.dart';

/// Loads the user's chosen background picture (the same one used behind the
/// timer) for the PDF, or null when none is set or it can't be read.
Future<ui.Image?> _loadBackground(String? path) async {
  if (path == null) return null;
  try {
    final file = File(path);
    if (!await file.exists()) return null;
    final codec = await ui.instantiateImageCodec(
      await file.readAsBytes(),
      targetWidth: 1200,
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  } catch (_) {
    return null;
  }
}

String _date(DateTime d) => '${d.year}/${d.month}/${d.day}';

/// Builds a designed one-page PDF of the Pomodoro report for [range] and
/// opens the system share sheet (WhatsApp, Drive, save to files, ...).
Future<void> exportReportPdf(
  BuildContext context,
  WidgetRef ref,
  StatRange range,
) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final isRtl = Directionality.of(context) == TextDirection.rtl;
  final weekdays = MaterialLocalizations.of(context).narrowWeekdays;

  final sessionsAsync = ref.read(focusSessionsProvider);
  final prefsAsync = ref.read(plannerPreferencesProvider);
  if (sessionsAsync is! AsyncData<List<FocusSession>> ||
      prefsAsync is! AsyncData<PlannerPreferences>) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.reportExportFailed)));
    return;
  }

  ui.Image? background;
  try {
    background = await _loadBackground(
      ref.read(timerExtrasProvider).backgroundPath,
    );
    final prefs = prefsAsync.value;
    final stats = PomodoroStats(
      sessionsAsync.value,
      dailyGoalMinutes: prefs.dailyGoalMinutes,
    );
    final now = DateTime.now();
    final day = windowFor(StatRange.day, now);
    final window = windowFor(range, now);
    final today = stats.totalDuration(day.from, day.to);
    final goalSeconds = prefs.dailyGoalMinutes * 60;
    final rangeTotal = stats.totalDuration(window.from, window.to);
    final buckets = stats.bucketMinutes(range, now);

    final rangeName = switch (range) {
      StatRange.day => l10n.rangeDay,
      StatRange.week => l10n.rangeWeek,
      StatRange.month => l10n.rangeMonth,
      StatRange.year => l10n.rangeYear,
    };
    final lastDay = window.to.subtract(const Duration(days: 1));

    var peak = 0.0;
    for (final value in buckets) {
      if (value > peak) peak = value;
    }

    final labels = List<String>.generate(buckets.length, (index) {
      switch (range) {
        case StatRange.day:
          return index % 6 == 0 ? '$index' : '';
        case StatRange.week:
          return weekdays[(DateTime.saturday + index) % 7];
        case StatRange.month:
          final number = index + 1;
          return (number == 1 || number % 5 == 0) ? '$number' : '';
        case StatRange.year:
          return '${index + 1}';
      }
    });

    final byLabel =
        stats.secondsByLabel(window.from, window.to).entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final topValue = byLabel.isEmpty ? 1 : byLabel.first.value;

    final data = ReportPdfData(
      isRtl: isRtl,
      title: l10n.reportPdfTitle,
      subtitle: '$rangeName  •  ${_date(window.from)} - ${_date(lastDay)}',
      generated: l10n.reportPdfGenerated(_date(now)),
      todayLabel: l10n.reportToday,
      todayValue: today.label(l10n),
      goalText: l10n.reportDailyGoal(
        today.label(l10n),
        Duration(seconds: goalSeconds).label(l10n),
      ),
      progress: goalSeconds == 0 ? 0 : today.inSeconds / goalSeconds,
      stats: [
        ReportPdfStat(l10n.reportRangeFocus, rangeTotal.label(l10n)),
        ReportPdfStat(
          l10n.reportCompletedCount,
          '${stats.completedCount(window.from, window.to)}',
        ),
        ReportPdfStat(
          l10n.reportFocusDays,
          '${stats.focusDays(window.from, window.to)}',
        ),
        ReportPdfStat(
          l10n.reportGoalDays,
          '${stats.goalDays(window.from, window.to)}',
        ),
      ],
      chartTitle: l10n.reportRangeFocus,
      peakLabel: l10n.reportPeak(
        Duration(seconds: (peak * 60).round()).label(l10n),
      ),
      bars: buckets,
      barLabels: labels,
      rowsTitle: l10n.reportBySubject,
      rows: [
        for (final entry in byLabel.take(5))
          ReportPdfRow(
            label: entry.key.isEmpty ? l10n.reportUntitled : entry.key,
            fraction: entry.value / topValue,
            value: Duration(seconds: entry.value).label(l10n),
          ),
      ],
      footer: l10n.appName,
      background: background,
    );

    final png = await ReportImageRenderer.renderPng(data);

    final document = pw.Document();
    final image = pw.MemoryImage(png);
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Image(image, fit: pw.BoxFit.fill),
      ),
    );
    final Uint8List bytes = await document.save();

    await Printing.sharePdf(bytes: bytes, filename: 'mero_focus_report.pdf');
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.reportExportFailed)));
  } finally {
    background?.dispose();
  }
}
