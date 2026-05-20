# design.md - Visual & Interaction Design Spec

> Written from the perspective of a senior product designer briefing an engineer. Every value here is a hard spec the agent must follow. When in doubt, prefer restraint over flourish - this is a math app for thinking, not a slot machine.

---

## 1. Design Principles

1. **Calm focus.** The riddle is the protagonist. Everything else fades.
2. **Confident hierarchy.** One primary action per screen; never two equally-weighted CTAs.
3. **Generous whitespace.** Touch targets are large. Text breathes. Density is for spreadsheets.
4. **Motion as feedback, not decoration.** Animations communicate state changes (correct, wrong, unlock). They never play just to look nice.
5. **Material 3, not custom.** Lean on `useMaterial3: true`. Override only what design demands. The agent is faster, the user gets familiar interactions.
6. **Dark-Only Theme.** The app exclusively uses a premium dark palette to maintain a high-focus, high-contrast environment. Light mode is intentionally excluded to simplify the aesthetic and emphasize the "brain-training" focus.

---

## 2. Brand Identity

- **Name:** Math Riddles (display); ASO title separate (see `projectOverview.md` §3).
- **Voice:** Friendly tutor. Not a clown, not a drill sergeant.
- **Tagline:** *"Train your brain, one riddle a day."*
- **Logo concept (for the icon designer):** A bold question mark formed by stacked equation symbols, on a brand-purple gradient. Square, no text on icon (Play Store strips it anyway).
- **Personality words:** thoughtful, playful, clean, modern.

---

## 3. Color System

All values below are exact hex. The agent encodes them in `lib/core/theme/app_colors.dart` as `static const`.

### 3.1 Brand
| Token | Hex | Use |
|---|---|---|
| `brandPrimary` | `#6C5CE7` | Primary buttons, key accents, brand surfaces |
| `brandPrimaryDark` | `#5546C7` | Pressed state of brand primary |
| `brandSecondary` | `#00C2A8` | Secondary accents, success accents |

### 3.2 Light Theme (`AppColors.light`)
| Token | Hex | Use |
|---|---|---|
| `background` | `#F7F7FB` | Scaffold background |
| `surface` | `#FFFFFF` | Cards, app bar |
| `surfaceMuted` | `#EEEEF6` | Tile backgrounds, subtle containers |
| `onBackground` | `#1A1A2E` | Primary text |
| `onSurface` | `#1A1A2E` | Text on cards |
| `onSurfaceMuted` | `#5A5A78` | Secondary text |
| `divider` | `#E3E3EE` | Hairlines |
| `success` | `#19B26B` | Correct answer, solved tile check |
| `error` | `#E5484D` | Wrong answer, destructive button |
| `warning` | `#F5A524` | Hint indicator |
| `lockedTile` | `#D6D6E0` | Locked level tile background |
| `solvedTile` | `#DCF7E8` | Solved level tile background |
| `currentTileGlow` | `#6C5CE7` | Ring/glow color for the active tile |

### 3.3 Dark Theme (`AppColors.dark`)
| Token | Hex | Use |
|---|---|---|
| `background` | `#0F1020` | Scaffold background |
| `surface` | `#1A1B33` | Cards, app bar |
| `surfaceMuted` | `#23253F` | Tile backgrounds |
| `onBackground` | `#F2F2F7` | Primary text |
| `onSurface` | `#F2F2F7` | Text on cards |
| `onSurfaceMuted` | `#A0A0BB` | Secondary text |
| `divider` | `#2C2E48` | Hairlines |
| `success` | `#3BD986` | Correct answer |
| `error` | `#FF6B6B` | Wrong answer |
| `warning` | `#FFB454` | Hint indicator |
| `lockedTile` | `#2A2C46` | Locked tile |
| `solvedTile` | `#1F3A2C` | Solved tile |
| `currentTileGlow` | `#9C8CFF` | Ring/glow on dark |

### 3.4 Difficulty Accents (per bucket, used on Home cards & in Levels header)
| Bucket | Light hex | Dark hex |
|---|---|---|
| Easy | `#19B26B` | `#3BD986` |
| Medium | `#3FA7FF` | `#7CC4FF` |
| Hard | `#A06BFF` | `#C09EFF` |
| Expert | `#FF8A3D` | `#FFB370` |
| Master | `#E5484D` | `#FF7B7F` |

These are visual cues only; they never carry semantic state (success/error remain the canonical green/red).

### 3.5 Color contrast guarantee
Every text/background pair above meets WCAG AA (4.5:1 for body, 3:1 for large text). The agent should `assert` this in a small unit test if it's quick; otherwise trust the spec.

---

## 4. Typography

Use **Inter** as the primary type family (free, ships well, renders crisply at all sizes). For numerals on the riddle screen, use **JetBrains Mono** (or a similar monospaced font) so that digits have equal width and align.

Add the fonts via `google_fonts` package OR ship them as font assets. **Recommended:** ship as assets (avoids the network fetch on first launch). Drop `Inter-*.ttf` and `JetBrainsMono-*.ttf` into `assets/fonts/` and register in `pubspec.yaml`.

Type scale (encoded in `lib/core/theme/app_text_styles.dart`):

| Token | Family | Size / Line / Weight | Used on |
|---|---|---|---|
| `displayLarge` | Inter | 32 / 40 / 700 | Splash app name, big headlines |
| `headline` | Inter | 24 / 32 / 700 | Screen titles in app bar (centered when alone) |
| `title` | Inter | 18 / 24 / 600 | Card titles, dialog titles |
| `body` | Inter | 16 / 24 / 400 | Default body text |
| `bodyEmphasis` | Inter | 16 / 24 / 600 | Emphasized body |
| `caption` | Inter | 13 / 18 / 400 | Helper text, footer notes |
| `riddleEquation` | JetBrains Mono | 28 / 36 / 500 | The given equations & question on riddle screen |
| `riddleAnswer` | JetBrains Mono | 36 / 44 / 700 | Big answer field |
| `numpadKey` | JetBrains Mono | 24 / 32 / 600 | Numpad digits |
| `tileNumber` | JetBrains Mono | 18 / 24 / 600 | Level tile riddle number |

All styles inherit color from theme (`onBackground` / `onSurface` as appropriate); the styles themselves do not hardcode color.

---

## 5. Spacing, Radius, Elevation

### Spacing scale (4-pt base)
`s1=4`, `s2=8`, `s3=12`, `s4=16`, `s5=20`, `s6=24`, `s7=32`, `s8=40`, `s9=48`, `s10=64`.

Encoded in `lib/core/theme/app_spacing.dart` as `class AppSpacing { static const double s1 = 4; ... }`.

Default screen horizontal padding: `s5` (20). Vertical section gap: `s6` (24).

### Radius
- Buttons: 14
- Cards / tiles: 16
- Bottom sheets: 24 (top corners)
- Pill chips (e.g. progress bar pill): 999 (fully rounded)
- Numpad keys: 16

### Elevation (Material 3 tonal)
- Cards: 1 (`surfaceContainerLow`)
- AppBar: 0 (flat)
- Bottom sheets: 3
- Dialogs: 3
- Floating action: not used in v0

Shadows are minimal. Rely on subtle background-elevation contrast.

---

## 6. Iconography

- Use `Icons.*` (Material) for system icons: back arrow, settings gear, stats chart, lock, check.
- Use the `lucide_icons` package only if a specific Lucide glyph is meaningfully better than the Material equivalent. Default is Material; introducing a second icon font has a binary-size cost.
- Icon size: 24 default. 20 in compact contexts. 32 in section headers.
- Hint icon: `Icons.lightbulb_outline` (idle) → `Icons.lightbulb` filled (hint visible). Color: `warning`.

Symbol set (the things in the riddles): use Unicode emoji from the OS - no custom icon set in v0. The riddles in `riddles.json` use only **Unicode 6.0 / pre-2014 emoji** so they render correctly on Android 6.0+ without `EmojiCompat`:
`🍎 🍌 🥥 🍒 🍇 🍊 🍓 🍐 🍋 🍑 ⭐ 🔺 🔵 🌳 🌽 💎 ❤️ ⚽ 🎈 🎁 💰 🔑 🎲 ⚓ 🌙`

**Why this list, specifically:** Unicode 12+ emoji (like the colored squares 🟢🟡🟣 introduced 2019) and Unicode 13+ emoji (🪙 the coin, 2020) render as "tofu" boxes on Android 6-10 without the AndroidX `EmojiCompat` downloadable font wired in. To keep v0 dependency-light and ship to all minSdk-23 devices cleanly, we use only the older codepoints. If you ever want richer/cuter art, replace this set with bundled SVGs keyed by canonical name (e.g. `apple.svg`, `green_circle.svg`) — the JSON schema doesn't change.

---

## 7. Per-Screen Layout Specs

Coordinates are described top-down. All values reference the spacing scale.

### 7.1 Splash
- Solid `background` color.
- Centered: app icon (96×96) above app name (`displayLarge`). Gap `s4` between.
- Optional: subtle scale-in animation on icon (200ms ease-out from 0.9 to 1.0). Duration of screen: 900ms total.

### 7.2 Onboarding
Each page:
- Top: skip button (top-right, body, `onSurfaceMuted`).
- Center: illustration (60% of screen height max).
- Below illustration: headline (`headline`), gap `s3`, subline (`body`, `onSurfaceMuted`, max 2 lines, centered).
- Bottom: page indicator dots (8×8, gap `s2`) + Next button (full width, brandPrimary, height 56, radius 14, label `body` weight 600).

Last page CTA reads "Get Started" instead of "Next".

### 7.3 Home
- AppBar: app name centered (`title`). Trailing actions: Stats icon, Settings icon, gap `s2`. No leading icon.
- Body: vertical list, padding `s5` horizontal, `s4` between cards.
- DifficultyCard:
  - Height 96.
  - Padding `s5`.
  - Border-radius 16, surface background.
  - Left vertical accent stripe (4px wide, full card height, color = bucket accent).
  - Layout: bucket name (`title`), gap `s1`, "x / 20 solved" (`caption`, muted). Below: progress bar (4px tall, full card width minus `s5` right padding, 999 radius, `surfaceMuted` track + bucket-accent fill).
  - Right side: chevron (`Icons.chevron_right`) for unlocked; lock icon for locked. Locked card opacity 0.55.

### 7.4 Levels
- AppBar: back arrow, bucket name (centered, `headline`, color = bucket accent), trailing progress text (`caption`, e.g. "12 / 20").
- Body: 4-column grid. Tile size: ~72×72 (let `GridView.count` divide width). Spacing `s3`. Padding `s5`.
- LevelTile:
  - Solved: `solvedTile` background, success-colored check icon (24), riddle number (`tileNumber`) below (or to right of icon).
  - Current: `surface` background, 2px border in `currentTileGlow`, riddle number centered, soft pulse animation (1200ms loop, scale 1.0 ↔ 1.04).
  - Locked: `lockedTile` background, lock icon (20), opacity 0.55, no riddle number.
- Tap on locked: snackbar "Solve riddle X first." (use the previous unlocked riddle's number).

### 7.5a Riddle - Triangle Pattern variant (`displayType: "trianglePattern"`)
- AppBar identical to the equation variant.
- Body, top to bottom:
  1. Caption row (`caption`, muted, centered): "Find the missing number."
  2. **Triangle row** — three triangles centered, equal-spaced, each ~28% of screen width. Triangle outline stroke `onSurfaceMuted` 2px, no fill. Numbers rendered:
     - `left` at the top-left vertex (small offset outside the line, `riddleEquation` size).
     - `right` at the top-right vertex (mirror placement).
     - `bottom` at the bottom-center vertex below the line. Renders `?` in `brandPrimary` if `null`.
  3. The remaining body (answer field + numpad) is identical to the equation variant.
- The triangle is drawn entirely in code via `CustomPainter` (single-color stroke, no fill). No PNG, SVG, or image asset is shipped. This same pattern extends to circles, squares, etc. for future diagram types.

### 7.5 Riddle
- AppBar: back arrow, "Riddle 7 / 20" (centered, `title`), trailing Hint icon (`warning` color when available).
- Body, padding `s5` horizontal, scrollable column (in case of small screens or many givens):
  1. **Givens block** (gap `s5` from app bar). Card with `surfaceMuted` background, radius 16, padding `s4`. Each given equation on its own row using `riddleEquation`. Rows separated by gap `s2`. If only one given, no card chrome - render directly.
  2. Gap `s6`.
  3. **Question equation** (`riddleEquation`, centered, color `onSurface`). The `?` is rendered in `brandPrimary` and slightly larger.
  4. Gap `s5`.
  5. **Answer field**. Centered card. Min width 160, height 72, radius 16, border 2px in `divider`. Shows typed digits in `riddleAnswer`. Empty state: faint placeholder `?`.
  6. Gap `s6`.
  7. **Numpad**. Always visible, pinned to bottom.
- Numpad layout:
  - 4 rows × 3 cols, plus a full-width Submit row beneath.
  - Each digit key: 64 high, equal width (use `Expanded`), radius 16, `surfaceMuted` background, `numpadKey` text, ripple on tap.
  - Backspace: `Icons.backspace_outlined`, same sizing as digits, slightly muted color.
  - Submit row: full-width pill, height 56, radius 14, `brandPrimary` background when input non-empty (else `surfaceMuted` + disabled).

### 7.6 Hint Panel (bottom sheet)
- Drag handle at top.
- Header row: lightbulb icon (warning) + "Hint" (`title`).
- Hint text (`body`, color `onSurface`).
- "Got it" button (full-width, brandPrimary, height 48).
- Background: `surface`, top radius 24.

### 7.7 Result Dialog (correct)
- Confetti overlay covers full screen behind the dialog (60-frame burst, then fades). Use `confetti` package.
- Dialog: rounded 16, padded `s5`.
- Top: large success check (48px, `success` color).
- Title: "Correct!" (`title`).
- Below: explanation text (`body`).
- Actions: secondary "Back" (text button), primary "Next Riddle" (filled). If last in bucket: primary becomes "Back to Levels".
- Sound: `correct.mp3`. Haptic: `HapticFeedback.heavyImpact()` (success-style).

### 7.8 Result feedback (wrong) - no dialog
- Inline. The Answer field shakes (tween: x ±8 over 250ms).
- Sound: `wrong.mp3`. Haptic: `HapticFeedback.lightImpact()`.
- Snackbar: "Not quite - try again." (3s).

### 7.9 Stats
- Padding `s5`.
- Top card: large progress ring (140px) + center label "47 / 100" (`displayLarge`). Subtitle "Riddles solved" (`caption`).
- Below: 5 rows. Each row: bucket dot (12×12, accent color) + bucket name (`bodyEmphasis`) + count "12 / 20" right-aligned (`caption`).
- Footer two-up grid: "Hints used: N", "Streak: N days". `surface` cards, padding `s4`, radius 16.

### 7.10 Settings
- Padding `s5`. Sections separated by `s6` and a section header (`caption` muted, uppercase).
- Section: Appearance → Theme (segmented control: System / Light / Dark).
- Section: Feedback → Sound (switch), Haptics (switch).
- Section: Progress → Reset progress (text button, `error` color).
- Section: About → Version row, Privacy policy row, Rate us row, Share app row. Each row: title left, chevron right.
- Reset confirmation: AlertDialog, title "Reset progress?", body "This wipes your solved riddles and stats. This cannot be undone.", actions Cancel + Reset (Reset is `error` filled).

---

## 8. Motion

| Event | Animation | Duration |
|---|---|---|
| Splash → Home/Onboarding | Fade through black | 250ms |
| Page push (router) | Material default slide | 300ms |
| Onboarding page change | PageView default | system |
| Bucket card tap | Tap ripple + slight scale (1.0 → 0.98 → 1.0) | 200ms |
| Level tile (current) pulse | Scale 1.0 ↔ 1.04 | 1200ms loop, ease-in-out |
| Hint panel slide-up | Default `showModalBottomSheet` | system |
| Answer correct: confetti | 1200ms burst + 600ms fade | total 1800ms |
| Answer correct: dialog scale-in | 200ms ease-out | 200ms |
| Answer wrong: shake | 4 oscillations of 8px over 250ms | 250ms |
| Theme switch | `AnimatedTheme` | 250ms |

Reduce-motion accessibility: if `MediaQuery.disableAnimations` is true, skip the pulse, the shake, and the confetti.

---

## 9. Components Catalog

The agent should build these reusable widgets in `lib/core/widgets/` so screens compose them rather than redefining:

- `AppButton(label, onPressed, variant: primary|secondary|destructive, fullWidth)` - height 56 / 48 variants, radius 14, ink ripple.
- `AppCard(child, padding, onTap?)` - the standard surface container.
- `ProgressBar(value 0..1, color)` - 4px tall pill.
- `ProgressRing(value 0..1, size, strokeWidth, color)` - for stats screen.
- `BucketBadge(difficulty)` - colored dot + name.
- `EquationRow(text)` - tokenizer-driven rendering of a single equation.
- `Shaker(child, controller)` - imperative shake driver for the answer field.

These are tiny. Don't over-engineer them.

---

## 10. Accessibility

- All tappable items are at least 48×48.
- Color is never the only signal: locked tiles also have a lock icon; correct/wrong always also have text + sound.
- Large text scaling: layouts must survive `MediaQuery.textScaler` up to 1.4 without overflow. Use `FittedBox` on the riddle equations and the answer field.
- Semantics labels on icon buttons (`Hint`, `Back`, `Stats`, `Settings`).
- Disable haptics if the user toggles off; don't substitute aggressive sounds.

---

## 11. Empty / Error / Loading States

- **Loading riddles JSON (rare; only on cold start):** centered circular indicator with caption "Loading riddles…". Maximum visible duration ≤ 500ms in practice.
- **Riddles JSON failed to parse:** full-screen empty state with icon + "Couldn't load riddles" + Retry button. Should not happen in production - if it does it's our bug.
- **Stats screen with zero solves:** show ring at 0%, all bucket rows at 0/20, footer cards at 0. No need for a special empty state.
- **First time on Levels in a locked bucket:** unreachable by design. UI does not need to handle.

---

## 12. Tone of Microcopy

| Surface | Microcopy |
|---|---|
| Onboarding 1 headline | Welcome to Math Riddles |
| Onboarding 1 sub | 100 visual puzzles to flex your brain. |
| Onboarding 2 headline | How it works |
| Onboarding 2 sub | Each symbol is a number. Use the equations to find what's missing. |
| Onboarding 3 headline | Climb the difficulty |
| Onboarding 3 sub | Solve every riddle in a level to unlock the next. |
| Onboarding skip | Skip |
| Onboarding final CTA | Get started |
| Locked tile snackbar | Solve riddle X first. |
| Hint panel CTA | Got it |
| Wrong answer snackbar | Not quite - try again. |
| Correct dialog title | Correct! |
| Correct dialog primary | Next riddle |
| Reset confirm title | Reset progress? |
| Reset confirm body | This wipes your solved riddles and stats. This can't be undone. |
| Reset confirm CTA | Reset |

Keep copy in `lib/core/constants/strings.dart` as `static const`. Localizable in v0.x via ARB later.

---

## 13. Open Design Questions (to revisit before launch)

- Should the answer field be tappable to open the system keyboard as a fallback? *(Recommendation: no - the numpad is faster and avoids input mode confusion. Revisit if QA shows an accessibility need.)*
- Should the bucket accent color also tint the riddle screen subtly? *(Recommendation: only in a 2px top progress strip showing "riddle 7 of 20" progress within the bucket.)*
- Confetti on every correct answer, or only on bucket completion? *(Recommendation: keep on every solve in v0 - it's the dopamine moment. Revisit if users find it annoying.)*

These are intentionally not blocking; the spec gives clear defaults the agent should follow.

---

*End of design.md. The agent should have everything needed to build the UI from this file and `agents.md` alone.*
