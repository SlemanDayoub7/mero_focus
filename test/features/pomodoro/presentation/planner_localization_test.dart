import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/l10n/app_localizations.dart';
import 'package:mero_focus/l10n/app_localizations_ar.dart';
import 'package:mero_focus/l10n/app_localizations_en.dart';

void main() {
  final en = AppLocalizationsEn();
  final ar = AppLocalizationsAr();

  test('planner sections are translated', () {
    expect(en.tasks, 'Tasks');
    expect(ar.tasks, 'المهام');
    expect(en.subjects, 'Subjects');
    expect(ar.subjects, 'المواد الدراسية');
    expect(en.reports, 'Reports');
    expect(ar.reports, 'التقارير');
  });

  test('planner scopes and task labels are translated', () {
    expect(en.tasksToday, 'Today');
    expect(ar.tasksToday, 'اليوم');
    expect(en.tasksTomorrow, 'Tomorrow');
    expect(ar.tasksTomorrow, 'غداً');
    expect(en.tasksWeek, 'This week');
    expect(ar.tasksWeek, 'هذا الأسبوع');
    expect(en.tasksAddHint, 'Add a task...');
    expect(ar.tasksAddHint, isNotEmpty);
    expect(en.taskEstimatedPomodoros, 'Estimated pomodoros');
    expect(ar.taskEstimatedPomodoros, isNotEmpty);
  });

  test('report labels and duration formats are translated', () {
    expect(en.reportTotalFocus, 'Total focus time');
    expect(ar.reportTotalFocus, isNotEmpty);
    expect(en.rangeDay, 'Daily');
    expect(ar.rangeDay, 'يومي');
    expect(en.durationMinutes(25), '25 min');
    expect(ar.durationMinutes(25), isNotEmpty);
    expect(en.durationHoursMinutes(2, 5), '2 h 5 min');
    expect(ar.durationHoursMinutes(2, 5), isNotEmpty);
  });

  test('localized delegates expose English and Arabic', () {
    expect(
      AppLocalizations.supportedLocales.map((locale) => locale.languageCode),
      containsAll(<String>['en', 'ar']),
    );
  });
}
