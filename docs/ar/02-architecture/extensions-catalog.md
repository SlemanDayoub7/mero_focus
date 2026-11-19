# كتالوج الـ Extensions

قاعدة ثابتة: **أي قيمة متكررة الاستخدام (ترجمة، ثيم، أبعاد شاشة...) يُصمَّم لها extension واحد موحّد، ولا يُستدعى الكود الأصلي (`Theme.of`, `MediaQuery.of`, `AppLocalizations.of`...) مباشرة من أي widget.** كل extension يُسجَّل بهذا الملف فور إنشائه.

| Extension | الموقع | الاستخدام | يرجع |
|---|---|---|---|
| `L10nContext.l10n` | `core/l10n/l10n_context.dart` | النصوص المترجمة | `AppLocalizations` |
| `AppThemeContext.appTheme` | `core/theme/app_theme_extension.dart` | ألوان/مسافات/خلفية مخصصة | `AppThemeExtension` |
| `ResponsiveContext.deviceType` / `.isTablet` / `.isLandscape` / `.screenWidth` | `core/responsive/breakpoints.dart` | قرارات التخطيط حسب حجم/اتجاه الشاشة | `DeviceType` / `bool` / `double` |

## قاعدة الإضافة

أي extension جديد لازم:
1. يُضاف فقط إذا استُخدمت قيمته من أكثر من widget واحد (وإلا يبقى ضمن الـ widget نفسه كـ local variable).
2. يُسجَّل بهذا الجدول فورًا ضمن نفس الـ PR الذي أنشأه.
3. يُوضع ضمن `core/` دائمًا (لا يوجد extension خاص بميزة واحدة فقط إلا إذا كان استخدامه محصورًا فعليًا بداخلها، وحينها يوضع ضمن `features/<feature>/presentation/extensions/`).
