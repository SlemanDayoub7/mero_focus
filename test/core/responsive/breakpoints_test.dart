import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/responsive/breakpoints.dart';

Future<BuildContext> _contextWithSize(WidgetTester tester, Size size) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size),
      child: Builder(
        builder: (context) {
          captured = context;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return captured;
}

void main() {
  test('Breakpoints keeps the numeric thresholds', () {
    expect(Breakpoints.isMobile(599), isTrue);
    expect(Breakpoints.isTablet(600), isTrue);
    expect(Breakpoints.isDesktop(1024), isTrue);
  });

  testWidgets('narrow screens are mobile and wide screens are tablets',
      (tester) async {
    final mobile = await _contextWithSize(tester, const Size(400, 800));
    expect(mobile.deviceType, DeviceType.mobile);
    expect(mobile.isTablet, isFalse);

    final tablet = await _contextWithSize(tester, const Size(800, 600));
    expect(tablet.deviceType, DeviceType.tablet);
    expect(tablet.isTablet, isTrue);
  });

  testWidgets('orientation is derived from the size', (tester) async {
    final portrait = await _contextWithSize(tester, const Size(400, 800));
    expect(portrait.orientation, Orientation.portrait);
    expect(portrait.isLandscape, isFalse);

    final landscape = await _contextWithSize(tester, const Size(800, 400));
    expect(landscape.orientation, Orientation.landscape);
    expect(landscape.isLandscape, isTrue);
  });
}
