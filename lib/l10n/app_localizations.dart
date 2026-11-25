import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Mero Focus'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get pomodoro;

  /// No description provided for @addEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Entry'**
  String get addEntry;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @themeSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeSection;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @pomodoroWork.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get pomodoroWork;

  /// No description provided for @pomodoroShortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short break'**
  String get pomodoroShortBreak;

  /// No description provided for @pomodoroLongBreak.
  ///
  /// In en, this message translates to:
  /// **'Long break'**
  String get pomodoroLongBreak;

  /// No description provided for @timerStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get timerStart;

  /// No description provided for @timerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get timerPause;

  /// No description provided for @timerReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get timerReset;

  /// No description provided for @timerStop.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get timerStop;

  /// No description provided for @timerStartBreak.
  ///
  /// In en, this message translates to:
  /// **'Start break'**
  String get timerStartBreak;

  /// No description provided for @timerSkipBreak.
  ///
  /// In en, this message translates to:
  /// **'Skip break'**
  String get timerSkipBreak;

  /// No description provided for @timerSettings.
  ///
  /// In en, this message translates to:
  /// **'Timer settings'**
  String get timerSettings;

  /// No description provided for @timerLongBreakEvery.
  ///
  /// In en, this message translates to:
  /// **'Long break after (rounds)'**
  String get timerLongBreakEvery;

  /// No description provided for @timerRound.
  ///
  /// In en, this message translates to:
  /// **'Round {round}'**
  String timerRound(int round);

  /// No description provided for @backgroundNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus session running'**
  String get backgroundNotificationTitle;

  /// No description provided for @backgroundNotificationText.
  ///
  /// In en, this message translates to:
  /// **'Tap to return to Mero Focus'**
  String get backgroundNotificationText;

  /// No description provided for @overlayTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time remaining'**
  String get overlayTimeLabel;

  /// No description provided for @backgroundPermissions.
  ///
  /// In en, this message translates to:
  /// **'Background & overlay'**
  String get backgroundPermissions;

  /// No description provided for @backgroundPermissionsIntro.
  ///
  /// In en, this message translates to:
  /// **'Keep your timer running and visible after you leave the app.'**
  String get backgroundPermissionsIntro;

  /// No description provided for @overlayPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Floating timer (optional)'**
  String get overlayPermissionTitle;

  /// No description provided for @overlayPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Shows a small timer over other apps when you leave Mero Focus. Off by default: the notification already shows the live time. Turning it on asks for the \"draw over other apps\" permission.'**
  String get overlayPermissionBody;

  /// No description provided for @overlayPermissionAction.
  ///
  /// In en, this message translates to:
  /// **'Grant overlay permission'**
  String get overlayPermissionAction;

  /// No description provided for @batteryExemptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery optimization'**
  String get batteryExemptionTitle;

  /// No description provided for @batteryExemptionBody.
  ///
  /// In en, this message translates to:
  /// **'Some devices stop background timers to save power. Exempt Mero Focus so your session is not interrupted.'**
  String get batteryExemptionBody;

  /// No description provided for @batteryExemptionAction.
  ///
  /// In en, this message translates to:
  /// **'Exempt from optimization'**
  String get batteryExemptionAction;

  /// No description provided for @statusEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get statusEnabled;

  /// No description provided for @statusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Not enabled'**
  String get statusDisabled;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @tasksToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tasksToday;

  /// No description provided for @tasksTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tasksTomorrow;

  /// No description provided for @tasksWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get tasksWeek;

  /// No description provided for @tasksDone.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tasksDone;

  /// No description provided for @tasksCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'Completed tasks'**
  String get tasksCompletedCount;

  /// No description provided for @tasksRemainingCount.
  ///
  /// In en, this message translates to:
  /// **'Remaining tasks'**
  String get tasksRemainingCount;

  /// No description provided for @tasksElapsedTime.
  ///
  /// In en, this message translates to:
  /// **'Time spent'**
  String get tasksElapsedTime;

  /// No description provided for @tasksEstimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated time'**
  String get tasksEstimatedTime;

  /// No description provided for @tasksShowDone.
  ///
  /// In en, this message translates to:
  /// **'Show completed'**
  String get tasksShowDone;

  /// No description provided for @tasksHideDone.
  ///
  /// In en, this message translates to:
  /// **'Hide completed'**
  String get tasksHideDone;

  /// No description provided for @tasksAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add a task...'**
  String get tasksAddHint;

  /// No description provided for @tasksSort.
  ///
  /// In en, this message translates to:
  /// **'Sort tasks'**
  String get tasksSort;

  /// No description provided for @tasksSortProject.
  ///
  /// In en, this message translates to:
  /// **'By fixed task'**
  String get tasksSortProject;

  /// No description provided for @tasksSortDueDate.
  ///
  /// In en, this message translates to:
  /// **'By due date'**
  String get tasksSortDueDate;

  /// No description provided for @tasksSortPriority.
  ///
  /// In en, this message translates to:
  /// **'By priority'**
  String get tasksSortPriority;

  /// No description provided for @tasksSelected.
  ///
  /// In en, this message translates to:
  /// **'Task selected for focus'**
  String get tasksSelected;

  /// No description provided for @tasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks in this range'**
  String get tasksEmpty;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Fixed tasks'**
  String get subjects;

  /// No description provided for @subjectsNew.
  ///
  /// In en, this message translates to:
  /// **'New fixed task'**
  String get subjectsNew;

  /// No description provided for @subjectsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit fixed task'**
  String get subjectsEdit;

  /// No description provided for @subjectsNameHint.
  ///
  /// In en, this message translates to:
  /// **'Fixed task name (e.g. Maintenance)'**
  String get subjectsNameHint;

  /// No description provided for @subjectsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add the fixed tasks you work on all year'**
  String get subjectsEmpty;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get actionReopen;

  /// No description provided for @actionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskTitleLabel;

  /// No description provided for @taskEstimatedPomodoros.
  ///
  /// In en, this message translates to:
  /// **'Estimated sessions (optional)'**
  String get taskEstimatedPomodoros;

  /// No description provided for @taskPomodorosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pomodoros'**
  String taskPomodorosCount(int count);

  /// No description provided for @taskPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get taskPriorityLow;

  /// No description provided for @taskPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get taskPriorityMedium;

  /// No description provided for @taskPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get taskPriorityHigh;

  /// No description provided for @taskNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get taskNoDueDate;

  /// No description provided for @taskStartFocus.
  ///
  /// In en, this message translates to:
  /// **'Start focus'**
  String get taskStartFocus;

  /// No description provided for @taskPick.
  ///
  /// In en, this message translates to:
  /// **'Select a task'**
  String get taskPick;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @reportsPomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro report'**
  String get reportsPomodoro;

  /// No description provided for @reportsTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks report'**
  String get reportsTasks;

  /// No description provided for @rangeDay.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get rangeDay;

  /// No description provided for @rangeWeek.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get rangeWeek;

  /// No description provided for @rangeMonth.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get rangeMonth;

  /// No description provided for @rangeYear.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get rangeYear;

  /// No description provided for @reportTotalFocus.
  ///
  /// In en, this message translates to:
  /// **'Total focus time'**
  String get reportTotalFocus;

  /// No description provided for @reportThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get reportThisWeek;

  /// No description provided for @reportToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get reportToday;

  /// No description provided for @reportCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'Completed focus sessions'**
  String get reportCompletedCount;

  /// No description provided for @reportCompletedWeek.
  ///
  /// In en, this message translates to:
  /// **'Completed this week'**
  String get reportCompletedWeek;

  /// No description provided for @reportCompletedToday.
  ///
  /// In en, this message translates to:
  /// **'Completed today'**
  String get reportCompletedToday;

  /// No description provided for @reportDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal: {current} of {goal}'**
  String reportDailyGoal(String current, String goal);

  /// No description provided for @reportRangeFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus time'**
  String get reportRangeFocus;

  /// No description provided for @reportFocusDays.
  ///
  /// In en, this message translates to:
  /// **'Focus days'**
  String get reportFocusDays;

  /// No description provided for @reportAveragePerDay.
  ///
  /// In en, this message translates to:
  /// **'Average / day'**
  String get reportAveragePerDay;

  /// No description provided for @reportGoalDays.
  ///
  /// In en, this message translates to:
  /// **'Days meeting goal'**
  String get reportGoalDays;

  /// No description provided for @reportCopySummary.
  ///
  /// In en, this message translates to:
  /// **'Copy summary'**
  String get reportCopySummary;

  /// No description provided for @reportCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get reportCopied;

  /// No description provided for @reportRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get reportRecords;

  /// No description provided for @reportNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get reportNoData;

  /// No description provided for @reportUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get reportUntitled;

  /// No description provided for @reportSummary.
  ///
  /// In en, this message translates to:
  /// **'Total focus: {total}\nCompleted sessions: {completed}\nFocus days: {days}'**
  String reportSummary(String total, String completed, String days);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @taskEstimateNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get taskEstimateNotSet;

  /// No description provided for @taskEstimatedSessions.
  ///
  /// In en, this message translates to:
  /// **'Estimated sessions: {count}'**
  String taskEstimatedSessions(int count);

  /// No description provided for @taskSpentSummary.
  ///
  /// In en, this message translates to:
  /// **'Time spent: {time} • Sessions: {count}'**
  String taskSpentSummary(String time, int count);

  /// No description provided for @subjectSessionsDone.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions done'**
  String subjectSessionsDone(int count);

  /// No description provided for @timerFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Full screen'**
  String get timerFullscreen;

  /// No description provided for @timerExitFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Exit full screen'**
  String get timerExitFullscreen;

  /// No description provided for @settingsSoundSection.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get settingsSoundSection;

  /// No description provided for @soundNone.
  ///
  /// In en, this message translates to:
  /// **'No sound'**
  String get soundNone;

  /// No description provided for @soundWhite.
  ///
  /// In en, this message translates to:
  /// **'White noise'**
  String get soundWhite;

  /// No description provided for @soundPink.
  ///
  /// In en, this message translates to:
  /// **'Pink noise'**
  String get soundPink;

  /// No description provided for @soundBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown noise'**
  String get soundBrown;

  /// No description provided for @soundEndTimer.
  ///
  /// In en, this message translates to:
  /// **'Sound at the end of the timer'**
  String get soundEndTimer;

  /// No description provided for @settingsBackgroundSection.
  ///
  /// In en, this message translates to:
  /// **'Background image'**
  String get settingsBackgroundSection;

  /// No description provided for @backgroundPick.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get backgroundPick;

  /// No description provided for @backgroundRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get backgroundRemove;

  /// No description provided for @backgroundTimerOnly.
  ///
  /// In en, this message translates to:
  /// **'Timer only'**
  String get backgroundTimerOnly;

  /// No description provided for @backgroundTimerAndTasks.
  ///
  /// In en, this message translates to:
  /// **'Timer and tasks'**
  String get backgroundTimerAndTasks;

  /// No description provided for @reportDailyGoalEdit.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get reportDailyGoalEdit;

  /// No description provided for @reportStreak.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get reportStreak;

  /// No description provided for @examDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String examDaysLeft(int count);

  /// No description provided for @examToday.
  ///
  /// In en, this message translates to:
  /// **'The exam is today'**
  String get examToday;

  /// No description provided for @examPassed.
  ///
  /// In en, this message translates to:
  /// **'The exam date has passed'**
  String get examPassed;

  /// No description provided for @examEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit exam goal'**
  String get examEdit;

  /// No description provided for @examRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get examRemove;

  /// No description provided for @examPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick study plan'**
  String get examPlanTitle;

  /// No description provided for @examPlanIntro.
  ///
  /// In en, this message translates to:
  /// **'If you study this much every day until the exam:'**
  String get examPlanIntro;

  /// No description provided for @examPlanPerDay.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours a day'**
  String examPlanPerDay(int hours);

  /// No description provided for @examPlanTotal.
  ///
  /// In en, this message translates to:
  /// **'You will have studied {total} hours by the exam'**
  String examPlanTotal(int total);

  /// No description provided for @examPlanNoDays.
  ///
  /// In en, this message translates to:
  /// **'Pick a future exam date to see a plan.'**
  String get examPlanNoDays;

  /// No description provided for @examPlanMotivation.
  ///
  /// In en, this message translates to:
  /// **'Study, focus and stay consistent — every session brings you closer to your goal.'**
  String get examPlanMotivation;

  /// No description provided for @goalsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a goal'**
  String get goalsAdd;

  /// No description provided for @goalNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get goalNameLabel;

  /// No description provided for @goalNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Physics exam, learn English'**
  String get goalNameHint;

  /// No description provided for @goalDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End date (optional)'**
  String get goalDateLabel;

  /// No description provided for @goalNoDate.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get goalNoDate;

  /// No description provided for @reportExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export / share PDF'**
  String get reportExportPdf;

  /// No description provided for @reportExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the PDF'**
  String get reportExportFailed;

  /// No description provided for @reportPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus report'**
  String get reportPdfTitle;

  /// No description provided for @reportPdfGenerated.
  ///
  /// In en, this message translates to:
  /// **'Created on {date}'**
  String reportPdfGenerated(String date);

  /// No description provided for @reportPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak: {value}'**
  String reportPeak(String value);

  /// No description provided for @reportBySubject.
  ///
  /// In en, this message translates to:
  /// **'Time by fixed task'**
  String get reportBySubject;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String confirmDeleteBody(String name);

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get actionMarkDone;

  /// No description provided for @actionMore.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get actionMore;

  /// No description provided for @subtasksManage.
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get subtasksManage;

  /// No description provided for @subtaskRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get subtaskRename;

  /// No description provided for @subtaskNameHint.
  ///
  /// In en, this message translates to:
  /// **'Subtask name'**
  String get subtaskNameHint;

  /// No description provided for @subtaskAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add a subtask (optional)...'**
  String get subtaskAddHint;

  /// No description provided for @subtaskGeneral.
  ///
  /// In en, this message translates to:
  /// **'General (no subtask)'**
  String get subtaskGeneral;

  /// No description provided for @subtaskTotalAllTime.
  ///
  /// In en, this message translates to:
  /// **'Total time, all time'**
  String get subtaskTotalAllTime;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @remindersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet. Add one so you never skip studying.'**
  String get remindersEmpty;

  /// No description provided for @reminderAdd.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get reminderAdd;

  /// No description provided for @reminderEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get reminderEdit;

  /// No description provided for @reminderTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you need to do?'**
  String get reminderTitleLabel;

  /// No description provided for @reminderTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Revise chapter 3'**
  String get reminderTitleHint;

  /// No description provided for @reminderDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to study'**
  String get reminderDefaultTitle;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get reminderTime;

  /// No description provided for @reminderRepeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get reminderRepeatDaily;

  /// No description provided for @reminderRepeatDays.
  ///
  /// In en, this message translates to:
  /// **'Some days'**
  String get reminderRepeatDays;

  /// No description provided for @reminderRepeatOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get reminderRepeatOnce;

  /// No description provided for @reminderEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get reminderEveryDay;

  /// No description provided for @reminderOnceOn.
  ///
  /// In en, this message translates to:
  /// **'Once on {date}'**
  String reminderOnceOn(String date);

  /// No description provided for @reminderDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get reminderDate;

  /// No description provided for @reminderLinkedTask.
  ///
  /// In en, this message translates to:
  /// **'Linked fixed task (optional)'**
  String get reminderLinkedTask;

  /// No description provided for @reminderNoLink.
  ///
  /// In en, this message translates to:
  /// **'None (start a general session)'**
  String get reminderNoLink;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Tap to start your Pomodoro'**
  String get reminderBody;

  /// No description provided for @reminderSuggestedTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get reminderSuggestedTitle;

  /// No description provided for @reminderSuggestMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning study session'**
  String get reminderSuggestMorning;

  /// No description provided for @reminderSuggestEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening review'**
  String get reminderSuggestEvening;

  /// No description provided for @reminderSuggestPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan tomorrow\'s tasks'**
  String get reminderSuggestPlan;

  /// No description provided for @reminderSmartSwitch.
  ///
  /// In en, this message translates to:
  /// **'Smart reminder'**
  String get reminderSmartSwitch;

  /// No description provided for @reminderSmartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminds you only on days you haven\'t studied yet'**
  String get reminderSmartSubtitle;

  /// No description provided for @reminderSmartTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your streak going'**
  String get reminderSmartTitle;

  /// No description provided for @reminderSmartBody.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t studied today — start a session now.'**
  String get reminderSmartBody;

  /// No description provided for @reminderNotificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off, so reminders cannot reach you.'**
  String get reminderNotificationsOff;

  /// No description provided for @reminderAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get reminderAllow;

  /// No description provided for @reminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Study reminders'**
  String get reminderChannelName;

  /// No description provided for @reminderChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders to start studying'**
  String get reminderChannelDescription;

  /// No description provided for @weekday1.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekday1;

  /// No description provided for @weekday2.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekday2;

  /// No description provided for @weekday3.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekday3;

  /// No description provided for @weekday4.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekday4;

  /// No description provided for @weekday5.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekday5;

  /// No description provided for @weekday6.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekday6;

  /// No description provided for @weekday7.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekday7;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
