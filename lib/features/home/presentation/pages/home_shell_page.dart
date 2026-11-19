import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../capture/presentation/pages/placeholder_capture_page.dart';
import '../../../pomodoro/presentation/pages/pomodoro_timer_page.dart';
import '../../../review/presentation/pages/placeholder_review_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  int _currentIndex = 0;

  static const List<Widget> _pages = <Widget>[
    PomodoroTimerPage(),
    PlaceholderReviewPage(),
    PlaceholderCapturePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.timer_outlined),
            label: context.l10n.pomodoro,
          ),
          NavigationDestination(
            icon: const Icon(Icons.refresh),
            label: context.l10n.review,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            label: context.l10n.addEntry,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: context.l10n.settings,
          ),
        ],
      ),
    );
  }
}
