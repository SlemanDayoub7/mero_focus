import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/core_providers.dart';
import 'core/l10n/l10n_context.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/background_overlay/presentation/widgets/background_session_coordinator.dart';
import 'features/home/presentation/pages/home_shell_page.dart';
import 'l10n/app_localizations.dart';

class MeroFocusApp extends ConsumerWidget {
  const MeroFocusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = ref.watch(primaryAccentProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: AppTheme.darkFor(accent),
      darkTheme: AppTheme.darkFor(accent),
      themeMode: ThemeMode.dark,
      routes: AppRouter.routes,
      home: const BackgroundSessionCoordinator(child: HomeShellPage()),
    );
  }
}
