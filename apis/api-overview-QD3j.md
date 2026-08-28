# API overview — Pilates Exercises

FastAPI mobile backend (v1.0.0). **OpenAPI/Swagger disabled** — no `/docs`, `/redoc`, or `/openapi.json`.

## Endpoints (30)

### Health

| Method | Path | Auth | Rate limit | Notes |
|--------|------|------|------------|-------|
| GET | `/health` | none | none | Liveness `{success,status}` |

### Discover catalogue (mobile)

| Method | Path | Auth | Rate limit | Notes |
|--------|------|------|------------|-------|
| GET | `/api/v1/pilates/categories` | X-API-KEY | text | All sections; bare JSON **array**; ETag / 304; includes `section_type` |
| GET | `/api/v1/pilates/programs` | X-API-KEY | text | Programs tab (`section_type=program`) |
| GET | `/api/v1/pilates/challenges` | X-API-KEY | text | Challenges tab (`section_type=challenge`) |
| GET | `/api/v1/pilates/body-focus` | X-API-KEY | text | Body Focus tab (`section_type=body_focus`) |
| GET | `/api/v1/pilates/discover` | X-API-KEY | text | Grouped `{programs, challenges, body_focus}` |
| GET | `/api/v1/pilates/categories/{category_id}` | X-API-KEY | text | Single category |
| GET | `/api/v1/pilates/workouts/{workout_id}` | X-API-KEY | text | Nested exercises |
| GET | `/api/v1/pilates/exercises/{exercise_id}` | X-API-KEY | text | Master library entry |

### Other mobile

| Method | Path | Auth | Rate limit | Notes |
|--------|------|------|------------|-------|
| POST | `/api/v1/exercises/recommend` | X-API-KEY | text | JSON body: goal, level, duration_minutes |
| POST | `/api/v1/scan/pose` | X-API-KEY | scan | Multipart `image` → S3 |

### Admin CRUD (catalogue management)

Same `X-API-KEY`. Success: `{success: true, content: ...}`. Rate limit: text.

| Method | Path | Notes |
|--------|------|-------|
| GET | `/api/v1/admin/categories` | List all (incl. inactive) |
| POST | `/api/v1/admin/categories` | Create; set `section_type` |
| GET | `/api/v1/admin/categories/{category_id}` | One category |
| PUT | `/api/v1/admin/categories/{category_id}` | Update |
| DELETE | `/api/v1/admin/categories/{category_id}` | Soft delete |
| GET | `/api/v1/admin/workouts` | List; optional `?category_id=` |
| POST | `/api/v1/admin/workouts` | Create |
| GET | `/api/v1/admin/workouts/{workout_id}` | One workout |
| PUT | `/api/v1/admin/workouts/{workout_id}` | Update |
| DELETE | `/api/v1/admin/workouts/{workout_id}` | Soft delete |
| GET | `/api/v1/admin/exercises` | Exercise library list |
| POST | `/api/v1/admin/exercises` | Create |
| GET | `/api/v1/admin/exercises/{exercise_id}` | One exercise |
| PUT | `/api/v1/admin/exercises/{exercise_id}` | Update |
| DELETE | `/api/v1/admin/exercises/{exercise_id}` | Hard delete if unused |
| GET | `/api/v1/admin/workouts/{workout_id}/exercises` | Ordered links |
| PUT | `/api/v1/admin/workouts/{workout_id}/exercises` | Replace full list |
| POST | `/api/v1/admin/workouts/{workout_id}/exercises` | Add one link |
| DELETE | `/api/v1/admin/workouts/{workout_id}/exercises/{order}` | Remove by order |

## Response conventions

- Discover catalogue (`/api/v1/pilates/*` success): bare objects/arrays; errors `{error:{code,message}}`
- Admin / recommend / scan / health: `{success: true, content: ...}` or `{success:false,message}`
- Statuses: 200, 304, 401, 403, 404, 422, 429, 500, 504

## Stack

Python 3.12+, FastAPI, Uvicorn, SQLAlchemy + PostgreSQL catalogue, boto3 → S3.
Port **8128** (`run.sh` / PM2 name `pilates-exercises-app`).

- **Production base URL:** `http://56.228.38.227:8128`
- **Repository:** https://github.com/sohailtahir5858/pilates-exercises-app
