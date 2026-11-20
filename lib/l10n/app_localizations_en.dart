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
  String get overlayPermissionTitle => 'Floating timer';

  @override
  String get overlayPermissionBody =>
      'Allow Mero Focus to draw over other apps so a small timer stays visible when you switch apps.';

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
  String get tasksSortProject => 'By subject';

  @override
  String get tasksSortDueDate => 'By due date';

  @override
  String get tasksSortPriority => 'By priority';

  @override
  String get tasksSelected => 'Task selected for focus';

  @override
  String get tasksEmpty => 'No tasks in this range';

  @override
  String get subjects => 'Subjects';

  @override
  String get subjectsNew => 'New subject';

  @override
  String get subjectsNameHint => 'Subject name';

  @override
  String get subjectsEmpty => 'Add your subjects to pick them later';

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
  String get taskEstimatedPomodoros => 'Estimated pomodoros';

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
}
