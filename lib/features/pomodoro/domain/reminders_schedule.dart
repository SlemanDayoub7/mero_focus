import 'entities/reminder.dart';
import 'entities/scheduled_item.dart';

/// Notification ids: `reminderId * 100 + slot` (slot < 100). The app's own
/// reminder uses reminder id 0, user reminders start at 1.
const int kSlotsPerReminder = 100;

/// Pure: turns the saved reminders into the exact notifications to schedule.
List<ScheduledItem> buildScheduledItems({
  required List<Reminder> reminders,
  required SmartReminder smart,
  required bool studiedToday,
  required DateTime now,
  required ReminderTexts texts,
}) {
  final items = <ScheduledItem>[];

  for (final reminder in reminders) {
    if (reminder.id <= 0) continue;
    final times = reminder.dueTimes(now);
    for (var slot = 0; slot < times.length && slot < kSlotsPerReminder; slot++) {
      items.add(
        ScheduledItem(
          id: reminder.id * kSlotsPerReminder + slot,
          title: reminder.title.trim().isEmpty
              ? texts.defaultTitle
              : reminder.title.trim(),
          body: texts.body,
          when: times[slot],
          payload: 'r:${reminder.id}',
        ),
      );
    }
  }

  final smartTimes = smart.dueTimes(now, studiedToday: studiedToday);
  for (var slot = 0; slot < smartTimes.length && slot < kSlotsPerReminder; slot++) {
    items.add(
      ScheduledItem(
        id: slot,
        title: texts.smartTitle,
        body: texts.smartBody,
        when: smartTimes[slot],
        payload: 'smart',
      ),
    );
  }
  return items;
}
