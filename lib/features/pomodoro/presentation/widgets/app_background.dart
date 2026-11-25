import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/timer_extras_settings.dart';

enum BackgroundTarget { timer, tasks }

/// Draws the user's gallery image behind [child] with a translucent scrim so
/// the content on top stays readable. Does nothing when no image is chosen
/// or when the image is limited to the timer and this is the tasks screen.
class AppBackground extends ConsumerWidget {
  const AppBackground({super.key, required this.target, required this.child});

  final BackgroundTarget target;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extras = ref.watch(timerExtrasProvider);
    final path = extras.backgroundPath;
    final visible =
        path != null &&
        (target == BackgroundTarget.timer ||
            extras.scope == BackgroundScope.timerAndTasks);
    if (!visible) return child;

    final scheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          File(path),
          fit: BoxFit.cover,
          cacheWidth: 1440,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
        ColoredBox(color: scheme.surface.withValues(alpha: 0.6)),
        // Transparent Material keeps ink splashes visible above the image.
        Material(type: MaterialType.transparency, child: child),
      ],
    );
  }
}
