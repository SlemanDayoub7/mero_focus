# Git / Branching Strategy

## Branch Model (Simplified — No develop)

```
main       # The only permanent branch. Fully protected (protected + ruleset). Every commit = a candidate release for Google Play
feature/*  # e.g. feature/pomodoro-timer, feature/stats-weekly
fix/*      # bug fixes
```

A `develop` branch is intentionally not used at this stage, since work is currently solo and an intermediate integration branch here would be overhead without real benefit. **This decision is revisited once collaborators join** (a `develop` branch may be needed then to batch several parallel features before each release).

## Protecting the main Branch (GitHub Branch Protection / Ruleset)

The following settings must be enabled on `main` in the repository settings:
- Disallow direct pushes — every change goes through a Pull Request, even for the repository owner themselves.
- Require CI checks (`flutter analyze` + `flutter test`) to pass before merging is allowed.
- Require the branch to be up to date with `main` before merging, to avoid silent conflicts.

## Workflow

1. Open `feature/<feature-name>` from `main`.
2. Implement + write tests (see `testing-strategy.md`).
3. Open a Pull Request against `main` (even against yourself — a documentation discipline that records the rationale for every decision in the PR description).
4. Wait for CI to pass automatically.
5. Merge directly into `main` (Squash or regular Merge, as preferred), delete the branch.

No `release/x.y.z` branch is needed at this stage: releases are tagged directly on `main` after merging (`v0.1.0`, `v0.2.0`...), since `main` is always clean and releasable given the protection above.
