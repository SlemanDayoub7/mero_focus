/// How often a reminder fires.
enum ReminderRepeat { daily, days, once }

/// A study reminder the user created: what to do, when, and optionally the
/// fixed task (subject) to start when the notification is tapped.
class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    required this.hour,
    required this.minute,
    this.repeat = ReminderRepeat.daily,
    this.weekdays = const <int>{},
    this.date,
    this.subjectId,
    this.enabled = true,
  });

  /// 0 means "not saved yet".
  final int id;
  final String title;
  final int hour;
  final int minute;
  final ReminderRepeat repeat;

  /// ISO weekdays (1 = Monday ... 7 = Sunday), used when [repeat] is `days`.
  final Set<int> weekdays;

  /// The single day of a `once` reminder.
  final DateTime? date;
  final int? subjectId;
  final bool enabled;

  Reminder copyWith({
    int? id,
    String? title,
    int? hour,
    int? minute,
    ReminderRepeat? repeat,
    Set<int>? weekdays,
    DateTime? date,
    int? subjectId,
    bool clearSubject = false,
    bool? enabled,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      repeat: repeat ?? this.repeat,
      weekdays: weekdays ?? this.weekdays,
      date: date ?? this.date,
      subjectId: clearSubject ? null : (subjectId ?? this.subjectId),
      enabled: enabled ?? this.enabled,
    );
  }

  /// Upcoming fire times within [horizonDays]. Android has no reliable
  /// "repeat in the local time zone" without time-zone data, so the app
  /// schedules each occurrence itself and refreshes the window whenever it
  /// opens or something changes.
  List<DateTime> dueTimes(DateTime now, {int horizonDays = 30}) {
    if (!enabled) return const <DateTime>[];
    final earliest = now.add(const Duration(seconds: 20));
    DateTime at(DateTime day) =>
        DateTime(day.year, day.month, day.day, hour, minute);

    if (repeat == ReminderRepeat.once) {
      final day = date;
      if (day == null) return const <DateTime>[];
      final moment = at(day);
      return moment.isAfter(earliest) ? <DateTime>[moment] : const <DateTime>[];
    }

    final result = <DateTime>[];
    for (var i = 0; i <= horizonDays && result.length < 60; i++) {
      final day = DateTime(now.year, now.month, now.day + i);
      if (repeat == ReminderRepeat.days && !weekdays.contains(day.weekday)) {
        continue;
      }
      final moment = at(day);
      if (moment.isAfter(earliest)) result.add(moment);
    }
    return result;
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'title': title,
    'hour': hour,
    'minute': minute,
    'repeat': repeat.name,
    'weekdays': weekdays.toList(),
    'date': date?.toIso8601String(),
    'subjectId': subjectId,
    'enabled': enabled,
  };

  static Reminder? fromJson(Object? source) {
    if (source is! Map) return null;
    final id = source['id'];
    final title = source['title'];
    final hour = source['hour'];
    final minute = source['minute'];
    if (id is! int || title is! String || hour is! int || minute is! int) {
      return null;
    }
    final repeatName = source['repeat'];
    final days = source['weekdays'];
    final rawDate = source['date'];
    final subject = source['subjectId'];
    return Reminder(
      id: id,
      title: title,
      hour: hour,
      minute: minute,
      repeat: ReminderRepeat.values.firstWhere(
        (value) => value.name == repeatName,
        orElse: () => ReminderRepeat.daily,
      ),
      weekdays: days is List
          ? <int>{
              for (final day in days)
                if (day is int) day,
            }
          : const <int>{},
      date: rawDate is String ? DateTime.tryParse(rawDate) : null,
      subjectId: subject is int ? subject : null,
      enabled: source['enabled'] != false,
    );
  }
}

/// The app's own reminder: nudges the student only on days they have not
/// studied yet. Today's occurrence is dropped once a session is done.
class SmartReminder {
  const SmartReminder({
    this.enabled = false,
    this.hour = 21,
    this.minute = 0,
  });

  final bool enabled;
  final int hour;
  final int minute;

  SmartReminder copyWith({bool? enabled, int? hour, int? minute}) {
    return SmartReminder(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  List<DateTime> dueTimes(
    DateTime now, {
    required bool studiedToday,
    int horizonDays = 30,
  }) {
    if (!enabled) return const <DateTime>[];
    final earliest = now.add(const Duration(seconds: 20));
    final result = <DateTime>[];
    for (var i = 0; i <= horizonDays; i++) {
      if (i == 0 && studiedToday) continue;
      final moment = DateTime(now.year, now.month, now.day + i, hour, minute);
      if (moment.isAfter(earliest)) result.add(moment);
    }
    return result;
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'enabled': enabled,
    'hour': hour,
    'minute': minute,
  };

  static SmartReminder fromJson(Object? source) {
    if (source is! Map) return const SmartReminder();
    final hour = source['hour'];
    final minute = source['minute'];
    return SmartReminder(
      enabled: source['enabled'] == true,
      hour: hour is int ? hour : 21,
      minute: minute is int ? minute : 0,
    );
  }
}
