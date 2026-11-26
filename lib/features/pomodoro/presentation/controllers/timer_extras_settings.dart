import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Where the user's background image is shown.
enum BackgroundScope { timerOnly, timerAndTasks }

/// A bundled, ready-made background. `id` is stored in preferences with the
/// `asset:` prefix so it can be told apart from a picked gallery file path.
class BuiltInBackground {
  const BuiltInBackground(this.id, this.asset, this.labelKey);

  final String id;
  final String asset;
  final String labelKey;

  String get storedPath => 'asset:$id';

  /// Applied on first run so every main screen always has a background.
  static const String defaultStoredPath = 'asset:dawn';

  static const List<BuiltInBackground> all = <BuiltInBackground>[
    BuiltInBackground(
      'dawn',
      'assets/images/backgrounds/dawn-mist.jpg',
      'dawn',
    ),
    BuiltInBackground(
      'ocean',
      'assets/images/backgrounds/ocean-calm.jpg',
      'ocean',
    ),
    BuiltInBackground(
      'forest',
      'assets/images/backgrounds/forest-shadow.jpg',
      'forest',
    ),
    BuiltInBackground(
      'rose',
      'assets/images/backgrounds/rose-quartz.jpg',
      'rose',
    ),
    BuiltInBackground(
      'slate',
      'assets/images/backgrounds/slate-sky.jpg',
      'slate',
    ),
    BuiltInBackground(
      'sand',
      'assets/images/backgrounds/sand-dune.jpg',
      'sand',
    ),
    BuiltInBackground(
      'aurora',
      'assets/images/backgrounds/aurora.jpg',
      'aurora',
    ),
    BuiltInBackground(
      'nebula',
      'assets/images/backgrounds/nebula.jpg',
      'nebula',
    ),
  ];

  static BuiltInBackground? fromId(String? id) {
    for (final background in all) {
      if (background.id == id) return background;
    }
    return null;
  }
}

/// Look-and-sound options that live outside the database preferences:
/// background image, where it applies, and the end-of-timer sound switch.
class TimerExtras {
  const TimerExtras({
    this.backgroundPath,
    this.scope = BackgroundScope.timerAndTasks,
    this.endSoundEnabled = true,
  });

  /// Either a picked file path or a bundled `asset:<id>` reference.
  final String? backgroundPath;
  final BackgroundScope scope;
  final bool endSoundEnabled;

  String? get backgroundAssetId {
    final path = backgroundPath;
    if (path == null || !path.startsWith('asset:')) return null;
    return path.substring('asset:'.length);
  }

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
    return const TimerExtras(
      backgroundPath: BuiltInBackground.defaultStoredPath,
    );
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed) return;
      final path = prefs.getString(_pathKey);
      final scopeName = prefs.getString(_scopeKey);
      final usablePath = switch (path) {
        null => BuiltInBackground.defaultStoredPath,
        final String value when value.startsWith('asset:') =>
          BuiltInBackground.fromId(value.substring('asset:'.length)) != null
              ? value
              : BuiltInBackground.defaultStoredPath,
        final String value =>
          File(value).existsSync()
              ? value
              : BuiltInBackground.defaultStoredPath,
      };
      state = TimerExtras(
        backgroundPath: usablePath,
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
    if (old != null && !old.startsWith('asset:')) await _deleteQuietly(old);
  }

  Future<void> selectBuiltIn(BuiltInBackground background) async {
    final old = state.backgroundPath;
    if (!_disposed) {
      state = state.copyWith(backgroundPath: background.storedPath);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pathKey, background.storedPath);
    if (old != null && !old.startsWith('asset:')) await _deleteQuietly(old);
  }

  /// Resets to the default bundled background; a screen is never left bare.
  Future<void> clearBackground() async {
    final old = state.backgroundPath;
    if (!_disposed) {
      state = state.copyWith(
        backgroundPath: BuiltInBackground.defaultStoredPath,
      );
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pathKey, BuiltInBackground.defaultStoredPath);
    if (old != null && !old.startsWith('asset:')) await _deleteQuietly(old);
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
