# المخططات (Diagrams)

هذا المستند يحتوي المخططات الأساسية الكافية لبدء التنفيذ. مخططات إضافية (تسلسل عمليات لميزة معينة، حالات واجهة معقدة...) تُضاف لاحقًا **عند بناء تلك الميزة تحديدًا**، وليس كلها دفعة واحدة الآن — إضافتها مسبقًا بدون سياق فعلي غالبًا ستحتاج تعديلًا بعد أول تطبيق حقيقي على أي حال.

## 1. مخطط الطبقات المعماري (Architecture Layers)

```mermaid
graph TD
    subgraph Presentation
        A[Widgets / Pages] --> B[Riverpod Providers]
    end
    subgraph Domain
        C[UseCases] --> D[Repository Interfaces]
    end
    subgraph Data
        E[Repository Implementations] --> F[Drift DataSources]
    end

    B --> C
    E --> D
    F --> G[(SQLite via Drift)]
```

## 2. مخطط العلاقات بين الجداول (ER Diagram)

```mermaid
erDiagram
    FOCUS_SESSIONS }o--|| TAGS : "tagged with (optional)"
    HABITS ||--o{ HABIT_LOGS : "logged daily"
    APP_LOCK_RULES {
        string packageName PK
        bool enabled
    }
    APP_SETTINGS {
        int id PK
        int workDurationSec
        string themeId
    }

    FOCUS_SESSIONS {
        int id PK
        datetime startTime
        datetime endTime
        int plannedDurationSeconds
        int actualDurationSeconds
        int sessionType
        bool completed
        int completionPercentage
        int tagId FK
    }
    TAGS {
        int id PK
        string name
        string colorHex
    }
    HABITS {
        int id PK
        string name
        int frequencyType
        string frequencyConfig
    }
    HABIT_LOGS {
        int id PK
        int habitId FK
        datetime date
        bool completed
        real value
    }
```

## 3. مخطط تسلسل: دورة حياة جلسة بومودورو واحدة

```mermaid
sequenceDiagram
    participant U as المستخدم
    participant UI as PomodoroTimerPage
    participant UC as StartFocusSessionUseCase
    participant Repo as FocusSessionRepository
    participant DB as Drift DB
    participant Lock as AppLockService

    U->>UI: ضغط "ابدأ"
    UI->>UC: execute(duration)
    UC->>Repo: createSession(sessionDraft)
    Repo->>DB: insert FocusSession
    UC->>Lock: activateLockRules()
    Note over UI: المؤقت يعمل، النافذة العائمة تظهر عند الخلفية (ADR-0009)
    U->>UI: انتهاء المدة أو إيقاف يدوي
    UI->>UC: completeSession(id, actualDuration)
    UC->>Repo: updateSession(...)
    Repo->>DB: update FocusSession
    UC->>Lock: deactivateLockRules()
```

## متى نضيف مخططات جديدة؟

- **مخطط تسلسل جديد**: عند بناء أي ميزة فيها تنسيق بين أكثر من usecase/service (مثل تدفق استثناء تحسين البطارية، أو تدفق تصدير PDF الكامل من الإحصائيات).
- **مخطط حالة (State Diagram)**: إذا تبيّن أن حالة واجهة معينة (مثل حالات المؤقت: idle/running/paused/completed) معقدة بما يكفي ليصعب تتبعها من الكود مباشرة.
- **القاعدة العامة**: مخطط يُضاف فقط إذا كان سيوفر وقتًا فعليًا وقت التنفيذ أو المراجعة، لا كـ "واجب توثيقي" منفصل عن الحاجة الفعلية.
