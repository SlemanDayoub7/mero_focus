# أساس الواجهة: الهوية البصرية، الاستجابة (Responsive)، التعريب

هذا الأساس يُبنى **قبل** أي feature فعلية، لأن كل شاشة لاحقة ستعتمد عليه مباشرة.

## 1. نظام الثيم (Theming) — تبديل سهل على مستوى التطبيق كامل

نستخدم `ThemeExtension<T>` فوق `ThemeData` القياسي لتعريف قيم تصميم خاصة بنا (ليست موجودة أصلًا بـ Material):

```dart
// core/theme/app_theme_extension.dart
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color focusPrimary;
  final Color focusBackground;
  final double spacingUnit; // وحدة المسافات الأساسية (مثلًا 8.0)
  final String backgroundAssetId; // الخلفية المختارة من المستخدم

  const AppThemeExtension({
    required this.focusPrimary,
    required this.focusBackground,
    required this.spacingUnit,
    required this.backgroundAssetId,
  });

  @override
  AppThemeExtension copyWith({...}) => ...;

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) => ...;
}

// وصول موحّد عبر extension على BuildContext — لا استدعاء Theme.of(context).extension<...> مباشرة بأي مكان
extension AppThemeContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
```

**آلية التبديل:** `themeSettingsProvider` (Riverpod) يحمل اختيار المستخدم الحالي (لون أساسي، خلفية، فاتح/داكن)، مقروء من جدول `AppSettings` (راجع `data-model.md`) ومحفوظ فيه عند أي تغيير. أي widget بالتطبيق يستهلك `context.appTheme` تلقائيًا يتحدث فور تغيير الإعداد، بدون أي ربط يدوي إضافي.

**صفر hard-coding للألوان:** أي لون بالتطبيق يُقرأ من `context.appTheme.xxx`، لا `Color(0xFF...)` مباشرة داخل أي widget.

## 2. الاستجابة (Responsive) — موبايل/تابلت، Portrait/Landscape

بدون الاعتماد على مكتبة خارجية ثقيلة (لتفادي مشاكل الأداء/القياس غير الدقيق لبعض مكتبات الـ scaling)، نبني أداة بسيطة:

```dart
// core/responsive/breakpoints.dart
enum DeviceType { mobile, tablet }

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  Orientation get orientation => MediaQuery.orientationOf(this);
  DeviceType get deviceType =>
      screenWidth >= 600 ? DeviceType.tablet : DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isLandscape => orientation == Orientation.landscape;
}
```

**قاعدة تصميم ثابتة:** أي شاشة تُبنى بـ `LayoutBuilder` + `Flex`/`Wrap`/`Expanded` بدل أبعاد ثابتة بالبكسل. حيث يلزم تخطيط مختلف جوهريًا بين الموبايل والتابلت (مثلًا: قائمة واحدة مقابل عمودين)، يُحسم القرار عبر `context.isTablet` و`context.isLandscape` مجتمعين، ضمن نفس الـ widget الأب، دون تكرار منطق كامل الشاشة.

## 3. التعريب (Localization) — بدون نصوص مكتوبة مباشرة إطلاقًا

نعتمد الحل الرسمي من Flutter (`flutter_localizations` + ملفات ARB) بدل مكتبات الطرف الثالث القائمة على نصوص حرة (مثل `easy_localization`)، لأن **التوليد من ARB يعطي فحصًا وقت الترجمة (compile-time)**: أي مفتاح غير موجود يُكتشف فورًا، بعكس البحث بمفتاح نصي حر القابل للخطأ الإملائي الصامت.

```
lib/l10n/
├── app_en.arb
└── app_ar.arb
```

الوصول من أي مكان عبر extension موحّد على `BuildContext` (بالضبط كما طلبت):

```dart
// core/l10n/l10n_context.dart
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// الاستخدام بأي widget:
Text(context.l10n.startFocusSession)
```

**إضافة لغة جديدة مستقبلًا = إضافة ملف `app_xx.arb` جديد فقط**، بدون أي تعديل كود — هذا يحقق شرط "يحتمل أي لغة تُضاف لاحقًا".

## 4. لا شيء Hard-coded — ملخص تطبيقي

| النوع | أين يُعرَّف | كيف يُستهلك |
|---|---|---|
| نصوص | `lib/l10n/app_*.arb` | `context.l10n.key` |
| ألوان | `AppThemeExtension` | `context.appTheme.colorName` |
| مسافات/أبعاد | `AppThemeExtension.spacingUnit` أو `core/constants/spacing.dart` | `context.appTheme.spacingUnit * n` |
| قيم افتراضية منطقية (مدة بومودورو مثلًا) | `core/constants/defaults.dart` | import مباشر، لا تكرار الرقم بأي مكان آخر |

## 5. الأداء

- `const` constructors لكل widget لا يعتمد على حالة متغيرة — تطبيق صارم بما أن كل widget مستخرج كـ class (راجع `coding-conventions.md`، بند 1)، هذا يصبح طبيعيًا وليس جهدًا إضافيًا.
- تجنّب `Opacity`/`ClipRRect` غير الضرورية في قوائم طويلة (شاشة الإحصائيات ستعرض قوائم/رسوم بيانية كثيفة البيانات) — استخدام `RepaintBoundary` حول عناصر الرسوم البيانية المعقدة.
- `ListView.builder`/`SliverList` دائمًا للقوائم الطويلة (سجل الجلسات، سجل العادات)، لا `ListView(children: [...])` مع بيانات غير محدودة.
