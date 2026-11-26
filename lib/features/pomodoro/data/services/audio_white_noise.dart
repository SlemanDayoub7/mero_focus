import 'package:audioplayers/audioplayers.dart';

import '../../domain/repositories/white_noise_port.dart';

/// Ids stored in preferences for the bundled ambience loops.
abstract final class AmbientSounds {
  static const String white = 'white_noise';
  static const String pink = 'pink_noise';
  static const String brown = 'brown_noise';
  static const String rain = 'rain';
  static const String sea = 'sea';
  static const String forest = 'forest';
  static const String birds = 'birds';
  static const String cafe = 'cafe';

  static const List<String> all = <String>[
    white,
    pink,
    brown,
    rain,
    sea,
    forest,
    birds,
    cafe,
  ];

  /// Asset path relative to `assets/` (audioplayers' AssetSource root).
  static String? assetFor(String id) {
    return switch (id) {
      white => 'sounds/white_noise.wav',
      pink => 'sounds/pink_noise.wav',
      brown => 'sounds/brown_noise.wav',
      rain => 'sounds/rain.wav',
      sea => 'sounds/sea.wav',
      forest => 'sounds/forest.wav',
      birds => 'sounds/birds.wav',
      cafe => 'sounds/cafe.wav',
      _ => null,
    };
  }

  static const String endChimeAsset = 'sounds/timer_end.wav';
}

/// audioplayers-backed ambience + end chime. Every call swallows playback
/// errors: audio is a nicety and must never break a focus session.
class AudioWhiteNoise implements WhiteNoisePort {
  AudioWhiteNoise();

  final AudioPlayer _ambient = AudioPlayer();
  final AudioPlayer _chime = AudioPlayer();
  String? _playingId;

  @override
  Future<void> play(String soundId) async {
    final asset = AmbientSounds.assetFor(soundId);
    if (asset == null) return;
    if (_playingId == soundId) return;
    try {
      await _ambient.setReleaseMode(ReleaseMode.loop);
      await _ambient.setVolume(0.6);
      await _ambient.play(AssetSource(asset));
      _playingId = soundId;
    } catch (_) {
      _playingId = null;
    }
  }

  @override
  Future<void> stop() async {
    _playingId = null;
    try {
      await _ambient.stop();
    } catch (_) {}
  }

  @override
  Future<void> playEndChime() async {
    try {
      await _chime.setReleaseMode(ReleaseMode.release);
      await _chime.play(AssetSource(AmbientSounds.endChimeAsset));
    } catch (_) {}
  }

  Future<void> dispose() async {
    try {
      await _ambient.dispose();
      await _chime.dispose();
    } catch (_) {}
  }
}
