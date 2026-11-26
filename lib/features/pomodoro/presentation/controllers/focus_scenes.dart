import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FocusScene {
  const FocusScene({
    required this.id,
    required this.title,
    required this.description,
    required this.quote,
    required this.imagePath,
    required this.accentValue,
  });

  final String id;
  final String title;
  final String description;
  final String quote;
  final String imagePath;
  final int accentValue;

  Color get accentColor => Color(accentValue);

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'quote': quote,
    'imagePath': imagePath,
    'accentValue': accentValue,
  };

  factory FocusScene.fromJson(Map<String, dynamic> json) => FocusScene(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    quote: json['quote'] as String? ?? '',
    imagePath: json['imagePath'] as String,
    accentValue: json['accentValue'] as int? ?? 0xFF718CFF,
  );
}

class FocusScenesState {
  const FocusScenesState({this.scenes = const [], this.activeSceneId});

  final List<FocusScene> scenes;
  final String? activeSceneId;

  FocusScene? get activeScene {
    for (final scene in scenes) {
      if (scene.id == activeSceneId) return scene;
    }
    return null;
  }
}

final focusScenesProvider =
    NotifierProvider<FocusScenesNotifier, FocusScenesState>(
      FocusScenesNotifier.new,
    );

class FocusScenesNotifier extends Notifier<FocusScenesState> {
  static const _scenesKey = 'focus_scenes_v1';
  static const _activeKey = 'focus_active_scene_v1';
  bool _disposed = false;

  @override
  FocusScenesState build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(_load());
    return const FocusScenesState();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_scenesKey);
      final decoded = raw == null ? <dynamic>[] : jsonDecode(raw) as List;
      final scenes = decoded
          .whereType<Map<String, dynamic>>()
          .map(FocusScene.fromJson)
          .where((scene) => File(scene.imagePath).existsSync())
          .toList(growable: false);
      if (_disposed) return;
      state = FocusScenesState(
        scenes: scenes,
        activeSceneId: prefs.getString(_activeKey),
      );
    } catch (_) {
      // Keep an empty collection if preferences contain invalid old data.
    }
  }

  Future<String?> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2200,
      imageQuality: 88,
    );
    if (picked == null) return null;
    final directory = await getApplicationDocumentsDirectory();
    final extension = picked.path.contains('.')
        ? picked.path.split('.').last.toLowerCase()
        : 'jpg';
    final target =
        '${directory.path}/focus_scene_${DateTime.now().microsecondsSinceEpoch}.$extension';
    await File(picked.path).copy(target);
    return target;
  }

  Future<void> saveScene({
    required String title,
    required String description,
    required String quote,
    required String imagePath,
    required Color accentColor,
    String? existingId,
  }) async {
    final id = existingId ?? DateTime.now().microsecondsSinceEpoch.toString();
    final scene = FocusScene(
      id: id,
      title: title.trim(),
      description: description.trim(),
      quote: quote.trim(),
      imagePath: imagePath,
      accentValue: accentColor.toARGB32(),
    );
    final scenes = [...state.scenes];
    final index = scenes.indexWhere((item) => item.id == id);
    if (index < 0) {
      scenes.add(scene);
    } else {
      scenes[index] = scene;
    }
    state = FocusScenesState(scenes: scenes, activeSceneId: id);
    await _persist();
  }

  Future<void> select(String? id) async {
    state = FocusScenesState(scenes: state.scenes, activeSceneId: id);
    await _persist();
  }

  Future<void> delete(String id) async {
    FocusScene? removed;
    for (final scene in state.scenes) {
      if (scene.id == id) { removed = scene; break; }
    }
    final scenes = state.scenes.where((scene) => scene.id != id).toList();
    final activeId = state.activeSceneId == id ? null : state.activeSceneId;
    state = FocusScenesState(scenes: scenes, activeSceneId: activeId);
    await _persist();
    if (removed != null) {
      try {
        final file = File(removed.imagePath);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _scenesKey,
      jsonEncode(state.scenes.map((scene) => scene.toJson()).toList()),
    );
    if (state.activeSceneId == null) {
      await prefs.remove(_activeKey);
    } else {
      await prefs.setString(_activeKey, state.activeSceneId!);
    }
  }
}
