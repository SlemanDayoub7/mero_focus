import 'package:flutter/material.dart';

/// غلاف رفيع لـ SafeArea. ملاحظة: AppScaffold تحته أصلاً SafeArea افتراضياً،
/// فاستخدم AppSafeArea فقط خارج سياق Scaffold (مثلاً داخل Dialog أو BottomSheet).
class AppSafeArea extends StatelessWidget {
  final Widget child;
  const AppSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SafeArea(child: child);
}
