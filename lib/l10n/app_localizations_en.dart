// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mero Focus';

  @override
  String get home => 'Home';

  @override
  String get review => 'Review';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get addEntry => 'Add Entry';

  @override
  String get settings => 'Settings';

  @override
  String get themeSection => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get languageSection => 'Language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get pomodoroWork => 'Focus';

  @override
  String get pomodoroShortBreak => 'Short break';

  @override
  String get pomodoroLongBreak => 'Long break';

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerReset => 'Reset';

  @override
  String get timerStop => 'End';

  @override
  String get timerStartBreak => 'Start break';

  @override
  String get timerSkipBreak => 'Skip break';

  @override
  String get timerSettings => 'Timer settings';

  @override
  String get timerLongBreakEvery => 'Long break after (rounds)';

  @override
  String timerRound(int round) {
    return 'Round $round';
  }

  @override
  String get backgroundNotificationTitle => 'Focus session running';

  @override
  String get backgroundNotificationText => 'Tap to return to Mero Focus';

  @override
  String get overlayTimeLabel => 'Time remaining';

  @override
  String get backgroundPermissions => 'Background & overlay';

  @override
  String get backgroundPermissionsIntro =>
      'Keep your timer running and visible after you leave the app.';

  @override
  String get overlayPermissionTitle => 'Floating timer (optional)';

  @override
  String get overlayPermissionBody =>
      'Shows a small timer over other apps when you leave Mero Focus. Off by default: the notification already shows the live time. Turning it on asks for the \"draw over other apps\" permission.';

  @override
  String get overlayPermissionAction => 'Grant overlay permission';

  @override
  String get batteryExemptionTitle => 'Battery optimization';

  @override
  String get batteryExemptionBody =>
      'Some devices stop background timers to save power. Exempt Mero Focus so your session is not interrupted.';

  @override
  String get batteryExemptionAction => 'Exempt from optimization';

  @override
  String get statusEnabled => 'Enabled';

  @override
  String get statusDisabled => 'Not enabled';

  @override
  String get tasks => 'Tasks';

  @override
  String get tasksToday => 'Today';

  @override
  String get tasksTomorrow => 'Tomorrow';

  @override
  String get tasksWeek => 'This week';

  @override
  String get tasksDone => 'Completed';

  @override
  String get tasksCompletedCount => 'Completed tasks';

  @override
  String get tasksRemainingCount => 'Remaining tasks';

  @override
  String get tasksElapsedTime => 'Time spent';

  @override
  String get tasksEstimatedTime => 'Estimated time';

  @override
  String get tasksShowDone => 'Show completed';

  @override
  String get tasksHideDone => 'Hide completed';

  @override
  String get tasksAddHint => 'Add a task...';

  @override
  String get tasksSort => 'Sort tasks';

  @override
  String get tasksSortProject => 'By fixed task';

  @override
  String get tasksSortDueDate => 'By due date';

  @override
  String get tasksSortPriority => 'By priority';

  @override
  String get tasksSelected => 'Task selected for focus';

  @override
  String get tasksEmpty => 'No tasks in this range';

  @override
  String get subjects => 'Fixed tasks';

  @override
  String get subjectsNew => 'New fixed task';

  @override
  String get subjectsEdit => 'Edit fixed task';

  @override
  String get subjectsNameHint => 'Fixed task name (e.g. Maintenance)';

  @override
  String get subjectsEmpty => 'Add the fixed tasks you work on all year';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionSave => 'Save';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionReopen => 'Reopen';

  @override
  String get actionClear => 'Clear';

  @override
  String get taskTitleLabel => 'Task';

  @override
  String get taskEstimatedPomodoros => 'Estimated sessions (optional)';

  @override
  String taskPomodorosCount(int count) {
    return '$count pomodoros';
  }

  @override
  String get taskPriorityLow => 'Low';

  @override
  String get taskPriorityMedium => 'Medium';

  @override
  String get taskPriorityHigh => 'High';

  @override
  String get taskNoDueDate => 'No due date';

  @override
  String get taskStartFocus => 'Start focus';

  @override
  String get taskPick => 'Select a task';

  @override
  String get reports => 'Reports';

  @override
  String get reportsPomodoro => 'Pomodoro report';

  @override
  String get reportsTasks => 'Tasks report';

  @override
  String get rangeDay => 'Daily';

  @override
  String get rangeWeek => 'Weekly';

  @override
  String get rangeMonth => 'Monthly';

  @override
  String get rangeYear => 'Yearly';

  @override
  String get reportTotalFocus => 'Total focus time';

  @override
  String get reportThisWeek => 'This week';

  @override
  String get reportToday => 'Today';

  @override
  String get reportCompletedCount => 'Completed focus sessions';

  @override
  String get reportCompletedWeek => 'Completed this week';

  @override
  String get reportCompletedToday => 'Completed today';

  @override
  String reportDailyGoal(String current, String goal) {
    return 'Daily goal: $current of $goal';
  }

  @override
  String get reportRangeFocus => 'Focus time';

  @override
  String get reportFocusDays => 'Focus days';

  @override
  String get reportAveragePerDay => 'Average / day';

  @override
  String get reportGoalDays => 'Days meeting goal';

  @override
  String get reportCopySummary => 'Copy summary';

  @override
  String get reportCopied => 'Copied';

  @override
  String get reportRecords => 'Records';

  @override
  String get reportNoData => 'No data';

  @override
  String get reportUntitled => 'Untitled';

  @override
  String reportSummary(String total, String completed, String days) {
    return 'Total focus: $total\nCompleted sessions: $completed\nFocus days: $days';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get taskEstimateNotSet => 'Not set';

  @override
  String taskEstimatedSessions(int count) {
    return 'Estimated sessions: $count';
  }

  @override
  String taskSpentSummary(String time, int count) {
    return 'Time spent: $time • Sessions: $count';
  }

  @override
  String subjectSessionsDone(int count) {
    return '$count sessions done';
  }

  @override
  String get timerFullscreen => 'Full screen';

  @override
  String get timerExitFullscreen => 'Exit full screen';

  @override
  String get settingsSoundSection => 'Sounds';

  @override
  String get soundNone => 'No sound';

  @override
  String get soundWhite => 'White noise';

  @override
  String get soundPink => 'Pink noise';

  @override
  String get soundBrown => 'Brown noise';

  @override
  String get soundEndTimer => 'Sound at the end of the timer';

  @override
  String get settingsBackgroundSection => 'Background image';

  @override
  String get backgroundPick => 'Choose from gallery';

  @override
  String get backgroundRemove => 'Remove image';

  @override
  String get backgroundTimerOnly => 'Timer only';

  @override
  String get backgroundTimerAndTasks => 'Timer and tasks';

  @override
  String get reportDailyGoalEdit => 'Daily goal';

  @override
  String get reportStreak => 'Day streak';

  @override
  String examDaysLeft(int count) {
    return '$count days left';
  }

  @override
  String get examToday => 'The exam is today';

  @override
  String get examPassed => 'The exam date has passed';

  @override
  String get examEdit => 'Edit exam goal';

  @override
  String get examRemove => 'Remove';

  @override
  String get examPlanTitle => 'Quick study plan';

  @override
  String get examPlanIntro =>
      'If you study this much every day until the exam:';

  @override
  String examPlanPerDay(int hours) {
    return '$hours hours a day';
  }

  @override
  String examPlanTotal(int total) {
    return 'You will have studied $total hours by the exam';
  }

  @override
  String get examPlanNoDays => 'Pick a future exam date to see a plan.';

  @override
  String get examPlanMotivation =>
      'Study, focus and stay consistent — every session brings you closer to your goal.';

  @override
  String get goalsAdd => 'Add a goal';

  @override
  String get goalNameLabel => 'Goal name';

  @override
  String get goalNameHint => 'e.g. Physics exam, learn English';

  @override
  String get goalDateLabel => 'End date (optional)';

  @override
  String get goalNoDate => 'No end date';

  @override
  String get reportExportPdf => 'Export / share PDF';

  @override
  String get reportExportFailed => 'Could not create the PDF';

  @override
  String get reportPdfTitle => 'Focus report';

  @override
  String reportPdfGenerated(String date) {
    return 'Created on $date';
  }

  @override
  String reportPeak(String value) {
    return 'Peak: $value';
  }

  @override
  String get reportBySubject => 'Time by fixed task';

  @override
  String get confirmDeleteTitle => 'Delete?';

  @override
  String confirmDeleteBody(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionMarkDone => 'Mark as done';

  @override
  String get actionMore => 'More options';

  @override
  String get subtasksManage => 'Subtasks';

  @override
  String get subtaskRename => 'Rename';

  @override
  String get subtaskNameHint => 'Subtask name';

  @override
  String get subtaskAddHint => 'Add a subtask (optional)...';

  @override
  String get subtaskGeneral => 'General (no subtask)';

  @override
  String get subtaskTotalAllTime => 'Total time, all time';

  @override
  String get reminders => 'Reminders';

  @override
  String get remindersEmpty =>
      'No reminders yet. Add one so you never skip studying.';

  @override
  String get reminderAdd => 'Add reminder';

  @override
  String get reminderEdit => 'Edit reminder';

  @override
  String get reminderTitleLabel => 'What do you need to do?';

  @override
  String get reminderTitleHint => 'e.g. Revise chapter 3';

  @override
  String get reminderDefaultTitle => 'Time to study';

  @override
  String get reminderTime => 'Time';

  @override
  String get reminderRepeatDaily => 'Every day';

  @override
  String get reminderRepeatDays => 'Some days';

  @override
  String get reminderRepeatOnce => 'Once';

  @override
  String get reminderEveryDay => 'Every day';

  @override
  String reminderOnceOn(String date) {
    return 'Once on $date';
  }

  @override
  String get reminderDate => 'Date';

  @override
  String get reminderLinkedTask => 'Linked fixed task (optional)';

  @override
  String get reminderNoLink => 'None (start a general session)';

  @override
  String get reminderBody => 'Tap to start your Pomodoro';

  @override
  String get reminderSuggestedTitle => 'Suggestions';

  @override
  String get reminderSuggestMorning => 'Morning study session';

  @override
  String get reminderSuggestEvening => 'Evening review';

  @override
  String get reminderSuggestPlan => 'Plan tomorrow\'s tasks';

  @override
  String get reminderSmartSwitch => 'Smart reminder';

  @override
  String get reminderSmartSubtitle =>
      'Reminds you only on days you haven\'t studied yet';

  @override
  String get reminderSmartTitle => 'Keep your streak going';

  @override
  String get reminderSmartBody =>
      'You haven\'t studied today — start a session now.';

  @override
  String get reminderNotificationsOff =>
      'Notifications are off, so reminders cannot reach you.';

  @override
  String get reminderAllow => 'Allow';

  @override
  String get reminderChannelName => 'Study reminders';

  @override
  String get reminderChannelDescription => 'Reminders to start studying';

  @override
  String get weekday1 => 'Mon';

  @override
  String get weekday2 => 'Tue';

  @override
  String get weekday3 => 'Wed';

  @override
  String get weekday4 => 'Thu';

  @override
  String get weekday5 => 'Fri';

  @override
  String get weekday6 => 'Sat';

  @override
  String get weekday7 => 'Sun';
}
