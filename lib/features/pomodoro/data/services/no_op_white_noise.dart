import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/white_noise_port.dart';
import 'audio_white_noise.dart';

/// Safe fallback that accepts every call and plays nothing.
class NoOpWhiteNoise implements WhiteNoisePort {
  const NoOpWhiteNoise();

  @override
  Future<void> play(String soundId) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> playEndChime() async {}
}

/// The real audio implementation. Tests can override this provider with
/// [NoOpWhiteNoise].
final whiteNoisePortProvider = Provider<WhiteNoisePort>((ref) {
  final audio = AudioWhiteNoise();
  ref.onDispose(audio.dispose);
  return audio;
});
