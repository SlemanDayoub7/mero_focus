/// Spacing and sizing tokens. All values are multiples of 4 px (8 px grid).
///
/// `minTouchTarget` follows Material/Accessibility guidance (48 dp Android,
/// 44 pt iOS) and is the minimum height of every tappable control.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double radiusSm = 12;
  static const double radiusMd = 18;
  static const double radiusLg = 24;
  static const double radiusXl = 32;

  /// Minimum tap target and spacing between adjacent targets.
  static const double minTouchTarget = 48;
  static const double touchTargetGap = 8;

  /// Default height for buttons and chips.
  static const double controlHeight = 48;

  /// Horizontal padding of a standard screen.
  static const double screenPadding = 16;
}
