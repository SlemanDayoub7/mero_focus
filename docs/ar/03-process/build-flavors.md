# Build Flavors — Dev / Release

## الهدف
فصل بيئة التطوير (dev) عن بيئة النشر (release) بحيث يمكن تثبيت نسخة dev بجانب نسخة release الحقيقية على نفس الجهاز للاختبار، دون تعارض، ودون تسريب أي إعدادات تطوير (مثل تفعيل logging مفصّل) للنسخة المنشورة.

## الـ Flavors

| Flavor | Application ID | الاستخدام |
|---|---|---|
| `dev` | `com.sleman.miro_focus.dev` | أثناء التطوير اليومي، logging مفصّل مفعّل، أي مزوّد تحليلات (ADR-0008) بوضع تجريبي/معطّل |
| `release` | `com.sleman.miro_focus` | النسخة المنشورة فعليًا على Google Play |

*(المعرّف الفعلي المعتمد للمشروع: `com.sleman.miro_focus`، مع لاحقة `.dev` لبيئة التطوير)*

## الإعداد التقني (Android)

يُعرَّف الـ flavors ضمن `android/app/build.gradle`:

```gradle
android {
    flavorDimensions "environment"
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            resValue "string", "app_name", "App (Dev)"
        }
        release {
            dimension "environment"
            resValue "string", "app_name", "App"
        }
    }
}
```

## التشغيل والبناء

```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter build appbundle --flavor release -t lib/main_release.dart
```

`lib/main_dev.dart` و`lib/main_release.dart` ملفان صغيران فقط يحددان أي إعدادات بيئة (مثل تفعيل/تعطيل `CrashReporter` الحقيقي من ADR-0008) قبل استدعاء `runApp` من `lib/app.dart` المشترك بين الاثنين — **لا تكرار منطق، فقط نقطة دخول مختلفة.**

## ملاحظة أمان
أي مفتاح/سر خاص بمزوّد خارجي (لو أُضيف Firebase لاحقًا) يُمرَّر عبر `--dart-define` أو ملفات إعداد غير مرفوعة على Git (`google-services.json` لكل flavor في مساره الخاص)، وليس داخل الكود مباشرة.
