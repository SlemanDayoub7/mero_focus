import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/timer_snapshot.dart';

/// Minimal circular countdown. The ring fills as the phase progresses; when
/// [onTap] is set the time is tappable (used to edit the duration).
class PomodoroTimerDisplay extends StatelessWidget {
  const PomodoroTimerDisplay({
    super.key,
    required this.snapshot,
    this.onTap,
    this.size = 280,
  });

  final TimerSnapshot snapshot;
  final VoidCallback? onTap;

  /// Diameter of the ring; the digits scale with it.
  final double size;

  @override
  Widget build(BuildContext context) {
    final totalSeconds = snapshot.remaining.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final time =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final planned = (snapshot.elapsed + snapshot.remaining).inSeconds;
    final progress = planned <= 0
        ? 0.0
        : (snapshot.elapsed.inSeconds / planned).clamp(0.0, 1.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.surfaceContainerLow,
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.12),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 12 / 280),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: size * 12 / 280,
              strokeCap: StrokeCap.round,
              backgroundColor: context.colors.surfaceContainerHighest,
              color: context.colors.primary,
            ),
          ),
          Semantics(
            label: time,
            button: onTap != null,
            child: ExcludeSemantics(
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(size * 40 / 280),
                  child: Text(
                    time,
                    textAlign: TextAlign.center,
                    style: AppTypography.heading.copyWith(
                      fontSize: size * 60 / 280,
                      fontWeight: FontWeight.w600,
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
