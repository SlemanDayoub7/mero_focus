import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/core_providers.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeModeProvider);

    return AppScaffold(
      appBar: AppAppBar(title: context.l10n.settings),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.l10n.themeSection,
              variant: AppTextVariant.heading,
            ),
            const SizedBox(height: AppSpacing.sm),
            RadioGroup<ThemeMode>(
              groupValue: currentMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ThemeOption(
                    label: context.l10n.themeLight,
                    mode: ThemeMode.light,
                    selected: currentMode == ThemeMode.light,
                  ),
                  _ThemeOption(
                    label: context.l10n.themeDark,
                    mode: ThemeMode.dark,
                    selected: currentMode == ThemeMode.dark,
                  ),
                  _ThemeOption(
                    label: context.l10n.themeSystem,
                    mode: ThemeMode.system,
                    selected: currentMode == ThemeMode.system,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppText(
              context.l10n.languageSection,
              variant: AppTextVariant.heading,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: context.l10n.arabic,
                    onPressed: () =>
                        ref.read(localeProvider.notifier).setLocale(
                              const Locale('ar'),
                            ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: context.l10n.english,
                    isSecondary: true,
                    onPressed: () =>
                        ref.read(localeProvider.notifier).setLocale(
                              const Locale('en'),
                            ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.mode,
    required this.selected,
  });

  final String label;
  final ThemeMode mode;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ThemeMode>(
      title: AppText(label),
      value: mode,
      selected: selected,
      contentPadding: EdgeInsets.zero,
    );
  }
}
