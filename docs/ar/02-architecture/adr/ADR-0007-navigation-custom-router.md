# ADR-0007: Router يدوي خفيف بدل go_router

**الحالة:** مقبول

## السياق
عدد شاشات الـ MVP محدود نسبيًا (مؤقت، إحصائيات، عادات، إعدادات، شاشة حجب تطبيق). لا حاجة حاليًا لـ deep links خارجية أو تنقل متداخل معقد.

## القرار
عدم استخدام `go_router`. بناء `AppRouter` يدوي خفيف فوق `Navigator` 1.0 القياسي.

## الأسباب
- `go_router` معروف بمشاكل مع nested navigators وredirect logic المعقد، وهذا عبء غير مبرر لعدد شاشات بسيط.
- Router يدوي بسيط = تحكم كامل، صفر "سحر" خفي (implicit behavior)، سهولة اختبار (`NavigatorObserver` بسيط بدل mocking مكتبة كاملة).
- يتوافق مع مبدأ "صفر hard-coding": كل انتقال بين شاشات يمر عبر دالة واضحة الاسم بدل أسماء routes نصية حرة متناثرة بالكود.

## التصميم المقترح

```dart
// core/routing/app_router.dart
class AppRouter {
  AppRouter._();

  static void toStatistics(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StatisticsPage()),
    );
  }

  static void toSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  // ... بقية الشاشات
}
```

كل استدعاء تنقل بالتطبيق يمر حصرًا عبر `AppRouter.toXxx(context)`، لا `Navigator.push` مباشر متناثر داخل الـ widgets.

## إعادة التقييم
إذا احتجنا مستقبلًا تنقلًا معقدًا فعليًا (تبويبات متداخلة، deep links من إشعارات خارجية)، يُعاد فتح هذا القرار وتُقيَّم `auto_route` تحديدًا (نهج code-generation، نفس عائلة Riverpod وDrift المستخدمة أصلًا بالمشروع) كبديل مدروس — وليس `go_router`.
