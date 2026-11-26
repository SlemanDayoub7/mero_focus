/// A personal goal the student keeps in front of them: a free name
/// ("Physics exam", "Learn English") and an optional end date.
class StudyGoal {
  const StudyGoal({required this.id, required this.name, this.date});

  final String id;
  final String name;
  final DateTime? date;

  StudyGoal copyWith({String? name, DateTime? date, bool clearDate = false}) {
    return StudyGoal(
      id: id,
      name: name ?? this.name,
      date: clearDate ? null : (date ?? this.date),
    );
  }

  /// Whole calendar days from [now] until the end date (0 = today, negative
  /// = passed), or null when the goal has no date. Computed in UTC so
  /// daylight-saving changes never shift the count.
  int? daysLeft(DateTime now) {
    final end = date;
    if (end == null) return null;
    final today = DateTime.utc(now.year, now.month, now.day);
    final last = DateTime.utc(end.year, end.month, end.day);
    return last.difference(today).inDays;
  }

  /// Study hours reached by the end date at [hoursPerDay] every day.
  int totalHours(int hoursPerDay, DateTime now) {
    final days = daysLeft(now);
    return days == null || days <= 0 ? 0 : days * hoursPerDay;
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'name': name,
    'date': date?.toIso8601String(),
  };

  static StudyGoal? fromJson(Object? source) {
    if (source is! Map) return null;
    final id = source['id'];
    final name = source['name'];
    if (id is! String || name is! String) return null;
    final rawDate = source['date'];
    return StudyGoal(
      id: id,
      name: name,
      date: rawDate is String ? DateTime.tryParse(rawDate) : null,
    );
  }
}
