import 'package:flutter/material.dart';

import 'features/background_overlay/presentation/widgets/timer_overlay_view.dart';
import 'l10n/app_localizations.dart';

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
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: OverlayTimerView(),
      );
}

/// Kept as the entry point's view name; the accessible overlay itself lives in
/// one place so both isolates render exactly the same thing.
class OverlayTimerView extends StatelessWidget {
  const OverlayTimerView({super.key});

  @override
  Widget build(BuildContext context) => const TimerOverlayView();
}
