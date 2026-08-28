# Pilates Exercises API — Mobile Developer Guide

Backend for the Pilates Exercises mobile app: Discover catalogue (categories / workouts / exercises), optional text recommend, and pose image upload to AWS S3.

| Feature | Endpoint |
|---------|----------|
| Health | `GET /health` |
| **Discover — all sections** | `GET /api/v1/pilates/categories` (includes `section_type`) |
| **Programs** | `GET /api/v1/pilates/programs` |
| **Challenges** | `GET /api/v1/pilates/challenges` |
| **Body Focus** | `GET /api/v1/pilates/body-focus` |
| **Discover grouped** | `GET /api/v1/pilates/discover` |
| Single category | `GET /api/v1/pilates/categories/{category_id}` |
| Single workout | `GET /api/v1/pilates/workouts/{workout_id}` |
| Single exercise | `GET /api/v1/pilates/exercises/{exercise_id}` |
| **Admin CRUD** | `GET/POST/PUT/DELETE /api/v1/admin/*` |
| Recommend routine | `POST /api/v1/exercises/recommend` |
| Upload pose image | `POST /api/v1/scan/pose` |

OpenAPI/Swagger UI is **disabled** — `/docs`, `/redoc`, and `/openapi.json` return **404**. Do not expose API schema in production.

**Production:** `http://56.228.38.227:8128` (PM2 process `pilates-exercises-app`).

**Source:** [github.com/sohailtahir5858/pilates-exercises-app](https://github.com/sohailtahir5858/pilates-exercises-app)

---

## Quick start

- **Base URL (prod):** `http://56.228.38.227:8128`
- **Base URL (local):** `http://localhost:8128`
- **Auth header:** `X-API-KEY: <API_KEY from .env>` (required on all routes except `GET /health`)
- **Auth scheme (v1 confirmed):** API key only — not public, not Firebase Bearer
- **First requests (production):**

```bash
export BASE_URL=http://56.228.38.227:8128
export API_KEY=<your-api-key>

curl -s "$BASE_URL/health"
```

```bash
curl -s "$BASE_URL/api/v1/pilates/categories" \
  -H "X-API-KEY: $API_KEY" \
  -H "Accept: application/json"
```

Local dev: use `BASE_URL=http://localhost:8128`.

---

## Authentication

Two layers:

1. **API key** (enforced) — `X-API-KEY`
2. **App signature** (implemented, not enforced by default) — `X-App-Timestamp`, `X-App-Nonce`, `X-App-Signature`

Full algorithm, multipart/JSON rules, Swift & Kotlin samples: see **[AUTHENTICATION_PROCESS.md](./AUTHENTICATION_PROCESS.md)**.

---

## Common conventions

- Field names: `snake_case`
- **Discover catalogue success body:** bare JSON **array** (not wrapped) — matches Flutter `jsonDecode(body) as List`
- Other endpoints: `{ "success": true, "content": "..." }` where applicable
- Error shapes:
  - Most routes: `{ "success": false, "message": "..." }`
  - `/api/v1/pilates/*`: `{ "error": { "code": "NOT_FOUND", "message": "..." } }`
- Uploaded pose files are stored on **AWS S3 only**

---

## Error handling

| Code | Meaning |
|------|---------|
| 200 | Success |
| 304 | Catalogue not modified (`If-None-Match` matched `ETag`) |
| 401 | Missing/invalid API key or app signature |
| 403 | IP temporarily blocked (rate-limit strikes) |
| 404 | Unknown category / workout / exercise id (pilates) |
| 422 | Validation error |
| 429 | Rate limit exceeded (`Retry-After` header) |
| 500 | Upstream/processing failure |
| 504 | Request timed out |

Pilates error example:

```json
{ "error": { "code": "NOT_FOUND", "message": "Category not found." } }
```

---

## Discover catalogue

The Discover module has three content tabs — **Programs**, **Challenges**, and **Body Focus**. Each tab is a list of categories (same nested shape: category → workouts → exercises).

| Tab | `section_type` | Public endpoint |
|-----|----------------|-----------------|
| Programs | `program` | `GET /api/v1/pilates/programs` |
| Challenges | `challenge` | `GET /api/v1/pilates/challenges` |
| Body Focus | `body_focus` | `GET /api/v1/pilates/body-focus` |

- `GET /api/v1/pilates/categories` — **all** active sections combined (backward compatible); each item includes `section_type`
- `GET /api/v1/pilates/discover` — grouped object: `{ "programs": [...], "challenges": [...], "body_focus": [...] }`

All list endpoints return a **bare JSON array** per tab (except `/discover`, which is grouped).

### Response shape

Root is a **JSON array** of categories. Nesting: `Category → workouts[] → exercises[]`. Same key names and types as the app's bundled `pilates.json` (see Flutter `category_model.dart`), plus:

| Field | Type | Notes |
|-------|------|-------|
| `section_type` | string | `program` \| `challenge` \| `body_focus` |

### Caching

- Response headers: `ETag`, `X-Content-Version`, `Cache-Control`
- Send `If-None-Match: <ETag>` to receive `304 Not Modified` when unchanged

### §5.1 Duplicate workout ids (resolved)

Original seed had `wk_squat_thigh_toner` under both `cat_weight_loss_01` and `cat_toned_shape_01`.

**Resolution (option a):** distinct ids per category copy. First occurrence keeps the original id; later copies are renamed.

| Original id | Category | New id |
|-------------|----------|--------|
| `wk_squat_thigh_toner` | `cat_weight_loss_01` | `wk_squat_thigh_toner` (unchanged) |
| `wk_squat_thigh_toner` | `cat_toned_shape_01` | `wk_ts_squat_thigh_toner` |

Full map after each seed: `data/workout_id_renames.json`.

### Admin / content updates

Use **`/api/v1/admin/*`** CRUD APIs (same `X-API-KEY`). Mutations refresh catalogue `ETag` automatically.

| Resource | Endpoints |
|----------|-----------|
| Categories | `GET/POST /admin/categories`, `GET/PUT/DELETE /admin/categories/{id}` |
| Workouts | `GET/POST /admin/workouts`, `GET/PUT/DELETE /admin/workouts/{id}` |
| Exercises (library) | `GET/POST /admin/exercises`, `GET/PUT/DELETE /admin/exercises/{id}` |
| Workout ↔ exercise links | `GET/PUT /admin/workouts/{id}/exercises`, `POST` add one, `DELETE .../{order}` |

Admin success shape: `{ "success": true, "content": {...} }`. Deletes on categories/workouts are **soft** (`is_active=false`).

Bulk reseed from JSON (optional):

```bash
cd /var/www/html/pilates-exercises-app
source .venv/bin/activate
python scripts/seed_pilates.py
pm2 restart pilates-exercises-app
```

---

## Image upload rules

- **Endpoint:** `POST /api/v1/scan/pose`
- **Field name:** `image` (multipart form-data)
- **Formats:** `image/jpeg`, `image/png`, `image/webp`, `image/heic`
- **Max size:** 10 MB (`MAX_UPLOAD_BYTES`)
- **Storage:** AWS S3 bucket `pilates-exercises-app`
- **URL returned:** public/CDN URL if `S3_PUBLIC_BASE_URL` is set; otherwise a time-limited **presigned GET URL**

Catalogue media URLs must be absolute **HTTPS** (permanent / CDN). Empty `video_url` is `""`, never `null`.

---

## Recommended mobile flows

### Discover catalogue flow

1. Programs: `GET /api/v1/pilates/programs` + `X-API-KEY`
2. Challenges: `GET /api/v1/pilates/challenges`
3. Body Focus: `GET /api/v1/pilates/body-focus`
4. Or all at once: `GET /api/v1/pilates/discover`
5. Parse body as `List` (same models as local `pilates.json`)
6. Cache locally; on next launch send `If-None-Match` with last `ETag` on `/categories`

### Text recommend flow

1. User picks goal / level / duration
2. `POST /api/v1/exercises/recommend` + `X-API-KEY`
3. Render `exercises[]` / `content`

### Camera scan flow

1. Capture pose photo
2. `POST /api/v1/scan/pose` multipart with `image` + `X-API-KEY`
3. Persist returned `key` / display `url`

---

## Full API reference

Use `BASE_URL=http://56.228.38.227:8128` for production or `http://localhost:8128` locally.

### 1. `GET /health`

No auth.

```bash
curl -s "$BASE_URL/health"
```

```json
{ "success": true, "status": "ok" }
```

---

### 2. `GET /api/v1/pilates/categories`

Full Discover catalogue. **Root = array.** Auth: `X-API-KEY`. Rate limit: TEXT.

```bash
curl -si "$BASE_URL/api/v1/pilates/categories" \
  -H "X-API-KEY: $API_KEY"
```

Conditional:

```bash
curl -si "$BASE_URL/api/v1/pilates/categories" \
  -H "X-API-KEY: $API_KEY" \
  -H 'If-None-Match: "<etag-from-previous-response>"'
```

**Success (200):** JSON array of categories (abbreviated):

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
        "thumbnail_url": "https://...",
        "exercises": []
      }
    ]
  }
]
```

---

### 3. `GET /api/v1/pilates/categories/{category_id}`

Single category object (not wrapped). `404` if unknown.

```bash
curl -s "$BASE_URL/api/v1/pilates/categories/cat_weight_loss_01" \
  -H "X-API-KEY: $API_KEY"
```

---

### 4. `GET /api/v1/pilates/workouts/{workout_id}`

Single workout with nested exercises.

```bash
curl -s "$BASE_URL/api/v1/pilates/workouts/wk_model_leg_booty" \
  -H "X-API-KEY: $API_KEY"
```

---

### 5. `GET /api/v1/pilates/exercises/{exercise_id}`

Master exercise library entry (`exercise_id`, title, media, tip arrays).

```bash
curl -s "$BASE_URL/api/v1/pilates/exercises/ex_glute_bridge" \
  -H "X-API-KEY: $API_KEY"
```

---

### 6. `POST /api/v1/exercises/recommend`

| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| `goal` | string | yes | 1–500 chars |
| `level` | string | no | default `beginner` |
| `duration_minutes` | int | no | 5–120, default 20 |

```bash
curl -s -X POST "$BASE_URL/api/v1/exercises/recommend" \
  -H "Content-Type: application/json" \
  -H "X-API-KEY: $API_KEY" \
  -d '{"goal":"better posture","level":"intermediate","duration_minutes":30}'
```

---

### 7. `POST /api/v1/scan/pose`

Multipart field `image` → S3.

```bash
curl -s -X POST "$BASE_URL/api/v1/scan/pose" \
  -H "X-API-KEY: $API_KEY" \
  -F "image=@/path/to/pose.jpg;type=image/jpeg"
```

---

## Flutter / Discover integration

Point `discover_repository.dart` at:

`GET http://56.228.38.227:8128/api/v1/pilates/categories` (production) with header `X-API-KEY`.

Decode as `List` — same models as `assets/json/pilates.json`. No envelope unwrap.

Update favourites / progress keys if you previously used the duplicate `wk_squat_thigh_toner` under `cat_toned_shape_01` — that id is now `wk_ts_squat_thigh_toner`.

---

## Endpoint summary

1. `GET /health` — liveness
2. `GET /api/v1/pilates/categories` — all Discover sections (array)
3. `GET /api/v1/pilates/programs` — Programs tab
4. `GET /api/v1/pilates/challenges` — Challenges tab
5. `GET /api/v1/pilates/body-focus` — Body Focus tab
6. `GET /api/v1/pilates/discover` — grouped sections
7. `GET /api/v1/pilates/categories/{category_id}` — one category
8. `GET /api/v1/pilates/workouts/{workout_id}` — one workout
9. `GET /api/v1/pilates/exercises/{exercise_id}` — one exercise
10. `GET/POST/PUT/DELETE /api/v1/admin/*` — catalogue CRUD
11. `POST /api/v1/exercises/recommend` — routine suggestion
12. `POST /api/v1/scan/pose` — pose image → S3

---

## Postman

1. Import `postman/Pilates-Exercises-API.postman_collection.json`
2. Default `base_url` is production (`http://56.228.38.227:8128`); set `api_key`
3. Health uses no auth; other requests send `X-API-KEY`

---

## Local backend setup

```bash
cd pilates-exercises-app
cp .env.example .env
# Fill API_KEY, APP_SIGNATURE_SECRET, AWS/S3 as needed
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python scripts/seed_pilates.py
chmod +x run.sh
# Dev: ./run.sh
# Prod: pm2 start ./run.sh --name pilates-exercises-app --interpreter bash
```

Python 3.12+. Catalogue stored in **PostgreSQL** (`DATABASE_URL`). No Docker.

S3 bootstrap (optional for pose uploads):

```bash
./setup-s3-app.sh pilates-exercises-app
```

`setup-s3-app.sh` is gitignored — do not commit secrets.
