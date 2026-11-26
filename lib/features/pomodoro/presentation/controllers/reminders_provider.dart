import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/reminder_notification_service.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/entities/session_type.dart';
import '../../domain/stats/pomodoro_stats.dart';
import 'planner_providers.dart';

final remindersProvider = NotifierProvider<RemindersNotifier, List<Reminder>>(
  RemindersNotifier.new,
);

/// The user's reminders, stored locally so they work fully offline.
class RemindersNotifier extends Notifier<List<Reminder>> {
  static const String _key = 'reminders_json';
  bool _disposed = false;

  @override
  List<Reminder> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(_load());
    return const <Reminder>[];
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed) return;
      final raw = prefs.getString(_key);
      if (raw == null) return;
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        state = <Reminder>[
          for (final item in decoded) ?Reminder.fromJson(item),
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

  /// Adds the reminder (id 0 = new) or replaces the one with the same id.
  Future<void> save(Reminder reminder) async {
    final next = <Reminder>[...state];
    if (reminder.id <= 0) {
      var maxId = 0;
      for (final item in next) {
        if (item.id > maxId) maxId = item.id;
      }
      next.add(reminder.copyWith(id: maxId + 1));
    } else {
      final index = next.indexWhere((item) => item.id == reminder.id);
      if (index >= 0) {
        next[index] = reminder;
      } else {
        next.add(reminder);
      }
    }
    state = next;
    await _persist();
  }

  Future<void> setEnabled(int id, {required bool enabled}) async {
    state = <Reminder>[
      for (final item in state)
        item.id == id ? item.copyWith(enabled: enabled) : item,
    ];
    await _persist();
  }

  Future<void> remove(int id) async {
    state = <Reminder>[
      for (final item in state)
        if (item.id != id) item,
    ];
    await _persist();
  }
}

final smartReminderProvider =
    NotifierProvider<SmartReminderNotifier, SmartReminder>(
      SmartReminderNotifier.new,
    );

class SmartReminderNotifier extends Notifier<SmartReminder> {
  static const String _key = 'smart_reminder_json';
  bool _disposed = false;

  @override
  SmartReminder build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(_load());
    return const SmartReminder();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed) return;
      final raw = prefs.getString(_key);
      if (raw == null) return;
      state = SmartReminder.fromJson(jsonDecode(raw));
    } catch (_) {}
  }

  Future<void> update(SmartReminder value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(value.toJson()));
  }
}

/// True once a focus session has been recorded today.
final studiedTodayProvider = Provider<bool>((ref) {
  final sessions = ref.watch(focusSessionsProvider);
  if (sessions is! AsyncData<List<FocusSession>>) return false;
  final now = DateTime.now();
  return sessions.value.any(
    (session) =>
        session.sessionType == SessionType.work &&
        isSameDay(session.startTime, now),
  );
});

/// Whether the system lets the app show notifications right now.
final notificationsEnabledProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(reminderServiceProvider).notificationsEnabled();
});
