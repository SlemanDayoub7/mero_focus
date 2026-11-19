# Diagrams

This document contains the baseline diagrams sufficient to start implementation. Additional diagrams (a process flow for a specific feature, complex UI states...) are added later **when that feature is actually being built**, not all upfront — adding them prematurely without real context would likely need revision after the first real implementation anyway.

## 1. Architecture Layers Diagram

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

## 2. Entity-Relationship Diagram

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

## 3. Sequence Diagram: Lifecycle of a Single Pomodoro Session

```mermaid
sequenceDiagram
    participant U as User
    participant UI as PomodoroTimerPage
    participant UC as StartFocusSessionUseCase
    participant Repo as FocusSessionRepository
    participant DB as Drift DB
    participant Lock as AppLockService

    U->>UI: tap "Start"
    UI->>UC: execute(duration)
    UC->>Repo: createSession(sessionDraft)
    Repo->>DB: insert FocusSession
    UC->>Lock: activateLockRules()
    Note over UI: Timer runs, floating window appears when backgrounded (ADR-0009)
    U->>UI: duration ends or manual stop
    UI->>UC: completeSession(id, actualDuration)
    UC->>Repo: updateSession(...)
    Repo->>DB: update FocusSession
    UC->>Lock: deactivateLockRules()
```

## When to Add New Diagrams

- **A new sequence diagram**: when building any feature that coordinates more than one usecase/service (e.g. the battery-optimization exemption flow, or the full PDF export flow from statistics).
- **A state diagram**: if a particular UI state (e.g. timer states: idle/running/paused/completed) proves complex enough that tracking it directly in code becomes hard.
- **General rule**: a diagram is added only if it will actually save time during implementation or review, not as a documentation obligation detached from real need.
