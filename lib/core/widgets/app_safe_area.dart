import 'package:flutter/material.dart';

/// غلاف رفيع لـ SafeArea للمحتوى خارج Scaffold.
///
/// AppScaffold يطبّق الحاشية السفلية أصلاً، لذلك [includeBottom] خطأ افتراضياً؛
/// فعّله فقط حين لا يوجد Scaffold أعلاه (مثل Dialog أو BottomSheet).
class AppSafeArea extends StatelessWidget {
  const AppSafeArea({
    super.key,
    required this.child,
    this.includeBottom = false,
  });

  final Widget child;
  final bool includeBottom;

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: includeBottom,
        child: child,
      );
}
