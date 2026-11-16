import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/settings/cubit/theme_cubit.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/locale_keys.g.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMode = context.watch<ThemeCubit>().state;

    return AppScaffold(
      appBar: AppAppBar(title: context.translate(LocaleKeys.settings)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(context.translate(LocaleKeys.theme_section), variant: AppTextVariant.heading),
            const SizedBox(height: AppSpacing.sm),
            _ThemeOption(
              label: context.translate(LocaleKeys.theme_light),
              mode: ThemeMode.light,
              groupValue: currentMode,
              onChanged: context.read<ThemeCubit>().setThemeMode,
            ),
            _ThemeOption(
              label: context.translate(LocaleKeys.theme_dark),
              mode: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: context.read<ThemeCubit>().setThemeMode,
            ),
            _ThemeOption(
              label: context.translate(LocaleKeys.theme_system),
              mode: ThemeMode.system,
              groupValue: currentMode,
              onChanged: context.read<ThemeCubit>().setThemeMode,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppText(context.translate(LocaleKeys.language_section), variant: AppTextVariant.heading),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'العربية',
                    onPressed: () => context.setLocale(const Locale('ar')),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: 'English',
                    isSecondary: true,
                    onPressed: () => context.setLocale(const Locale('en')),
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
  final String label;
  final ThemeMode mode;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeOption({
    required this.label,
    required this.mode,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ThemeMode>(
      title: AppText(label),
      value: mode,
      groupValue: groupValue,
      onChanged: (v) => onChanged(v!),
      contentPadding: EdgeInsets.zero,
    );
  }
}
