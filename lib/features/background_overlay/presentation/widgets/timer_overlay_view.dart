import 'dart:async';
import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../domain/entities/overlay_timer_data.dart';

/// Entry point body for the overlay isolate. Call it from the
/// `overlayMain()` function (see the note in the answer).
void runTimerOverlay() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimerOverlayView(),
    ),
  );
}

/// Floating overlay content: just the current time (MM:SS), nothing else.
class TimerOverlayView extends StatefulWidget {
  const TimerOverlayView({super.key});

  @override
  State<TimerOverlayView> createState() => _TimerOverlayViewState();
}

class _TimerOverlayViewState extends State<TimerOverlayView> {
  StreamSubscription<dynamic>? _subscription;
  OverlayTimerData? _data;

  @override
  void initState() {
    super.initState();
    _subscription = FlutterOverlayWindow.overlayListener.listen((event) {
      final data = OverlayTimerData.fromJson(event);
      if (data != null && mounted) setState(() => _data = data);
    });
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _data?.formattedTime ?? '--:--',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}
