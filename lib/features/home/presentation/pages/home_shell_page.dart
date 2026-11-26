import 'package:flutter/material.dart';
import 'package:mero_focus/features/pomodoro/presentation/pages/reports_page.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../focus_scenes/presentation/pages/focus_scenes_page.dart';
import '../../../pomodoro/presentation/pages/pomodoro_timer_page.dart';
import '../../../pomodoro/presentation/pages/tasks_page.dart';
import '../../../pomodoro/presentation/widgets/app_background.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  int _currentIndex = 0;

  void _select(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isArabic = context.l10n.localeName.startsWith('ar');
    final pages = <Widget>[
      const PomodoroTimerPage(),
      const TasksPage(),
      const ReportsPage(),
      const FocusScenesPage(),
      const SettingsPage(applySafeArea: false),
    ];

    return Scaffold(
      body: AppBackground(
        child: IndexedStack(index: _currentIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _select,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return (selected ? AppTypography.label : AppTypography.caption)
              .copyWith(
                color: selected
                    ? colors.onPrimaryContainer
                    : colors.onSurfaceVariant,
              );
        }),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.timer_outlined),
            selectedIcon: const Icon(Icons.timer),
            label: context.l10n.pomodoro,
          ),
          NavigationDestination(
            icon: const Icon(Icons.checklist_outlined),
            selectedIcon: const Icon(Icons.checklist),
            label: context.l10n.tasks,
          ),
          NavigationDestination(
            icon: const Icon(Icons.timeline_outlined),
            selectedIcon: const Icon(Icons.timeline),
            label: context.l10n.reports,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_outlined),
            selectedIcon: const Icon(Icons.auto_awesome),
            label: isArabic ? 'هوياتي' : 'Identities',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: context.l10n.settings,
          ),
        ],
      ),
    );
  }
}
