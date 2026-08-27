# Project Context & Progress Document

## 1. Project Overview

* **Core Purpose:** A Flutter fitness app (Pilates/yoga focused) that takes a user
  from onboarding through a structured training plan and tracks what they
  actually did. Four content flows feed one shared workout player: **Programs**
  (phase → day → exercise), **Challenges** (week → day → exercise), **Body Focus**
  (body part → workout → session → exercise) and **Discover** (category →
  workout → exercise). Completed work is persisted locally and fed back into the
  Home banner ("what's next") and the Progress screen (totals, streak, history).
  All UI is implemented from a Figma file — `Fitness-App`, file key
  `DsoOQCKBfX5jXDNfnJIKZX`, designed on a 393×852 frame.

* **Tech Stack:**
  * Flutter / Dart 3 (dot-shorthand syntax in use, e.g. `.circular(20)`)
  * **Persistence:** `drift` + `drift_sqflite` + `sqflite` (codegen via
    `drift_dev` + `build_runner`); `shared_preferences` for legacy/simple keys
  * **Media:** `video_player`
  * **UI:** `flutter_svg`, `flutter_animate`, `cherry_toast`, `wave`,
    `flutter_shimmer_pro`, `flutter_confetti_plus`
  * **State:** `flutter_bloc` is a dependency but is **not yet used**; screens
    currently use `StatefulWidget` + `ValueNotifier`
  * **Platform/Infra:** Firebase (core, analytics, crashlytics, remote config,
    performance), `google_mobile_ads`, `in_app_purchase`, `easy_localization`,
    `connectivity_plus`, `url_launcher`
  * **Fonts:** `Nexa` (theme default, weights 100–900) and `NexaText`
    (Thin/Regular only)

* **Key Architecture:**
  * `lib/core/` — cross-cutting concerns.
    * `core/database/` — Drift schema (`app_database.dart` + generated
      `app_database.g.dart`) and `repositories/` (progress, settings, user
      profile). `AppDatabase.instance` is a singleton with
      `overrideInstance()` for tests.
    * `core/constants/` — `app_colors.dart`, `app_theme.dart`,
      `app_extension.dart` (`.heightBox` / `.widthBox` on `num`),
      `routes/nav_extension.dart` (`context.push(Widget)`, logs analytics).
    * `core/services/` — Firebase wrappers, `shared_prefrences/`,
      `user_info_storage.dart`.
    * `core/models/`, `core/network/`, `core/repositories/` — **empty
      directories**; the remote API layer has not been started.
  * `lib/features/<feature>/` — each feature owns `models/`, `services/`,
    `views/`, `widgets/`. Cross-feature reuse is deliberate and one-directional:
    `challenges` / `body_focus` / `workout` all import from `discover`
    (`ExerciseModel`, `ExerciseDetailScreen`, `DiscoverWorkoutCard`) and from
    `workout` (`DayModel`, `DayStatsCard`, `WorkoutRowCard`, `WorkoutAppBar`,
    `WorkoutHeroBanner`).
  * **Shared-component principle:** where two Figma nodes are the same component
    at a different size, the widget is parameterised rather than duplicated —
    `ChallengeCardWidget(scale:)` (113pt base × 1.5244 for the grid) and
    `DiscoverWorkoutCard(width:/height:/imageHeight:)` (224 rail vs 172.256
    grid).
  * **Data:** bundled JSON in `assets/json/` behind static repositories
    (`DiscoverRepository`, `WorkoutRepository`, `ChallengeRepository`,
    `BodyFocusRepository`), each shaped like the eventual API.
    `challenges.json` and `body_focus.json` keep a single exercise catalogue and
    have days reference it by id, resolved at load — this keeps them at ~250 KB
    and ~145 KB instead of megabytes.

## 2. Current System State

### Working Features

Implemented and verified (37 passing tests across
`test/progress_tracking_test.dart`, `test/progress_history_test.dart`,
`test/progress_layout_test.dart`, `test/exercise_duration_test.dart`,
`test/player_layout_test.dart` and `test/home_hero_banner_test.dart`;
`flutter analyze lib test` clean apart from one pre-existing warning):

* **Persistence layer** — Drift schema (v3) with six tables: `UserProfiles`,
  `WorkoutSettingsRows`, `PlanProgressRows`, `SessionLogs`, `ExerciseLogs`.
  Single-row tables are seeded on create so reads never return empty. v2 added
  `thumbnailUrl` (both log tables) and `dayLevel` (`SessionLogs`) behind an
  `onUpgrade` step, so history cards can render real artwork and
  "Day 2. Beginner"; v3 added `ExercisePreferences` (the per-exercise duration
  the detail screen's stepper caches).
* **Onboarding gate** — Splash routes on real state: returning users go straight
  to `BottomBarScreen`; only a profile that never finished the info flow sees
  onboarding. The user info flow persists on **every step** (mid-flow exit is not
  lost) and flips `onboardingComplete` only on the last one.
* **Progress tracking** — the player logs each exercise as it ends and the
  session on finish. Plan progress advances only on a *fully completed* day and
  never rewinds when an earlier day is replayed. Streak counts consecutive days
  and breaks on a gap.
* **Dynamic Home banner** — `NextUpService` resolves the most recently touched
  plan against real progress, walking phases as one flat list so a finished phase
  rolls over. After Day 1 completes the banner reads "Day 2 / Keep Going /
  Continue / Pilates Premier · Day 2 of 3 / 6min/8 Exercise", and its CTA opens
  that exact day.
* **Progress screen** — rebuilt to Figma 16:418 / 17:1159 and split into
  `features/progress/widgets/` (`ProgressStatsCard`, `ProgressChartCard`,
  `HistoryMonthCard`, `HistoryCard`). Real calories/minutes/workouts/streak on
  the 26pt tinted chips, an auto-scaling bar chart, a centred Duration/Calories
  pill, history grouped by month with the exercise thumbnail in the tile, and a
  working trash button (confirm → `deleteSession`, which never rewinds plan
  progress).
* **Period selector** — the pill (16:1099) drives the chart:
  `ProgressRepository.chartSeries` buckets This Week (7, Mon-first), This Month
  (one bar per day, labelled every fifth) and This Year (12 months).
* **History screen** — `history_view.dart` (Figma 17:1688) reads real logs,
  groups them into month panels newest-first, reuses `WorkoutAppBar` for the
  30x30 back tile and supports delete. No hardcoded rows left.
* **Workout settings** — persisted and consumed live by both the player and the
  exercise detail preview: countdown drives the Get Ready tick-down, and
  volume + the sound-effect toggle set playback volume through
  `SettingsRepository.watch()`, so a change made mid-workout applies at once.
* **Exercise detail screen** — one shared screen behind all four flows, with a
  "Start Now" footer that opens the shared player on that exercise
  (`PlayerSession.startingAt`) and still logs against the right plan. Its
  duration stepper seeds from the clip's own length, caches every change against
  the exercise (`ExercisePrefsRepository`), and the player then loops that clip
  for exactly that long before skipping on.
* **My Profile** — reads `UserProfileRepository`, so the height, weight and
  target weight collected in the info flow are shown back and edits persist.
  Metric is canonical; imperial is display-only (`profile/unit_conversion.dart`)
  so toggling units cannot drift the stored value.
* **Video player** — the clip plays in a rounded banner at its own aspect ratio
  above the sheet (`VideoBanner`), capped at 36% of the screen and narrowing
  rather than stretching when the cap bites. Full-bleed `VideoBackdrop` is still
  in the file but unused by the player: covering a 9:19.5 frame with a 16:9 clip
  cropped the exercise to a strip. Artwork fallback until the clip is ready;
  playback and the clock pause when the app leaves the foreground.
* **All UI screens from Figma** — 14 nodes implemented and geometry-verified at
  393×852: Home card (8:32), program flow (10:509, 11:738, 11:959), challenge
  flow (11:1397, 11:1744, 12:2319, 12:2424), player (11:1201, 11:1235, 11:1312),
  body focus (14:2, 14:242, 14:528, 15:765).

### In-Progress Work

* Nothing is mid-edit. **Everything is still uncommitted** — the persistence
  layer from the previous session plus this session's Progress/History rebuild.
  Last commit is `18369d8 UI Completeion`, which predates both.

### Known Blockers / Bugs

**Bugs**

* `test/widget_test.dart` **fails** — the stock Flutter counter smoke test
  committed in `0fe61de`, asserting on a counter this app never had. Broken since
  it landed; unrelated to current work. Delete or rewrite it.
* `flutter analyze lib` reports one warning: `_buildPlaceholderPage` unused in
  `lib/features/bottom_bar/bottom_bar_screen.dart:147`. Pre-existing.

**Not yet wired to real data**

* The **voice guide** toggle and the Detailed/Brief switch in workout settings
  persist but drive nothing — there is no TTS engine in the project, so no
  guidance is spoken. Only volume, the sound-effect mute and the countdown
  reach the player.
* `my_profile_screen.dart` shows height/weight/target weight but not the rest of
  the info-flow answers (goal, age, body shape, activities, injuries).
* The Progress screen's greeting ("Good Morning Emily") and its menu/bell
  buttons are still static — no name from `UserProfiles`, no destinations.

**Technical debt**

* `assets/images` is **26 MB**. Four Figma exports account for ~6.9 MB of it
  (`program_banner.png`, `challenge_banner.png`, `challenge_model.png`,
  `player_model.png`) — they are the exact ~1800px exports but never render wider
  than 393pt. Downscaling to ~1100px would bring those four under 1 MB total.
* Seed JSON is placeholder-faithful, not real content: every Body Focus workout
  is "Model Leg & Bubble Booty"; challenge/program copy comes straight from the
  design. Replacing it is a data edit, no code change.
* **Missing fonts.** The design uses **Montserrat** (the "244 User" meta line)
  and **Noto Rashi Hebrew Bold** ("Get Ready!", the player countdown); neither is
  in `pubspec.yaml`. Both currently fall back to Nexa.
* **Design drift in the older Discover screens.** `category_detail_screen.dart`
  and `workout_detail_screen.dart` still use a 36×36 r10 back tile (Figma
  specifies 30×30 r7) and three separate Material-icon metric cards instead of
  the single 70pt `DayStatsCard` with exported icons. `DayStatsCard` is a
  drop-in replacement.
* The chart's dashed gridlines (Figma 16:1040 etc.) are not drawn — the design
  strokes them #EFEFEF at 22% opacity, which renders as nothing on white. Only
  the solid #4D4D4D baseline is implemented.
* History thumbnails are `Image.network` against the one placeholder pixabay URL
  every seed record shares, with the designed #D9D9D9 tile as the fallback.
  There is no disk cache yet.
* Calorie estimation is a deliberate placeholder — ~8 kcal per active minute, one
  constant in `ProgressRepository.estimateCalories`. Should become a MET-based
  formula once weight and intensity are trusted.
* `flutter_bloc` is a dependency but unused; state is `StatefulWidget` +
  `ValueNotifier` throughout. Decide whether to adopt it or drop it.
* `core/models/`, `core/network/`, `core/repositories/` are empty. See
  `API_REQUIREMENTS_FOR_PILATES.md` for the intended remote contract.
* Drift + `NativeDatabase` **deadlocks under `testWidgets`** — its futures
  complete on real timers the fake clock never advances. DB assertions must live
  in plain `test()` (or inside `tester.runAsync`). This is why the widget tests
  pass data in directly.

**Unverified**

* **No device/simulator build has been run.** Verification so far is analyzer +
  codegen + tests. The `sqflite` native path and real video playback need a smoke
  test on hardware.
* All Figma geometry was verified numerically. The `flutter_test` harness
  substitutes a square-glyph font, so text widths in tests are meaningless and
  the real Nexa typographic rhythm has never been eyeballed on device.

## 3. Latest Session Summary (Updated: 2026-08-27)

* **What was just completed:** Two passes in one session. First the Progress and
  History screens were rebuilt against Figma 16:418 / 17:1159 / 17:1688 and
  wired to real data (see the Progress/History bullets above). Then the player
  and detail surfaces: the exercise detail screen gained a "Start Now" footer
  that opens the shared player on that exercise, its duration stepper now seeds
  from the clip's own length and caches per-exercise in the new
  `ExercisePreferences` table (schema v3), and the player resolves each
  exercise's runtime as cached override -> clip length -> catalogue value,
  looping the clip until the time is up. The player's full-bleed video backdrop
  was replaced by an aspect-ratio `VideoBanner` shared with the Get Ready
  screen. Workout settings now stream into both the player and the detail
  preview via `SettingsRepository.watch()`. My Profile reads and writes
  `UserProfileRepository`, with imperial units reduced to a display-only
  conversion so they cannot corrupt the stored metric values.

* **Files modified (this pass):**
  * Created: `lib/core/database/repositories/exercise_prefs_repository.dart`,
    `lib/features/profile/unit_conversion.dart`,
    `test/exercise_duration_test.dart`, `test/player_layout_test.dart`
  * Modified: `lib/core/database/app_database.dart` (+ `.g.dart`),
    `lib/features/discover/views/exercise_detail_screen.dart`,
    `lib/features/discover/views/workout_detail_screen.dart`,
    `lib/features/workout/views/day_detail_screen.dart`,
    `lib/features/challenges/views/challenge_day_screen.dart`,
    `lib/features/body_focus/views/body_session_screen.dart`,
    `lib/features/player/models/player_session.dart`,
    `lib/features/player/views/exercise_player_screen.dart`,
    `lib/features/player/views/get_ready_screen.dart`,
    `lib/features/player/widgets/video_backdrop.dart`,
    `lib/features/profile/my_profile_screen.dart`, `docs/context.md`

* **Next immediate steps:**
  1. **Run the app on a device/simulator.** Nothing here has been executed
     outside the test harness. Confirm the v2 -> v3 migrations apply on an
     existing install, the banner sizes correctly against the real clip, the
     cached stepper duration drives the player, and history thumbnails load.
  2. **Commit.** The tree is still entirely uncommitted; the last commit
     predates the data layer, the Progress rebuild and this pass.
  3. Decide on voice guidance: the toggle and the Detailed/Brief switch persist
     but nothing speaks. It needs a TTS package (`flutter_tts`) plus per-exercise
     cue copy, or the controls should be removed.
  4. Clarify the open question: *"Play video in BG"* was implemented as the clip
     playing behind/above the player UI. If background **audio** while the app is
     minimised was meant, that needs `audio_service`/`just_audio` plus platform
     background modes — the current behaviour (pause on background) is the
     deliberate opposite.
  5. Surface the rest of the info-flow answers on `my_profile_screen.dart`.
  6. Delete or rewrite `test/widget_test.dart` so `flutter test` is green.
  7. Downscale the four oversized banner PNGs.
