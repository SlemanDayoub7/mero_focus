import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/focus_scenes.dart';
import '../controllers/timer_extras_settings.dart';

/// Kept for callers that used to scope the image to a single tab. The shell now
/// owns one background for every screen, so all values render the image.
enum BackgroundTarget { all, timer, tasks }

/// Sits behind the main shell. A saved Focus Scene takes precedence over the
/// regular background setting; clearing the active scene restores that setting.
class AppBackground extends ConsumerWidget {
  const AppBackground({
    super.key,
    this.target = BackgroundTarget.all,
    required this.child,
  });

  final BackgroundTarget target;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extras = ref.watch(timerExtrasProvider);
    final activeScene = ref.watch(focusScenesProvider).activeScene;
    final path = activeScene?.imagePath ??
        extras.backgroundPath ??
        BuiltInBackground.defaultStoredPath;
    final background = activeScene == null && path.startsWith('asset:')
        ? BuiltInBackground.fromId(path.substring('asset:'.length)) ??
              BuiltInBackground.fromId(
                BuiltInBackground.defaultStoredPath.substring('asset:'.length),
              )
        : null;

    final image = background != null
        ? Image.asset(
            background.asset,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          )
        : Image.file(
            File(path),
            fit: BoxFit.cover,
            cacheWidth: 1440,
            excludeFromSemantics: true,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          );

    return Stack(
      fit: StackFit.expand,
      children: [
        image,
        Container(color: Colors.black.withAlpha((255 * 0.6).round())),
        if (activeScene != null)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  activeScene.accentColor.withValues(alpha: .10),
                  Colors.transparent,
                  Colors.black.withValues(alpha: .16),
                ],
              ),
            ),
          ),
        Material(type: MaterialType.transparency, child: child),
      ],
    );
  }
}
