import 'package:flutter/material.dart';
import 'package:mero_focus/features/pomodoro/presentation/pages/reports_page.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/presentation/pages/placeholder_capture_page.dart';
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
    final pages = <Widget>[
      const PomodoroTimerPage(),
      const TasksPage(),
      const ReportsPage(),
      // PlaceholderReviewPage(onGoToTimer: () => _select(0)),
      PlaceholderCapturePage(onGoToTasks: () => _select(1)),
      // The shell owns the bottom inset; a nested AppScaffold must not add it
      // again.
      const SettingsPage(applySafeArea: false),
    ];

    return Scaffold(
      // Only the five main tabs get the image; pushed routes stay plain.
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
            icon: const Icon(Icons.edit_note_outlined),
            selectedIcon: const Icon(Icons.edit_note),
            label: context.l10n.addEntry,
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
