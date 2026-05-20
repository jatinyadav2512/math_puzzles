# architecture.md - Math Riddles, Per-File Build Spec

> **App-specific.** Lives in this repo. For generic engineering practices that apply to any AI-built app, see `agents.md`. For session token-saving protocol, see `tokenUsageGuide.md`. For visual design, see `design.md`. For product scope, see `projectOverview.md`.
>
> The agent reads this file at the start of any session that touches code structure or new files.

---

## 1. Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         Presentation                            │
│  features/<screen>/presentation/*.dart - widgets only           │
│  Reads state via context.watch<T>() from Provider.              │
│  Knows nothing about JSON, files, or audio APIs directly.       │
└──────────────────────────────▲──────────────────────────────────┘
                               │ watches/reads
┌──────────────────────────────┴──────────────────────────────────┐
│                          Providers                              │
│  app.dart MultiProvider (root) + features/<screen>/providers/   │
│  ChangeNotifiers / FutureProviders that hold UI state.          │
│  Talk to repositories via injected interfaces.                  │
└──────────────────────────────▲──────────────────────────────────┘
                               │ uses
┌──────────────────────────────┴──────────────────────────────────┐
│                         Repositories                            │
│  Abstract interfaces in data/repositories/*.dart                │
│  Local impls (LocalRiddleRepository, SharedPrefsProgressRepo)   │
│  Future remote impls go side-by-side with local ones.           │
└──────────────────────────────▲──────────────────────────────────┘
                               │ uses
┌──────────────────────────────┴──────────────────────────────────┐
│                   Services & Data Sources                       │
│  HintService, AudioService, HapticService                       │
│  rootBundle (assets), SharedPreferences                         │
└─────────────────────────────────────────────────────────────────┘
```

**Golden rule:** widgets do not import `shared_preferences`, `rootBundle`, or `audioplayers`. All side effects pass through a repository or service, exposed via a Provider.

---

## 2. Folder & File Specification

Each file below has a **purpose** (one sentence) and **public surface** (the things other files depend on). Internals can change. The public surface cannot, without flagging in `summary.md`.

### 2.1 `lib/main.dart`
- **Purpose:** Async startup, then runApp inside the root MultiProvider.
- **Behavior:** `WidgetsFlutterBinding.ensureInitialized();` → preload riddles JSON via local repository → load settings → set portrait orientation → `runApp(MathRiddlesApp());`. Errors during preload show a minimal error screen.

### 2.2 `lib/app.dart`
- **Purpose:** Root `MultiProvider` + `MaterialApp.router` with theme + router.
- **Public:** `class MathRiddlesApp extends StatelessWidget`.
- **Behavior:** Wraps the app in a `MultiProvider` registering all repositories, services, and root-level state holders (see §3). Reads theme via `context.watch<SettingsState>()` to react to theme changes.

### 2.3 `lib/core/constants/app_constants.dart`
- **Public:** `kAppName`, `kAppTagline`, `kPrivacyPolicyUrl`, `kPlayStoreUrl`, `kBucketCount = 5`, `kRiddlesPerBucket = 20`, `kSharedPrefsPrefix = 'mr.'`, `kSchemaVersion = 1`.

### 2.4 `lib/core/constants/asset_paths.dart`
- **Public:** `kRiddlesJsonPath`, `kRiddlesDiagramSamplesPath`, `kSoundCorrect`, `kSoundWrong`, `kSoundTap`, onboarding image paths.

### 2.5 `lib/core/theme/*` (3 files)
Mechanical implementation of `design.md` §3 (Color), §4 (Typography), §5 (Spacing).
- `app_colors.dart` — `class AppColors` with `light` / `dark` instances; semantic names.
- `app_text_styles.dart` — `class AppTextStyles` with semantic names.
- `app_theme.dart` — `class AppTheme { static ThemeData light(); static ThemeData dark(); }`. Material 3 (`useMaterial3: true`).

### 2.6 `lib/core/routing/app_router.dart`
- **Public:** `final goRouter = GoRouter(...)` configured with all routes (see `design.md` §7 for screen list).
- **Behavior:** Redirect-based gating on first-launch flag. Material slide transitions.

### 2.7 `lib/core/utils/equation.dart` (parser & evaluator — central piece)
- **Public:**
  ```dart
  /// Tokens of an equation expression.
  sealed class Token { ... }
  class SymbolToken  extends Token { final String letter; }   // 'A'..'H'
  class OpToken       extends Token { final String op; }       // '+', '-', '×', '÷'
  class LiteralToken  extends Token { final int value; }
  class UnknownToken  extends Token { }                        // '?'

  /// Parse "A+B×C=42" into (lhsTokens, optional rhs).
  /// Question form: ends with "=?" → rhs is null.
  class EquationParser {
    static (List<Token> lhs, int? rhs) parse(String s);
  }

  /// Evaluate tokens with PEMDAS, using letter→int map. Throws if Unknown present.
  int evaluate(List<Token> tokens, Map<String, int> values);
  ```
- **Notes:**
  - Whitespace ignored.
  - `×` and `÷` precede `+` and `−` (PEMDAS).
  - No parentheses in v0.
  - Same letter may multiply itself (`A×A`); evaluator handles trivially.
  - Throws `FormatException` on malformed input.
  - Lives behind a single facade so swapping for a richer parser later is mechanical.

### 2.8 `lib/core/utils/haptics.dart`
- Thin wrapper that respects `SettingsState.hapticsEnabled`. `void light()`, `void selection()`, `void success()`, `void error()`.

### 2.9 `lib/data/models/riddle.dart`
- **Public:** Freezed sealed union. Two cases:
  - `Riddle.equation({id, difficulty, bucketIndex, orderInBucket, givens, question, answer, hint, explanation})`.
  - `Riddle.trianglePattern({id, difficulty, bucketIndex, orderInBucket, triangles, answer, hint, explanation})`.
  - `class TriangleCell({int left, int right, int? bottom})` — `bottom == null` marks the unknown.
- `Riddle.fromJson` switches on `displayType` field (default `"equation"`).
- **Enum:** `Difficulty { easy, medium, hard, expert, master }` plus `fromString`.

### 2.10 `lib/data/models/progress.dart`
- **Public:**
  - `class RiddleProgress { bool solved, bool hintUsed, int attempts, DateTime? solvedAt }` (Freezed).
  - `class Progress { Map<String, RiddleProgress> byId }` (Freezed).
  - Helpers `bool isUnlocked(Riddle r, List<Riddle> all)` and `Riddle? nextRiddle(List<Riddle> all)`.
- **Unlock rule (single source of truth, lives here):**
  - Riddle is unlocked iff (a) it's the first riddle in the first bucket, OR (b) the previous riddle in the same bucket is solved, OR (c) it's the first riddle in a bucket and every riddle in the previous bucket is solved.
  - Unit-tested in `test/progression_test.dart`.

### 2.11 `lib/data/models/app_settings.dart`
- Freezed: `themeMode` (enum), `soundEnabled` (bool), `hapticsEnabled` (bool), `firstLaunch` (bool).

### 2.12 `lib/data/repositories/riddle_repository.dart`
- **Public:** abstract `RiddleRepository { Future<List<Riddle>> loadAll(); Future<Riddle?> byId(String id); }` and `class LocalRiddleRepository implements RiddleRepository`.
- **Behavior:** Loads `assets/data/riddles.json` and (if present) `assets/data/riddles_diagrams_samples.json` via `rootBundle.loadString`, parses once, caches in memory. `byId` is O(1) via internal map.

### 2.13 `lib/data/repositories/progress_repository.dart`
- abstract `ProgressRepository { load(), save(p), reset() }`, `class SharedPrefsProgressRepository`.
- Persists JSON-encoded `Progress` under `mr.progress.json` plus `mr.progress.version = 1` for future migrations.

### 2.14 `lib/data/repositories/settings_repository.dart`
- abstract + `SharedPrefsSettingsRepository`.

### 2.15 `lib/data/services/hint_service.dart`
- **Public:**
  ```dart
  abstract class HintService {
    /// Returns true if the user is permitted to see the hint for [riddleId].
    Future<bool> requestHint(String riddleId);
  }
  class FreeHintService implements HintService {
    @override Future<bool> requestHint(_) async => true;
  }
  // Later: class RewardedAdHintService implements HintService { ... }
  ```

### 2.16 `lib/data/services/audio_service.dart`
- Wraps `audioplayers`. Preloads the three SFX. Respects `SettingsState.soundEnabled`. Public: `playCorrect`, `playWrong`, `playTap`, `dispose`.

### 2.17 `lib/providers/app_state.dart`
- **Public:** `class AppState extends ChangeNotifier` aggregating cross-feature state holders (riddles + progress + settings + stats). Wraps `RiddleRepository`, `ProgressRepository`, `SettingsRepository` injected via constructor.
- Exposes:
  - `AsyncValue<List<Riddle>> riddles`
  - `Progress progress`
  - `AppSettings settings`
  - `Stats get stats` (derived)
  - `bool isUnlocked(Riddle r)`
  - `Riddle? get nextUnsolvedRiddle` (helper for direct play)
  - `Future<void> markSolved(Riddle r, {bool hintUsed, int attempts})`
  - `Future<void> resetProgress()`
- Calls `notifyListeners()` on state mutations.

(Alternative: split into three `ChangeNotifier`s — `RiddlesState`, `ProgressState`, `SettingsState` — and register all under `MultiProvider`. Choose split if `AppState` exceeds ~250 lines. Default = single `AppState`.)

### 2.18 — 2.27 Feature presentation layer

| File | Purpose |
|---|---|
| `features/splash/presentation/splash_screen.dart` | 1s brand reveal, route based on first-launch flag |
| `features/onboarding/presentation/onboarding_screen.dart` | 3-page PageView; on finish set `firstLaunch=false`, go home |
| `features/home/presentation/home_screen.dart` | Centered "Math" branding and direct "Play" button (no AppBar) |
| `features/levels/presentation/levels_screen.dart` | (Secondary) 4-col grid of 20 tiles for selected bucket |
| `features/riddle/presentation/riddle_screen.dart` | Solve loop. Local `RiddleController extends ChangeNotifier` (per-route) holds typed answer + attempt count |
| `features/riddle/widgets/riddle_display.dart` | Dispatcher — `riddle.when(equation: ..., trianglePattern: ...)` |
| `features/riddle/widgets/equation_display.dart` | Tokenizes & renders letter-symbol equations using `riddleEquation` text style |
| `features/riddle/widgets/triangle_pattern_display.dart` | `CustomPainter` triangle outline + 3 `Positioned` `Text` widgets per triangle |
| `features/riddle/widgets/numpad.dart` | 12-key custom numpad + Submit row |
| `features/riddle/widgets/hint_panel.dart` | Bottom sheet showing the hint |
| `features/riddle/widgets/result_dialog.dart` | "Correct!" or wrong-answer feedback |
| `features/stats/presentation/stats_screen.dart` | Pure UI over `AppState.stats` |
| `features/settings/presentation/settings_screen.dart` | Toggles, reset progress, about, share app |

---

## 3. Provider Wiring (root)

```dart
// lib/app.dart
return MultiProvider(
  providers: [
    Provider<RiddleRepository>(create: (_) => LocalRiddleRepository()),
    Provider<ProgressRepository>(create: (_) => SharedPrefsProgressRepository()),
    Provider<SettingsRepository>(create: (_) => SharedPrefsSettingsRepository()),
    Provider<HintService>(create: (_) => FreeHintService()),
    Provider<AudioService>(create: (_) => AudioService()),
    ChangeNotifierProvider<AppState>(
      create: (ctx) => AppState(
        riddles: ctx.read<RiddleRepository>(),
        progress: ctx.read<ProgressRepository>(),
        settings: ctx.read<SettingsRepository>(),
      )..init(),
    ),
  ],
  child: MaterialApp.router(...),
);
```

To swap to ads later: replace `Provider<HintService>(create: (_) => FreeHintService())` with `Provider<HintService>(create: (_) => RewardedAdHintService(...))`. UI is untouched.

---

## 4. Riddle Parser & Evaluator (rules)

The parser is small (~120 lines) and lives in `lib/core/utils/equation.dart` (see §2.7).

**Why a parser:** keeps the riddle JSON human-authorable (we hand-write a string instead of nested arrays), and gives a unit-testable evaluator independent of the UI.

**The riddle answer is computed at authoring time and stored in the `answer` field.** The runtime never solves the equation system. It only:
1. Renders the `givens` and `question` strings.
2. Compares the user's typed integer to `riddle.answer`.

This intentionally removes a class of "wrong on user device" bugs from a runtime solver.

**Triangle riddles** don't need the parser; the renderer just reads `triangles[*].left`, `.right`, `.bottom`.

---

## 5. Build Phases (sequential, one per agent session)

Each phase fits in a ~30-min Antigravity session. Do all of phase N before starting phase N+1. Use the prompt template in `agents.md` §9.

| Phase | Scope (files) | Output |
|---|---|---|
| 0 | `flutter create`, `pubspec.yaml`, `analysis_options.yaml`, folder skeleton, drop in `assets/data/riddles.json` and `riddles_diagrams_samples.json`. | `flutter run` shows blank scaffold. |
| 1 | `core/constants/`, `core/theme/`, `core/utils/equation.dart`, `data/models/riddle.dart` (+ generated). Tests: `parser_test.dart`. | `flutter test` green for parser. |
| 2 | `data/models/progress.dart`, `app_settings.dart`, all three repositories, JSON loader. Tests: `progression_test.dart`, `repository_test.dart`. | All repo tests green. |
| 3 | `providers/app_state.dart`, `core/routing/app_router.dart`, `app.dart`, `main.dart`, `features/splash/`, `features/home/`. | App launches → Home with 5 difficulty cards (only Easy unlocked). |
| 4a | `features/levels/` grid. | Tap on Easy card opens 20-tile grid; only tile 1 active. |
| 4b | `features/riddle/` solve loop without polish (numpad, equation_display, dispatcher, basic correct/wrong logic, save progress on solve). | End-to-end solve loop functional. |
| 5 | Polish: `triangle_pattern_display.dart` (renders the 5 sample diagrams), `hint_panel.dart`, `result_dialog.dart` (with confetti), `audio_service.dart` wired in, haptics. | Polished solve loop. |
| 6 | `features/onboarding/`, `features/stats/`, `features/settings/`. | All screens complete. |
| 7 | App icon, splash artwork, audio assets dropped in. ProGuard rules. Release config. Keystore wiring. | Release AAB builds and installs. |
| 8 | Manual QA on real devices; fix P0/P1s from `summary.md` smoke-test checklist. | Ready for closed testing on Play Store. |

---

## 6. Test Strategy (lean — v0 only)

Write only:

1. **`test/parser_test.dart`** — tokenize and evaluate covers `+`, `-`, `×`, `÷`, mixed precedence, unknown handling, whitespace, malformed input, single-letter symbols A–H, `A×A` self-multiplication.
2. **`test/progression_test.dart`** — unlock rule for all four states (first riddle, mid-bucket locked, mid-bucket unlocked, first of next bucket).
3. **`test/repository_test.dart`** — round-trip serialize/deserialize Progress; reset clears all keys; settings round-trip.

Skip widget tests for v0 (per `agents.md` §8).

---

## 7. Performance Budget

- Cold start: < 2s on a low-end Android 10 / 4GB device.
- App size: < 25 MB AAB (with R8, no font subsetting).
- Riddle screen: < 100ms from tap to render.
- Memory: < 120 MB steady on Riddle screen.

---

## 8. App-Specific Failure Modes

- **`rootBundle.loadString` fails:** show retry screen; do not crash.
- **Riddle JSON parse error:** debug = throw with offending id; release = skip that riddle, log via `debugPrint`.
- **SharedPreferences write fails:** swallow + log; do not surface to user. Will retry on next solve.
- **Audio file missing:** `AudioService` swallows + logs; UI continues. Do not block solve loop on audio.
- **Confetti heavy on low-end:** if cold-start budget breached on Android 6/7, replace `confetti` with hand-rolled `CustomPainter` (cheap to do).
- **Triangle widget overflow on narrow screens:** clamp triangle width to 90 px min; use `FittedBox` on the row.

---

## 9. App-Specific "Things The Agent Must NOT Do"

Generic anti-patterns are in `agents.md` §13. App-specific additions:

1. **Do not regenerate `riddles.json` or `riddles_diagrams_samples.json`** — they are the human's content.
2. **Do not skip the `displayType` field** in JSON — it's the discriminator for the Freezed union.
3. **Do not embed business logic (unlock rules) in widgets** — they live in `progress.dart` so they're testable.
4. **Do not add a runtime equation solver** — `riddle.answer` is authoritative.
5. **Do not introduce a second state library** — Provider only.
6. **Do not change `kSchemaVersion`** without flagging — it's a migration anchor.

---

## 10. Backend-Readiness Checklist

These rules ensure backend can be added later without UI rewrites:

1. All data access goes through abstract repositories (`RiddleRepository`, `ProgressRepository`). Providers / UI depend on the abstraction, never on the local impl.
2. `LocalRiddleRepository` reads from `assets/data/*.json`. Future `RemoteRiddleRepository` will read from REST/Firestore with the same method signatures.
3. Riddle ids are stable strings (`easy_01`, `tri_sample_04`). No list-index references anywhere.
4. Progress is keyed by riddle id. Migrating local → remote is one binding change in the root MultiProvider.
5. No business logic in widgets — it lives in `progress.dart` and `app_state.dart` so it's portable across data sources.
6. JSON shape matches the model 1:1 — backend serves the same shape.
7. Optional `minAppVersion` per riddle (string) so backend rollouts can include content older clients don't render yet (read by the loader; riddles with a `minAppVersion` newer than `package_info_plus` version are silently skipped).

---

*End of architecture.md. Pair with `agents.md` (engineering practices), `tokenUsageGuide.md` (session protocol), `design.md` (visual), `projectOverview.md` (product scope), and `summary.md` (current state).*
