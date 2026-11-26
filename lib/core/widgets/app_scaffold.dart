import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final bool applySafeArea;

  /// Main tabs sit above the shell's background image; pushed routes keep the
  /// opaque canvas so they do not inherit it.
  final bool transparentBackground;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.applySafeArea = true,
    this.transparentBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: transparentBackground
          ? Colors.transparent
          : AppColors.appCanvas,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      body: applySafeArea ? SafeArea(child: body) : body,
    );
  }
}
