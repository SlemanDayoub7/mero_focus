/// One notification to schedule, already localized and resolved to a time.
class ScheduledItem {
  const ScheduledItem({
    required this.id,
    required this.title,
    required this.body,
    required this.when,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final DateTime when;

  /// `r:<reminderId>` for a user reminder, `smart` for the app's reminder.
  final String payload;
}

/// Texts the scheduler needs, supplied by the UI layer from l10n.
class ReminderTexts {
  const ReminderTexts({
    required this.defaultTitle,
    required this.body,
    required this.smartTitle,
    required this.smartBody,
    required this.channelName,
    required this.channelDescription,
  });

  final String defaultTitle;
  final String body;
  final String smartTitle;
  final String smartBody;
  final String channelName;
  final String channelDescription;
}
