import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/background_session_controller.dart';

typedef _Status = ({IconData icon, String label, bool isError});

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
    final overlayStatus = _statusOf(overlay, l10n);
    final batteryStatus = _statusOf(battery, l10n);

    return AppScaffold(
      appBar: AppAppBar(title: l10n.backgroundPermissions),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(l10n.backgroundPermissionsIntro),
            const SizedBox(height: AppSpacing.lg),
            SwitchListTile(
              title: Text(
                l10n.overlayPermissionTitle,
                style: AppTypography.bodyStrong.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              subtitle: AppText(l10n.overlayPermissionBody),
              value: overlayEnabled,
              onChanged: (value) => unawaited(
                _toggleOverlay(
                  controller,
                  ref,
                  value,
                  alreadyGranted: overlay.value ?? false,
                ),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.sm),
            _StatusRow(status: overlayStatus),
            if (overlay.hasError) ...[
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: l10n.actionRetry,
                icon: Icons.refresh,
                isSecondary: true,
                onPressed: () => ref.invalidate(overlayPermissionGrantedProvider),
              ),
            ] else if (overlay is AsyncData<bool> && !overlay.value) ...[
              const SizedBox(height: AppSpacing.sm),
              AppText(
                l10n.errorGeneric,
                variant: AppTextVariant.caption,
                color: context.colors.error,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: l10n.overlayPermissionAction,
                onPressed: () => unawaited(
                  _toggleOverlay(
                    controller,
                    ref,
                    true,
                    alreadyGranted: false,
                  ),
                ),
              ),
            ],
            Divider(height: AppSpacing.lg, color: context.colors.outlineVariant),
            _SectionTitle(l10n.batteryExemptionTitle),
            const SizedBox(height: AppSpacing.sm),
            AppText(l10n.batteryExemptionBody),
            const SizedBox(height: AppSpacing.md),
            _StatusRow(status: batteryStatus),
            if (battery.hasError) ...[
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: l10n.actionRetry,
                icon: Icons.refresh,
                isSecondary: true,
                onPressed: () => unawaited(controller.requestBatteryExemption()),
              ),
            ] else if (battery is AsyncData<bool> && !battery.value) ...[
              const SizedBox(height: AppSpacing.sm),
              AppText(
                l10n.errorGeneric,
                variant: AppTextVariant.caption,
                color: context.colors.error,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: l10n.batteryExemptionAction,
                onPressed: () => unawaited(controller.requestBatteryExemption()),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _Status _statusOf(AsyncValue<bool> value, AppLocalizations l10n) => value.when(
        data: (granted) => granted
            ? (
                icon: Icons.check_circle_outline,
                label: l10n.statusEnabled,
                isError: false,
              )
            : (
                icon: Icons.radio_button_unchecked,
                label: l10n.statusDisabled,
                isError: false,
              ),
        loading: () => (
          icon: Icons.hourglass_empty,
          label: l10n.statusLoading,
          isError: false,
        ),
        error: (_, _) => (
          icon: Icons.error_outline,
          label: l10n.errorLoadFailed,
          isError: true,
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTypography.title.copyWith(color: context.colors.onSurface),
      );
}

/// Status is always an icon plus a word, never a colour alone.
class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.status});

  final _Status status;

  @override
  Widget build(BuildContext context) {
    final ink = status.isError
        ? context.colors.error
        : context.colors.onSurfaceVariant;
    return Row(
      children: [
        Icon(status.icon, size: 20, color: ink),
        const SizedBox(width: AppSpacing.sm),
        AppText(status.label, variant: AppTextVariant.caption, color: ink),
      ],
    );
  }
}
