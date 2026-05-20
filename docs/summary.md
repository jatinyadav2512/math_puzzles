# summary.md - Build State Snapshot

> **Update this file at the end of every session and read it at the start.** Stale = useless. See `tokenUsageGuide.md` §5 for the protocol.

---

## Snapshot

- **Last updated:** 2026-05-04
- **Current phase:** Phase 8 - QA & Stabilization
- **Next session's first action:** Final production build and submission.
- **Build environment:** Local SDK is 3.2.6. Dependencies downgraded for compatibility.

---

## Done (✅)

- Phase 0: Bootstrap
  - Folder skeleton created.
  - Riddles JSON verified in `assets/data/`.
  - `pubspec.yaml` dependencies resolved (downgraded for Dart 3.2.6).
  - `analysis_options.yaml` configured.
  - `lib/app.dart` and `lib/main.dart` initialized.
- Phase 1: Theme + parser + tests
  - `core/constants/app_constants.dart` — app-wide constants.
  - `core/constants/asset_paths.dart` — centralised asset paths.
  - `core/theme/app_colors.dart` — semantic color tokens (light + dark).
  - `core/theme/app_text_styles.dart` — typography tokens (Inter + JetBrains Mono).
  - `core/theme/app_theme.dart` — Material 3 ThemeData builder.
  - `core/theme/app_spacing.dart` — 4-pt spacing scale.
  - `core/utils/equation.dart` — equation parser & PEMDAS evaluator.
  - `data/models/riddle.dart` — Freezed model with equation/trianglePattern union.
  - `test/parser_test.dart` — 27 tests, all green.
  - `analysis_options.yaml` updated to exclude generated files.
  - Skipped: Font assets (Inter, JetBrains Mono TTFs) — pending user drop-in.
- Phase 2: Repositories
  - `data/models/progress.dart` — Freezed `RiddleProgress` + `Progress` with unlock rule logic (`isUnlocked`, `nextRiddle`).
  - `data/models/app_settings.dart` — Freezed `AppSettings` (themeMode, soundEnabled, hapticsEnabled, firstLaunch).
  - `data/repositories/riddle_repository.dart` — abstract `RiddleRepository` + `LocalRiddleRepository` (loads from bundled JSON, caches in memory, O(1) `byId`).
  - `data/repositories/progress_repository.dart` — abstract `ProgressRepository` + `SharedPrefsProgressRepository` (JSON-encoded progress, schema version key).
  - `data/repositories/settings_repository.dart` — abstract `SettingsRepository` + `SharedPrefsSettingsRepository` (individual SharedPreferences keys).
  - `build.yaml` — enabled `explicit_to_json: true` globally for nested Freezed serialization.
  - `test/progression_test.dart` — 16 tests: unlock rules (all 4 states), nextRiddle, RiddleProgress/Progress serialization round-trips.
  - `test/repository_test.dart` — 11 tests: ProgressRepo (round-trip, reset, corrupted data, schema version), SettingsRepo (round-trip, defaults, invalid themeMode), AppSettings serialization.
  - All 54 tests green. `flutter analyze` — no issues found.
  - Skipped: nothing.
- Phase 3: App shell + Splash + Home
  - `providers/app_state.dart` — `AppState` ChangeNotifier: aggregates riddles + progress + settings, exposes derived `Stats`, bucket helpers, mutation methods with persistence.
  - `core/routing/app_router.dart` — GoRouter with splash + home routes; levels/riddle routes stubbed for Phase 4.
  - `features/splash/presentation/splash_screen.dart` — 900ms brand reveal, scale-in animation, auto-navigate to home.
  - `features/home/presentation/home_screen.dart` — 5 DifficultyCards with accent stripe, progress bar, lock/chevron, loading + error states.
  - `data/services/hint_service.dart` — abstract `HintService` + `FreeHintService` (always-allow for v0).
  - `app.dart` — rewritten with full MultiProvider wiring (repos, HintService, AppState) + `MaterialApp.router` with theme reactivity.
  - `main.dart` — async startup with portrait lock.
  - All 54 tests green. `flutter analyze` — no issues found.
  - Skipped: onboarding redirect (deferred to Phase 6), Stats/Settings navigation (Phase 6), levels navigation (Phase 4a).
- Phase 4a: Levels grid
  - `features/levels/presentation/levels_screen.dart` — 4-col `GridView` of bucket tiles; 3 states: solved (green + check), current (glow border + 1.04× pulse), locked (muted + lock icon, 0.55 opacity). Locked tile tap → snackbar. Respects `reduceMotion`.
  - `core/routing/app_router.dart` — levels route activated (`:bucketIndex` path param parsed to `LevelsScreen`).
  - `features/home/presentation/home_screen.dart` — DifficultyCard onTap now pushes `/levels/$bucketIndex`.
  - All 54 tests green. `flutter analyze` — no issues found.
  - Skipped: riddle navigation from tile tap (Phase 4b).
- Phase 4b: Riddle solve loop
  - `features/riddle/presentation/riddle_screen.dart` — full solve screen: givens block (card for multi, bare for single), question with `?` highlighted in `brandPrimary`, answer field (72h, 2px border, accent on input), shake animation on wrong (4 oscillations ±8px / 250ms), correct dialog with explanation + Next/Back actions, haptic feedback (heavy on correct, light on wrong), inline hint card with lightbulb icon.
  - `_Numpad` — 4×3 digit grid + Clear/0/Backspace row + full-width Submit pill. `surfaceMuted` keys, ink ripple, disabled submit when empty.
  - `_TriangleGivensBlock` — placeholder for triangle `CustomPainter` (Phase 5).
  - `core/routing/app_router.dart` — riddle route activated (`:riddleId` path param parsed to `RiddleScreen`).
  - `features/levels/presentation/levels_screen.dart` — tile onTap now pushes `/riddle/$riddleId`.
  - All 54 tests green. `flutter analyze` — no issues found.
  - Skipped: confetti overlay (Phase 5), audio playback (Phase 5), triangle CustomPainter (Phase 5).
- Phase 5: Polish
  - `core/utils/haptics.dart` — lightweight wrapper checking `hapticsEnabled` before calling `HapticFeedback`.
  - `data/services/audio_service.dart` — wraps `audioplayers` for tap/correct/wrong sounds, checking `soundEnabled`.
  - `features/riddle/presentation/riddle_screen.dart` — added `ConfettiWidget` overlay in `Stack`.
  - `features/riddle/presentation/riddle_screen.dart` — updated `_TriangleGivensBlock` to use `CustomPainter` (`_TrianglePainter`) with `Stack` and `Positioned` to draw Triangle layout exactly as designed.
  - `app.dart` — added `AudioService` into `MultiProvider`.
  - All 54 tests green. `flutter analyze` — no issues found.
  - Skipped: actual mp3 files.
- Phase 6: Onboarding + Stats + Settings
  - `features/onboarding/presentation/onboarding_screen.dart` — 3-page PageView with icon placeholders, "Get Started" cta, and `firstLaunch` logic.
  - `features/stats/presentation/stats_screen.dart` — Progress ring (CircularProgressIndicator) + bucket-wise breakdown list + hints/streak summary.
  - `features/settings/presentation/settings_screen.dart` — Theme segmented control (System/Light/Dark), Sound/Haptics switches, Reset Progress button with confirmation dialog.
  - `core/routing/app_router.dart` — added routes for `/onboarding`, `/stats`, `/settings`.
  - `features/splash/presentation/splash_screen.dart` — added gating to `/onboarding` if `firstLaunch` is true.
  - `features/home/presentation/home_screen.dart` — added Stats and Settings icon buttons to the AppBar.
  - All 54 tests green. `flutter analyze` — no issues found.
- Phase 7: Release Assets & Configuration
  - Configured `flutter_launcher_icons` and `flutter_native_splash`.
  - Upgraded Android `compileSdkVersion` to 34.
  - Integrated `url_launcher` for Privacy Policy, Rate Us, and Share App.
- Phase 8: QA & Stabilization
  - **Layout Fix:** Resolved `double.infinity` width crash in `FilledButton` global theme. Changed `Size.fromHeight(56)` to `Size(0, 56)` to prevent overflow in `Row` layouts (Onboarding footer).
  - **Sliver Stability:** Added `ValueKey` to `_DifficultyCard` and `_LevelTile` to resolve `indexOf(child) > index` assertion failures in `GridView`/`ListView`.
  - **Null Safety:** Removed all remaining `!` (bang) operators across the entire `lib/` directory. Replaced with `??` fallbacks and local non-nullable variables.
  - **Manifest Update:** Enabled `android:enableOnBackInvokedCallback="true"` for Android 14 compatibility.
  - **Data Integrity:** Fixed missing `bucketIndex`/`orderInBucket` in diagram samples JSON.
  - All 54 tests green. `flutter analyze` — no issues found.

---

## In Progress (🟡)

*(empty)*

---

## Next Up (📋)

Listed in build order. Each item is sized for one Antigravity session.

1. ~~Phase 0 - Bootstrap~~ ✅
2. ~~Phase 1 - Theme + parser + tests~~ ✅
   - Create empty placeholder files for the folder structure in `agents.md` §4.
   - `flutter pub get` + `flutter run` should display an empty white screen.
2. Phase 1 - Theme + parser + tests (per `agents.md` §7).
3. ~~Phase 2 - Repositories~~ ✅
4. ~~Phase 3 - App shell + Splash + Home~~ ✅
5. ~~Phase 4a - Levels grid~~ ✅
6. ~~Phase 4b - Riddle solve loop~~ ✅
7. ~~Phase 5 - Polish (audio, haptics, hint, confetti)~~ ✅
8. ~~Phase 6 - Onboarding + Stats + Settings~~ ✅
10. Phase 8 - QA & Stabilization ✅
11. Phase 9 - Production Build & Submission.

---

## Decisions Log

(Source: `projectOverview.md` §2. Anything new added during build goes here AND in §2.)

| Date | Decision | Rationale |
|---|---|---|
| 2026-05-03 | Visual symbol equations (no word problems) | Matches reference app, mobile-friendly, parser-tractable |
| 2026-05-03 | Hint system only for v0 (no hearts/coins/skip) | Tightest scope; ad-gating later via `HintService` swap |
| 2026-05-03 | Strict linear within bucket; bucket gate | Clearest user model; matches reference app |
| 2026-05-03 | 100 riddles (down from 200) | Faster to author + ship; v0.2 can add more |
| 2026-05-03 | Riverpod + go_router locked | Prevents agent re-litigation |
| 2026-05-03 | English only for v0 | ARB scaffolding present; languages added later by editing files only |
| 2026-05-03 | Onboarding included in v0 | Reference app's biggest UX gap is no onboarding |
| 2026-05-03 | Sound + haptics + Settings + Stats included in v0 | All cheap; meaningful retention impact |
| 2026-05-03 | Letter-variable symbols (A, B, C…) instead of emoji | Cleaner UI, no Unicode-rendering risk on older Android, reads like algebra |
| 2026-05-03 | Schema extended with `displayType` (`equation` \| `trianglePattern`) | Supports diagram-style riddles (triangles, circles, hexagons later) without schema break |
| 2026-05-03 | State management = `provider` (not `flutter_riverpod`) | Lower cognitive load, larger AI training corpus; DI swap pattern still works for HintService |
| 2026-05-03 | Split `agents.md` (generic, reusable) + `architecture.md` (app-specific) | Reusable engineering-practices doc carries to next projects; per-file specs stay locally where they save the most build-time tokens |
| 2026-05-03 | `tokenUsageGuide.md` made fully generic too | Forms a 2-file portable bundle (`agents.md` + `tokenUsageGuide.md`) usable on every future AI-driven build |

---

## Open Questions (❓)

*(Surfaced by the agent during a session, answered by Jatin.)*

| Date raised | Question | Where (file:line) | Answer |
|---|---|---|---|
| 2026-05-03 | Local Dart SDK (3.2.6) mismatch with pinned packages (requires 3.4.0+). Downgrade packages or upgrade SDK? | `pubspec.yaml` | Resolved: Downgraded packages. |
| 2026-05-03 | Final ASO name? Math Riddles- Logic Puzzles | `app_constants.dart` (appName) | Resolved: "Math Riddles- Logic Puzzles" |
| 2026-05-03 | Privacy policy URL | `app_constants.dart` (privacyPolicyUrl) | Resolved: Google Docs link. |
| 2026-05-03 | Audio file source | `assets/audio/*.mp3` | *Pending - download from mixkit.co* |
| 2026-05-03 | App icon design | `assets/images/icon.png` | *Pending - need 1024×1024 PNG* |
| 2026-05-03 | Onboarding illustrations | `assets/images/onboarding/*.png` | *Pending - need 3× 1080×1080 PNGs* |
| 2026-05-03 | Splash artwork | `assets/images/splash.png` | *Pending - 1242×2436 PNG* |

---

## Smoke Test Checklist (run before each release candidate)

- [ ] App launches; splash → home (or onboarding on first launch).
- [ ] Onboarding shows once; skipping persists.
- [ ] All 5 difficulty cards render with correct progress (0/20 first run).
- [ ] Only Easy bucket is unlocked initially.
- [ ] Solve riddle 1 → riddle 2 unlocks.
- [ ] Solve all 20 in a bucket → next bucket unlocks.
- [ ] Hint panel shows the riddle's hint text.
- [ ] Wrong answer triggers shake + sound + snackbar.
- [ ] Correct answer triggers confetti + sound + dialog.
- [ ] Stats screen reflects solved count.
- [ ] Settings: theme switching takes effect immediately.
- [ ] Settings: sound and haptics toggles disable both globally.
- [ ] Settings: reset progress wipes everything but keeps onboarding-seen flag.
- [ ] Background and foreground the app mid-riddle - state preserved.
- [ ] Kill and relaunch the app - solved riddles still solved.
- [ ] Release AAB builds; no analyzer warnings; tests green.
- [ ] Dark mode renders cleanly across all screens.
- [ ] Test on Android 6 (minSdk) and Android 14 device.

---

## Known Issues / Risks

- *(none yet)*

---

## Useful Commands (cheat sheet)

```bash
# Setup
flutter create --org com.<yourorg> --project-name math_riddles .
flutter pub get

# Codegen (after model edits)
dart run build_runner build --delete-conflicting-outputs

# Quality
flutter analyze
flutter test

# Run
flutter run                                  # debug on attached device
flutter run --release                        # release on attached device

# Build
flutter build apk --release                  # APK
flutter build appbundle --release            # AAB for Play Store

# Asset generation
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

---

*End of summary.md. Update at every session boundary - this is what makes the build feel continuous.*
