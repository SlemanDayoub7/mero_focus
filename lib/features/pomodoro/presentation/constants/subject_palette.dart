import 'dart:ui';

import '../../../../core/theme/app_colors.dart';

/// Stable color choices for subjects, stored as ARGB hex strings.
abstract final class SubjectPalette {
  static const List<Color> colors = <Color>[
    AppColors.skyBlue,
    AppColors.royalBlue,
    AppColors.mutedYellow,
    Color(0xFF26A69A),
    Color(0xFFAB47BC),
    Color(0xFFEF5350),
    Color(0xFF66BB6A),
    Color(0xFF8D6E63),
  ];

  static String toHex(Color color) =>
      color.toARGB32().toRadixString(16).padLeft(8, '0');

  static Color fromHex(String hex) => Color(int.parse(hex, radix: 16));
}
