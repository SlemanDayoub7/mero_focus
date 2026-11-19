# استراتيجية Git / Branching

## نموذج الفروع (مبسّط — بدون develop)

```
main       # الفرع الوحيد الدائم. محمي بالكامل (protected + ruleset). كل commit = نسخة مرشحة لـ Google Play
feature/*  # مثال: feature/pomodoro-timer, feature/stats-weekly
fix/*      # إصلاحات بقات
```

تم تعمّد عدم استخدام فرع `develop` بهذه المرحلة لأن العمل فردي حاليًا، وإضافة فرع تكامل وسيط هنا عبء بدون فائدة فعلية. **عند انضمام متعاونين لاحقًا، يُعاد تقييم هذا القرار** (قد نحتاج `develop` حينها لتجميع عدة ميزات متوازية قبل كل إصدار).

## حماية فرع main (GitHub Branch Protection / Ruleset)

يجب تفعيل الإعدادات التالية على `main` من إعدادات المستودع:
- منع الدفع المباشر (direct push) — كل تغيير يمر عبر Pull Request حتى لو كان صاحب المستودع نفسه.
- اشتراط نجاح فحوصات CI (`flutter analyze` + `flutter test`) قبل السماح بالدمج.
- اشتراط أن يكون الفرع محدّثًا (up to date) مع `main` قبل الدمج، لتفادي تعارضات صامتة.

## سير العمل

1. فتح `feature/<اسم-الميزة>` من `main`.
2. الإنجاز + كتابة الاختبارات (راجع `testing-strategy.md`).
3. فتح Pull Request على `main` (حتى لنفسك — التزام توثيقي، يوضح تاريخ كل قرار بالوصف).
4. انتظار نجاح CI تلقائيًا.
5. دمج مباشر بـ `main` (Squash أو Merge حسب التفضيل)، حذف الفرع.

لا حاجة لفرع `release/x.y.z` بهذه المرحلة: الإصدار نفسه يُعلَّم مباشرة بوسم (tag) على `main` بعد الدمج (`v0.1.0`, `v0.2.0`...)، لأن `main` نظيف وقابل للنشر دائمًا بحكم الحماية المذكورة أعلاه.

## معيار كتابة الـ Commits: Conventional Commits

```
feat(pomodoro): add configurable round count
fix(stats): correct weekly aggregation off-by-one
test(habit_tracking): add usecase unit tests
docs(architecture): document mode plugin interface
refactor(app_lock): extract overlay rendering logic
chore(deps): bump drift to x.y.z
```

**الفائدة:** توليد CHANGELOG تلقائيًا لاحقًا، وتاريخ commits منظم ومقروء — مهم بشكل خاص لمشروع يُراد عرضه لشركات أو مستخدمين كمنتج احترافي موثّق.

## CI (GitHub Actions) — الحد الأدنى من اليوم الأول

- عند كل push/PR على `main`: تشغيل `flutter analyze` و`flutter test --coverage`.
- منع الدمج إذا فشل أي من الفحصين.
- عند وسم إصدار (`v1.0.0` مثلًا): بناء APK/AAB موقّع تلقائيًا كخطوة تمهيدية للنشر.
