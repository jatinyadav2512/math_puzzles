# agents.md - Engineering Practices for AI-Driven App Builds

> **A reusable contract between the human and the coding agent (Antigravity, Claude Code, Cursor, etc.).**
> This file describes **how** the agent should work — coding standards, state management choices, build discipline, anti-patterns. It is **project-agnostic**. Copy this file unchanged into every new project you start with an AI agent.
>
> Per-project specifics — data models, screen list, parser logic, business rules — live in a sibling `architecture.md`. Token-saving habits and session protocol live in a sibling `tokenUsageGuide.md`. Both are also written to be reusable.

---

## 1. The Two Rules That Save The Most Tokens

1. **Never let the agent re-read or regenerate things that already exist on disk.** Every prompt gives the agent the *minimum* file set it needs and forbids touching the rest.
2. **Never let the agent make architectural decisions during a build phase.** All decisions live in `projectOverview.md`, `architecture.md`, `design.md`. If a question arises mid-build, the agent appends to `summary.md > Open Questions` and stops the affected work; the human answers, then the agent proceeds. No improvising.

If you internalize only those two, you save more tokens than every other tactic combined.

---

## 2. Read Order at Session Start

Every session, the agent reads in order:

1. `summary.md` (always — current state, last decisions, next action)
2. `architecture.md` (only if this session touches structure or new files)
3. `design.md` (only if this session touches UI)
4. This file (`agents.md`) — already in your context; skim if you've drifted from convention

`projectOverview.md` is read on session 1 only. After that, trust `summary.md` to surface deltas.

---

## 3. State Management (Flutter)

Use the **`provider`** package (^6.1.2). Reasons:

- Lower cognitive load — the largest training corpus for AI agents and Flutter devs.
- DI is direct: `Provider<T>(create: (_) => Impl())` plus override at app root for swap-in alternatives.
- Async loading via `FutureProvider` / `StreamProvider`.
- State holders extend `ChangeNotifier` wrapped in `ChangeNotifierProvider`.

Universal pattern:

```dart
// Root: register everything in one MultiProvider in app.dart
MultiProvider(
  providers: [
    Provider<XRepository>(create: (_) => LocalXRepository()),
    Provider<YService>(create: (_) => DefaultYService()),
    ChangeNotifierProvider(create: (ctx) => AppState(repo: ctx.read<XRepository>())),
  ],
  child: MaterialApp.router(...),
)

// In widgets:
final state = context.watch<AppState>();           // rebuilds on change
final repo  = context.read<XRepository>();         // one-shot read
```

For service swaps later (ads, paid features, remote data), override the registration in `MultiProvider` — UI code is untouched.

---

## 4. Models

Always use **Freezed + json_serializable + build_runner**. Never hand-write `copyWith`, `==`, `hashCode`, `toJson`, `fromJson` — that boilerplate is what `build_runner` is for.

After any model edit:
```bash
dart run build_runner build --delete-conflicting-outputs
```

For sum types (a value that is "either A or B"), use Freezed unions. They give exhaustive `when` / `map` checking at compile time and prevent the "I forgot to handle the new case" class of bug when you add a third variant.

---

## 5. Routing

`go_router` (^14.x). Routes are declared once in `lib/core/routing/app_router.dart` as named routes. No string route literals scattered through widgets.

---

## 6. Folder Convention (Flutter)

Feature-first:

```
lib/
  main.dart                  # async startup, runApp
  app.dart                   # MultiProvider + MaterialApp.router
  core/
    constants/
    theme/
    routing/
    utils/
    widgets/                 # reusable cross-feature widgets (AppButton, AppCard, …)
  data/
    models/                  # Freezed
    repositories/            # abstract + local impl, side-by-side with future remote impl
    services/                # AudioService, HapticService, domain services
  features/
    <feature_name>/
      presentation/          # widgets only
      providers/             # feature-scoped ChangeNotifiers (if any)
  providers/                 # root-level cross-feature providers (if needed)
test/
  <feature>_test.dart        # unit tests for pure logic
```

Why feature-first: gives the agent local context per feature and minimizes the file set it must hold in memory per prompt. Per-file responsibilities are documented in `architecture.md`.

---

## 7. Coding Conventions

- Strict null safety. No `late` unless set inside `initState` and used after.
- Immutable models via Freezed.
- No `BuildContext` use after `await` without `if (!mounted) return;`.
- One widget per file. A small leaf widget (<50 lines, not reused) may co-locate in the parent screen file.
- No magic numbers in widgets. All sizes and colors come from theme tokens.
- Linting: `very_good_analysis`. CI runs `flutter analyze`; fail on warnings.
- Comments explain *why*, not *what*. Resist commenting obvious lines.
- Lock dependency versions in `pubspec.yaml`. Bumping is a dedicated upgrade pass, not a feature side-effect.

---

## 8. Test Strategy (lean for v0)

For v0, write only:

1. Unit tests for pure business logic (parsers, evaluators, unlock rules, formatters).
2. Unit tests for repository serialization round-trip.

Skip widget tests, integration tests, golden tests for v0 — they're flaky, slow, and burn agent tokens. Add post-launch when the surface is stable.

Tests live in `test/<feature>_test.dart`. CI: `flutter test` must be green.

---

## 9. Phased Build Pattern

The build is sliced into discrete phases. **Do all of phase N before starting phase N+1.** Each phase fits in one ~30-minute agent session.

Per-phase prompt (paste at session start):

```
Continue the <project> build.

Read in order: summary.md, architecture.md (only if new files this phase), design.md (only if UI).

Implement Phase <N>: <phase name from architecture.md §Phases>.

Constraints:
- No file edits outside phase scope.
- No alternative library picks.
- No regenerating large hand-authored content files.
- Surface unspecified decisions in summary.md > Open Questions and stop the affected sub-task.
- Run `flutter analyze` and `flutter test`; paste only the summary line.
- Update summary.md with: what done, what skipped, next session's first action.
```

This prompt is ~250 tokens. Reuse it every session, changing only `<N>`.

Phase scope discipline:
- One phase = one logical layer or screen.
- Commit per logical change. Commit message: `phase-N: <what>`.
- If the phase scope feels >30 min, split it into 4a / 4b — don't try to push through.

---

## 10. Anti-Patterns (the agent should refuse / push back)

The agent must reject these requests, even if framed politely:

1. **"Read all files and tell me the architecture."** Cost: 30k+ tokens. The architecture *is* `architecture.md`. Reread that only.
2. **"Add tests for everything."** v0 widget/integration tests are out of scope. Only the units listed in `architecture.md`.
3. **"Refactor X for cleanliness."** Reject mid-build refactors. Defer to a post-v0 cleanup phase.
4. **"Convert state library."** Locked.
5. **"Try multiple approaches."** One approach per problem. If the first fails, ask the human.
6. **"Print the full file before editing."** Use the Edit tool for in-place changes; do not echo the file back.
7. **"Generate richer JSON / re-derive content."** Hand-authored content files are owned by the human; never regenerated by the agent.

---

## 11. Self-Diagnostic Mid-Session

If the agent has been running ~20 minutes (replies slow, edits get muddier), it runs:

```
Self-check:
- Am I still on Phase <N> scope?
- Did I touch any file outside phase scope without flagging?
- Is `flutter analyze` still clean against the last known-good?
- Have I committed the last logical chunk?
```

If any answer is "no": commit current work, update `summary.md` with state, stop. A clean stop is far cheaper than running until the session dies mid-edit.

---

## 12. Resume-After-Crash Protocol

When a session ends unexpectedly (token cap, IDE crash):

1. Open new session.
2. Paste:
   ```
   Read summary.md. Three sentences only:
   - Last completed phase.
   - What was in progress.
   - First action to resume.
   No code, no edits.
   ```
3. Agent's answer drives your next prompt. Costs ~2k tokens but reliably restores context.

`summary.md` is the linchpin. If it's stale, this protocol fails. Hence the rule: every session ends by updating `summary.md`.

---

## 13. Things The Agent Must NEVER Do

- Change pinned package versions without flagging in `summary.md > Open Questions`.
- Pick alternative state management, routing, or persistence libraries — locked in `architecture.md`.
- Regenerate large hand-authored content files (data JSON, large copy decks, illustration prompts).
- Import filesystem APIs (`dart:io`) inside widgets — file access goes through repositories.
- Use `setState` in a widget that is also a `Consumer` for persistent state. View-state only (animation controllers, focus nodes); persistent state belongs in a `ChangeNotifier` provider.
- Commit secrets. (There should be none in v0; keep it that way.)
- Skip the end-of-session `summary.md` update. Non-negotiable.

---

## 14. End-of-Session Checklist

Every session, no exceptions:

1. `flutter analyze` and `flutter test`. Paste only the summary line into chat.
2. Update `summary.md`:
   - Bump "Last Updated".
   - Move completed items from "Next Up" → "Done".
   - Add new "Open Questions" with file path and line where the question was raised.
   - State the very first action for the next session in one sentence.
3. Commit. Push only if the human asked.

---

## 15. The Single Most Important Habit

> **End every session by writing `summary.md`. Start every session by reading `summary.md`.**

If you do nothing else from this file, do that. It's the only thing that makes a 9-session disjoint build feel like one continuous build.

---

*End of agents.md. This file is engineering-practices-only. App-specific architecture lives in `architecture.md`. Token-saving session protocol lives in `tokenUsageGuide.md`.*
