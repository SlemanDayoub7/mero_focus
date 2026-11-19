# ADR-0008: تتبع الأعطال والتحليلات (بدون كسر مبدأ أوفلاين-أولًا)

**الحالة:** مقترح — يحتاج قرار نهائي عن المزوّد قبل التنفيذ

## السياق
التطبيق مصمم ليعمل أوفلاين بالكامل (مبدأ أساسي، راجع `problem-statement.md`). بالمقابل، نحتاج معرفة أماكن حدوث الأعطال (crashes) وفهم أنماط استخدام أساسية (أي الشاشات تُستخدم فعليًا) دون انتظار مزامنة سحابية كاملة.

## القرار
1. **الوظائف الأساسية للتطبيق لا تعتمد على الإنترنت إطلاقًا وبأي شكل.**
2. تُبنى طبقة تجريد (`core/observability/`) بواجهة موحّدة (`CrashReporter`, `AnalyticsTracker`) منذ الآن، **بدون ربطها بمزوّد فعلي بعد** — لضمان قابلية الإضافة لاحقًا دون تغيير أي كود استهلاكي.
3. عند التفعيل الفعلي (قرار لاحق)، يُستخدم مزوّد يجمع البيانات محليًا ويرفعها فقط عند توفر إنترنت (Firebase Crashlytics/Analytics، أو بديل أكثر خصوصية مثل Sentry self-hosted) — سلوك هذه الأدوات نفسها "offline-first" بطبيعتها (تخزين مؤقت محلي ثم رفع انتهازي).

## التصميم (الواجهة المجرَّدة فقط، بدون تنفيذ بعد)

```dart
// core/observability/crash_reporter.dart
abstract class CrashReporter {
  void recordError(Object error, StackTrace stackTrace, {String? context});
}

// core/observability/analytics_tracker.dart
abstract class AnalyticsTracker {
  void logEvent(String name, {Map<String, Object?>? parameters});
}

// تطبيق مبدئي لا يفعل شيئًا (null object pattern) — يُستخدم حتى يُحسم قرار المزوّد
class NoOpCrashReporter implements CrashReporter {
  @override
  void recordError(Object error, StackTrace stackTrace, {String? context}) {}
}
```

تُربط `FlutterError.onError` و`PlatformDispatcher.instance.onError` بـ `CrashReporter` منذ الآن (حتى وهي `NoOp`)، حتى لا نحتاج تعديل `main.dart` لاحقًا عند تفعيل مزوّد حقيقي.

## الأسباب
- يفصل القرار التقني (الواجهة) عن القرار الأعمالي/الخصوصي (أي مزوّد، ومتى) — لا نُقحم اعتمادية خارجية بالكود قبل حسم هذا القرار.
- يُبقي الباب مفتوحًا لمزوّد يحترم الخصوصية أكثر (Sentry self-hosted) إذا تبيّن أن هذا مهم لجمهور المستخدمين المستهدف.

## النتائج المترتبة
- عند تفعيل أي مزوّد مستقبلًا: **يجب تحديث سياسة الخصوصية والإفصاح ضمن Google Play Data Safety form** عن نوع البيانات المجمَّعة (حتى لو كانت تقنية بحتة بدون معلومات شخصية).
- هذا القرار لا يُنفَّذ فعليًا (لا إضافة Firebase/Sentry كاعتمادية) قبل مرحلة التحضير للنشر، إلا إذا طرأت حاجة أبكر.
