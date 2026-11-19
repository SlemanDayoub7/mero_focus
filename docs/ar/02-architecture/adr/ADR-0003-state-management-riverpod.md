# ADR-0003: Riverpod كنظام إدارة الحالة

**الحالة:** مقبول

## السياق
المشروع يحتاج نظام إدارة حالة reactive، قابل للاختبار بسهولة (mocking/override للـ dependencies)، ويدعم توسعًا مستقبليًا (ميزات تُفعَّل/تُعطَّل ديناميكيًا مثل `mode_system` و`app_lock`) بدون boilerplate ثقيل.

## القرار
اعتماد **Riverpod** (مع `riverpod_generator` لتوليد الكود) كنظام إدارة الحالة الموحّد في كامل المشروع.

## البدائل المرفوضة
- **Bloc/Cubit**: أكثر شيوعًا بشروحات Clean Architecture التقليدية وبنية صارمة جدًا، لكنه يتطلب boilerplate أكبر (events/states منفصلة) لكل ميزة صغيرة، وهو عبء غير ضروري لمشروع فردي بالبداية.

## الأسباب
- حقن الاعتمادات (Dependency Injection) مدمج طبيعيًا في Riverpod، بدون الحاجة لمكتبة DI منفصلة مثل `get_it`.
- سهولة عمل `override` لأي provider أثناء الاختبار، مما يبسّط unit/widget tests لكل ميزة.
- Reactivity مناسبة جدًا لحالات متعددة تتغير بشكل مستقل (مؤقت، قفل تطبيقات، إعدادات) دون الحاجة لدمجها بـ state واحد ضخم.

## النتائج المترتبة
- كل الـ providers تُعرَّف ضمن طبقة `presentation/` (أو `application/` إذا احتجنا طبقة تنسيق إضافية بين domain وpresentation لاحقًا).
- `riverpod_generator` يتطلب `build_runner` كجزء من سير العمل التطويري (يُوثَّق في `README.md` الخاص بالإعداد التقني).
