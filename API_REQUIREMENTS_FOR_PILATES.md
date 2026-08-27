# API Requirements — Pilates Exercises / Workouts

**Audience:** Backend Developer
**Consumer:** Fitness App (Flutter) — Discover module
**Source of truth for the payload shape:** `assets/json/pilates.json` (currently bundled locally in the app; the API must return the exact same structure so the local file can be swapped for a network call with zero model changes).
**App-side models that parse this response:** `lib/features/discover/models/category_model.dart`
**App-side loader to be switched to HTTP:** `lib/features/discover/services/discover_repository.dart`

---

## 1. Goal

Right now the app ships a static JSON file. We need one endpoint that returns the **same JSON** from the server so content (categories, workouts, exercises, videos) can be updated without an app release.

**Hard requirement:** the response body must be byte-compatible with the current file structure — same key names (`snake_case`), same nesting, same types. Do not rename, wrap, or restructure without telling us first.

---

## 2. Endpoint

### `GET /api/v1/pilates/categories`

Returns the full catalogue: all categories, each with its workouts, each workout with its exercises.

| Item | Value |
|---|---|
| Method | `GET` |
| Path | `/api/v1/pilates/categories` |
| Auth | Bearer token (optional for v1 — see §7) |
| Content-Type | `application/json; charset=utf-8` |
| Success | `200 OK` |
| Response root | **JSON array** of Category objects |

> **Important:** the root is a **bare array**, not an object. The app does `jsonDecode(body) as List`. If you must wrap it (e.g. `{ "data": [...] }`), tell us before implementing so we update the parser.

### Optional supporting endpoints (nice to have, not blocking v1)

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/api/v1/pilates/categories/{category_id}` | Single category with its workouts |
| `GET` | `/api/v1/pilates/workouts/{workout_id}` | Single workout with its exercises |
| `GET` | `/api/v1/pilates/exercises/{exercise_id}` | Single exercise detail |

---

## 3. Response structure (3 levels)

```
Category (array root)
└── workouts[]  → Workout
     └── exercises[] → Exercise
```

### 3.1 Category object

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | Unique, stable slug-style id. e.g. `cat_weight_loss_01`. Used as a local key — must never change once shipped. |
| `title` | string | ✅ | Display name. e.g. `Weight Loss Journey` |
| `description` | string | ✅ | Short one-line subtitle shown under the title. |
| `workouts` | array\<Workout\> | ✅ | May be empty `[]`, must never be `null`. |

### 3.2 Workout object

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | ✅ | Unique workout id, e.g. `wk_model_leg_booty`. **Must be globally unique** — see §5.1. |
| `title` | string | ✅ | e.g. `Model Leg & Bubble Booty` |
| `difficulty` | string (enum) | ✅ | One of exactly: `Beginner`, `Intermediate`, `Advanced`. Case-sensitive. |
| `duration_minutes` | integer | ✅ | Total session length incl. rest. Shown on the workout card. |
| `net_time_minutes` | integer | ✅ | Active time excluding rest. Must be `<= duration_minutes`. |
| `calories_burned` | integer | ✅ | Estimated kcal for the whole workout. |
| `thumbnail_url` | string (URL) | ✅ | Absolute HTTPS URL. Workout cover image. See §6. |
| `exercises` | array\<Exercise\> | ✅ | Ordered list. May be empty `[]`, never `null`. |

### 3.3 Exercise object

| Field | Type | Required | Notes |
|---|---|---|---|
| `order` | integer | ✅ | 1-based position inside this workout. Must be sequential with no gaps/duplicates (1, 2, 3 …). |
| `exercise_id` | string | ✅ | Id of the exercise in the master exercise library, e.g. `ex_glute_bridge`. **Reused across workouts** — see §5.2. |
| `title` | string | ✅ | e.g. `Pilates Glute Bridge` |
| `description` | string | ✅ | One-sentence summary shown under the title. |
| `duration_seconds` | integer | ✅ | How long this exercise runs. Drives the in-app timer. Must be `> 0`. |
| `reps` | integer | ✅ | Target repetitions. Send `0` for time-only (hold) exercises — do **not** send `null`. |
| `rest_seconds` | integer | ✅ | Rest after this exercise. `0` is valid for the last exercise. |
| `thumbnail_url` | string (URL) | ✅ | Absolute HTTPS URL. Still image for the exercise. |
| `video_url` | string (URL) | ✅ | Absolute HTTPS URL to an **MP4 (H.264 + AAC)** demo clip. See §6. |
| `how_to_do` | array\<string\> | ✅ | Step-by-step instructions, in order. Typically 3–6 items. Each item is one plain-text step (no HTML, no markdown, no leading numbering — the app renders the bullets/numbers). |
| `common_mistakes` | array\<string\> | ✅ | Typically 2–4 items. Same formatting rules. |
| `breathing_tips` | array\<string\> | ✅ | Typically 3–4 items. Same formatting rules. |

**Empty-list rule:** all three string arrays must be present. If there is no content, return `[]` — never `null`, never omit the key.

---

## 4. Example response (abbreviated, real shape)

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

The complete current dataset lives at `assets/json/pilates.json` — **use that file as the seed data for the database.**

---

## 5. Data model / DB notes

Suggested tables:

```
categories        (id PK, title, description, sort_order, is_active, created_at, updated_at)
workouts          (id PK, category_id FK, title, difficulty, duration_minutes,
                   net_time_minutes, calories_burned, thumbnail_url, sort_order,
                   is_active, created_at, updated_at)
exercises         (id PK, title, description, thumbnail_url, video_url,
                   how_to_do JSON, common_mistakes JSON, breathing_tips JSON,
                   created_at, updated_at)
workout_exercises (workout_id FK, exercise_id FK, order,
                   duration_seconds, reps, rest_seconds,
                   PRIMARY KEY (workout_id, order))
```

### 5.1 Workout ids must be globally unique
The current JSON has the **same workout id `wk_squat_thigh_toner` under two different categories** (`cat_weight_loss_01` and `cat_toned_shape_01`). This breaks per-workout lookups, progress tracking, and favourites on the app side.

Please resolve it one of two ways, and tell us which:
- **(a) Preferred:** give each category's copy a distinct id (e.g. `wk_wl_squat_thigh_toner` / `wk_ts_squat_thigh_toner`), **or**
- **(b)** make a workout genuinely shareable across categories via a `category_workouts` join table, keeping one canonical id — but then the same id will legitimately appear in two categories and we'll handle dedup client-side.

### 5.2 Exercise ids are shared by design
`exercise_id` (e.g. `ex_glute_bridge`) intentionally repeats across workouts — it points at the master exercise library. The per-workout numbers (`order`, `duration_seconds`, `reps`, `rest_seconds`) belong to the `workout_exercises` join row, **not** to the exercise itself. Keep the content fields (`title`, `description`, `how_to_do`, `common_mistakes`, `breathing_tips`, `video_url`, `thumbnail_url`) on the exercise so an edit propagates everywhere.

### 5.3 Ordering
The app renders categories, workouts, and exercises **in the order the arrays arrive**. Please add an explicit `sort_order` column server-side and always sort deterministically — do not rely on insertion/PK order.

---

## 6. Media requirements

| Item | Requirement |
|---|---|
| Protocol | HTTPS only (iOS ATS blocks plain HTTP) |
| URLs | Absolute and publicly reachable — no relative paths, no signed URLs that expire in minutes |
| Images | JPG or PNG, ~16:9, ideally ≥ 720p, served from a CDN, `Cache-Control` set |
| Video | **MP4, H.264 video + AAC audio**, ≤ 1080p, short loopable clip. Must support HTTP range requests (byte-range) so the player can seek/stream |
| Video size | Keep clips small (target < 5 MB) — they autoplay inside the workout player |
| Fallback | If a video is unavailable, still return a valid `thumbnail_url` and an empty string `""` for `video_url` (not `null`) |

Current placeholder assets point at Pixabay CDN — those are temporary and must be replaced with our own CDN links.

---

## 7. Auth, headers, caching

- **Auth (v1):** endpoint may be public, or accept `Authorization: Bearer <token>`. Confirm which — the app can send the Firebase ID token if needed.
- **Caching:** please return `ETag` (or `Last-Modified`) and support `If-None-Match` → `304 Not Modified`. The catalogue changes rarely; the app will cache it locally and only refetch when it changes.
- **Versioning:** keep the `/api/v1/` prefix. Any breaking field change goes to `/api/v2/`.
- Optionally include a top-level `X-Content-Version` header (or a `version` field, if we agree to wrap the array) so the app can skip re-parsing unchanged data.

---

## 8. Error handling

Non-200 responses should use a consistent envelope:

```json
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Category not found."
  }
}
```

| Status | When |
|---|---|
| `200` | Success (empty catalogue → `[]`, still `200`) |
| `400` | Malformed request / bad query param |
| `401` | Missing or invalid token (if auth is enabled) |
| `404` | Unknown `category_id` / `workout_id` / `exercise_id` |
| `500` | Server error |

The app treats any non-200 as "load failed" and falls back to cached/bundled data.

---

## 9. Validation checklist (please verify before handing over)

- [ ] Root of `GET /api/v1/pilates/categories` is a JSON **array**
- [ ] All keys are `snake_case` and match §3 exactly (no camelCase)
- [ ] No `null` anywhere — use `""`, `0`, or `[]` instead
- [ ] `difficulty` is exactly one of `Beginner` / `Intermediate` / `Advanced`
- [ ] Numeric fields are JSON **numbers**, not strings (`45`, not `"45"`)
- [ ] `order` is 1-based, sequential, unique within each workout
- [ ] `net_time_minutes <= duration_minutes` for every workout
- [ ] Every workout has ≥ 1 exercise
- [ ] All `thumbnail_url` / `video_url` are absolute HTTPS and return `200`
- [ ] Workout ids are unique across the whole response (see §5.1)
- [ ] `assets/json/pilates.json` fully seeded into the DB
- [ ] Response is valid UTF-8; special characters (`&`, accents) are not escaped into entities

---

## 10. Deliverables

1. Live endpoint URL (staging + production).
2. Confirmation of the auth scheme.
3. Postman collection or `curl` example.
4. Answer on §5.1 (duplicate workout id).
5. Seeded data matching the current `pilates.json` content.
6. An admin/CMS path (or at minimum a documented way) to add categories, workouts, and exercises later.

**Contact for questions on the payload shape:** Flutter/mobile team.
