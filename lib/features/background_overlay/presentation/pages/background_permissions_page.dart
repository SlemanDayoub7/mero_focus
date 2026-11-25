import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../controllers/background_session_controller.dart';

/// In-app explanation and consent flow for the two Android permissions that
/// make the background timer reliable (ADR-0009).
class BackgroundPermissionsPage extends ConsumerWidget {
  const BackgroundPermissionsPage({super.key});

  /// Asks for the overlay permission only when the user turns the option on.
  Future<void> _toggleOverlay(
    BackgroundSessionController controller,
    WidgetRef ref,
    bool value, {
    required bool alreadyGranted,
  }) async {
    if (value) {
      final granted = alreadyGranted || await controller.requestOverlayPermission();
      if (!granted) return;
    }
    await ref.read(overlayEnabledProvider.notifier).setEnabled(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final overlay = ref.watch(overlayPermissionGrantedProvider);
    final battery = ref.watch(batteryExemptionGrantedProvider);
    final controller = ref.read(backgroundSessionProvider.notifier);
    final overlayEnabled = ref.watch(overlayEnabledProvider);

    return AppScaffold(
      appBar: AppAppBar(title: l10n.backgroundPermissions),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(l10n.backgroundPermissionsIntro),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: SwitchListTile(
                title: Text(l10n.overlayPermissionTitle),
                subtitle: Text(l10n.overlayPermissionBody),
                value: overlayEnabled,
                onChanged: (value) => unawaited(
                  _toggleOverlay(
                    controller,
                    ref,
                    value,
                    alreadyGranted: overlay.value ?? false,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _PermissionCard(
              title: l10n.batteryExemptionTitle,
              body: l10n.batteryExemptionBody,
              status: battery.when(
                data: (granted) =>
                    granted ? l10n.statusEnabled : l10n.statusDisabled,
                loading: () => l10n.statusDisabled,
                error: (_, _) => l10n.statusDisabled,
              ),
              actionLabel: l10n.batteryExemptionAction,
              onPressed: battery.value ?? false
                  ? null
                  : controller.requestBatteryExemption,
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.title,
    required this.body,
    required this.status,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String body;
  final String status;
  final String actionLabel;
  final Future<bool> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText(title, variant: AppTextVariant.heading),
                ),
                AppText(status, variant: AppTextVariant.caption),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(body),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: actionLabel,
              onPressed:
                  onPressed == null ? null : () => unawaited(onPressed!()),
            ),
          ],
        ),
      ),
    );
  }

}
