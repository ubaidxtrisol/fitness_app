# Project Context & Progress Document

## 1. Project Overview

* **Core Purpose:** A Flutter fitness app (Pilates/yoga focused) that takes a user
  from onboarding through a structured training plan and tracks what they
  actually did. Four content flows feed one shared workout player: **Discover**,
  **Programs** and **Body Focus** (all category → workout → exercise — the
  backend's real catalogue shape, see `apis/readme-cLqG (2).md`) and
  **Challenges** (week → day → exercise — the one flow that kept its richer
  bundled-content shape; see **Backend shape mismatch** under Known Blockers).
  Completed work is persisted locally and fed back into the
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
    * `core/network/` — `ApiClient`/`ApiEndpoints`/`ApiException`/
      `PilatesRemoteDataSource`, the full remote API layer (see §2's
      **Remote API integration**). `core/models/`, `core/repositories/` are
      still empty — the remote layer's models live with the features that
      consume them (`discover/models/category_model.dart` is now shared far
      beyond Discover, see below).
  * `lib/features/<feature>/` — each feature owns `models/`, `services/`,
    `views/`, `widgets/`. Cross-feature reuse is deliberate and one-directional:
    `challenges` imports from `discover` (`ExerciseModel`) and `workout`
    (`DayModel`, `DayStatsCard`, `WorkoutRowCard`, `WorkoutAppBar`,
    `WorkoutHeroBanner`) for its own richer week/day model; `body_focus` and
    `workout` (Programs) both import `discover`'s `CategoryModel`/
    `WorkoutModel` **directly as their own data model** — Discover, Programs
    and Body Focus are the same shape all the way down, not just similar.
  * **Shared-component principle:** where two Figma nodes are the same component
    at a different size, the widget is parameterised rather than duplicated —
    `ChallengeCardWidget(scale:)` (113pt base × 1.5244 for the grid) and
    `DiscoverWorkoutCard(width:/height:/imageHeight:)` (224 rail vs 172.256
    grid).
  * **Data:** network first (see **Remote API integration**), local cache,
    then bundled JSON in `assets/json/` as the last-resort fallback, behind
    static repositories (`DiscoverRepository`, `WorkoutRepository`,
    `ChallengeRepository`, `BodyFocusRepository`) — all four never throw for
    "the network is down". `challenges.json` and `body_focus.json` keep a
    single exercise catalogue and have days/sessions reference it by id,
    resolved at load — this keeps them at ~250 KB and ~145 KB instead of
    megabytes; the *bundled-fallback* tier of `WorkoutRepository`/
    `BodyFocusRepository` re-flattens their still-nested bundled JSON
    (`Program → Phase → Day`, `Workout → Session → exercise_ids`) into the
    same flat `Category → Workout → Exercise` shape the network tier already
    returns.

## 2. Current System State

### Working Features

Implemented and verified (62 passing tests across `test/*.dart`;
`flutter analyze lib test` clean apart from one pre-existing warning):

* **Persistence layer** — Drift schema (v4) with seven tables: `UserProfiles`,
  `WorkoutSettingsRows`, `PlanProgressRows`, `SessionLogs`, `ExerciseLogs`,
  `ExercisePreferences`, `ActiveSessions`. Single-row tables are seeded on
  create so reads never return empty. v2 added `thumbnailUrl` (both log
  tables) and `dayLevel` (`SessionLogs`) behind an `onUpgrade` step, so history
  cards can render real artwork and "Day 2. Beginner"; v3 added
  `ExercisePreferences` (the per-exercise duration the detail screen's stepper
  caches); v4 added `ActiveSessions`, the mid-workout resume checkpoint (see
  below).
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
  duration stepper seeds from the catalogue's `duration_seconds`, caches every
  change against the exercise (`ExercisePrefsRepository`), and the player then
  loops that clip for exactly that long before skipping on. The hero (Figma
  16:374) is **static artwork, not a video preview** — the same banner shell as
  `ChallengeHeroBanner` (`assets/images/challenge_banner.png` is byte-identical
  to that node's background fill) with the exercise's own thumbnail bled off the
  right edge. Only `ExercisePlayerScreen` plays video.
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
* **Challenge locking** — real per-user progress, not the static
  `current_day_index` the content JSON ships (always `0`). `ChallengeProgress`
  (`challenges/services/challenge_progress.dart`) reads `plan_progress_rows`
  per week and enforces "step by step": a day unlocks once the previous one is
  done, and a week unlocks once every day in the previous week is done.
  `WeekTrack` renders completed (check), current (outline) and locked (lock
  glyph) chips from this — locked chips are still tappable, matching "you can
  browse ahead, you just can't start ahead." `ChallengeDayScreen` gates both
  its Start button and every exercise row on `isUnlocked`, showing
  `showChallengeLockedDialog` ("You're currently on Week 2, Day 3...") instead
  of navigating when locked. `NextUpService._resumeChallenge` was rewritten to
  use the same class, fixing a real bug: a finished week's `currentDayIndex`
  (7, past the last valid index) used to clamp back to day 7 instead of
  rolling into week 2 day 1, the same way program phases already rolled over.
* **Resumable workouts** — `ActiveSessionRepository` checkpoints
  (planId, dayId) → completed-exercise-ids/elapsed-time/started-at, written
  after *every* finished exercise via `_saveCheckpoint()`, not just at the end
  — so it survives the app being killed mid-workout. `ExercisePlayerScreen`
  checks for one on boot (only for the plain Start button, never for "Start
  Now" on a specific exercise) and offers `showResumeSessionDialog` —
  "Continue" restores `_index`/`_loggedExerciseIds`/`_elapsedSeconds`/
  `_startedAt`; "Start Over" clears it and begins at 0. The checkpoint is
  cleared on finish (completed or "Do it Later") and on an explicit Restart
  from the paused screen. Fixed a latent reentrancy bug in the same pass:
  `_completeCurrentExercise` didn't cancel the periodic ticker before its own
  `await`s, so a slow save/overlay could let the next tick fire the handler a
  second time and skip an exercise.
* **Completion UI** — `showExerciseCompleteOverlay` is a self-dismissing
  card ("Exercise Complete!" + the exercise's title), still used standalone
  and covered by its own test, but no longer called by the player itself (see
  below). `WorkoutCompleteScreen` is a full celebration (confetti via
  `flutter_confetti_plus`'s `ConfettiPlus.success`, duration/calories/exercise
  stats, a Done button) shown by `_finish()` whenever the outcome is
  `completed`, before handing control back to whoever pushed the player.
* **Single-screen player state machine** — `ExercisePlayerScreen` no longer
  pushes `GetReadyScreen`/`WorkoutPausedScreen` as separate routes; it cross
  fades between four in-place phases (`getReady`/`playing`/`paused`/
  `celebrating`) via `AnimatedSwitcher`, so pausing, resuming and the
  between-exercise beat never navigate away from the screen. `GetReadyScreen`
  and `WorkoutPausedScreen` still exist as thin standalone routes (kept for
  any other caller and their existing tests) but now share their visual
  content with the player through two extracted widgets: `GetReadyCard`
  (countdown + title + Skip) and `PausedOverlay` (still + blur scrim + the
  three actions). A new `ExerciseCelebration` widget plus a
  `ConfettiPlus.success` burst play between exercises — a natural finish (or
  the forward-skip button) fires this instead of jumping straight to the next
  clip: it rings a system chime (`SystemSound.play`, muted with the same
  sound-effect toggle — there's no bundled audio asset/package in the project
  yet, so this is the one built-in "ring" available without adding a
  dependency), waits ~1.8s showing the "Exercise Complete!" card, then starts
  the next exercise's own get-ready countdown rather than auto-starting it.
  The hardware/gesture back button and the transport's pause glyph both just
  flip to the paused phase in place (remembering which phase to return to on
  "Keep exercising"); backing out again while already paused resumes, matching
  the old pushed-route's behaviour when dismissed without an explicit choice.
  The final exercise still skips celebration entirely and goes straight to
  `_finish()`/`WorkoutCompleteScreen`, unchanged.
* **Join Challenge** — a persisted `JoinedChallenges` table (schema v5,
  `challengeId` + `joinedAt` only) backs a new
  `JoinedChallengesRepository`. `ChallengeDetailScreen` shows a "Join
  Challenge" button until joined, then a "Your Progress" card (percent bar,
  "Week N, Day M" or a "Completed" badge) instead — nothing else on the
  screen changed, so the existing per-day lock rules are untouched. Whether a
  joined challenge is finished or how far through it the user is was
  deliberately **not** duplicated into the new table: `ChallengeProgress`
  gained `totalDays`/`totalCompletedDays`/`percentComplete`/`hasProgress`
  getters that recompute it from `plan_progress_rows` every time, the same
  way `isComplete` already did. A challenge someone started before "Join"
  existed (or without tapping it) is silently back-filled as joined the next
  time its detail screen loads (`hasProgress` true + no join row yet). Both
  `ChallengesScreen` and the Home rail render the same progress bar/
  "Completed" badge on `ChallengeCardWidget` (via new `ChallengeModel.
  isJoined/percentComplete/isCompleted` fields, threaded through
  `ChallengeProgramModel.card()`, now a method instead of a getter since the
  progress fields have to be resolved per challenge) and their Join pill
  joins immediately rather than just opening the detail screen. The Home
  rail's hardcoded three-item `_challenges` list (never wired to
  `ChallengeRepository`) is gone; it now loads the real bundled challenges
  and orders them joined-and-in-progress first (most recently joined first),
  then not-yet-joined, then joined-and-finished last — finished challenges
  stay visible, just marked, rather than disappearing. This also fixed a
  latent bug: `_openChallenge` used to match the tapped card back to a real
  `ChallengeProgramModel` by lower-cased title (`orElse: () =>
  challenges.first`), which would silently open the wrong challenge if
  titles ever diverged; it now carries the real model straight through.
  `NextUpService.resolve()` gained a fallback tier between "the most
  recently touched plan" and "day one of the first bundled program": a
  challenge the user joined but hasn't logged a single day of yet, most
  recently joined first, skipping any that are already complete — so joining
  makes a challenge show up on the Home hero banner immediately, not only
  after finishing day 1.
* **Mid-day resume, real per-challenge lengths, card layout fix.** Three
  related follow-ups:
  * **A real "Do it Later" bug fix.** `ExercisePlayerScreen._finish()` used
    to clear the `ActiveSessions` checkpoint on *any* outcome, including
    "Do it Later" — so pausing partway through a day and tapping Start again
    silently restarted at exercise one, the checkpoint having already been
    wiped. It's now only cleared when the outcome is `completed`; deferring
    a day leaves the checkpoint in place so the player's existing
    `_offerResume()` dialog (already there, just never actually reached)
    correctly offers to continue.
  * **`ChallengeDayScreen`'s exercise list reflects real progress.** Now a
    `StatefulWidget` that reads the day's `ActiveSessions` checkpoint (or, if
    `isCompleted` is set — the day was already finished on a prior run and
    its checkpoint is long gone — treats every exercise as done). Each
    already-logged exercise gets a small checkmark badge (new `isDone` on
    `WorkoutRowCard`, anchored to the thumbnail's own corner so both row
    variants can use it), the "Exercise N" heading gains a "3/7" pill (with a
    thin progress bar) or a "Completed" badge, and the Start button reads
    "Resume" whenever a day is genuinely mid-way through. `ChallengeProgress`
    itself also now takes partial credit for the in-flight day into
    `percentComplete` (a new `ActiveSessionRepository` lookup for whatever
    `currentTarget` points at, added as an optional third `resolve()`
    param) — pausing after 5 of a day's exercises moves the *whole
    challenge's* percent immediately rather than waiting for the full day to
    log.
  * **Challenges now actually have the length their `days_label` claims.**
    Every bundled challenge was authored with the same 4 weeks x 7 days (28
    days) regardless of whether its label said "14 Days", "60 Days", "45
    Days", etc. — the label was purely cosmetic text. `ChallengeRepository`
    now re-chunks the days actually authored into the real week/day shape
    implied by that label: full 7-day weeks with the remainder in the last
    one (14 -> 7+7, 10 -> 7+3, 20 -> 7+7+6, ...), cycling back through the
    authored days when the label calls for more than were written down (a
    60-day challenge cycles the same 28 authored days twice-plus). Nothing
    about the week/day *rendering* code changed — `WeekTrack`,
    `ChallengeProgress`, etc. were already fully generic over week/day
    counts; this was purely a bundled-content shaping fix in the repository
    load path.
  * **Fixed the Home card's progress bar overlapping the title/user-count
    text.** The title+user-count block and the Join-pill/progress-bar/
    "Completed" row were two independently-`Positioned` blocks with
    hand-picked Figma offsets; the offset chosen for the new progress row
    didn't actually clear the text block's real height. They're now one
    `Column` with `mainAxisAlignment: spaceBetween` inside a single
    `Positioned`, so the action row can never overlap the text above it
    regardless of exact metrics. Once joined, the Join pill is gone
    entirely — replaced by the progress bar, then, once finished, by the
    "Completed" badge — never shown alongside either.
* **Remote API integration.** `core/network/` (`ApiClient`, `ApiEndpoints`,
  `ApiException`, `PilatesRemoteDataSource`) covers the full delivered
  contract in `apis/`: every `/api/v1/pilates/*` list/detail route, the
  admin CRUD set, `recommend`/`scan/pose`, and an HMAC-SHA256 app-signature
  layer (`X-App-Timestamp`/`X-App-Nonce`/`X-App-Signature`) that signs every
  request whenever `PILATES_APP_SIGNATURE_SECRET` is set — a safe no-op
  today since the backend doesn't enforce it yet. `DiscoverRepository`
  (Discover tab) already matched the API 1:1 and needed no adapter.
  `WorkoutRepository` (Programs) and `BodyFocusRepository` (Body Focus) were
  **adopted to the API's real flat shape** (see the follow-up pass below) —
  they now also return plain `CategoryModel`/`WorkoutModel`, network → local
  cache → bundled JSON, same as Discover, with no adapter at all.
  `ChallengeRepository` alone keeps a `ChallengeProgramModel.fromApiCategory`
  adapter, deliberately, because Challenges kept its richer week/day model —
  see **Backend shape mismatch** below, now scoped to Challenges only.

### In-Progress Work

* Nothing is mid-edit. **Everything is still uncommitted** — the persistence
  layer from the previous session plus this session's Progress/History rebuild.
  Last commit is `18369d8 UI Completeion`, which predates both.

### Known Blockers / Bugs

**Backend shape mismatch — now scoped to Challenges only**

* `apis/API_REQUIREMENTS.md` asked for `Program → Phase → Day`,
  `Challenge → Week → Day` and `BodyFocus → Category → Workout → Session`.
  What was delivered (`apis/readme-cLqG (2).md`, `apis/api-overview-QD3j.md`)
  is one flat `Category → Workout → Exercise` tree per tab
  (`/api/v1/pilates/{programs,challenges,body-focus}`), tagged
  `section_type`, identical in shape to the original Discover catalogue.
  **Resolution (this session):** rather than keep forcing that flat data
  into the old nested models via lossy adapters, Programs and Body Focus
  were **adopted to the real shape** — `WorkoutRepository`/
  `BodyFocusRepository` now return plain `CategoryModel`/`WorkoutModel`
  (Discover's own models) with zero adapter, and the UI (`DayDetailScreen`,
  `BodyFocusCategoryScreen`, `BodyWorkoutDetailScreen`) was simplified to
  match — see the fifth-session entry below for the full change. This is a
  clean, honest fit: no more thinner-than-bundled synthetic phases/sessions,
  no more fake "Phase 1 · 0%" header. Body Focus's Home-tile-id mismatch
  (live ids like `cat_flexibility_01` vs. the hardcoded `butt_leg`/`abs`/
  `full_body`/`arm`) is unchanged by this — `findCategory`'s fallback still
  papers over it, and only the backend seeding those exact ids fixes it for
  real. **Challenges was deliberately left as-is** (explicit user choice) —
  its week/day locking, resume-by-day and join-progress-% features are real,
  working features with no equivalent in the flat API shape, so
  `ChallengeRepository` keeps its `ChallengeProgramModel.fromApiCategory`
  adapter (one synthetic week wrapping the API's workouts) and the shape gap
  for Challenges specifically is still open — confirmed live,
  `GET /api/v1/pilates/challenges` currently returns a single
  `{"id":"cat_7day_core_challenge",...,"workouts":[]}`, no `weeks`, no
  `title_lead`/`title_accent`/`days_label`/`user_count`. **Next step:** send
  this (now Challenges-only) gap back to the backend dev if/when real
  week/day content for Challenges is wanted from the API instead of the
  bundled fallback.

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
* Programs and Body Focus have no step-by-step locking — only Challenges do,
  per the explicit ask. Every program day and body-focus session is freely
  startable regardless of progress.
* There is no "Continue Workout" surface on Home — the resume checkpoint is
  only offered at the point the user taps Start again on that same day.
  A banner reading the most-recently-updated `ActiveSessions` row would be a
  natural follow-up.
* History rows don't show a persistent "completed" checkmark — the completion
  UI is the live in-player moment only (the overlay and the finish screen),
  not a retroactive marker on exercise-list rows elsewhere in the app.
* The between-exercise "ring" is `SystemSound.play(SystemSoundType.click)` —
  the built-in OS click, not a designed chime. There's no audio-player package
  (`audioplayers`/`just_audio`) or bundled sound asset in the project yet;
  adding a real chime needs both.

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
* `core/repositories/` is still empty. `core/network/` is no longer empty —
  see **Remote API integration** below and `apis/` for the delivered
  contract (`apis/API_REQUIREMENTS.md` was the ask; `apis/readme-cLqG (1).md`
  / `apis/api-overview-QD3j.md` document what was actually built).
* Drift + `NativeDatabase` **deadlocks under `testWidgets`** — its futures
  complete on real timers the fake clock never advances. DB assertions must live
  in plain `test()` (or inside `tester.runAsync`). This is why the widget tests
  pass data in directly.
* `ProgressRepository._advancePlan` increments `completedDays` on every
  *completed* session, including a replay of an already-finished day — so
  `completedDays` can end up larger than the plan's actual day count (e.g.
  redoing day 1 five times after finishing a 7-day week reports 12). Harmless
  for challenge unlocking (`ChallengeProgress` only ever checks `>=`, so
  over-counting can't wrongly lock or unlock anything), but the raw number
  would be misleading if ever shown as "X of Y days done" verbatim.

**Unverified**

* **No device/simulator build has been run.** Verification so far is analyzer +
  codegen + tests. The `sqflite` native path and real video playback need a smoke
  test on hardware.
* All Figma geometry was verified numerically. The `flutter_test` harness
  substitutes a square-glyph font, so text widths in tests are meaningless and
  the real Nexa typographic rhythm has never been eyeballed on device.

## 3. Latest Session Summary (Updated: 2026-08-28)

* **What was just completed:** Challenge step-by-step locking, in-workout
  completion UI, and resumable workouts — three related pieces of the
  challenge/player experience, plus a small fix to the exercise detail
  screen's hero (now a static banner sharing `ChallengeHeroBanner`'s
  background asset, not a video preview). `ChallengeProgress` replaces the
  static `current_day_index` the content JSON ships with real progress read
  from `plan_progress_rows`, and `WeekTrack`/`ChallengeDayScreen` use it to
  lock every day beyond the user's actual position — days still open for
  browsing, but Start and every exercise row show a "one step at a time"
  dialog instead of navigating. The same class fixed a real bug in
  `NextUpService`: a finished challenge week used to clamp back onto its own
  last day instead of rolling into the next week, unlike programs. The player
  now checkpoints progress via a new `ActiveSessions` table (schema v4) after
  every finished exercise, offers to resume via a dialog when the Start button
  (not "Start Now") reopens a day with saved progress, and shows a
  self-dismissing "Exercise Complete!" card between exercises plus a full
  confetti "Workout Complete!" screen on finish. Fixed a latent reentrancy bug
  found while wiring this in: the periodic ticker wasn't cancelled before
  `_completeCurrentExercise`'s own awaits, so a slow save could let it fire
  again and skip an exercise.

* **Follow-up pass (same day):** Collapsed `ExercisePlayerScreen` from a
  screen that pushed `GetReadyScreen`/`WorkoutPausedScreen` as separate routes
  into one screen with an `AnimatedSwitcher` state machine (`getReady` /
  `playing` / `paused` / `celebrating`) — see **Single-screen player state
  machine** above for the full behaviour. `GetReadyScreen` and
  `WorkoutPausedScreen` were refactored (not deleted) to share their visuals
  with the player via two new extracted widgets rather than duplicating
  markup.

* **Second follow-up pass (same day): Join Challenge.** Added the
  `JoinedChallenges` table (schema v5) + `JoinedChallengesRepository`, a
  "Join Challenge" button and progress card on `ChallengeDetailScreen`, real
  percent-complete/"Completed" rendering on `ChallengeCardWidget` (grid and
  Home rail alike, with a quick-join pill), Home's challenge rail wired to
  real bundled data (the old hardcoded three-item list and its fragile
  title-matching lookup are gone) and ordered by join/progress priority, and
  a `NextUpService` fallback tier so a freshly joined challenge reaches the
  Home hero banner before day 1 is ever logged. See **Join Challenge** above
  for the full behaviour.

* **Third follow-up pass (same day): resume-from-where-you-left-off, real
  challenge lengths, card overlap fix.** Fixed `_finish()` clearing the
  `ActiveSessions` checkpoint on "Do it Later" (the actual cause of Start
  restarting at exercise one); `ChallengeDayScreen` now reads that checkpoint
  and shows per-exercise checkmarks, a day-level "3/7"/"Completed" pill, a
  "Resume" button label, and folds partial in-day progress into
  `ChallengeProgress.percentComplete`; `ChallengeRepository` re-chunks every
  bundled challenge's authored days into the week/day layout its `days_label`
  actually implies instead of always 4x7; and `ChallengeCardWidget`'s bottom
  section was restructured into one `spaceBetween` `Column` so the progress
  bar/badge can no longer overlap the title/user-count text. See
  **Mid-day resume, real per-challenge lengths, card layout fix** above.

* **Files modified (this pass):**
  * Created: `lib/core/database/repositories/active_session_repository.dart`,
    `lib/features/challenges/services/challenge_progress.dart`,
    `lib/features/challenges/widgets/challenge_lock_dialog.dart`,
    `lib/features/player/widgets/resume_session_dialog.dart`,
    `lib/features/player/widgets/exercise_complete_overlay.dart`,
    `lib/features/player/views/workout_complete_screen.dart`,
    `lib/features/player/widgets/get_ready_card.dart`,
    `lib/features/player/widgets/paused_overlay.dart`,
    `lib/features/player/widgets/exercise_celebration.dart`,
    `lib/core/database/repositories/joined_challenges_repository.dart`,
    `test/challenge_progress_test.dart`, `test/active_session_test.dart`,
    `test/challenge_lock_widgets_test.dart`, `test/completion_ui_test.dart`,
    `test/joined_challenges_test.dart`, `test/challenge_repository_test.dart`,
    `test/challenge_day_screen_test.dart`
  * Rewritten: `lib/features/challenges/widgets/week_track.dart`,
    `lib/features/challenges/views/challenge_detail_screen.dart` (now
    `StatefulWidget`, loads `ChallengeProgress` once and reloads it after
    returning from a day; Join button/progress card added in the second
    pass), `lib/features/player/views/exercise_player_screen.dart`
    (route-per-state → one `AnimatedSwitcher` state machine),
    `lib/features/player/views/workout_paused_screen.dart` (now a thin wrapper
    around `PausedOverlay`), `lib/features/challenges/views/challenges_screen.dart`
    (now resolves per-challenge join/progress state before building cards),
    `lib/features/home/views/home_screen.dart` (real challenge data +
    priority ordering + join wiring, replacing the hardcoded rail),
    `lib/features/challenges/views/challenge_day_screen.dart` (now
    `StatefulWidget`, reads the day's `ActiveSessions` checkpoint),
    `lib/features/challenges/services/challenge_repository.dart` (added
    `_repaginate`), `lib/features/home/widgets/challenge_card_widget.dart`
    (bottom section now one `spaceBetween` `Column`)
  * Modified: `lib/core/database/app_database.dart` (+ `.g.dart`),
    `lib/features/home/services/next_up_service.dart` (joined-challenge
    fallback tier), `lib/features/player/views/get_ready_screen.dart` (now
    built on `GetReadyCard`), `lib/features/player/widgets/player_scaffold.dart`
    (added `showBack`), `lib/features/challenges/models/challenge_program_model.dart`
    (`card` getter → `card()` method with progress params),
    `lib/features/home/models/home_models.dart` (`ChallengeModel` gained
    `isJoined`/`percentComplete`/`isCompleted`),
    `lib/features/challenges/services/challenge_progress.dart` (partial-day
    credit via `ActiveSessionRepository`),
    `lib/features/player/views/exercise_player_screen.dart` (`_finish()` only
    clears the checkpoint on `completed`),
    `lib/features/workout/widgets/workout_row_card.dart` (added `isDone`
    badge), `lib/features/challenges/views/challenge_detail_screen.dart`
    (passes `isCompleted` through to `ChallengeDayScreen`), `docs/context.md`

* **Next immediate steps:**
  1. **Run the app on a device/simulator.** Nothing here has been executed
     outside the test harness — same standing gap as every prior session.
     Confirm the v3 -> v4 migration applies on an existing install, the resume
     dialog fires correctly after force-quitting mid-workout, and the lock
     dialog reads sensibly against real challenge content.
  2. **Commit.** The tree is still entirely uncommitted; the last commit
     predates the entire data layer.
  3. Decide whether Home should surface an `ActiveSessions` row as a
     "Continue Workout" banner, rather than only offering resume when the user
     re-opens that exact day (see Not Yet Wired above).
  4. Decide on voice guidance: the toggle and the Detailed/Brief switch persist
     but nothing speaks. It needs a TTS package (`flutter_tts`) plus per-exercise
     cue copy, or the controls should be removed.
  5. Clarify the open question: *"Play video in BG"* was implemented as the clip
     playing behind/above the player UI. If background **audio** while the app is
     minimised was meant, that needs `audio_service`/`just_audio` plus platform
     background modes — the current behaviour (pause on background) is the
     deliberate opposite.
  6. Surface the rest of the info-flow answers on `my_profile_screen.dart`.
  7. Delete or rewrite `test/widget_test.dart` so `flutter test` is green.
  8. Downscale the four oversized banner PNGs.

* **Fourth session (2026-08-28): remote API integration.** Two passes.
  First, rebuilt `core/network/` (`ApiClient`/`ApiEndpoints`/`ApiException`)
  against the full delivered `apis/` contract (it was originally set up
  against just the first-draft `apis/readme-v3Nm.md`): added the
  Programs/Challenges/Body Focus/grouped-discover endpoints, the admin CRUD
  set, `put`/`delete` on `ApiClient`, an HMAC-SHA256 app-signature
  interceptor (`X-App-Timestamp`/`X-App-Nonce`/`X-App-Signature`, safe
  no-op until `PILATES_APP_SIGNATURE_SECRET` is set), and a `code` field on
  `ApiException` for the backend's `{"error":{"code":...}}` shape.
  Second, wired that layer into the app: moved `PilatesRemoteDataSource`
  from `discover/services/` into `core/network/` (it now serves four list
  endpoints, not just Discover) and gave `WorkoutRepository`/
  `ChallengeRepository`/`BodyFocusRepository` the same network → local
  cache → bundled-JSON chain `DiscoverRepository` already had, via new
  `fromApiCategory` adapters on `ProgramModel`/`ChallengeProgramModel`/
  `BodyFocusCategoryModel`. Hit the live backend directly (`curl` + a
  throwaway adapter smoke test, not just the docs) and found the docs
  overstate what's implemented — see **Backend shape mismatch** under Known
  Blockers; the adapters are knowingly lossy by the user's explicit choice
  rather than leaving these three screens on bundled-only data. Also fixed
  a latent bug surfaced while wiring this: `DiscoverRepository.getCategories()`
  read `storage.getString` *before* its own try/catch, so an app run before
  `StorageService.init()` completed would throw uncaught instead of falling
  back — moved inside the guard and hardened `_readCache()` on all four
  repositories to treat an uninitialized/unavailable store as "no cache"
  rather than propagate. `flutter analyze lib test` clean, `flutter test`
  unchanged at 77/79 (the 2 failures are the pre-existing
  `test/widget_test.dart` counter test and a pre-existing
  `home_hero_banner_test.dart` failure, both confirmed present on `main`
  before this session's changes too).
  * **Files modified:** `lib/core/network/api_client.dart`,
    `lib/core/network/api_endpoints.dart`, `lib/core/network/api_exception.dart`,
    `.env.example`, `pubspec.yaml` (+`.lock`, added `crypto`),
    `lib/core/services/shared_prefrences/prefs_keys.dart`,
    `lib/features/discover/services/discover_repository.dart`,
    `lib/features/workout/models/program_model.dart`,
    `lib/features/workout/services/workout_repository.dart`,
    `lib/features/challenges/models/challenge_program_model.dart`,
    `lib/features/challenges/services/challenge_repository.dart`,
    `lib/features/body_focus/models/body_focus_model.dart`,
    `lib/features/body_focus/services/body_focus_repository.dart`,
    `docs/context.md`.
  * **Created:** `lib/core/network/pilates_remote_data_source.dart`
    (moved from `lib/features/discover/services/`, which is deleted).
  * **Next immediate steps:** send the shape-mismatch writeup to the
    backend dev (see Known Blockers); until resolved, expect Programs/
    Challenges/Body Focus to look thinner on live network data than on the
    bundled fallback, and all four Body Focus Home tiles to collapse onto
    one category. Everything else from the third session's list above is
    still outstanding too, in particular **run the app on a device** — this
    session's network integration has only been verified by unit tests, a
    throwaway adapter smoke test against captured live API responses, and
    direct `curl` calls, never through the actual app UI.

* **Fifth session (2026-08-28): adopt the UI to the flat API shape.**
  Follow-up to the fourth session's lossy adapters — the user reviewed the
  live API shape directly and asked for the UI to be adopted to match it
  ("everything is around categories/workouts/exercises") rather than
  bending real API data into the app's old nested models. Scoped via one
  clarifying question: Programs and Body Focus (no locking today — a clean,
  unambiguous fit for flattening) vs. Challenges (a real locking/resume/
  join-progress-% feature built on week/day structure the API doesn't have)
  — the user chose to flatten Programs + Body Focus and **leave Challenges
  exactly as built in the fourth session**.
  * **Research first:** an `Explore` subagent mapped every live navigation
    path into Programs/Body Focus before any code changed. Key finding:
    `ProgramDetailScreen` had **zero call sites anywhere in the app** — dead
    code; the only live path into Programs was Home's Next Up banner →
    `DayDetailScreen`. Also confirmed (via `app_database.dart`) that
    persistence only ever writes `planId` + a flat `dayId`/`dayIndex` —
    `PhaseModel.id` and Body Focus's session id were never persisted, so
    removing those wrapper layers could not break history/resume/streak.
  * **Programs:** `ProgramModel`/`PhaseModel` deleted outright.
    `WorkoutRepository.loadPrograms()` now returns `List<CategoryModel>` —
    Discover's own model, zero adapter (the fourth session's
    `ProgramModel.fromApiCategory` is gone). The bundled-asset fallback tier
    now does the flattening instead (`programs.json` still ships
    `Program → Phase → Day`; each program's phases flatten into one category,
    keeping the program's id so an in-progress `PlanProgressRows` row still
    resolves). `program_detail_screen.dart` and `phase_header.dart` deleted
    (dead code — nothing rendered `PhaseHeader`'s progress pill anyway; it
    was permanently hardcoded to 0%, "the design ships the 0% state", per
    the old model's own doc comment). `DayDetailScreen` kept (it's a real,
    Figma-backed "Day N" screen, reached from Next Up) but lost its
    `PhaseModel phase` parameter and the fake phase header block.
    `NextUpService`/`NextUpTarget` reworked: `program`/`phase` fields
    replaced by one `category: CategoryModel?`; `_resumeProgram`/
    `_firstProgramDay` now index into `category.workouts` directly instead
    of flattening `phases[].days[]`.
  * **Body Focus:** `body_focus_model.dart` (`BodyFocusCategoryModel`/
    `BodyWorkoutModel`) deleted outright — `BodyFocusRepository` now returns
    `List<CategoryModel>` the same way `WorkoutRepository` does, zero
    adapter. The bundled-asset fallback flattens `body_focus.json`'s
    `workout.sessions[].exercise_ids` (resolved against its exercise
    catalogue) into one `workout.exercises` list per workout. This removed
    an entire screen: `body_session_screen.dart` (the middle "session list"
    screen) is deleted — `BodyWorkoutDetailScreen` now shows the workout's
    exercises directly (with its own Start button, moved in from the deleted
    session screen) instead of a list of one fake "Session 1" wrapping them.
    The hero's "note" line (always "Note: Image Will Change" on every
    bundled workout — known placeholder junk, see Technical debt) is simply
    not rendered anymore rather than faked from an API field that doesn't
    exist. `body_focus_category_screen.dart` retargeted from
    `BodyFocusCategoryModel`/`.card` to plain `CategoryModel`/`WorkoutModel`.
  * **`DayModel` was kept**, deliberately narrowed to only what Challenges
    still needs (`ChallengeWeekModel.days`, `ChallengeDayScreen`,
    `DayStatsCard`) — `program_model.dart` now contains only `DayModel`.
    Both `DayDetailScreen` and the rebuilt `BodyWorkoutDetailScreen` build a
    `DayModel` inline via `DayModel.fromJson(workout.toJson())` wherever
    they still want the "day" framing (`DayStatsCard`) — safe because
    `WorkoutModel`/`DayModel` have always shared every field name.
  * **Verified against real data, not just unit tests:** a throwaway test
    (deleted after) called `WorkoutRepository.loadPrograms()` and
    `BodyFocusRepository.loadCategories()` directly — confirmed the bundled
    fallback correctly flattens `programs.json` (`prog_pilates_premier` → 1
    category, 6 workouts, every workout keeps its exercises) and
    `body_focus.json` (`butt_leg`/`abs`/`full_body`/`arm` → 4 categories, 8
    workouts each, sessions correctly flattened to 45 exercises per
    workout). Also re-confirmed live `/api/v1/pilates/programs` still
    decodes cleanly through the unchanged `CategoryModel.fromJson`.
    `flutter analyze lib test` clean (only the same pre-existing informational
    lints as before), `flutter test` unchanged at 77/79 — same 2
    pre-existing failures (`widget_test.dart`, `home_hero_banner_test.dart`),
    plus one test intentionally updated (`progress_tracking_test.dart`'s
    `target.phase` assertion → `target.category`, matching the renamed
    `NextUpTarget` field).
  * **Files modified:** `lib/features/workout/models/program_model.dart`
    (now `DayModel` only), `lib/features/workout/services/workout_repository.dart`
    (rewritten), `lib/features/workout/views/day_detail_screen.dart` (dropped
    `phase` param), `lib/features/body_focus/services/body_focus_repository.dart`
    (rewritten), `lib/features/body_focus/views/body_focus_category_screen.dart`,
    `lib/features/body_focus/views/body_workout_detail_screen.dart` (rewritten
    — exercises directly, own Start button), `lib/features/home/services/next_up_service.dart`
    (`NextUpTarget.category` replaces `.program`/`.phase`), `lib/features/home/views/home_screen.dart`
    (`_openNextUp` updated), `lib/core/network/pilates_remote_data_source.dart`
    / `lib/core/services/shared_prefrences/prefs_keys.dart` (stale doc-comment
    fixes), `test/progress_tracking_test.dart`, `docs/context.md`.
  * **Deleted:** `lib/features/workout/models/... ProgramModel`/`PhaseModel`
    (classes, not the file), `lib/features/workout/views/program_detail_screen.dart`,
    `lib/features/workout/widgets/phase_header.dart`,
    `lib/features/body_focus/models/body_focus_model.dart`,
    `lib/features/body_focus/views/body_session_screen.dart`.
  * **Next immediate steps:** same standing list as the fourth session
    (device/simulator run still hasn't happened; commit; voice guidance;
    etc.) plus: send the now-Challenges-only shape-mismatch writeup to the
    backend dev; consider whether Programs deserves a real "browse all
    programs" surface beyond the single-day Next Up banner (there is no
    Figma spec for one today, so none was added this pass — Home's reach
    into Programs is unchanged, just fed by real flat data now).
