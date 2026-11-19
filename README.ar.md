# Mero Focus — تطبيق بومودورو + تتبع عادات (أندرويد)

> **الحالة:** التنفيذ جاري — أساس الآركتكتشر مكتمل، والميزات تُبنى feature-by-feature.
> **المنصة المستهدفة:** أندرويد فقط (MVP)
> **اللغة/الإطار:** Flutter + Dart
> **الآركتكتشر:** Clean Architecture + Feature-First

## نظرة عامة

تطبيق بومودورو وتتبع عادات يعمل **أوفلاين بالكامل**، بميزات إحصائية تفصيلية (بمستوى ساعة/يوم/أسبوع/شهر/سنة/فترة مخصصة) **مجانية بالكامل** — بعكس أغلب المنافسين الرائدين بالسوق (مثل Focus To-Do) اللي بيحجبوا هاد النوع من التحليل خلف اشتراك مدفوع.

للتفاصيل الكاملة لصياغة المشكلة والبحث الذي بُني عليه هذا القرار، راجع:
[`docs/ar/01-problem-and-research/problem-statement.md`](docs/ar/01-problem-and-research/problem-statement.md)

## نطاق النسخة الأولى (MVP)

راجع [`docs/ar/04-roadmap/mvp-scope.md`](docs/ar/04-roadmap/mvp-scope.md) للقائمة الكاملة والمفصّلة.

ملخص سريع:
- مؤقت بومودورو قابل للتخصيص (مدة العمل/الراحة/عدد الجولات)
- تتبع عادات أساسي
- ثيمات بصرية بسيطة + خلفيات وأصوات قابلة للتخصيص (ضوضاء بيضاء + صوت نهاية المؤقت)
- إحصائيات تفصيلية كاملة — مجانية 100%
- تصدير PDF للإحصائيات
- قفل تطبيقات محددة أثناء الجلسة
- نافذة عائمة (Floating Overlay) فور الانتقال للخلفية
- عمل أوفلاين بالكامل
- نسخ احتياطي/استعادة محلي (Backup/Restore)

**مؤجّل عن قصد لنسخ لاحقة:** نظام "مودات"/جيمفكيشن (شخصيات تتطور)، حسابات ومزامنة سحابية، وضع تركيز مطلق (منع خروج فعلي من الجلسة).

## الآركتكتشر

راجع مجلد [`docs/ar/02-architecture/`](docs/ar/02-architecture/) — فيه:
- قرارات التصميم الموثقة (ADRs)
- [نموذج البيانات الكامل](docs/ar/02-architecture/data-model.md)
- [معايير كتابة الكود (Coding Conventions)](docs/ar/02-architecture/coding-conventions.md)
- [أساس الواجهة: الثيم، الاستجابة، التعريب](docs/ar/02-architecture/ui-foundation-and-conventions.md)
- [كتالوج الـ Extensions](docs/ar/02-architecture/extensions-catalog.md)
- [المخططات (Diagrams)](docs/ar/02-architecture/diagrams.md)

## سير العمل والاختبار

راجع مجلد [`docs/ar/03-process/`](docs/ar/03-process/) لاستراتيجية الـ Git/Branching والاختبار وFlavors (dev/release).

## من أين نبلش فعليًا؟

راجع [`docs/ar/04-roadmap/build-order.md`](docs/ar/04-roadmap/build-order.md) لترتيب البناء الكامل، و[`docs/ar/04-roadmap/execution-plan.md`](docs/ar/04-roadmap/execution-plan.md) لخطة عمل واقعية بالاعتماد على أدوات AI، و[`docs/ar/04-roadmap/pre-launch-checklist.md`](docs/ar/04-roadmap/pre-launch-checklist.md) لكل ما يجب تجهيزه قبل النشر (Foreground Service، البطارية، الخصوصية، التوقيع، الأيقونة — راجع `branding-assets.md`).

## لماذا هذا المشروع؟ (الفرصة بالسوق)

راجع [`docs/ar/01-problem-and-research/competitor-research.md`](docs/ar/01-problem-and-research/competitor-research.md).

## انحرافات التنفيذ (فرضها الـ SDK)

المشروع يستهدف Flutter 3.41 / Dart 3.11، اللي الـ SDK فيه يثبّت `meta 1.17.0`. هذا التثبيت يضيّق نطاق الـ analyzer إلى `<= 10.0.1`، مما يجعل مجموعة الـ generators/الـ lints الموثقة غير قابلة للتحقيق مع بعضها بنفس الوقت:

- **providers الخاصة بـ Riverpod مكتوبة يدويًا** بدل `riverpod_generator` + `riverpod_annotation`. قرار ADR-0003 (Riverpod، DI عبر providers، سهولة الـ override بالاختبارات) مطبَّق بالكامل؛ أُسقطت فقط أداة تقليل الـ boilerplate.
- **لم نثبّت `riverpod_lint` / `custom_lint`** لأنهما يحتاجان analyzer و`meta` أحدث مما يسمح به الـ SDK. بدل ذلك فعّلنا `flutter_lints` مع قواعد إضافية صارمة في `analysis_options.yaml`.
- **إصدارات الـ codegen مثبّتة** (`build_runner 2.15.1`، `drift_dev 2.34.0`، `drift 2.34.0`) لأن الإصدارات الأحدث تتطلب analyzer 13+ الذي يحتاج `meta ^1.18` ويتعارض مع تثبيت الـ SDK.

هذه الانحرافات مفروضة من الـ SDK وستُعاد مراجعتها عند الانتقال إلى Dart 3.12+.
