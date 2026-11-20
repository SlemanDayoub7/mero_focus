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
  String get overlayPermissionTitle => 'المؤقت العائم';

  @override
  String get overlayPermissionBody =>
      'اسمح لميرو فوكس بالرسم فوق التطبيقات الأخرى حتى يبقى مؤقت صغير مرئيًا عند التبديل بين التطبيقات.';

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
  String get tasksSortProject => 'حسب المادة';

  @override
  String get tasksSortDueDate => 'حسب تاريخ الاستحقاق';

  @override
  String get tasksSortPriority => 'حسب الأولوية';

  @override
  String get tasksSelected => 'تم اختيار المهمة للتركيز';

  @override
  String get tasksEmpty => 'لا توجد مهام في هذا النطاق';

  @override
  String get subjects => 'المواد الدراسية';

  @override
  String get subjectsNew => 'مادة جديدة';

  @override
  String get subjectsNameHint => 'اسم المادة';

  @override
  String get subjectsEmpty => 'أضف موادك ليسهل اختيارها لاحقاً';

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
  String get taskEstimatedPomodoros => 'عدد البومودورو المقدّر';

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
}
