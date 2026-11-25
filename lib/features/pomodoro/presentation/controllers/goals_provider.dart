import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/study_goal.dart';

final goalsProvider = NotifierProvider<GoalsNotifier, List<StudyGoal>>(
  GoalsNotifier.new,
);

/// The student's goals, kept in local storage as a small JSON list.
class GoalsNotifier extends Notifier<List<StudyGoal>> {
  static const String _key = 'study_goals_json';
  // Keys of the earlier single "exam goal" version; imported once.
  static const String _oldGoalKey = 'exam_goal_text';
  static const String _oldDateKey = 'exam_goal_date';

  bool _disposed = false;

  @override
  List<StudyGoal> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(_load());
    return const <StudyGoal>[];
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed) return;

      final raw = prefs.getString(_key);
      if (raw != null) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          state = <StudyGoal>[
            for (final item in decoded)
              if (StudyGoal.fromJson(item) case final goal?) goal,
          ];
        }
        return;
      }

      final oldText = prefs.getString(_oldGoalKey);
      final oldDate = DateTime.tryParse(prefs.getString(_oldDateKey) ?? '');
      if (oldText != null && oldDate != null) {
        final name = oldText.trim().isEmpty ? '🎯' : oldText.trim();
        state = <StudyGoal>[
          StudyGoal(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: name,
            date: oldDate,
          ),
        ];
        await _persist();
      }
    } catch (_) {
      // Keep an empty list when storage is unavailable or corrupted.
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(<Object?>[for (final goal in state) goal.toJson()]),
    );
  }

  String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  /// Adds the goal, or replaces the one with the same id.
  Future<void> save(StudyGoal goal) async {
    final next = <StudyGoal>[...state];
    final index = next.indexWhere((existing) => existing.id == goal.id);
    if (index >= 0) {
      next[index] = goal;
    } else {
      next.add(goal);
    }
    state = next;
    await _persist();
  }

  Future<void> remove(String id) async {
    state = <StudyGoal>[
      for (final goal in state)
        if (goal.id != id) goal,
    ];
    await _persist();
  }
}
