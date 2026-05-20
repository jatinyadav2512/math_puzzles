# tokenUsageGuide.md - Session Protocol & Token Discipline

> **Reusable across every project you build with an AI coding agent.** Generic — no app-specific content. Pair with `agents.md` (engineering practices) and an app-specific `architecture.md`.
>
> Agent token budgets burn fast in tools like Antigravity, Cursor, and Claude Code (often within ~30 minutes of active use). This file is a contract that keeps each session productive and resumable.

---

## 1. The Two Rules That Save The Most Tokens

1. **Never let the agent re-read or regenerate things that already exist on disk.** Every prompt gives the *minimum* file set the agent needs and forbids touching the rest.
2. **Never let the agent make architectural decisions during a build phase.** Decisions live in your spec docs (`projectOverview.md`, `architecture.md`, `design.md`). Mid-build questions are appended to `summary.md > Open Questions`; the human answers, the agent proceeds.

If you internalize only those two, you save more tokens than every other tactic combined.

---

## 2. Phased-Build Pattern

Slice the build into phases. Each phase = one ~30-minute agent session. Define them once in `architecture.md > Build Phases`. Do all of phase N before starting phase N+1.

**Per-session prompt template** (paste verbatim, change only the phase number and scope):

```
Continue the build.

Read in order, one-sentence ack each:
1. summary.md
2. architecture.md (only if this phase touches structure or new files)
3. design.md (only if this phase touches UI)

Implement Phase <N>: <phase name from architecture.md>.

Constraints:
- No edits outside Phase <N>'s scope (listed in architecture.md).
- No alternative library picks. No version bumps without flagging.
- No regenerating large hand-authored content files.
- If you hit an unspecified decision, append to summary.md "Open Questions" and stop the affected sub-task.
- After implementing, run the test command (e.g. `flutter analyze && flutter test`) and paste the summary line only.
- Update summary.md with: what you did, what you skipped, next session's first action.
```

The prompt is ~250 tokens. Reuse every session.

---

## 3. What To Offload To The Human (saves the most tokens)

The agent should never spend tokens on these. Bake them into your spec.

| Offload | What you (the human) do |
|---|---|
| Large hand-authored content (riddle banks, copy decks, lookup tables, content JSON) | Author once outside the agent. Drop file into `assets/`. |
| Visual assets (icon, splash, illustrations) | Generate via tooling (Canva, Figma, Midjourney, stock). Drop into `assets/`. |
| Audio (royalty-free SFX) | Download from mixkit.co / freesound. Drop into `assets/`. |
| Privacy policy text | Generate via a free generator. Host. Paste URL into constants. |
| Keystore (Android) | `keytool` once locally; gitignore the keystore + `key.properties`. |
| Store listing (title, descriptions, screenshots, feature graphic) | Done in store console UI. |
| Real-device QA | Side-load the release build to one premium + one budget device. |
| Final naming / branding decisions | Decide once, lock in `projectOverview.md`. |

---

## 4. Anti-Patterns That Burn Tokens

The agent should refuse / push back on any of these:

1. **"Read all files and tell me the architecture."** Cost 30k+ tokens. The architecture *is* `architecture.md`.
2. **"Add tests for everything."** v0 widget/integration tests are out of scope per `agents.md` §8.
3. **"Refactor X for cleanliness."** Reject mid-build refactors. Defer to a v0.1 polish phase.
4. **"Convert state library / change routing library."** Locked.
5. **"Generate richer JSON for content."** Schema is fixed; content is owned by the human.
6. **"Try multiple approaches."** One per problem. If first fails, ask the human.
7. **"Print full file before editing."** Use Edit for in-place changes; do not echo files back.

---

## 5. How To Use Each Session Optimally

### Session opening (~500 tokens, first 30 seconds):
1. Read `summary.md` first.
2. Read `architecture.md` only the relevant section for the phase.
3. Read `design.md` only if the phase touches UI.
4. Do **not** read `projectOverview.md` every session — it's a reference, not a runtime input. Read on session 1 only; trust `summary.md` to surface deltas afterward.

### Session middle (the work):
- Implement strictly within the phase scope.
- Commit per logical change. Commit message: `phase-N: <what>`.

### Session close (~600 tokens, last 60 seconds):
- Run the test/lint command. Paste only the summary line.
- Update `summary.md`:
  - Bump "Last Updated".
  - Move completed items from "Next Up" → "Done".
  - Add new "Open Questions" with file path and line.
  - State the very first action for the next session in one sentence.

---

## 6. Per-Phase Token Budgets

These are *targets*. The agent reports actual usage at session end. If a phase exceeds budget by 2×, the phase scope was too large — split it.

| Phase type | Target tokens (in + out) | Common cause of overrun |
|---|---|---|
| Bootstrap (scaffolding, deps) | < 8k | Over-explaining empty files |
| Pure-logic layer (parsers, models, calc) | < 25k | Re-deriving design tokens; not using codegen |
| Repositories / persistence | < 20k | Hand-writing JSON instead of `json_serializable` |
| App shell + first screen | < 25k | Trying to build two screens in one session |
| Major feature screen (e.g. main solve loop) | < 35k | Cap; if over budget, split into 4a / 4b |
| Polish (audio, motion, micro-interactions) | < 20k | Asset wiring is small if assets exist |
| Multi-screen (settings, stats, etc., 3 small screens) | < 25k | Cap each at 8k |
| Release config | < 10k | Mechanical: icon gen, splash gen, signing, ProGuard |
| QA fixes | varies | Driven by bug count |

---

## 7. Code Generation Saves Real Tokens

Use generators wherever they exist (Freezed + json_serializable + build_runner for Dart; whatever your stack provides elsewhere).

The agent writes ~10 lines (annotations + fields); `build_runner` writes ~150 lines of `copyWith` / `==` / `hashCode` / `toJson` / `fromJson`. That's a 15× multiplier of code-per-token.

The agent should **never** hand-write boilerplate that a generator can produce. If it does, the prompt was wrong.

---

## 8. Pin Dependencies (no debate)

Versions are listed in `projectOverview.md`. The agent does not Google "what's the latest version of X" — that wastes a tool call and tokens. Version bumps are a dedicated upgrade pass, not a feature side-effect.

---

## 9. Self-Diagnostic Mid-Session

If the agent has been running ~20 minutes (replies slow, edits muddier):

```
Self-check:
- Am I still on Phase <N> scope, or have I wandered?
- Have I touched any file outside the phase scope without flagging?
- Is the lint/test still clean against the last known-good?
- Have I committed the last logical chunk?
```

Any "no" → commit current work, update `summary.md`, stop. A clean stop is far cheaper than running until the session dies mid-edit.

---

## 10. Resume-After-Crash Protocol

When a session ends unexpectedly (token cap, IDE crash):

1. New agent session.
2. Paste:
   ```
   Read summary.md. Three sentences only:
   - The last completed Phase.
   - What was in progress.
   - The very first action I should take to resume.
   No code. No file edits. Just three sentences.
   ```
3. The agent's answer drives your next prompt. Costs ~2k tokens but reliably restores context.

`summary.md` is the linchpin. If it's stale, this fails. Hence the rule: *every session ends by updating `summary.md`*.

---

## 11. Things You (The Human) Should NOT Ask The Agent

Asking these will burn tokens for poor returns:

- "Is this app a good idea?" — product validation, not engineering.
- "What should the privacy policy say?" — generators exist; not the coding agent's job.
- "Generate marketing copy / store description." — better done in a chat-only context, not in your build agent.
- "Run the app and try it." — the agent doesn't have a phone. You do.
- "Compare library X vs Y." — locked decisions.
- "Optimize this widget." — defer to a v0.1 polish phase after launch metrics.

---

## 12. The Single Most Important Habit

> **End every session by writing `summary.md`. Start every session by reading `summary.md`.**

If you do nothing else from this guide, do that. It's the only thing that makes a 9-session disjoint build feel like one continuous build.

---

*End of tokenUsageGuide.md. Reusable across all your AI-built projects. Engineering practices live in `agents.md`. App-specific structure lives in `architecture.md`.*
