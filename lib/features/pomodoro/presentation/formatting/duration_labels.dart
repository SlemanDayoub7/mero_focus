import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../l10n/app_localizations.dart';

/// Formats durations with ARB-owned units, so no script hardcodes "min"/"h".
extension DurationLabels on Duration {
  String label(AppLocalizations l10n) {
    final totalMinutes = inSeconds ~/ 60;
    if (totalMinutes < 60) return l10n.durationMinutes(totalMinutes);
    return l10n.durationHoursMinutes(
      totalMinutes ~/ 60,
      totalMinutes % 60,
    );
  }

  String labelOf(BuildContext context) => label(context.l10n);
}
