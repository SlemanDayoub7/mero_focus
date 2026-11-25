/// An optional part of a fixed task (subject), e.g. "Practical" or "Theory"
/// under "Maintenance". Stored locally; sessions are linked to it through the
/// subtask log, never through the database schema.
class Subtask {
  const Subtask({required this.id, required this.subjectId, required this.name});

  final String id;
  final int subjectId;
  final String name;

  Subtask copyWith({String? name}) =>
      Subtask(id: id, subjectId: subjectId, name: name ?? this.name);

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'subjectId': subjectId,
    'name': name,
  };

  static Subtask? fromJson(Object? source) {
    if (source is! Map) return null;
    final id = source['id'];
    final subjectId = source['subjectId'];
    final name = source['name'];
    if (id is! String || subjectId is! int || name is! String) return null;
    return Subtask(id: id, subjectId: subjectId, name: name);
  }
}

/// Links one saved focus session to the subtask it was spent on.
class SubtaskLogEntry {
  const SubtaskLogEntry({required this.sessionId, required this.subtaskId});

  final int sessionId;
  final String subtaskId;

  Map<String, Object?> toJson() => <String, Object?>{
    'sessionId': sessionId,
    'subtaskId': subtaskId,
  };

  static SubtaskLogEntry? fromJson(Object? source) {
    if (source is! Map) return null;
    final sessionId = source['sessionId'];
    final subtaskId = source['subtaskId'];
    if (sessionId is! int || subtaskId is! String) return null;
    return SubtaskLogEntry(sessionId: sessionId, subtaskId: subtaskId);
  }
}
