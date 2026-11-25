import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../../pomodoro/presentation/pages/focus_launcher.dart';

/// Listens for taps on the Android home-screen widgets.
///
/// The widgets open the app with a `merofocus://<target>/...` address:
///  - `merofocus://pomodoro/start` -> start the timer and show it
///  - `merofocus://habits/open`    -> just bring the app forward
/// Works both for a cold start (app was closed) and when already running.
class HomeWidgetBridge extends ConsumerStatefulWidget {
  const HomeWidgetBridge({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<HomeWidgetBridge> createState() => _HomeWidgetBridgeState();
}

class _HomeWidgetBridgeState extends ConsumerState<HomeWidgetBridge> {
  StreamSubscription<Uri?>? _subscription;

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform != TargetPlatform.android) return;
    unawaited(_listen());
  }

  Future<void> _listen() async {
    try {
      final initial = await HomeWidget.initiallyLaunchedFromHomeWidget();
      _handle(initial);
      if (!mounted) return;
      _subscription = HomeWidget.widgetClicked.listen(_handle);
    } catch (_) {
      // Plugin unavailable (tests / unsupported platform): ignore.
    }
  }

  void _handle(Uri? uri) {
    if (uri == null || !mounted) return;
    if (uri.host != 'pomodoro') return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(startPomodoroFromWidget(context, ref));
    });
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
