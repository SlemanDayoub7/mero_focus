import 'dart:ui';

import '../../../../core/theme/app_colors.dart';

/// Stable color choices for subjects, stored as ARGB hex strings.
///
/// Every entry is a named token so widgets never construct ad-hoc colors. The
/// swatches act as surfaces (never as text ink); the values below were chosen
/// so a light check halo and the app's primary ink stay legible on top of them:
/// * [teal]   5.3:1 on white — safe as a surface and as a dark accent.
/// * [purple] 9.4:1 on white — deep enough for any overlay.
/// * [red]    5.6:1 on white — calmer than the error hue, still readable.
/// * [green]  5.1:1 on white — meets 4.5:1 even against white ink.
/// * [brown]  9.3:1 on white — neutral, high-contrast accent.
abstract final class SubjectPalette {
  /// Teal accent — 5.3:1 against white, 3.2:1 against charcoal ink.
  static const Color teal = Color(0xFF00796B);

  /// Deep purple accent — 9.4:1 against white.
  static const Color purple = Color(0xFF6A1B9A);

  /// Muted red accent — 5.6:1 against white, distinct from [AppColors] error.
  static const Color brickRed = Color(0xFFC62828);

  /// Deep green accent — 5.1:1 against white.
  static const Color forestGreen = Color(0xFF2E7D32);

  /// Warm brown accent — 9.3:1 against white.
  static const Color warmBrown = Color(0xFF5D4037);

  /// All selectable subject colors, in the order shown in the editor.
  static const List<Color> colors = <Color>[
    AppColors.skyBlue,
    AppColors.royalBlue,
    AppColors.mutedYellow,
    teal,
    purple,
    brickRed,
    forestGreen,
    warmBrown,
  ];

  static String toHex(Color color) =>
      color.toARGB32().toRadixString(16).padLeft(8, '0');

  static Color fromHex(String hex) => Color(int.parse(hex, radix: 16));
}
