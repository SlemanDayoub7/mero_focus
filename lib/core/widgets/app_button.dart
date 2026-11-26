import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Primary/secondary action button with a 48 dp tap target and accessible ink.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSecondary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(label),
            ],
          );

    if (isSecondary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(72, AppSpacing.controlHeight),
        ),
        child: child,
      );
    }

    return FilledButton(onPressed: onPressed, child: child);
  }
}
