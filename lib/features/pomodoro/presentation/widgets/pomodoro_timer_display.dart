import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/timer_snapshot.dart';

/// Transparent circular countdown. The ring fills as the phase progresses;
/// when [onTap] is set the time is tappable (used to edit the duration). There
/// is no filled disc or shadow, so the selected app background shows through.
/// The digits use on-surface ink so they stay readable on both themes.
class PomodoroTimerDisplay extends StatelessWidget {
  const PomodoroTimerDisplay({
    super.key,
    required this.snapshot,
    this.onTap,
    this.size = 260,
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

    final accessibleLabel = onTap == null
        ? time
        : '$time, ${context.l10n.focusPrimaryHint}';

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      padding: EdgeInsets.all(size * 10 / 260),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: size * 8 / 260,
              strokeCap: StrokeCap.round,
              backgroundColor: context.colors.surfaceContainerHighest,
              color: context.colors.primary,
            ),
          ),
          Semantics(
            label: accessibleLabel,
            button: onTap != null,
            onTap: onTap,
            child: ExcludeSemantics(
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(size * 36 / 260),
                  child: Text(
                    time,
                    textAlign: TextAlign.center,
                    style: AppTypography.display.copyWith(
                      fontSize: size * 56 / 260,
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
