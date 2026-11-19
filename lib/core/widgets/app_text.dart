import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';
import '../theme/app_typography.dart';

enum AppTextVariant { heading, body, caption }

class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.body,
    this.color,
    this.textAlign,
  });

  TextStyle _styleFor(AppTextVariant v) {
    switch (v) {
      case AppTextVariant.heading:
        return AppTypography.heading;
      case AppTextVariant.body:
        return AppTypography.body;
      case AppTextVariant.caption:
        return AppTypography.caption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: _styleFor(variant).copyWith(color: color ?? context.colors.onSurface),
    );
  }
}
