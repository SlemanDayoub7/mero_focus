// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ميرو فوكس';

  @override
  String get home => 'الرئيسية';

  @override
  String get review => 'المراجعة';

  @override
  String get pomodoro => 'بومودورو';

  @override
  String get addEntry => 'إضافة عنصر';

  @override
  String get settings => 'الإعدادات';

  @override
  String get themeSection => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get languageSection => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get pomodoroWork => 'تركيز';

  @override
  String get pomodoroShortBreak => 'استراحة قصيرة';

  @override
  String get pomodoroLongBreak => 'استراحة طويلة';

  @override
  String get timerStart => 'ابدأ';

  @override
  String get timerPause => 'إيقاف مؤقت';

  @override
  String get timerReset => 'إعادة ضبط';

  @override
  String get timerStop => 'إنهاء';

  @override
  String get timerStartBreak => 'ابدأ الاستراحة';

  @override
  String get timerSkipBreak => 'تخطّي الاستراحة';

  @override
  String get timerSettings => 'إعدادات المؤقت';

  @override
  String get timerLongBreakEvery => 'استراحة طويلة بعد (جولات)';

  @override
  String timerRound(int round) {
    return 'الجولة $round';
  }

  @override
  String get backgroundNotificationTitle => 'جلسة التركيز قيد التشغيل';

  @override
  String get backgroundNotificationText => 'اضغط للعودة إلى ميرو فوكس';

  @override
  String get overlayTimeLabel => 'الوقت المتبقي';

  @override
  String get backgroundPermissions => 'الخلفية والنافذة العائمة';

  @override
  String get backgroundPermissionsIntro =>
      'حافظ على تشغيل المؤقت وظهوره بعد مغادرة التطبيق.';

  @override
  String get overlayPermissionTitle => 'المؤقت العائم (اختياري)';

  @override
  String get overlayPermissionBody =>
      'يعرض مؤقتاً صغيراً فوق التطبيقات الأخرى عند خروجك من ميرو فوكس. مغلق افتراضياً لأن الإشعار يعرض الوقت الحي أصلاً. تفعيله يطلب إذن \"العرض فوق التطبيقات الأخرى\".';

  @override
  String get overlayPermissionAction => 'منح إذن النافذة العائمة';

  @override
  String get batteryExemptionTitle => 'تحسين البطارية';

  @override
  String get batteryExemptionBody =>
      'بعض الأجهزة توقف مؤقتات الخلفية لتوفير الطاقة. استثنِ ميرو فوكس حتى لا تنقطع جلستك.';

  @override
  String get batteryExemptionAction => 'استثناء من التحسين';

  @override
  String get statusEnabled => 'مفعّل';

  @override
  String get statusDisabled => 'غير مفعّل';

  @override
  String get tasks => 'المهام';

  @override
  String get tasksToday => 'اليوم';

  @override
  String get tasksTomorrow => 'غداً';

  @override
  String get tasksWeek => 'هذا الأسبوع';

  @override
  String get tasksDone => 'تم الانتهاء';

  @override
  String get tasksCompletedCount => 'المهام المكتملة';

  @override
  String get tasksRemainingCount => 'المهام المتبقية';

  @override
  String get tasksElapsedTime => 'الوقت المنقضي';

  @override
  String get tasksEstimatedTime => 'الوقت المقدّر';

  @override
  String get tasksShowDone => 'عرض المهام المكتملة';

  @override
  String get tasksHideDone => 'إخفاء المهام المكتملة';

  @override
  String get tasksAddHint => 'أضف مهمة...';

  @override
  String get tasksSort => 'ترتيب المهام';

  @override
  String get tasksSortProject => 'حسب المهمة الثابتة';

  @override
  String get tasksSortDueDate => 'حسب تاريخ الاستحقاق';

  @override
  String get tasksSortPriority => 'حسب الأولوية';

  @override
  String get tasksSelected => 'تم اختيار المهمة للتركيز';

  @override
  String get tasksEmpty => 'لا توجد مهام في هذا النطاق';

  @override
  String get subjects => 'المهام الثابتة';

  @override
  String get subjectsNew => 'مهمة ثابتة جديدة';

  @override
  String get subjectsEdit => 'تعديل المهمة الثابتة';

  @override
  String get subjectsNameHint => 'اسم المهمة الثابتة (مثلاً: الصيانة)';

  @override
  String get subjectsEmpty => 'أضف المهام الثابتة التي تعمل عليها طوال السنة';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionAdd => 'إضافة';

  @override
  String get actionSave => 'حفظ';

  @override
  String get actionDelete => 'حذف';

  @override
  String get actionReopen => 'إعادة فتح';

  @override
  String get actionClear => 'مسح';

  @override
  String get taskTitleLabel => 'المهمة';

  @override
  String get taskEstimatedPomodoros => 'الجلسات المقدّرة (اختياري)';

  @override
  String taskPomodorosCount(int count) {
    return '$count بومودورو';
  }

  @override
  String get taskPriorityLow => 'منخفضة';

  @override
  String get taskPriorityMedium => 'متوسطة';

  @override
  String get taskPriorityHigh => 'عالية';

  @override
  String get taskNoDueDate => 'بدون تاريخ انتهاء';

  @override
  String get taskStartFocus => 'ابدأ التركيز';

  @override
  String get taskPick => 'حدد مهمة';

  @override
  String get reports => 'التقارير';

  @override
  String get reportsPomodoro => 'تقرير البومودورو';

  @override
  String get reportsTasks => 'تقرير المهام';

  @override
  String get rangeDay => 'يومي';

  @override
  String get rangeWeek => 'أسبوعي';

  @override
  String get rangeMonth => 'شهري';

  @override
  String get rangeYear => 'سنوي';

  @override
  String get reportTotalFocus => 'وقت التركيز الكلي';

  @override
  String get reportThisWeek => 'هذا الأسبوع';

  @override
  String get reportToday => 'اليوم';

  @override
  String get reportCompletedCount => 'التركيزات المكتملة';

  @override
  String get reportCompletedWeek => 'مكتملة هذا الأسبوع';

  @override
  String get reportCompletedToday => 'مكتملة اليوم';

  @override
  String reportDailyGoal(String current, String goal) {
    return 'هدف اليوم: $current من $goal';
  }

  @override
  String get reportRangeFocus => 'وقت التركيز';

  @override
  String get reportFocusDays => 'أيام التركيز';

  @override
  String get reportAveragePerDay => 'المتوسط / يوم';

  @override
  String get reportGoalDays => 'أيام تحقق الهدف';

  @override
  String get reportCopySummary => 'نسخ الملخص';

  @override
  String get reportCopied => 'تم النسخ';

  @override
  String get reportRecords => 'السجلات';

  @override
  String get reportNoData => 'لا توجد بيانات';

  @override
  String get reportUntitled => 'بدون عنوان';

  @override
  String reportSummary(String total, String completed, String days) {
    return 'إجمالي التركيز: $total\nالتركيزات المكتملة: $completed\nأيام التركيز: $days';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ساعة $minutes دقيقة';
  }

  @override
  String get taskEstimateNotSet => 'غير محدد';

  @override
  String taskEstimatedSessions(int count) {
    return 'الجلسات المقدّرة: $count';
  }

  @override
  String taskSpentSummary(String time, int count) {
    return 'الوقت المستغرق: $time • الجلسات: $count';
  }

  @override
  String subjectSessionsDone(int count) {
    return '$count جلسة منجزة';
  }

  @override
  String get timerFullscreen => 'ملء الشاشة';

  @override
  String get timerExitFullscreen => 'إنهاء ملء الشاشة';

  @override
  String get settingsSoundSection => 'الأصوات';

  @override
  String get soundNone => 'بدون صوت';

  @override
  String get soundWhite => 'ضوضاء بيضاء';

  @override
  String get soundPink => 'ضوضاء وردية';

  @override
  String get soundBrown => 'ضوضاء بنية';

  @override
  String get soundEndTimer => 'صوت عند نهاية المؤقت';

  @override
  String get settingsBackgroundSection => 'صورة الخلفية';

  @override
  String get backgroundPick => 'اختيار من المعرض';

  @override
  String get backgroundRemove => 'حذف الصورة';

  @override
  String get backgroundTimerOnly => 'المؤقت فقط';

  @override
  String get backgroundTimerAndTasks => 'المؤقت والمهام';

  @override
  String get reportDailyGoalEdit => 'الهدف اليومي';

  @override
  String get reportStreak => 'أيام متتالية';

  @override
  String examDaysLeft(int count) {
    return 'تبقّى $count يوم';
  }

  @override
  String get examToday => 'الامتحان اليوم';

  @override
  String get examPassed => 'انتهى موعد الامتحان';

  @override
  String get examEdit => 'تعديل هدف الامتحان';

  @override
  String get examRemove => 'حذف';

  @override
  String get examPlanTitle => 'خطة دراسة سريعة';

  @override
  String get examPlanIntro => 'إذا درست هذا القدر كل يوم حتى الامتحان:';

  @override
  String examPlanPerDay(int hours) {
    return '$hours ساعات يومياً';
  }

  @override
  String examPlanTotal(int total) {
    return 'ستكون قد درست $total ساعة حتى الامتحان';
  }

  @override
  String get examPlanNoDays => 'اختر تاريخ امتحان قادم لعرض الخطة.';

  @override
  String get examPlanMotivation =>
      'ادرس وركّز واستمر — كل جلسة تقرّبك من هدفك.';

  @override
  String get goalsAdd => 'أضف هدفاً';

  @override
  String get goalNameLabel => 'اسم الهدف';

  @override
  String get goalNameHint => 'مثلاً: امتحان الفيزياء، تعلّم الإنجليزي';

  @override
  String get goalDateLabel => 'تاريخ الانتهاء (اختياري)';

  @override
  String get goalNoDate => 'بدون تاريخ انتهاء';

  @override
  String get reportExportPdf => 'تصدير ومشاركة PDF';

  @override
  String get reportExportFailed => 'تعذّر إنشاء ملف PDF';

  @override
  String get reportPdfTitle => 'تقرير التركيز';

  @override
  String reportPdfGenerated(String date) {
    return 'أُنشئ بتاريخ $date';
  }

  @override
  String reportPeak(String value) {
    return 'الأعلى: $value';
  }

  @override
  String get reportBySubject => 'الوقت حسب المهمة الثابتة';

  @override
  String get confirmDeleteTitle => 'حذف؟';

  @override
  String confirmDeleteBody(String name) {
    return 'هل تريد حذف «$name»؟ لا يمكن التراجع عن ذلك.';
  }

  @override
  String get actionEdit => 'تعديل';

  @override
  String get actionMarkDone => 'تحديد كمنجزة';

  @override
  String get actionMore => 'المزيد من الخيارات';

  @override
  String get subtasksManage => 'المهام الفرعية';

  @override
  String get subtaskRename => 'إعادة تسمية';

  @override
  String get subtaskNameHint => 'اسم المهمة الفرعية';

  @override
  String get subtaskAddHint => 'أضف مهمة فرعية (اختياري)...';

  @override
  String get subtaskGeneral => 'عام (بدون مهمة فرعية)';

  @override
  String get subtaskTotalAllTime => 'الإجمالي على مدى الوقت';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get remindersEmpty =>
      'لا توجد تذكيرات بعد. أضف تذكيراً حتى لا تفوّت دراستك.';

  @override
  String get reminderAdd => 'إضافة تذكير';

  @override
  String get reminderEdit => 'تعديل التذكير';

  @override
  String get reminderTitleLabel => 'ما الذي عليك فعله؟';

  @override
  String get reminderTitleHint => 'مثلاً: مراجعة الفصل الثالث';

  @override
  String get reminderDefaultTitle => 'حان وقت الدراسة';

  @override
  String get reminderTime => 'الوقت';

  @override
  String get reminderRepeatDaily => 'كل يوم';

  @override
  String get reminderRepeatDays => 'أيام محددة';

  @override
  String get reminderRepeatOnce => 'مرة واحدة';

  @override
  String get reminderEveryDay => 'كل يوم';

  @override
  String reminderOnceOn(String date) {
    return 'مرة واحدة بتاريخ $date';
  }

  @override
  String get reminderDate => 'التاريخ';

  @override
  String get reminderLinkedTask => 'مهمة ثابتة مرتبطة (اختياري)';

  @override
  String get reminderNoLink => 'بدون (ابدأ جلسة عامة)';

  @override
  String get reminderBody => 'اضغط لبدء البومودورو';

  @override
  String get reminderSuggestedTitle => 'اقتراحات';

  @override
  String get reminderSuggestMorning => 'جلسة دراسة صباحية';

  @override
  String get reminderSuggestEvening => 'مراجعة مسائية';

  @override
  String get reminderSuggestPlan => 'خطط لمهام الغد';

  @override
  String get reminderSmartSwitch => 'التذكير الذكي';

  @override
  String get reminderSmartSubtitle =>
      'يذكّرك فقط في الأيام التي لم تدرس فيها بعد';

  @override
  String get reminderSmartTitle => 'حافظ على استمراريتك';

  @override
  String get reminderSmartBody => 'لم تدرس اليوم بعد — ابدأ جلسة الآن.';

  @override
  String get reminderNotificationsOff =>
      'الإشعارات متوقفة، لذلك لن تصلك التذكيرات.';

  @override
  String get reminderAllow => 'السماح';

  @override
  String get reminderChannelName => 'تذكيرات الدراسة';

  @override
  String get reminderChannelDescription => 'تذكيرات لبدء الدراسة';

  @override
  String get weekday1 => 'الاثنين';

  @override
  String get weekday2 => 'الثلاثاء';

  @override
  String get weekday3 => 'الأربعاء';

  @override
  String get weekday4 => 'الخميس';

  @override
  String get weekday5 => 'الجمعة';

  @override
  String get weekday6 => 'السبت';

  @override
  String get weekday7 => 'الأحد';
}
