# Build Flavors — Dev / Release

## الهدف
فصل بيئة التطوير (dev) عن بيئة النشر (release) بحيث يمكن تثبيت نسخة dev بجانب نسخة release الحقيقية على نفس الجهاز للاختبار، دون تعارض، ودون تسريب أي إعدادات تطوير (مثل تفعيل logging مفصّل) للنسخة المنشورة.

## الـ Flavors

| Flavor | Application ID | الاستخدام |
|---|---|---|
| `dev` | `com.sleman.miro_focus.dev` | أثناء التطوير اليومي، logging مفصّل مفعّل، أي مزوّد تحليلات (ADR-0008) بوضع تجريبي/معطّل |
| `prod` | `com.sleman.miro_focus` | النسخة المنشورة فعليًا على Google Play |

*(المعرّف الفعلي المعتمد للمشروع: `com.sleman.miro_focus`، مع لاحقة `.dev` لبيئة التطوير. flavor النشر اسمه `prod` لأن AGP يمنع تسمية product flavor بنفس اسم build type القياسي `release`.)*

## الإعداد التقني (Android)

يُعرَّف الـ flavors ضمن `android/app/build.gradle.kts`:

```kotlin
android {
    namespace = "com.sleman.miro_focus"
    defaultConfig {
        applicationId = "com.sleman.miro_focus"
    }
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Mero Focus (Dev)")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "Mero Focus")
        }
    }
}
```

الـ manifest يستخدم `android:label="@string/app_name"` حتى يأتي العنوان من الـ flavor.
و`MainActivity` في الحزمة `com.sleman.miro_focus` بما يطابق `namespace`.

## التشغيل والبناء

```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter build appbundle --flavor prod -t lib/main_release.dart
```

`lib/main_dev.dart` و`lib/main_release.dart` ملفان صغيران يختاران `AppEnvironment` فقط ويمرّران `MeroFocusApp` المشترك إلى `bootstrap()` في `lib/bootstrap.dart` — **لا تكرار منطق، فقط نقطة دخول مختلفة.** الـ `bootstrap()` يتولى التهيئة وربط معالجات الأخطاء و overrides الخاصة بـ Riverpod.
و`lib/main.dart` تُبقى كنقطة دخول تطويرية للتوافق مع الأدوات التي لا تمرّر `-t`؛ دائمًا مرّر `-t lib/main_release.dart` للبناء المنشور.

## ملاحظة أمان
أي مفتاح/سر خاص بمزوّد خارجي (لو أُضيف Firebase لاحقًا) يُمرَّر عبر `--dart-define` أو ملفات إعداد غير مرفوعة على Git (`google-services.json` لكل flavor في مساره الخاص)، وليس داخل الكود مباشرة.
