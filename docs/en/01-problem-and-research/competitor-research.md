# Competitor Research and Market Analysis

## Methodology

Open review of Pomodoro and habit-tracking apps available on Google Play and the App Store (public search, no internal tools or unofficial files), conducted November 2026.

## Key Findings

### 1. Pairing Pomodoro with motivational themes/characters is common, but shallow
Several apps (e.g. Pomo Pals, Pomokittens, Habit Hunter, GOGO, Focus Gacha, SpaceFocus, PomoArt) use characters or themes (pets, space, pixel art) as a core motivational hook. **Each app commits to one fixed theme** — none offer a system for switching modes/themes within the same app.

### 2. Pomodoro + habit tracking combos exist, but rarely with real statistical depth
Apps like Mindle combine both with a focus on privacy and offline operation. Some apps only mark a habit "done" once a full timer session completes (not a simple button tap), to prevent streak gaming — a useful general concept worth adopting.

### 3. Detailed statistics are a common weak spot
Most Pomodoro apps remain basic: start a timer, it ends, done — with no deep analysis of usage patterns over time. This is a clear market gap.

### 4. Main direct competitor: Focus To-Do
A very feature-complete app functionally (tasks + timer + sync). Key paid features relevant to us:
- Detailed reports on time distribution and completed tasks, with a Gantt chart of focus time and breakdown by project.
- Cross-device sync (mobile, desktop, browser extension).
- A "Strict Mode" to prevent distraction.

**Notable weaknesses from real user reviews:**
- Repeated requests for raw data export (CSV) that remain unmet even in the paid tier.
- Complaints about the paid subscription itself failing to activate properly, and inconsistent focus-time numbers across devices.

## Resulting Competitive Opportunity

| Market Gap | Our Response |
|---|---|
| Detailed statistics paywalled by most competitors | Free, fully detailed, from day one |
| Data export unavailable even with payment at a leading competitor | PDF export in the MVP (CSV later) |
| Single fixed theme in motivational-character apps | Technical foundation (deferred activation) ready for multiple future modes without affecting user data |
| Inconsistent reliability (sync, payments) at a leading competitor | Fully offline MVP eliminates an entire class of these problems |

## Important Legal/Ethical Note

During this project, a file was encountered that is strongly suspected to be the output of decompiling the Focus To-Do app (obfuscated class/field names typical of tools like jadx after ProGuard/R8 obfuscation). **This file was entirely disregarded and was not used in any design decision**, since it is not a public or official source, and using it as a reference for our own database design would amount to copying another party's intellectual property. This project's data model (`data-model.md`) is built entirely from scratch based solely on our own functional requirements.
