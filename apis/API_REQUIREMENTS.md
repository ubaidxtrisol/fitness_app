# API Requirements — Content Catalogue

**Audience:** Backend Developer
**Consumer:** Fitness App (Flutter) — Discover, Programs, Challenges, Body Focus modules
**Source of truth for payload shape:** `assets/json/{pilates,programs,challenges,body_focus}.json` (currently bundled locally; the API must return the exact same structures so each local file can be swapped for a network call with zero model changes)
**App-side models that parse this response:** `lib/features/discover/models/category_model.dart`, `lib/features/workout/models/program_model.dart`, `lib/features/challenges/models/challenge_program_model.dart`, `lib/features/body_focus/models/body_focus_model.dart`
**App-side loaders to be switched to HTTP:** `lib/features/{discover,workout,challenges,body_focus}/services/*_repository.dart`

**Note on scope:** the app is **offline-first** — everything the user does (onboarding answers, settings, progress, workout history, favourites) is stored and read entirely from a local database on the device and does not need a server API. This document covers **content only**: the read-only catalogue of categories, programs, challenges, workouts and exercises that the app currently ships as bundled JSON and needs to fetch from a server instead so it can be updated without an app release.

---

## 1. Goal

The app ships **four static JSON files**. We need **four endpoints** that return the **same JSON** from the server so content (categories, programs, challenges, workouts, exercises, videos) can be updated without an app release.

**Hard requirement:** every response body must be byte-compatible with its current file's structure — same key names (`snake_case`), same nesting, same types. Do not rename, wrap, or restructure without telling us first.

---

## 2. Endpoints

| Module | Endpoint | Mirrors file | Current size |
|---|---|---|---|
| Discover (Pilates) | `GET /api/v1/pilates/categories` | `assets/json/pilates.json` | 17 KB |
| Programs | `GET /api/v1/programs` | `assets/json/programs.json` | 57 KB |
| Challenges | `GET /api/v1/challenges` | `assets/json/challenges.json` | 253 KB |
| Body Focus | `GET /api/v1/body-focus/categories` | `assets/json/body_focus.json` | 146 KB |

| Item | Value |
|---|---|
| Method | `GET` |
| Auth | None required — see §7 |
| Content-Type | `application/json; charset=utf-8` |
| Success | `200 OK` |

Each endpoint returns its **entire tree** in one call — categories with their workouts, workouts with their exercises. No pagination for v1.

### Optional supporting endpoints (nice to have, not blocking v1)

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/api/v1/pilates/categories/{category_id}` | Single category with its workouts |
| `GET` | `/api/v1/programs/{program_id}` | Single program with its phases and days |
| `GET` | `/api/v1/challenges/{challenge_id}` | Single challenge with its weeks and days |
| `GET` | `/api/v1/body-focus/categories/{category_id}` | Single category with its workouts and sessions |
| `GET` | `/api/v1/exercises/{exercise_id}` | Single exercise detail |

---

## 3. Shared objects

Two objects are identical across all four modules. Define them once server-side.

### 3.1 Exercise object

| Field | Type | Required | Notes |
|---|---|---|---|
| `order` | integer | ✅ | 1-based position **within its parent list**. Must be sequential with no gaps/duplicates (1, 2, 3 …) |
| `exercise_id` | string | ✅ | Id in the master exercise library, e.g. `ex_glute_bridge`. **Intentionally repeats** across workouts — see §5.2 |
| `title` | string | ✅ | e.g. `Pilates Glute Bridge` |
| `description` | string | ✅ | One-sentence summary shown under the title |
| `duration_seconds` | integer | ✅ | How long this exercise runs. Must be `> 0` |
| `reps` | integer | ✅ | Target repetitions. Send `0` for time-only (hold) exercises — do **not** send `null` |
| `rest_seconds` | integer | ✅ | Rest after this exercise. `0` is valid for the last exercise |
| `thumbnail_url` | string (URL) | ✅ | Absolute HTTPS URL. Still image for the exercise |
| `video_url` | string (URL) | ✅ | Absolute HTTPS URL to an **MP4 (H.264 + AAC)** demo clip. See §6 |
| `how_to_do` | array\<string\> | ✅ | Step-by-step instructions, in order. Typically 3–6 items. Plain text, no HTML/markdown/leading numbering — the app renders the bullets/numbers |
| `common_mistakes` | array\<string\> | ✅ | Typically 2–4 items. Same formatting rules |
| `breathing_tips` | array\<string\> | ✅ | Typically 3–4 items. Same formatting rules |

**Empty-list rule:** all three string arrays must be present. If there is no content, return `[]` — never `null`, never omit the key.

**Per-workout vs per-exercise fields:** `order`, `duration_seconds`, `reps` and `rest_seconds` describe how this exercise sits inside *this particular* workout/day. The content fields (`title`, `description`, `video_url`, `thumbnail_url`, the three arrays) belong to the exercise itself, so an edit to `ex_glute_bridge` propagates to every workout that uses it.

### 3.2 Day / Session object

A program **day**, a challenge **day** and a body-focus **session** all render on the same screen and share one shape:

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | See §5.1 — **must be globally unique** |
| `title` | string | ✅ | e.g. `Day 1`, `Exercise 1` |
| `difficulty` | string (enum) | ✅ | Exactly one of: `Beginner`, `Intermediate`, `Advanced`. Case-sensitive |
| `duration_minutes` | integer | ✅ | Total session length incl. rest |
| `net_time_minutes` | integer | ✅ | Active time excluding rest. Must be `<= duration_minutes` — see §8 |
| `calories_burned` | integer | ✅ | Estimated kcal for the whole day/session |
| `thumbnail_url` | string (URL) | ✅ | Absolute HTTPS URL |
| `exercises` | array\<Exercise\> | ✅ | Ordered list. May be `[]`, never `null` — see §3.3 |

### 3.3 Inline exercises vs `exercise_ids`

`pilates.json` and `programs.json` inline the full Exercise object directly in each day's `exercises` array. `challenges.json` and `body_focus.json` instead keep **one exercise catalogue at the document root**, keyed by `exercise_id`, and each day carries `exercise_ids: ["ex_a", "ex_b"]` which the app resolves against that catalogue at load time. That is what keeps those two files at 253 KB and 146 KB instead of several megabytes — 10 of the 13 challenge exercises are the same records as 10 of the 10 body-focus ones.

**Requirement:** keep the reference form for Challenges and Body Focus exactly as-is. Do not inline.

---

## 4. Response structures & examples

### 4.1 Discover / Pilates — `GET /api/v1/pilates/categories`

```
Category (array root)
└── workouts[]  → Workout
     └── exercises[] → Exercise (§3.1, inlined)
```

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | Unique, stable slug-style id, e.g. `cat_weight_loss_01`. Used as a local key — must never change once shipped |
| `title` | string | ✅ | Display name, e.g. `Weight Loss Journey` |
| `description` | string | ✅ | Short one-line subtitle |
| `workouts` | array\<Workout\> | ✅ | May be `[]`, never `null` |

**Workout object:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | Unique workout id, e.g. `wk_model_leg_booty`. **Must be globally unique** — see §5.1 |
| `title` | string | ✅ | e.g. `Model Leg & Bubble Booty` |
| `difficulty` | string (enum) | ✅ | `Beginner` / `Intermediate` / `Advanced` |
| `duration_minutes` | integer | ✅ | |
| `net_time_minutes` | integer | ✅ | `<= duration_minutes` |
| `calories_burned` | integer | ✅ | |
| `thumbnail_url` | string (URL) | ✅ | |
| `exercises` | array\<Exercise\> | ✅ | Ordered, inlined (§3.1) |

> **Important:** the root is a **bare array**, not an object. The app does `jsonDecode(body) as List`.

Example:

```json
[
  {
    "id": "cat_weight_loss_01",
    "title": "Weight Loss Journey",
    "description": "Targeted workouts focused on burn, strength, and toning.",
    "workouts": [
      {
        "id": "wk_model_leg_booty",
        "title": "Model Leg & Bubble Booty",
        "difficulty": "Beginner",
        "duration_minutes": 6,
        "net_time_minutes": 5,
        "calories_burned": 45,
        "thumbnail_url": "https://cdn.example.com/img/workouts/model_leg_booty.jpg",
        "exercises": [
          {
            "order": 1,
            "exercise_id": "ex_glute_bridge",
            "title": "Pilates Glute Bridge",
            "description": "Lie on your back with knees bent, squeeze glutes and lift hips upward.",
            "duration_seconds": 45,
            "reps": 15,
            "rest_seconds": 15,
            "thumbnail_url": "https://cdn.example.com/img/exercises/glute_bridge.jpg",
            "video_url": "https://cdn.example.com/video/exercises/glute_bridge.mp4",
            "how_to_do": [
              "Lie on your back with knees bent and feet flat on the floor, hip-width apart.",
              "Engage your core and squeeze your glutes.",
              "Lift your hips upward until your body forms a straight line from shoulders to knees.",
              "Lower down slowly to the starting position."
            ],
            "common_mistakes": [
              "Arching the lower back excessively at the top of the movement.",
              "Pushing through the toes instead of driving down through the heels.",
              "Letting knees cave inward during the lift."
            ],
            "breathing_tips": [
              "Breathe regularly throughout the movement.",
              "Exhale as you lift your hips up towards the ceiling.",
              "Inhale slowly as you lower back down to the floor.",
              "Do not hold your breath; holding your breath can cause your body to tense up and make the exercise more difficult."
            ]
          }
        ]
      }
    ]
  }
]
```

Seed from `assets/json/pilates.json`.

---

### 4.2 Programs — `GET /api/v1/programs`

```
Program (array root)
└── phases[]
     └── days[]  → Day (§3.2, exercises inlined)
```

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | e.g. `prog_pilates_premier` |
| `title` | string | ✅ | **Leading half** of the display name, e.g. `Pilates` |
| `subtitle` | string | ✅ | **Accent half**, e.g. `Premier`. The two render as one styled headline — `title` in black, `subtitle` in the brand pink. Do not merge them into one field |
| `phases` | array\<Phase\> | ✅ | Ordered. May be `[]`, never `null` |

**Phase object:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | e.g. `phase_1`. Unique **within the program** |
| `title` | string | ✅ | e.g. `Phase 1` |
| `subtitle` | string | ✅ | e.g. `Gentle Beginning` |
| `days` | array\<Day\> | ✅ | Ordered, §3.2, exercises inlined |

> Drop `progress` from this payload — the app tracks phase completion entirely from local workout history and does not read a `progress` field from the API.

Example (abbreviated):

```json
[
  {
    "id": "prog_pilates_premier",
    "title": "Pilates",
    "subtitle": "Premier",
    "phases": [
      {
        "id": "phase_1",
        "title": "Phase 1",
        "subtitle": "Gentle Beginning",
        "days": [
          {
            "id": "prog_pilates_premier_p1_d1",
            "title": "Day 1",
            "difficulty": "Beginner",
            "duration_minutes": 25,
            "net_time_minutes": 5,
            "calories_burned": 234,
            "thumbnail_url": "https://cdn.example.com/img/days/day_1.jpg",
            "exercises": [ ]
          }
        ]
      }
    ]
  }
]
```

Current data: one program, two phases, three days each. Seed from `assets/json/programs.json`.

---

### 4.3 Challenges — `GET /api/v1/challenges`

Root is a **JSON object** with two keys — this shape is deliberate (§3.3):

```json
{
  "exercises": { "ex_dynamic_chest": { "...": "Exercise object, §3.1" } },
  "challenges": [ { "...": "Challenge object" } ]
}
```

| Field | Type | Required | Notes |
|---|---|---|---|
| `exercises` | object | ✅ | **Map keyed by `exercise_id`**, not an array. Values are Exercise objects (§3.1) |
| `challenges` | array\<Challenge\> | ✅ | Ordered |

**Challenge object:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | e.g. `chal_flat_belly` |
| `title` | string | ✅ | Name used in the app bar and day screen, e.g. `Flat Belly` |
| `title_lead` | string | ✅ | Leading half of the hero headline, e.g. `"Belly "` (**note the trailing space where the design needs one**) |
| `title_accent` | string | ✅ | Accent half, drawn in brand pink, e.g. `Flat` |
| `days_label` | string | ✅ | Display string, e.g. `"28 Days"` — see §8 |
| `user_count` | string | ✅ | Display string, e.g. `"244 User"` — see §8 |
| `thumbnail_url` | string (URL) | ✅ | |
| `weeks` | array\<Week\> | ✅ | Ordered |

`title`, `title_lead` and `title_accent` are not redundant — `title_lead` + `title_accent` are a presentation split for the two-tone hero headline; `title` is the plain name used elsewhere. All three are needed.

> Drop `is_favorite` and `current_day_index` from this payload — favourites and per-plan progress are tracked entirely on-device.

**Week object:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | e.g. `week_1`. Unique **within the challenge** |
| `title` | string | ✅ | e.g. `Week 1` |
| `subtitle` | string | ✅ | e.g. `Belly Action` |
| `days` | array\<Day\> | ✅ | Ordered; each day carries `exercise_ids`, not `exercises` |

**Challenge day object** — same as §3.2 **except** `exercises` is replaced by:

| Field | Type | Required | Notes |
|---|---|---|---|
| `exercise_ids` | array\<string\> | ✅ | Ordered ids resolved against the root `exercises` map. Every id **must** exist in that map or the day silently loses exercises |

Current data: 9 challenges × 4 weeks × 7 days = 252 days, over a 13-exercise catalogue. Seed from `assets/json/challenges.json`.

---

### 4.4 Body Focus — `GET /api/v1/body-focus/categories`

Same two-key object shape as Challenges:

```json
{
  "exercises": { "ex_dynamic_chest": { "...": "Exercise object, §3.1" } },
  "categories": [ { "...": "Body Focus category object" } ]
}
```

**Category object:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | **Must be exactly one of** `butt_leg`, `abs`, `full_body`, `arm` — the Home screen's tiles are hardcoded to these ids |
| `title` | string | ✅ | e.g. `Butt & Leg` |
| `workouts` | array\<BodyWorkout\> | ✅ | Ordered |

**Body workout object:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | e.g. `butt_leg_wk_1`. Globally unique today ✅ |
| `title` | string | ✅ | e.g. `Model Leg & Bubble Booty` |
| `note` | string | ✅ | Second hero line. Send `""` if there is nothing to show — see §8 |
| `difficulty` | string (enum) | ✅ | `Beginner` / `Intermediate` / `Advanced` |
| `duration_minutes` | integer | ✅ | |
| `net_time_minutes` | integer | ✅ | `<= duration_minutes` |
| `calories_burned` | integer | ✅ | |
| `thumbnail_url` | string (URL) | ✅ | |
| `sessions` | array\<Session\> | ✅ | Ordered. Session = §3.2 with `exercise_ids` instead of `exercises` |

Current data: 4 categories × 8 workouts × 5 sessions = 160 sessions, over a 10-exercise catalogue. Seed from `assets/json/body_focus.json`.

---

## 5. Data model / DB notes

Suggested tables — one polymorphic `days` table covers program days, challenge days and body-focus sessions since they are the identical object:

```
exercises         (id PK, title, description, thumbnail_url, video_url,
                   how_to_do JSON, common_mistakes JSON, breathing_tips JSON,
                   created_at, updated_at)

categories        (id PK, kind ENUM('pilates','body_focus'), title, description,
                   sort_order, is_active, created_at, updated_at)
workouts          (id PK, category_id FK, title, note, difficulty,
                   duration_minutes, net_time_minutes, calories_burned,
                   thumbnail_url, sort_order, is_active, created_at, updated_at)

programs          (id PK, title, subtitle, sort_order, is_active)
program_phases    (id PK, program_id FK, title, subtitle, sort_order)

challenges        (id PK, title, title_lead, title_accent, days_label,
                   user_count, thumbnail_url, sort_order, is_active)
challenge_weeks   (id PK, challenge_id FK, title, subtitle, sort_order)

days              (id PK, owner_type ENUM('program_phase','challenge_week','body_workout'),
                   owner_id, title, difficulty, duration_minutes, net_time_minutes,
                   calories_burned, thumbnail_url, sort_order)
day_exercises     (day_id FK, exercise_id FK, order, duration_seconds,
                   reps, rest_seconds, PRIMARY KEY (day_id, order))
```

### 5.1 Ids must be globally unique

The current JSON has three id problems, all of which break the app's local history:

- **Duplicate workout id:** `wk_squat_thigh_toner` appears under two different Pilates categories (`cat_weight_loss_01` and `cat_toned_shape_01`).
- **Challenge day ids are not globally unique:** 252 challenge day rows share just **7** distinct ids (`day_1` … `day_7`, reused every week).
- **Body-focus session ids are not globally unique:** 160 session rows share just **5** distinct ids (`session_1` … `session_5`, reused every workout).
- **Program day ids repeat too:** 6 day rows across 2 phases share just 3 distinct ids (`day_1`–`day_3`).

This matters because the app writes `day_id` into every local workout-history row to identify what the user actually did. Right now "the user finished `day_1`" is ambiguous across 252 possibilities in the challenges catalogue alone.

**Required — please resolve for every module, not just Pilates:** give every category/workout/day/session a distinct id that is unique **across the whole response**, e.g. `chal_flat_belly_w1_d1` instead of `day_1`, `butt_leg_wk_1_s1` instead of `session_1`. Do not rely on the id being unique only within its immediate parent.

### 5.2 Exercise ids are shared by design

`exercise_id` (e.g. `ex_glute_bridge`) intentionally repeats across workouts — it points at the master exercise library. The per-workout numbers (`order`, `duration_seconds`, `reps`, `rest_seconds`) belong to the day/workout join, **not** to the exercise itself. Keep the content fields (`title`, `description`, `how_to_do`, `common_mistakes`, `breathing_tips`, `video_url`, `thumbnail_url`) on the exercise so an edit propagates everywhere it is used.

### 5.3 Ordering

The app renders categories, programs, challenges, workouts, phases, weeks, days and exercises **in the order the arrays arrive**. Please add an explicit `sort_order` column to every table above and always sort deterministically server-side — do not rely on insertion/PK order.

---

## 6. Media requirements

| Item | Requirement |
|---|---|
| Protocol | HTTPS only (iOS ATS blocks plain HTTP) |
| URLs | Absolute and publicly reachable — no relative paths, no signed URLs that expire in minutes. The app caches the catalogue for offline use, so a link must stay valid |
| Images | JPG or PNG, ~16:9, ideally ≥ 720p, served from a CDN, `Cache-Control` set |
| Video | **MP4, H.264 video + AAC audio**, ≤ 1080p, short loopable clip. Must support HTTP range requests (byte-range) so the player can seek/scrub |
| Video size | Keep clips small (target < 5 MB) — they autoplay inside the workout player and loop for as long as the exercise runs |
| Aspect ratio | Send a consistent ratio per clip — **16:9 preferred throughout**. The player sizes its video banner from the clip's own aspect ratio, so wildly mixed ratios make the layout jump between exercises |
| Fallback | If a video is unavailable, still return a valid `thumbnail_url` and an empty string `""` for `video_url` (not `null`) |

**Current state:** every `thumbnail_url` and `video_url` across all four files resolves to the same two Pixabay placeholders (544 thumbnail references, 81 video references). These are temporary and must be replaced with real per-exercise assets on our own CDN before launch.

---

## 7. Auth, headers, caching

- **Auth:** these endpoints can be public — no user identity is involved in fetching the catalogue. If you would rather require a simple API key for the app's own traffic, that's fine; the app does not need per-user tokens for content.
- **Caching:** please return `ETag` (or `Last-Modified`) and support `If-None-Match` → `304 Not Modified`. The app is offline-first: it fetches the catalogue once, caches it fully on-device, and only refetches when it has actually changed. On a failed fetch it falls back to the last cached copy, and if there is none, to the bundled JSON.
- **Versioning:** keep the `/api/v1/` prefix. Any breaking field change goes to `/api/v2/`.
- Optionally include a top-level `X-Content-Version` header (or a `version` field, if we agree to wrap the payload) so the app can skip re-parsing unchanged data.

---

## 8. Known issues in the current seed data (please fix during migration)

These are real defects in the JSON we are handing you — please do not carry them into the database.

### 8.1 `net_time_minutes` exceeds `duration_minutes` almost everywhere

Net (active) time can never exceed total time. Measured across the current files:

| File | Rows checked | Rows where `net_time > duration` |
|---|---|---|
| `pilates.json` | 4 workouts | 0 ✅ |
| `programs.json` | 6 days | **6 (100%)** |
| `challenges.json` | 252 days | **252 (100%)** |
| `body_focus.json` | 160 sessions + 32 workouts | **192 (100%)** |

Typical bad row: `duration_minutes: 6, net_time_minutes: 25`. The two values look swapped. `pilates.json` is the only file that is correct — please use it as the model and recompute the other three: `net_time_minutes = Σ duration_seconds` of the exercises, `duration_minutes = Σ (duration_seconds + rest_seconds)`.

### 8.2 Display strings where numbers belong

| Field | Current | Should be |
|---|---|---|
| `days_label` | `"28 Days"` | `days_count: 28` (integer) |
| `user_count` | `"244 User"` | `user_count: 244` (integer) |

These are pre-formatted English strings baked into the content. The app ships `easy_localization` and cannot translate or pluralise a baked string. Send numbers and let the app format them — this is a payload change, so flag it back to us and we will update the parser in the same release.

### 8.3 Ids are not globally unique

See §5.1 — this is the most important fix in this document.

### 8.4 Placeholder content

- Every Body Focus workout across all four categories is titled `"Model Leg & Bubble Booty"` (32 workouts, 1 title).
- `note` is `"Note: Image Will Change"` on all 32 body-focus workouts.
- `calories_burned` is `234` for every single row in `challenges.json` and `body_focus.json`.
- All 625 media references (544 thumbnails + 81 videos) point at two Pixabay files.

None of this breaks the app — it is a content-entry job — but it all needs real values before launch.

---

## 9. Validation checklist (please verify before handing over)

- [ ] `/pilates/categories` root is a JSON **array**
- [ ] `/programs` root is a JSON **array**
- [ ] `/challenges` root is an **object** with `exercises` (map) + `challenges` (array)
- [ ] `/body-focus/categories` root is an **object** with `exercises` (map) + `categories` (array)
- [ ] Every `exercise_ids` entry resolves to a key in that document's root `exercises` map
- [ ] All keys are `snake_case` and match §3/§4 exactly (no camelCase)
- [ ] No `null` anywhere — use `""`, `0`, or `[]` instead
- [ ] `difficulty` is exactly one of `Beginner` / `Intermediate` / `Advanced` (case-sensitive)
- [ ] Numeric fields are JSON **numbers**, not strings (`45`, not `"45"`)
- [ ] `order` is 1-based, sequential, unique within each exercise list
- [ ] `net_time_minutes <= duration_minutes` for **every** day/workout/session (§8.1)
- [ ] Every day/workout/session has ≥ 1 exercise
- [ ] Category, program, challenge, workout, day and session ids are unique **across the whole response** (§5.1)
- [ ] Body Focus category ids are exactly `butt_leg`, `abs`, `full_body`, `arm`
- [ ] `title_lead` keeps its trailing space where the design needs one
- [ ] No per-user fields (`progress`, `current_day_index`, `is_favorite`) anywhere in the response — those are local-only in the app
- [ ] All `thumbnail_url` / `video_url` are absolute HTTPS and return `200`
- [ ] Video URLs support byte-range requests
- [ ] All four datasets fully seeded from `assets/json/{pilates,programs,challenges,body_focus}.json`
- [ ] Response is valid UTF-8; special characters (`&`, accents) are not escaped into entities

---

## 10. Deliverables

1. Four live endpoint URLs (staging + production).
2. Postman collection or `curl` examples for each.
3. Confirmation of how §5.1 (duplicate/non-unique ids) was resolved.
4. Confirmation of whether `days_label`/`user_count` become integers (§8.2) — tell us before shipping, it changes our parser.
5. Seeded data matching the current four JSON files, with §8.1 and §8.3 fixed.
6. An admin/CMS path (or at minimum a documented way) to add categories, programs, challenges, workouts, and exercises later.

**Contact for questions on the payload shape:** Flutter/mobile team.
