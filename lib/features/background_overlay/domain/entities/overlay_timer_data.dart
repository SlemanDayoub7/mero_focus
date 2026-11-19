/// Snapshot pushed to the overlay isolate when the app is backgrounded.
///
/// Strings are included so the overlay isolate does not need to initialize the
/// localization delegates a second time.
class OverlayTimerData {
  const OverlayTimerData({
    required this.remainingSeconds,
    required this.phaseLabel,
    required this.timeLabel,
  });

  final int remainingSeconds;
  final String phaseLabel;
  final String timeLabel;

  static const String remainingKey = 'remainingSeconds';
  static const String phaseKey = 'phaseLabel';
  static const String timeKey = 'timeLabel';

  Map<String, Object?> toJson() => <String, Object?>{
        remainingKey: remainingSeconds,
        phaseKey: phaseLabel,
        timeKey: timeLabel,
      };

  static OverlayTimerData? fromJson(Object? value) {
    if (value is! Map) return null;
    final remaining = value[remainingKey];
    final phase = value[phaseKey];
    final time = value[timeKey];
    if (remaining is! int || phase is! String || time is! String) return null;
    return OverlayTimerData(
      remainingSeconds: remaining,
      phaseLabel: phase,
      timeLabel: time,
    );
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
