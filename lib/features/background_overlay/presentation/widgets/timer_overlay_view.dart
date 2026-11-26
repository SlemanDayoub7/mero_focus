import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/overlay_timer_data.dart';

/// Entry point body for the overlay isolate. Call it from the
/// `overlayMain()` function (see the note in the answer).
void runTimerOverlay() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: TimerOverlayView(),
    ),
  );
}

/// Floating overlay content: the time, its phase and an obvious way out.
///
/// This isolate runs without the app Theme, so every colour is taken from
/// [AppColors] and every size from the shared spacing/typography scales.
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
    final l10n = context.l10n;
    final data = _data;

    return Material(
      color: AppColors.charcoal,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.iceBlue, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: AppSpacing.minTouchTarget,
                height: AppSpacing.minTouchTarget,
                child: IconButton(
                  tooltip: l10n.timerExitFullscreen,
                  icon: const Icon(Icons.close),
                  iconSize: 24,
                  color: AppColors.iceBlue,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: AppSpacing.minTouchTarget,
                    height: AppSpacing.minTouchTarget,
                  ),
                  onPressed: () async => FlutterOverlayWindow.closeOverlay(),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.phaseLabel ?? l10n.statusLoading,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.iceBlue,
                    ),
                  ),
                  Text(
                    data?.formattedTime ?? '--:--',
                    style: AppTypography.display.copyWith(
                      color: AppColors.light.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
