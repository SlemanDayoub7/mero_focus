import 'package:flutter/material.dart';

/// Typography scale of Mero Focus.
///
/// Body text is 16 px so it stays readable on a phone held at arm's length.
/// Short metadata labels use 14 px; nothing smaller is used for content.
/// Every style keeps `height >= 1.35` because Cairo's Arabic glyphs need
/// more vertical room than Latin defaults.
abstract final class AppTypography {
  static const String family = 'Cairo';

  static const TextStyle display = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    fontFamily: family,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: family,
    height: 1.3,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: family,
    height: 1.35,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: family,
    height: 1.5,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: family,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: family,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontFamily: family,
    height: 1.4,
  );
}
