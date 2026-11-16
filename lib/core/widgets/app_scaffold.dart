import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool applySafeArea;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.applySafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: applySafeArea ? SafeArea(child: body) : body,
    );
  }
}
