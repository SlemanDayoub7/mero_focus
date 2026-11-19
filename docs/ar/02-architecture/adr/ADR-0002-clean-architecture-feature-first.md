# ADR-0002: Clean Architecture + Feature-First

**الحالة:** مقبول

## السياق
المشروع يحتاج قابلية اختبار عالية (unit/widget/integration)، وقابلية توسعة مستقبلية (إضافة مودات/جيمفكيشن، حسابات ومزامنة) دون إعادة هيكلة جذرية، وقابلية انضمام متعاونين لاحقًا بدون احتكاك.

## القرار
اعتماد Clean Architecture (طبقات Domain / Data / Presentation) داخل تنظيم Feature-First (كل ميزة لها مجلدها الخاص بالكامل بثلاث الطبقات).

## الهيكل العام
```
lib/
├── core/              # DI, database, routing, theme, error handling, utils
└── features/
    ├── pomodoro_timer/
    ├── habit_tracking/
    ├── statistics/
    ├── pdf_export/
    ├── app_lock/
    ├── background_overlay/
    ├── settings/
    └── mode_system/   # هيكل جاهز، غير مُفعّل بالـ MVP — راجع ADR-0005
```
كل ميزة: `domain/` (entities, repositories abstract, usecases) + `data/` (models, datasources, repo impl) + `presentation/` (pages, widgets, state).

## الأسباب
- عزل منطق الأعمال (Domain) عن تفاصيل التنفيذ (DB، UI) يسهّل اختبار الحسابات الحساسة (تجميع الإحصائيات) بمعزل تام عن واجهة المستخدم.
- كل ميزة قابلة للتطوير والاختبار بشكل مستقل — مهم لعمل فردي بالتوازي مع فروع Git متعددة، ومهم أكثر عند انضمام متعاونين.

## النتائج المترتبة
- تكلفة boilerplate أعلى من بنية بسيطة (MVC)، مقبولة مقابل قابلية الصيانة والاختبار طويلة المدى.
- أي ميزة جديدة (مثل `mode_system` لاحقًا) تُضاف كمجلد مستقل جديد يتبع نفس القالب، دون المساس بالميزات الموجودة.
