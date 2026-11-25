import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/subtask.dart';

/// The subtask picked for the current focus session (UI-only state).
final activeSubtaskIdProvider =
    NotifierProvider<ActiveSubtaskIdNotifier, String?>(
      ActiveSubtaskIdNotifier.new,
    );

class ActiveSubtaskIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

final subtasksProvider = NotifierProvider<SubtasksNotifier, List<Subtask>>(
  SubtasksNotifier.new,
);

/// Subtasks of the fixed tasks, kept in local storage as a small JSON list.
class SubtasksNotifier extends Notifier<List<Subtask>> {
  static const String _key = 'subtasks_json';
  bool _disposed = false;

  @override
  List<Subtask> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(_load());
    return const <Subtask>[];
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed) return;
      final raw = prefs.getString(_key);
      if (raw == null) return;
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        state = <Subtask>[
          for (final item in decoded)
            if (Subtask.fromJson(item) case final subtask?) subtask,
        ];
      }
    } catch (_) {}
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(<Object?>[for (final item in state) item.toJson()]),
    );
  }

  List<Subtask> forSubject(int subjectId) => <Subtask>[
    for (final item in state)
      if (item.subjectId == subjectId) item,
  ];

  Future<void> add(int subjectId, String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) return;
    state = <Subtask>[
      ...state,
      Subtask(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        subjectId: subjectId,
        name: name,
      ),
    ];
    await _persist();
  }

  Future<void> rename(String id, String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) return;
    state = <Subtask>[
      for (final item in state) item.id == id ? item.copyWith(name: name) : item,
    ];
    await _persist();
  }

  /// Removing a subtask also removes its time from the totals (the log
  /// entries stay but no longer match an existing subtask).
  Future<void> remove(String id) async {
    state = <Subtask>[
      for (final item in state)
        if (item.id != id) item,
    ];
    await _persist();
  }
}

final subtaskLogProvider =
    NotifierProvider<SubtaskLogNotifier, List<SubtaskLogEntry>>(
      SubtaskLogNotifier.new,
    );

class SubtaskLogNotifier extends Notifier<List<SubtaskLogEntry>> {
  static const String _key = 'subtask_log_json';
  bool _disposed = false;

  @override
  List<SubtaskLogEntry> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(_load());
    return const <SubtaskLogEntry>[];
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed) return;
      final raw = prefs.getString(_key);
      if (raw == null) return;
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        state = <SubtaskLogEntry>[
          for (final item in decoded)
            if (SubtaskLogEntry.fromJson(item) case final entry?) entry,
        ];
      }
    } catch (_) {}
  }

  Future<void> add(int sessionId, String subtaskId) async {
    state = <SubtaskLogEntry>[
      ...state,
      SubtaskLogEntry(sessionId: sessionId, subtaskId: subtaskId),
    ];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(<Object?>[for (final item in state) item.toJson()]),
    );
  }
}

/// The subtask selected right now, or null.
final activeSubtaskProvider = Provider<Subtask?>((ref) {
  final id = ref.watch(activeSubtaskIdProvider);
  if (id == null) return null;
  for (final item in ref.watch(subtasksProvider)) {
    if (item.id == id) return item;
  }
  return null;
});
