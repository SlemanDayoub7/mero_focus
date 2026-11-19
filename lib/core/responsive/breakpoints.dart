import 'package:flutter/material.dart';

/// Width (in logical pixels) at which the tablet layout starts.
const double kTabletBreakpoint = 600;

/// Coarse device categories used by layout decisions.
enum DeviceType { mobile, tablet }

/// Responsive helpers available on every [BuildContext].
///
/// Never call `MediaQuery.sizeOf(context)` / `MediaQuery.orientationOf(context)`
/// directly from a widget; use this extension instead.
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  Orientation get orientation => MediaQuery.orientationOf(this);

  DeviceType get deviceType =>
      screenWidth >= kTabletBreakpoint ? DeviceType.tablet : DeviceType.mobile;

  bool get isTablet => deviceType == DeviceType.tablet;

  bool get isLandscape => orientation == Orientation.landscape;
}

/// Numeric breakpoints, kept for code that only has a raw width available.
abstract final class Breakpoints {
  static const double tablet = kTabletBreakpoint;
  static const double desktop = 1024;

  static bool isTablet(double width) => width >= tablet && width < desktop;

  static bool isDesktop(double width) => width >= desktop;

  static bool isMobile(double width) => width < tablet;
}
