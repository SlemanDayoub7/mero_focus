/// Port for ambience playback and the end-of-timer chime. The default
/// implementation is a no-op so the timer never depends on audio.
abstract class WhiteNoisePort {
  /// Starts looping the ambience identified by [soundId].
  Future<void> play(String soundId);

  Future<void> stop();

  /// Plays the short sound that marks the natural end of a timer phase.
  Future<void> playEndChime();
}
