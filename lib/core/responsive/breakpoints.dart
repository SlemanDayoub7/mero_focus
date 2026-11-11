class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;

  static bool isTablet(double width) => width >= tablet && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
  static bool isMobile(double width) => width < tablet;
}
