# معايير كتابة الكود (Coding Conventions)

هذا المستند إلزامي لكل كود يُكتب بالمشروع، ويجب مراجعته ضمن أي Pull Request.

## 1. قواعد الـ Widgets

- **ممنوع استدعاء widget كـ method خاص** (مثل `Widget _buildHeader() => ...`). كل جزء واجهة مستقل منطقيًا يُستخرج دائمًا كـ `class` حقيقي يرث من `StatelessWidget` أو `StatefulWidget`.
  - **السبب:** الـ method لا يستفيد من `const` constructors، ولا من آلية إعادة البناء الانتقائية لـ Flutter (الـ widget كـ method يُعاد بناؤه بالكامل مع أي إعادة بناء للأب، أما الـ widget كـ class منفصل فيمكن أن يكون `const` ولا يُعاد بناؤه إطلاقًا إذا لم تتغير مدخلاته).
- **ملف واحد لكل widget رئيسي.** الويدجتس الصغيرة المساعدة التي لا معنى لاستخدامها خارج سياق واحد محدد يمكن أن تبقى بنفس الملف، لكن أي widget له أكثر من استخدام محتمل أو يتجاوز ~50 سطرًا ينتقل لملفه الخاص.
- تسمية الملفات: `snake_case` مطابق لاسم الـ class بصيغة `PascalCase` (مثال: `pomodoro_timer_display.dart` → `class PomodoroTimerDisplay`).

## 2. التجريد (Abstraction) — بحالات محددة لا بكل مكان

- **طبقة Domain/Data:** التجريد إلزامي دائمًا (repository interfaces في `domain/`، تطبيق فعلي في `data/`) — ضروري لقابلية الاختبار (mocking) بغض النظر عن وجود تطبيق بديل فعلي أم لا.
- **طبقة Presentation:** لا تجريد إضافي إلا إذا وُجد سبب حقيقي (مثلًا واجهة مشتركة بين أكثر من widget يجب أن تلتزم بنفس العقد). تجنّب إنشاء `abstract class` أو `interface` لمجرد "قد نحتاجها مستقبلًا" — هذا تعقيد غير مبرر (YAGNI).

## 3. مبادئ SOLID — التطبيق العملي بهذا المشروع

| المبدأ | التطبيق |
|---|---|
| **S**ingle Responsibility | كل usecase يقوم بعملية واحدة فقط (`GetDailyStatsUseCase`, `CompleteHabitUseCase`...). لا usecase "شامل" يقوم بعدة أشياء |
| **O**pen/Closed | `mode_system` (ADR-0005) مصمم بحيث تُضاف مودات جديدة كملفات جديدة دون تعديل الكود الموجود |
| **L**iskov Substitution | أي تطبيق لـ repository interface يجب أن يكون قابلًا للاستبدال الكامل بأي تطبيق آخر لنفس الـ interface دون كسر السلوك المتوقع |
| **I**nterface Segregation | واجهات repository صغيرة ومحددة بالغرض (لا `interface` ضخم يجمع كل عمليات قاعدة البيانات) |
| **D**ependency Inversion | طبقة Domain لا تعرف شيئًا عن Drift أو أي تفصيل تنفيذ — تعتمد فقط على الـ abstract repository المعرَّف بداخلها |

## 4. Dependency Injection — على مستوى كل Feature

- لا يوجد ملف DI مركزي ضخم واحد للتطبيق بالكامل.
- كل feature لها ملف `<feature>_providers.dart` ضمن `presentation/` (أو `application/` إذا لزم) يعرّف الـ Riverpod providers الخاصة بها فقط.
- الاعتماديات المشتركة فعليًا بين الميزات (مثل instance قاعدة البيانات Drift، أو SharedPreferences) تُعرَّف مرة واحدة في `core/di/` وتُستهلك عبر `ref.watch` من أي مكان، دون تكرار تعريفها.

## 5. التسمية (Naming)

- Classes: `PascalCase`. Variables/functions: `camelCase`. Files: `snake_case`. Constants: `camelCase` مع بادئة واضحة عند الحاجة (`kDefaultWorkDuration`).
- أسماء usecases: فعل + كائن (`StartFocusSession`, `GetWeeklyStatistics`). لا أسماء عامة غامضة (`Manager`, `Helper`, `Handler`) بدون توضيح دقيق للمسؤولية.

## 6. صفر Hard-coding

ممنوع أي قيمة ثابتة (نص، لون، بعد/مسافة، مدة) مكتوبة مباشرة داخل widget. كل قيمة تأتي من:
- نصوص: ملفات الترجمة (راجع `ui-foundation-and-conventions.md`).
- ألوان/مسافات/خطوط: `ThemeExtension` مخصصة (راجع نفس المستند).
- قيم إعدادات افتراضية (مدة بومودورو مثلًا): `core/constants/` فقط، وتُستهلك من هناك في كل مكان.

## 7. الاختبار إلزامي عند الإنجاز

راجع `testing-strategy.md` — لا PR يُدمج بدون اختبارات Unit على الأقل لأي usecase جديد.
