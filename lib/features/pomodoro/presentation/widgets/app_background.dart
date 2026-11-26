import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/timer_extras_settings.dart';

/// Kept for callers that used to scope the image to a single tab. The shell now
/// owns one background for every screen, so all values render the image.
enum BackgroundTarget { all, timer, tasks }

/// Sits behind the main shell only: picked gallery images and bundled images
/// both render here. A background is always drawn, falling back to the bundled
/// default when nothing valid is stored.
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
    final path = extras.backgroundPath ?? BuiltInBackground.defaultStoredPath;
    final background = path.startsWith('asset:')
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
        Container(color: Colors.black.withOpacity(0.6)),
        Material(type: MaterialType.transparency, child: child),
      ],
    );
  }
}
