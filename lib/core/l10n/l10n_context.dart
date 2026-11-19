import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Unified access to localized strings from any widget.
///
/// Never call `AppLocalizations.of(context)` directly; use `context.l10n`
/// so there is a single place to change if the localization solution changes.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
