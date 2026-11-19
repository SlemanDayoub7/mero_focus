import 'package:flutter/material.dart';
import 'package:mero_focus/core/extensions/context_extensions.dart';
import '../../../review/presentation/pages/placeholder_review_page.dart';
import '../../../capture/presentation/pages/placeholder_capture_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../../core/localization/locale_keys.g.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});
  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  int _currentIndex = 0;
  final _pages = const [
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
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.refresh),
            label: context.translate(LocaleKeys.review),
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            label: context.translate(LocaleKeys.add_entry),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: context.translate(LocaleKeys.settings),
          ),
        ],
      ),
    );
  }
}
