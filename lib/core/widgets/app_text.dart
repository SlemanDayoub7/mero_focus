import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_typography.dart';

/// Every variant maps 1:1 to a style in [AppTypography].
enum AppTextVariant {
  display,
  heading,
  title,
  body,
  bodyStrong,
  caption,
  label,
}

/// Text that always resolves its style from [AppTypography] and adds a
/// theme-aware ink. User text scaling from the OS is still respected.
class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  TextStyle _styleFor(AppTextVariant variant, ColorScheme colors) {
    switch (variant) {
      case AppTextVariant.display:
        return AppTypography.display.copyWith(color: colors.onSurface);
      case AppTextVariant.heading:
        return AppTypography.heading.copyWith(color: colors.onSurface);
      case AppTextVariant.title:
        return AppTypography.title.copyWith(color: colors.onSurface);
      case AppTextVariant.body:
        return AppTypography.body.copyWith(color: colors.onSurface);
      case AppTextVariant.bodyStrong:
        return AppTypography.bodyStrong.copyWith(color: colors.onSurface);
      case AppTextVariant.caption:
        return AppTypography.caption.copyWith(color: colors.onSurfaceVariant);
      case AppTextVariant.label:
        return AppTypography.label.copyWith(color: colors.onSurfaceVariant);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(variant, context.colors);
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: color == null ? style : style.copyWith(color: color),
    );
  }
}
