# ترتيب البناء — من أين نبلش فعليًا

القاعدة: **لا نكتب أي feature قبل ما يكون الأساس (Core) جاهز**، لأن كل feature لاحقة بتعتمد عليه (ثيم، تعريب، DB، DI، responsive).

## المرحلة 0 — تأسيس المشروع (تاسكات اليوم)

- [ ] `flutter create` + تنظيف القالب الافتراضي (حذف `counter` demo).
- [ ] إنشاء بنية المجلدات الفارغة حسب `ADR-0002` (`core/`, `features/<كل feature كمجلد فاضي مؤقتًا>`).
- [ ] إضافة الـ dependencies الأساسية بـ `pubspec.yaml`:
  - `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, `build_runner`
  - `drift`, `drift_dev`, `sqlite3_flutter_libs`, `path_provider`, `path`
  - `flutter_localizations` (SDK), `intl`
  - `pdf`, `printing` (لتصدير PDF)
  - `permission_handler`
  - Dev: `flutter_lints`, `mocktail`, `flutter_test` (SDK), `riverpod_lint`, `custom_lint`
- [ ] ضبط `analysis_options.yaml` بقواعد صارمة (`flutter_lints` + `riverpod_lint` مفعّلة بالكامل).
- [ ] تهيئة مستودع Git + أول commit + إنشاء الفرع `main` + رفعه على GitHub.
- [ ] تفعيل حماية فرع `main` (راجع `git-workflow.md` المحدَّث).
- [ ] إنشاء workflow بـ GitHub Actions: `flutter analyze` + `flutter test` على كل push/PR.
- [ ] نسخ مجلد `docs/` (هذا التوثيق) لجذر المشروع.

## المرحلة 1 — الأساس التقني (Core) قبل أي شاشة فعلية

- [ ] إعداد Drift: تعريف الجداول الست (`data-model.md`) + أول migration.
- [ ] إعداد نظام الثيم: `AppThemeExtension` + `themeSettingsProvider` + ربطه بجدول `AppSettings`.
- [ ] إعداد التعريب: ملفي `app_en.arb` و`app_ar.arb` أساسيين (حتى لو فارغين من كل النصوص بعد) + توليد `AppLocalizations` + `L10nContext` extension.
- [ ] إعداد أداة الاستجابة: `ResponsiveContext` extension.
- [ ] إعداد `core/routing/`: تطبيق `AppRouter` يدوي خفيف فوق `Navigator` 1.0 حسب ADR-0007 (بدون `go_router`).
- [ ] كتابة أول اختبار Unit حقيقي (حتى لو بسيط) للتأكد إن بيئة الاختبار شغالة فعليًا قبل الاستمرار.

## المرحلة 2 — أول Feature فعلية: الإعدادات (Settings)

نبدأ بـ `settings` تحديدًا (وليس `pomodoro_timer`) لأنها:
- أبسط feature من ناحية منطق الأعمال.
- تُستخدم لإثبات قالب الـ Clean Architecture الكامل (domain/data/presentation + DI + اختبارات) على مثال صغير قبل تطبيقه على ميزات أعقد.
- باقي الميزات (ثيم، صوت، قفل تطبيقات) ستقرأ منها فعليًا، فمن الأفضل أن تكون جاهزة أولًا.

## المرحلة 3 وما بعدها — الميزات الوظيفية بالترتيب

1. `pomodoro_timer` (المؤقت نفسه + منطق الجولات)
2. `habit_tracking`
3. `statistics` (تعتمد على بيانات المرحلتين السابقتين)
4. `app_lock` (حجب جزئي — ADR-0006)
5. `background_overlay`
6. `pdf_export` (يعتمد على `statistics` جاهزة)

## معيار الانتقال بين المراحل

لا ننتقل لمرحلة تالية قبل أن تكون المرحلة الحالية: (1) مبنية، (2) عليها اختبارات Unit أساسية، (3) ناجحة على CI. هذا نفس "تعريف خلص" الموثق بـ `testing-strategy.md`، مطبّق هنا على مستوى المراحل الكبرى أيضًا.
