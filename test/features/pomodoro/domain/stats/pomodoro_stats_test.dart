import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/focus_session.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/session_type.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/stat_range.dart';
import 'package:mero_focus/features/pomodoro/domain/stats/pomodoro_stats.dart';

FocusSession _session(
  DateTime start, {
  int seconds = 1500,
  String label = 'Math',
  bool completed = true,
  SessionType type = SessionType.work,
}) {
  final duration = Duration(seconds: seconds);
  return FocusSession(
    startTime: start,
    endTime: start.add(duration),
    plannedDuration: duration,
    actualDuration: duration,
    sessionType: type,
    completed: completed,
    label: label,
  );
}

void main() {
  test('windowFor returns half-open windows and Saturday-based weeks', () {
    final now = DateTime(2026, 3, 4, 13);

    expect(windowFor(StatRange.day, now).from, DateTime(2026, 3, 4));
    expect(windowFor(StatRange.day, now).to, DateTime(2026, 3, 5));
    expect(windowFor(StatRange.week, now).from, DateTime(2026, 2, 28));
    expect(windowFor(StatRange.week, now).to, DateTime(2026, 3, 7));
    expect(windowFor(StatRange.month, now).to, DateTime(2026, 4, 1));
    expect(windowFor(StatRange.year, now).from, DateTime(2026, 1, 1));
  });

  test('aggregations ignore breaks and respect the daily goal', () {
    final now = DateTime(2026, 3, 4, 12);
    final window = windowFor(StatRange.week, now);
    final stats = PomodoroStats([
      _session(DateTime(2026, 3, 2, 10)),
      _session(DateTime(2026, 3, 3, 10), seconds: 600, completed: false),
      _session(DateTime(2026, 3, 3, 11), type: SessionType.shortBreak),
    ], dailyGoalMinutes: 25);

    expect(
      stats.totalDuration(window.from, window.to),
      const Duration(seconds: 2100),
    );
    expect(stats.completedCount(window.from, window.to), 1);
    expect(stats.focusDays(window.from, window.to), 2);
    expect(stats.goalDays(window.from, window.to), 1);
    expect(stats.secondsByLabel(window.from, window.to), {'Math': 2100});
  });

  test('bucketMinutes places work sessions in hour and weekday buckets', () {
    final stats = PomodoroStats([
      _session(DateTime(2026, 3, 4, 9)),
      _session(DateTime(2026, 3, 4, 15), seconds: 600, label: 'Arabic'),
      _session(DateTime(2026, 3, 5, 9)),
      _session(DateTime(2026, 3, 4, 9), type: SessionType.longBreak),
    ]);

    final daily = stats.bucketMinutes(StatRange.day, DateTime(2026, 3, 4));
    expect(daily, hasLength(24));
    expect(daily[9], 25);
    expect(daily[15], 10);
    expect(daily[10], 0);

    final weekly = stats.bucketMinutes(StatRange.week, DateTime(2026, 3, 4));
    expect(weekly, hasLength(7));
    expect(weekly[4], 35);
    expect(weekly[5], 25);
  });
}
