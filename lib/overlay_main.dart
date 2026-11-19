import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'features/background_overlay/domain/entities/overlay_timer_data.dart';

/// Separate Dart entry point used by `flutter_overlay_window` for the floating
/// timer. It is intentionally tiny: it only renders data pushed from the main
/// isolate and never starts timers or platform services itself.
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayTimerApp());
}

class OverlayTimerApp extends StatelessWidget {
  const OverlayTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayTimerView(),
    );
  }
}

class OverlayTimerView extends StatefulWidget {
  const OverlayTimerView({super.key});

  @override
  State<OverlayTimerView> createState() => _OverlayTimerViewState();
}

class _OverlayTimerViewState extends State<OverlayTimerView> {
  OverlayTimerData? _data;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((message) {
      final data = OverlayTimerData.fromJson(message);
      if (data != null && mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xCC212121),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_data != null)
                Text(
                  _data!.phaseLabel,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              Text(
                _data?.formattedTime ?? '--:--',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
