import '../../../../core/constants/defaults.dart';
import '../entities/focus_session.dart';
import '../entities/session_type.dart';
import '../entities/stat_range.dart';

DateTime startOfDay(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// Weeks start on Saturday, matching the Arabic reporting convention.
DateTime startOfWeek(DateTime value) {
  final offset = (value.weekday - DateTime.saturday + 7) % 7;
  return DateTime(value.year, value.month, value.day - offset);
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Deliberately wide bounds for "all time" aggregations.
final DateTime allTimeFrom = DateTime(2000);
final DateTime allTimeTo = DateTime(2100);

/// Half-open `[from, to)` window containing [now].
({DateTime from, DateTime to}) windowFor(StatRange range, DateTime now) {
  final week = startOfWeek(now);
  return switch (range) {
    StatRange.day => (
      from: startOfDay(now),
      to: DateTime(now.year, now.month, now.day + 1),
    ),
    StatRange.week => (
      from: week,
      to: DateTime(week.year, week.month, week.day + 7),
    ),
    StatRange.month => (
      from: DateTime(now.year, now.month),
      to: DateTime(now.year, now.month + 1),
    ),
    StatRange.year => (from: DateTime(now.year), to: DateTime(now.year + 1)),
  };
}

/// Pure aggregations over raw [FocusSession] rows. No Flutter or l10n imports.
class PomodoroStats {
  const PomodoroStats(
    this.sessions, {
    this.dailyGoalMinutes = AppDefaults.dailyGoalMinutes,
  });

  final List<FocusSession> sessions;
  final int dailyGoalMinutes;

  Iterable<FocusSession> get _workSessions =>
      sessions.where((session) => session.sessionType == SessionType.work);

  Iterable<FocusSession> between(DateTime from, DateTime to) =>
      _workSessions.where(
        (session) =>
            !session.startTime.isBefore(from) && session.startTime.isBefore(to),
      );

  Duration totalDuration(DateTime from, DateTime to) => between(
    from,
    to,
  ).fold(Duration.zero, (sum, session) => sum + session.actualDuration);

  int completedCount(DateTime from, DateTime to) =>
      between(from, to).where((session) => session.completed).length;

  Map<DateTime, int> secondsByDay(DateTime from, DateTime to) {
    final totals = <DateTime, int>{};
    for (final session in between(from, to)) {
      final day = startOfDay(session.startTime);
      totals[day] = (totals[day] ?? 0) + session.actualDuration.inSeconds;
    }
    final sorted = totals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Map.fromEntries(sorted);
  }

  int focusDays(DateTime from, DateTime to) => secondsByDay(from, to).length;

  int goalDays(DateTime from, DateTime to) => secondsByDay(
    from,
    to,
  ).values.where((seconds) => seconds >= dailyGoalMinutes * 60).length;

  Map<String, int> secondsByLabel(DateTime from, DateTime to) {
    final totals = <String, int>{};
    for (final session in between(from, to)) {
      final label = session.label;
      totals[label] = (totals[label] ?? 0) + session.actualDuration.inSeconds;
    }
    return totals;
  }

  /// Minutes per chart bucket: hour/day/weekday/month according to [range].
  List<double> bucketMinutes(StatRange range, DateTime now) {
    final buckets = List<double>.filled(range.bucketCount(now), 0);
    for (final session in _workSessions) {
      final time = session.startTime;
      final int? index = switch (range) {
        StatRange.day => isSameDay(time, now) ? time.hour : null,
        StatRange.week =>
          startOfWeek(time) == startOfWeek(now)
              ? (time.weekday - DateTime.saturday + 7) % 7
              : null,
        StatRange.month =>
          time.year == now.year && time.month == now.month
              ? time.day - 1
              : null,
        StatRange.year => time.year == now.year ? time.month - 1 : null,
      };
      if (index != null) {
        buckets[index] += session.actualDuration.inSeconds / 60;
      }
    }
    return buckets;
  }
}
