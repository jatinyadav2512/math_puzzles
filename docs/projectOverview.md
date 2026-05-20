# Math Riddles - Project Overview

> **This is the source of truth for the app.** The coding agent (Google Antigravity) reads this file on session 1 only; thereafter `summary.md` carries the running state.
>
> Companion docs: `agents.md` (generic engineering practices, reusable across all your apps) · `architecture.md` (this app's per-file build spec) · `tokenUsageGuide.md` (generic session protocol) · `design.md` (visual spec) · `summary.md` (current state, updated every session). Any decision change made later must be reflected back into this file *and* logged in `summary.md > Decisions Log`.

---

## 1. What We Are Building

A native Android app, built in Flutter, that delivers visual symbol-equation math riddles in the style of the reference app `com.BlackGames.MathRiddles`. The user progresses through 100 hand-authored riddles systematically via a single "Play" button. v0 ships with no backend, no ads, and no monetization, but is architected so backend, ads, and IAP can slot in cleanly later.

### Reference app
`https://play.google.com/store/apps/details?id=com.BlackGames.MathRiddles&hl=en_IN`

### Why we will win
1. Faster, cleaner UI than the reference app (Material 3, smooth animations).
2. Deterministic difficulty curve (5 buckets × 20 riddles, each curated).
3. Onboarding so first-time users immediately understand the format.
4. Offline-first: every riddle ships in the APK; no network required.

---

## 2. Decisions Already Locked In (Do Not Re-Litigate)

| Area | Decision |
|---|---|
| Platform | Android only (v0). iOS later. |
| Framework | Flutter (Dart) |
| Backend | None for v0. Repository pattern abstracts data source so backend can be added without touching UI. |
| Monetization | None for v0. `HintService` interface added now so `RewardedAdHintService` can replace `FreeHintService` later without UI changes. |
| Riddle style | Visual symbol equations (e.g. `🍎+🍎+🍎=30`). |
| Game mechanics | Hint system only (no hearts, no coins, no skip). |
| Progression | Linear progression via single "Play" button. Difficulty increases systematically. |
| Riddle count | 100 (20 per bucket × 5 buckets). |
| Riddle source | `assets/data/riddles.json` (provided alongside this spec). |
| Design ownership | Coding agent builds UI from `design.md` directly. No Figma. |
| v0 extras | Sound + haptics + Settings + Stats + Onboarding + Share App. |
| Hint cost | v0: unlimited free. Architected so it can later become "watch ad to unlock hint". |

---

## 3. App Name (ASO Recommendation)

The store listing name and the in-app display name are decoupled from the package id. Recommended names from an ASO (App Store Optimization) perspective:

1. **`Math Riddles - Brain Puzzles`** *(strongest pick)* - leads with the highest-volume keyword, secondary keyword broadens discoverability, fits in 30-char Play Store title limit.
2. `Math Riddles: Logic & IQ`
3. `Brainy Math - Riddles & Puzzles`

**Lock the choice before generating the keystore and signing the release build.** Until then use:
- Display name: `Math Riddles`
- Package id: `com.<yourorg>.mathriddles` (replace `<yourorg>` before publishing)
- Application id (Gradle): same as package id

Tagline (used on store listing + about screen): *"Train your brain, one riddle a day."*

---

## 4. Core Game Loop

```
Splash (1s, brand reveal)
  └─ first launch? ──yes──> Onboarding (3 screens) ──> Home
                  └──no───> Home

Home (Centered "Math" title, prominent "Play" button)
  └─ tap "Play" ──> Riddle screen (next unsolved riddle)
       ├─ user types answer in custom numpad
       ├─ taps Hint (optional) -> Hint panel slides up
       ├─ taps Submit
       │   ├─ correct: confetti + sound + haptic, riddle marked solved,
       │   │           next riddle unlocks, "Next" CTA shown
       │   └─ wrong:   shake + wrong sound + light haptic, "Try Again"
       └─ back arrow returns to Home
```

The core loop is now even tighter: home → play → riddle → solve. No manual level selection. Settings is accessed from the top-right icon on Home.

---

## 5. Screens (v0)

### 5.1 Splash
- Centered logo + app name; 1s display, then route based on first-launch flag.
- Read `firstLaunch` from `SettingsRepository`.
- If true → Onboarding; else → Home.


### 5.3 Home
- **No AppBar**: Layout is centered and minimalist.
- **Branding**: Large, premium "Math" title centered in the upper half.
- **Primary Action**: A large, pulsing "Play" button centered below the title. Tap → route to Riddle screen for the next unsolved riddle.
- **Secondary Actions**: Settings icon in top right corner.
- **Progress**: "Level X / 100" text displayed above the Play button.

### 5.4 Levels (per-bucket grid)
- AppBar: back, bucket name, progress count.
- Body: 4-column grid of 20 `LevelTile`s.
- Tile states (mutually exclusive):
  - **Solved** - filled card, check icon, riddle number.
  - **Current** - highlighted ring, riddle number, subtle pulse animation.
  - **Locked** - greyed out, lock icon.
- Tap on Solved tile → opens Riddle in read-only review mode (shows the user's answer + explanation).
- Tap on Current → opens Riddle in solve mode.
- Locked tiles are disabled (tap → light haptic + toast "Solve riddle X first").

### 5.5 Riddle
- AppBar: back, Grid icon (opens all levels), hint icon. (No title).
- Body (top to bottom):
  1. **Equations panel & Question** - Centered in the middle of the screen.
  2. **Answer field** - positioned just above the numpad.
  3. **Custom numpad** - pinned to bottom.
- Tapping Hint opens a `Bottom Sheet` with the hint text and a "Got it" button.
- On Submit:
  - Correct: full-screen confetti overlay (`confetti` package or simple custom canvas), correct sound, success haptic, dialog shows answer + explanation + "Next Riddle" / "Back to Levels".
  - Wrong: input field shakes, wrong sound, light haptic, snackbar "Not quite - try again."

### 5.6 Stats
- Header: total solved (e.g. "47 / 100"), large progress ring.
- 5 rows (one per bucket): bucket name, solved count, progress bar.
- Footer cards: total hints used, current streak (consecutive days with at least one solve), longest streak, total time spent (rounded to minutes).
- All stats computed from local persistence; no network.

### 5.7 Settings
- Theme: System / Light / Dark (radio).
- Sound effects: toggle.
- Haptics: toggle.
- Reset progress: destructive button → confirm dialog → wipes progress and stats but keeps onboarding seen flag.
- About: app name, version, privacy policy link, share app link. (Note: Rate Us removed until app is published).

---

## 6. Data Model

### 6.1 Riddle (immutable, loaded from JSON at startup)

**Symbol convention:** v0 uses uppercase letters `A`, `B`, `C`, `D`, … as symbols (algebra-textbook style — no emoji or images). The set extends to `H` if a riddle ever needs more variables (none currently do).

```dart
@freezed
class Riddle with _$Riddle {
  const factory Riddle.equation({
    required String id,            // e.g. "easy_01"
    required Difficulty difficulty,// enum: easy, medium, hard, expert, master
    required int bucketIndex,      // 0..4
    required int orderInBucket,    // 1..20
    required List<String> givens,  // e.g. ["A+A+A=30", "A+B+B=18"]
    required String question,      // e.g. "A+B×C=?"
    required int answer,
    required String hint,
    required String explanation,
  }) = EquationRiddle;

  // Diagram-style riddle: three triangles, find the missing bottom value.
  // Renderer draws the triangles with CustomPainter — no image assets.
  const factory Riddle.trianglePattern({
    required String id,
    required Difficulty difficulty,
    required int bucketIndex,
    required int orderInBucket,
    required List<TriangleCell> triangles,   // exactly 3
    required int answer,
    required String hint,
    required String explanation,
  }) = TrianglePatternRiddle;

  factory Riddle.fromJson(Map<String, dynamic> json) => _$RiddleFromJson(json);
}

@freezed
class TriangleCell with _$TriangleCell {
  const factory TriangleCell({
    required int left,
    required int right,
    required int? bottom,   // null = the unknown to solve for; non-null = example
  }) = _TriangleCell;
  factory TriangleCell.fromJson(Map<String, dynamic> json) => _$TriangleCellFromJson(json);
}
```

**Discrimination via `displayType`:** the JSON includes a string field `displayType` whose value selects which factory `fromJson` calls. Default `"equation"`; other values: `"trianglePattern"`. New diagram types (sequence, grid, analogy) can be added later as additional union cases without touching existing data.

### 6.2 Progress (mutable, persisted)
```dart
class Progress {
  final Map<String, RiddleProgress> byId;
  // RiddleProgress: { solved: bool, hintUsed: bool, attempts: int, solvedAt: DateTime? }
  final int currentBucket;     // 0..4, the highest bucket the user has unlocked
  final int currentIndex;      // 1..20, the next-to-solve riddle index in currentBucket
}
```

### 6.3 Stats (derived, but cached)
- totalSolved, hintsUsed, currentStreakDays, longestStreakDays, totalSecondsSpent.
- Recomputed on app launch from progress + a small persisted "last solve date" for streaks.

### 6.4 Settings (persisted)
- themeMode: enum (system|light|dark)
- soundEnabled: bool (default true)
- hapticsEnabled: bool (default true)
- firstLaunch: bool (default true; flipped after onboarding finished)

### 6.5 Persistence keys (SharedPreferences)
```
mr.progress.json          # JSON-encoded Progress
mr.settings.themeMode     # int
mr.settings.soundEnabled  # bool
mr.settings.hapticsEnabled# bool
mr.firstLaunch            # bool
mr.streak.lastSolveDate   # ISO date string
mr.streak.current         # int
mr.streak.longest         # int
mr.timeSpent.seconds      # int
```

All keys are namespaced with `mr.` so they don't collide if the user backs up SharedPreferences.

---

## 7. Riddle Schema (JSON)

`assets/data/riddles.json` (shipped in the APK) is an array of objects. Each object has `displayType` selecting which schema variant it follows. The default (omitted = `"equation"`) is the algebra-style riddle; `"trianglePattern"` is the diagram-style.

### 7.1 `displayType: "equation"` (the v0 default)
```json
{
  "id": "easy_01",
  "difficulty": "easy",
  "bucketIndex": 0,
  "orderInBucket": 1,
  "displayType": "equation",
  "givens": ["A+A+A=30"],
  "question": "A=?",
  "answer": 10,
  "hint": "Count how many copies of A are on the left, then divide.",
  "explanation": "A = 30 ÷ 3 = 10."
}
```

**100 hand-authored equation riddles** are in `riddles.json` alongside this spec. Drop into `assets/data/riddles.json` and register in `pubspec.yaml`. **Do not let the agent regenerate riddles** — they're verified (`verify_riddles.py` proves 100/100 ✅).

### 7.2 `displayType: "trianglePattern"` (extension type)
Used for "find the missing number" diagram puzzles where three triangles each have a `left` (top-left), `right` (top-right), and `bottom`; the third triangle's `bottom` is `null` and is what the user solves for. The first two triangles establish the pattern (e.g. `bottom = right ÷ left`).
```json
{
  "id": "tri_sample_04",
  "difficulty": "medium",
  "displayType": "trianglePattern",
  "triangles": [
    {"left": 5, "right": 10, "bottom": 2},
    {"left": 4, "right": 32, "bottom": 8},
    {"left": 4, "right": 20, "bottom": null}
  ],
  "answer": 5,
  "hint": "Divide the larger top number by the smaller one.",
  "explanation": "Pattern: bottom = right ÷ left. So 20 ÷ 4 = 5."
}
```

**5 sample triangle riddles** are in `riddles_diagrams_samples.json` to demonstrate the schema and let the renderer be implemented and tested. v0 ships with the 100 equation riddles only; the sample file becomes the seed for a v0.1 content add. The renderer is built once in v0 (it's cheap) so adding more diagram riddles later is purely a content task.

### 7.3 Why no images
All diagrams are drawn at runtime by Flutter's `CustomPainter`:
- Triangle = 3-point `Path`.
- Numbers = 3 `Positioned` `Text` widgets at fractional coordinates of the triangle's bounding box.
- Same approach extends to circles, squares, hexagons, arrows. Zero PNG/SVG assets, zero binary-size cost, infinite-resolution-clean.

### 7.4 Notation rules (equation type)
- Symbols are uppercase letters `A`–`H`, used per-riddle (each riddle reuses A as its first variable).
- Operators allowed: `+`, `-`, `×`, `÷`, `=`. No parentheses in v0 (keeps the parser tiny).
- Order of operations: standard PEMDAS. The parser respects this.
- Question always ends with `=?`. The integer answer is in `answer`.
- A symbol may multiply itself (e.g. `A×A=49`). The parser supports this; the renderer treats it as `A²` visually (small superscript).

---

## 8. UI/UX Flow Summary

```
Launch ─> Splash ─[firstLaunch?]─> Onboarding ─> Home
                                      │
                                      ▼
                                    Home ─tap Play─> Riddle ─solve─> back to Home
                                      │
                                      └─tap gear  ─> Settings ─────┘
```

Back button behavior:
- Riddle → Home (animated slide).
- Settings → Home.
- Home → background app (Android default).

---

## 9. Tech Stack & Packages (pinned)

| Concern | Package | Pinned version |
|---|---|---|
| State management | `provider` | `^6.1.2` |
| Routing | `go_router` | `^14.2.0` |
| Persistence | `shared_preferences` | `^2.2.3` |
| Models | `freezed` + `freezed_annotation` + `json_annotation` + `json_serializable` + `build_runner` | latest stable |
| Audio | `audioplayers` | `^6.0.0` |
| Confetti | `confetti` | `^0.7.0` |
| App icon | `flutter_launcher_icons` (dev) | `^0.13.1` |
| Splash | `flutter_native_splash` (dev) | `^2.4.0` |
| Linting | `very_good_analysis` | `^6.0.0` |

Pinning versions removes a class of "agent debates dependency versions" failure modes during the build.

### Android config
- `compileSdk` 34, `targetSdk` 34, `minSdk` 23 (Android 6.0; covers ~99% of Play Store devices and is the lowest sdk currently allowed for new Play Store releases when combined with target 34).
- `applicationId`: `com.<yourorg>.mathriddles`.
- ProGuard / R8 enabled for release; rules file ships with the project (Flutter default + audioplayers rules).
- Multidex not required at minSdk 23.

---

## 10. Folder Structure

```
math_riddles/
├── android/                          # default Flutter Android scaffold
├── assets/
│   ├── audio/
│   │   ├── correct.mp3
│   │   ├── wrong.mp3
│   │   └── tap.mp3
│   ├── data/
│   │   └── riddles.json              # 100 riddles
│   └── images/
│       ├── icon.png                  # 1024x1024 source for launcher icon
│       ├── splash.png                # 1242x2436 source for splash
│       └── onboarding/
│           ├── welcome.png
│           ├── how_to_play.png
│           └── difficulty.png
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   ├── routing/
│   │   └── utils/
│   ├── data/
│   │   ├── models/                   # freezed
│   │   ├── repositories/             # abstract + local impls
│   │   └── services/                 # HintService, AudioService, HapticService
│   ├── features/
│   │   ├── splash/
│   │   ├── onboarding/
│   │   ├── home/
│   │   ├── levels/
│   │   ├── riddle/
│   │   ├── stats/
│   │   └── settings/
│   └── providers/                    # Riverpod providers
├── test/
│   ├── parser_test.dart
│   ├── progression_test.dart
│   └── repository_test.dart
├── pubspec.yaml
└── README.md
```

Feature-first layout (one folder per screen) is intentional: it gives the coding agent local context per feature and minimizes the number of files it must hold in its head per prompt.

See `agents.md` for the per-file specification of what each file should contain.

---

## 11. Backend-Readiness Checklist

These rules ensure backend can be added later without UI rewrites:

1. All data access goes through abstract repositories: `RiddleRepository`, `ProgressRepository`. UI/providers depend on the abstraction, never on the local impl.
2. `LocalRiddleRepository` reads from `assets/data/riddles.json`. The future `RemoteRiddleRepository` will read from REST/Firestore/etc with the same method signatures.
3. Riddle ids are stable strings (`easy_01`, `medium_07`, …). Do not use list indices anywhere.
4. Progress is keyed by riddle id, not by index. Migrating from local to remote requires only swapping the repo binding in `providers/repository_providers.dart`.
5. No business logic (e.g. unlock rules) lives in widgets - it lives in the providers / domain layer so it can be unit-tested and shared across data sources.
6. JSON shape matches the Riddle model 1:1 - the same shape can be served by a backend without re-serialization changes.

---

## 12. Ads-Readiness Checklist (for the Hint System)

1. `HintService` interface with `Future<bool> requestHint(String riddleId)` returning whether the hint was granted.
2. v0 binds `HintService` → `FreeHintService` (always returns `true`).
3. Future ad implementation binds `HintService` → `RewardedAdHintService` which shows a rewarded ad and returns `true` only if the ad completes.
4. The Riddle UI calls `HintService.requestHint(...)` and awaits the boolean - no UI changes needed when the implementation swaps.
5. Riddle UI never knows about ads, hint quotas, or coins; it only knows whether a hint is available.

---

## 13. v0 Out of Scope (Document & Defer)

- iOS build
- Backend
- User accounts / cloud sync
- Leaderboards
- Daily challenge (deferred - re-evaluate after v0 metrics)
- Multiple languages (English only for v0; ARB scaffolding present so adding languages is editing files, not architecture)
- Push notifications
- Achievements / badges
- IAP / coins
- Multiple hint tiers
- More than one hint per riddle
- Riddle generator / authoring tool

---

## 14. User Action Items (Blockers Before Play Store Submission)

The coding agent cannot do these. Track them outside the build:

1. **Final ASO name decision** (see §3).
2. **App icon** - 1024×1024 PNG, drop into `assets/images/icon.png`. Use `flutter_launcher_icons` to generate all densities.
3. **Splash artwork** - 1242×2436 PNG, drop into `assets/images/splash.png`. Use `flutter_native_splash`.
4. **Onboarding illustrations** - 3 PNGs at 1080×1080 in `assets/images/onboarding/`.
5. **Audio assets** - `correct.mp3`, `wrong.mp3`, `tap.mp3` (under 30KB each, royalty-free, e.g. mixkit.co).
6. **Privacy policy** - hosted publicly, URL added to `core/constants/app_constants.dart` and Play Store listing.
7. **Keystore** - generate once, store securely, configure `android/key.properties` (gitignored). Required for release signing.
8. **Play Store listing assets** - feature graphic (1024×500), 4-8 screenshots (1080×1920+), short description (80 chars), full description (4000 chars).
9. **Real-device QA pass** - Android 6, Android 10, Android 14 minimum. Pixel + a low-end device.

A draft of these is OK to start with; finalize before release.

---

## 15. Definition of Done for v0

- [ ] All 100 riddles solvable end-to-end.
- [ ] Progress survives app restart and device restart.
- [ ] Theme + sound + haptics toggles all work and persist.
- [ ] Reset progress wipes progress without crashing.
- [ ] Locked tiles cannot be opened.
- [ ] Onboarding shows exactly once on first launch.
- [ ] No analyzer warnings (`flutter analyze` clean against `very_good_analysis`).
- [ ] Unit tests pass: parser, progression, repositories.
- [ ] Release APK / AAB builds and installs on a clean device.
- [ ] `flutter test` green.
- [ ] Manual smoke test from `summary.md` checklist passes on a Pixel + a low-end Android device.

---

## 16. Change Management Rules

- Any decision change made during the build must be recorded under §2 (Decisions) **and** in the `Decisions Log` section of `summary.md`. Stale specs are how production bugs ship.
- The agent should never silently change architecture choices to "save time". If it sees a better option, it should surface it in `summary.md > Open Questions` and wait for confirmation.
- Adding a feature mid-build requires updating: this file → `agents.md` (if structural) → `design.md` (if visual) → `summary.md` (always).

---

*End of Project Overview. Read `architecture.md` next for build-time per-file specs, then `agents.md` for engineering practices, then `tokenUsageGuide.md` for session protocol.*
