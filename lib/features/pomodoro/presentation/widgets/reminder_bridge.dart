import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../data/services/reminder_notification_service.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/scheduled_item.dart';
import '../../domain/reminders_schedule.dart';
import '../controllers/planner_providers.dart';
import '../controllers/reminders_provider.dart';
import '../pages/focus_launcher.dart';

/// Keeps the scheduled notifications in step with the saved reminders and
/// turns a tapped notification into "open the app and start studying".
///
/// Refreshes when reminders change, when a session is recorded (the smart
/// reminder skips a day already studied), and whenever the app comes back to
/// the foreground (keeps the 30-day window topped up).
class ReminderBridge extends ConsumerStatefulWidget {
  const ReminderBridge({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ReminderBridge> createState() => _ReminderBridgeState();
}

class _ReminderBridgeState extends ConsumerState<ReminderBridge>
    with WidgetsBindingObserver {
  StreamSubscription<String>? _taps;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_start());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_taps?.cancel());
    super.dispose();
  }

  Future<void> _start() async {
    final service = ref.read(reminderServiceProvider);
    await service.init();
    if (!mounted) return;
    _ready = true;
    _taps = service.taps.listen(_handleTap);
    final launch = await service.launchPayload();
    if (launch != null) _handleTap(launch);
    await _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(studiedTodayProvider);
      ref.invalidate(notificationsEnabledProvider);
      unawaited(_sync());
    }
  }

  Future<void> _sync() async {
    if (!_ready || !mounted) return;
    final l10n = context.l10n;
    final texts = ReminderTexts(
      defaultTitle: l10n.reminderDefaultTitle,
      body: l10n.reminderBody,
      smartTitle: l10n.reminderSmartTitle,
      smartBody: l10n.reminderSmartBody,
      channelName: l10n.reminderChannelName,
      channelDescription: l10n.reminderChannelDescription,
    );
    final items = buildScheduledItems(
      reminders: ref.read(remindersProvider),
      smart: ref.read(smartReminderProvider),
      studiedToday: ref.read(studiedTodayProvider),
      now: DateTime.now(),
      texts: texts,
    );
    await ref
        .read(reminderServiceProvider)
        .replaceAll(
          items,
          channelName: texts.channelName,
          channelDescription: texts.channelDescription,
        );
  }

  void _handleTap(String payload) => unawaited(_open(payload));

  Future<void> _open(String payload) async {
    Subject? subject;
    if (payload.startsWith('r:')) {
      final id = int.tryParse(payload.substring(2));
      final subjectId = id == null
          ? null
          : ref
                .read(remindersProvider)
                .where((reminder) => reminder.id == id)
                .map((reminder) => reminder.subjectId)
                .firstOrNull;
      if (subjectId != null) {
        // Cold start: wait until the fixed tasks are loaded.
        final subjects = await ref.read(subjectsProvider.future);
        subject = subjects
            .where((candidate) => candidate.id == subjectId)
            .firstOrNull;
      }
    }
    if (!mounted) return;
    await startFocusFromReminder(context, ref, subject: subject);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(remindersProvider, (_, _) => unawaited(_sync()));
    ref.listen(smartReminderProvider, (_, _) => unawaited(_sync()));
    ref.listen(studiedTodayProvider, (_, _) => unawaited(_sync()));
    return widget.child;
  }
}
