import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/core_providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_accent.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../pomodoro/data/services/audio_white_noise.dart';
import '../../../pomodoro/presentation/controllers/planner_actions.dart';
import '../../../pomodoro/presentation/controllers/planner_providers.dart';
import '../../../pomodoro/presentation/controllers/timer_extras_settings.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key, this.applySafeArea = true});

  /// Tab hosts already inset their content, so a second bottom inset would
  /// waste space above the navigation bar.
  final bool applySafeArea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currentAccent = ref.watch(primaryAccentProvider);
    final currentLocale = ref.watch(localeProvider);
    final extras = ref.watch(timerExtrasProvider);
    final prefs = ref.watch(plannerPreferencesProvider).value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Future<void> runAction(Future<void> Function() action) async {
      try {
        await action();
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.maybeOf(
          context,
        )?.showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
      }
    }

    Future<void> selectSound(String? id) async {
      if (prefs == null) return;
      final next = id == null
          ? prefs.copyWith(clearWhiteNoiseSoundId: true)
          : prefs.copyWith(whiteNoiseSoundId: id);
      await ref.read(plannerActionsProvider).savePreferences(next);
    }

    return AppScaffold(
      transparentBackground: true,
      applySafeArea: applySafeArea,
      appBar: AppAppBar(title: l10n.settings),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const _SectionTitle('accentSection'),
          const SizedBox(height: AppSpacing.xs),
          AppText(l10n.accentHint, variant: AppTextVariant.caption),
          const SizedBox(height: AppSpacing.sm),
          _ChooserTile(
            icon: Icons.palette_outlined,
            label: l10n.accentSection,
            value: _accentLabel(context, currentAccent.labelKey),
            swatch: isDark
                ? currentAccent.darkPrimary
                : currentAccent.lightPrimary,
            onTap: () => _openChooser(
              context: context,
              title: l10n.accentSection,
              choices: [
                for (final accent in AppAccent.values)
                  _Choice(
                    label: _accentLabel(context, accent.labelKey),
                    selected: accent == currentAccent,
                    swatch: isDark ? accent.darkPrimary : accent.lightPrimary,
                    onSelected: () => ref
                        .read(primaryAccentProvider.notifier)
                        .setAccent(accent),
                  ),
              ],
            ),
          ),
          Divider(height: AppSpacing.lg, color: colors.outlineVariant),

          const _SectionTitle('settingsBackgroundSection'),
          const SizedBox(height: AppSpacing.sm),
          _ChooserTile(
            icon: Icons.image_outlined,
            label: l10n.settingsBackgroundSection,
            value: _backgroundLabel(
              context,
              extras.backgroundAssetId ?? l10n.backgroundCustom,
            ),
            onTap: () => _openChooser(
              context: context,
              title: l10n.settingsBackgroundSection,
              choices: [
                for (final background in BuiltInBackground.all)
                  _Choice(
                    label: _backgroundLabel(context, background.labelKey),
                    selected: extras.backgroundAssetId == background.id,
                    onSelected: () => unawaited(
                      runAction(
                        () => ref
                            .read(timerExtrasProvider.notifier)
                            .selectBuiltIn(background),
                      ),
                    ),
                  ),
                _Choice(
                  label: l10n.backgroundCustom,
                  selected: extras.backgroundAssetId == null,
                  onSelected: () => unawaited(
                    runAction(
                      ref.read(timerExtrasProvider.notifier).pickBackground,
                    ),
                  ),
                ),
                _Choice(
                  label: l10n.backgroundReset,
                  selected: false,
                  onSelected: () => unawaited(
                    runAction(
                      ref.read(timerExtrasProvider.notifier).clearBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: AppSpacing.lg, color: colors.outlineVariant),

          const _SectionTitle('settingsSoundSection'),
          const SizedBox(height: AppSpacing.sm),
          _ChooserTile(
            icon: Icons.graphic_eq_outlined,
            label: l10n.settingsSoundSection,
            value: _soundLabel(context, prefs?.whiteNoiseSoundId),
            onTap: () => _openChooser(
              context: context,
              title: l10n.settingsSoundSection,
              choices: [
                _Choice(
                  label: l10n.soundNone,
                  selected: prefs?.whiteNoiseSoundId == null,
                  onSelected: () =>
                      unawaited(runAction(() => selectSound(null))),
                ),
                for (final id in AmbientSounds.all)
                  _Choice(
                    label: _soundLabel(context, id),
                    selected: prefs?.whiteNoiseSoundId == id,
                    onSelected: () =>
                        unawaited(runAction(() => selectSound(id))),
                  ),
              ],
            ),
          ),
          Divider(height: AppSpacing.lg, color: colors.outlineVariant),

          const _SectionTitle('languageSection'),
          const SizedBox(height: AppSpacing.sm),
          RadioGroup<Locale>(
            groupValue: currentLocale,
            onChanged: (locale) {
              if (locale != null) {
                ref.read(localeProvider.notifier).setLocale(locale);
              }
            },
            child: Column(
              children: [
                _ChoiceRow<Locale>(
                  label: l10n.arabic,
                  value: const Locale('ar'),
                  selected: currentLocale.languageCode == 'ar',
                ),
                _ChoiceRow<Locale>(
                  label: l10n.english,
                  value: const Locale('en'),
                  selected: currentLocale.languageCode == 'en',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens one bottom-sheet list; every setting follows the same interaction.
Future<void> _openChooser({
  required BuildContext context,
  required String title,
  required List<Widget> choices,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: AppText(title, variant: AppTextVariant.title),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              children: choices,
            ),
          ),
        ],
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.labelKey);

  final String labelKey;

  String _label(BuildContext context) => switch (labelKey) {
    'themeSection' => context.l10n.themeSection,
    'accentSection' => context.l10n.accentSection,
    'settingsBackgroundSection' => context.l10n.settingsBackgroundSection,
    'settingsSoundSection' => context.l10n.settingsSoundSection,
    'languageSection' => context.l10n.languageSection,
    _ => labelKey,
  };

  @override
  Widget build(BuildContext context) =>
      AppText(_label(context), variant: AppTextVariant.title);
}

/// A glass card that shows the current choice and opens its list on tap.
class _ChooserTile extends StatelessWidget {
  const _ChooserTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.swatch,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Color? swatch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: swatch == null
              ? Icon(icon, color: AppColors.glassInk)
              : Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: swatch,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.glassInkMuted,
                      width: 2,
                    ),
                  ),
                ),
          title: AppText(label, variant: AppTextVariant.body),
          subtitle: AppText(value, variant: AppTextVariant.caption),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.glassInkMuted,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

/// One option inside a chooser list.
class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.swatch,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? swatch;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: context.colors.primaryContainer,
      leading: swatch == null
          ? null
          : Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: swatch,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glassInkMuted, width: 2),
              ),
            ),
      title: AppText(label, variant: AppTextVariant.body),
      trailing: selected
          ? const Icon(Icons.check, color: AppColors.glassInk)
          : null,
      onTap: () {
        Navigator.of(context).pop();
        onSelected();
      },
    );
  }
}

/// A 48 dp selection row: a check and a tinted surface mark the current
/// choice without relying on the radio dot alone.
class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.label,
    required this.value,
    required this.selected,
  });

  final String label;
  final T value;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
      child: RadioListTile<T>(
        value: value,
        selected: selected,
        selectedTileColor: colors.primaryContainer,
        title: AppText(label, variant: AppTextVariant.body),
        secondary: Visibility(
          visible: selected,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: const Icon(Icons.check, size: 20, color: AppColors.glassInk),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }
}

String _accentLabel(BuildContext context, String key) {
  final l10n = context.l10n;
  return switch (key) {
    'accentRoyal' => l10n.accentRoyal,
    'accentViolet' => l10n.accentViolet,
    'accentCrimson' => l10n.accentCrimson,
    'accentAmber' => l10n.accentAmber,
    'accentEmerald' => l10n.accentEmerald,
    'accentMagenta' => l10n.accentMagenta,
    'accentIndigo' => l10n.accentIndigo,
    'accentOlive' => l10n.accentOlive,
    'accentTeal' => l10n.accentTeal,
    'accentCyan' => l10n.accentCyan,
    'accentOrange' => l10n.accentOrange,
    'accentRose' => l10n.accentRose,
    'accentGrass' => l10n.accentGrass,
    'accentPlum' => l10n.accentPlum,
    'accentSlate' => l10n.accentSlate,
    'accentCopper' => l10n.accentCopper,
    _ => key,
  };
}

String _backgroundLabel(BuildContext context, String key) {
  final l10n = context.l10n;
  return switch (key) {
    'dawn' => l10n.backgroundDawn,
    'ocean' => l10n.backgroundOcean,
    'forest' => l10n.backgroundForest,
    'rose' => l10n.backgroundRose,
    'slate' => l10n.backgroundSlate,
    'sand' => l10n.backgroundSand,
    'aurora' => l10n.backgroundAurora,
    'nebula' => l10n.backgroundNebula,
    _ => key,
  };
}

String _soundLabel(BuildContext context, String? id) {
  final l10n = context.l10n;
  return switch (id) {
    null => l10n.soundNone,
    AmbientSounds.white => l10n.soundWhite,
    AmbientSounds.pink => l10n.soundPink,
    AmbientSounds.brown => l10n.soundBrown,
    AmbientSounds.rain => l10n.soundRain,
    AmbientSounds.sea => l10n.soundSea,
    AmbientSounds.forest => l10n.soundForest,
    AmbientSounds.birds => l10n.soundBirds,
    AmbientSounds.cafe => l10n.soundCafe,
    _ => id,
  };
}
