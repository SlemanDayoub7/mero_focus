import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Where the user's background image is shown.
enum BackgroundScope { timerOnly, timerAndTasks }

/// Look-and-sound options that live outside the database preferences:
/// background image, where it applies, and the end-of-timer sound switch.
class TimerExtras {
  const TimerExtras({
    this.backgroundPath,
    this.scope = BackgroundScope.timerAndTasks,
    this.endSoundEnabled = true,
  });

  final String? backgroundPath;
  final BackgroundScope scope;
  final bool endSoundEnabled;

  TimerExtras copyWith({
    String? backgroundPath,
    bool clearBackground = false,
    BackgroundScope? scope,
    bool? endSoundEnabled,
  }) {
    return TimerExtras(
      backgroundPath: clearBackground
          ? null
          : (backgroundPath ?? this.backgroundPath),
      scope: scope ?? this.scope,
      endSoundEnabled: endSoundEnabled ?? this.endSoundEnabled,
    );
  }
}

final timerExtrasProvider = NotifierProvider<TimerExtrasNotifier, TimerExtras>(
  TimerExtrasNotifier.new,
);

class TimerExtrasNotifier extends Notifier<TimerExtras> {
  static const String _pathKey = 'extras_background_path';
  static const String _scopeKey = 'extras_background_scope';
  static const String _endSoundKey = 'extras_end_sound';

  bool _disposed = false;

  @override
  TimerExtras build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(_load());
    return const TimerExtras();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed) return;
      final path = prefs.getString(_pathKey);
      final scopeName = prefs.getString(_scopeKey);
      state = TimerExtras(
        backgroundPath: (path != null && File(path).existsSync()) ? path : null,
        scope: scopeName == BackgroundScope.timerOnly.name
            ? BackgroundScope.timerOnly
            : BackgroundScope.timerAndTasks,
        endSoundEnabled: prefs.getBool(_endSoundKey) ?? true,
      );
    } catch (_) {
      // Keep defaults when storage is unavailable.
    }
  }

  /// Opens the gallery, copies the chosen image into the app's own folder
  /// (so it survives cache clean-ups) and stores its path.
  Future<void> pickBackground() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      imageQuality: 85,
    );
    if (picked == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final target =
        '${dir.path}/timer_background_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(picked.path).copy(target);

    final old = state.backgroundPath;
    if (!_disposed) state = state.copyWith(backgroundPath: target);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pathKey, target);
    if (old != null) await _deleteQuietly(old);
  }

  Future<void> clearBackground() async {
    final old = state.backgroundPath;
    if (!_disposed) state = state.copyWith(clearBackground: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pathKey);
    if (old != null) await _deleteQuietly(old);
  }

  Future<void> setScope(BackgroundScope scope) async {
    state = state.copyWith(scope: scope);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopeKey, scope.name);
  }

  Future<void> setEndSoundEnabled(bool value) async {
    state = state.copyWith(endSoundEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_endSoundKey, value);
  }

  Future<void> _deleteQuietly(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
