import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// App bar with a 20 px title and full-width, 48 dp icon buttons.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double transparentDegree;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
    this.transparentDegree = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      backgroundColor: Colors.black.withOpacity(transparentDegree),
      foregroundColor: AppColors.glassInk,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
