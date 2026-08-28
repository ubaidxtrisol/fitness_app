import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Every backend URL and route in one place — see `apis/` for the full API
/// contract as delivered against `apis/API_REQUIREMENTS.md`:
/// `apis/readme-cLqG (1).md` (endpoint reference), `apis/api-overview-QD3j.md`
/// (all 30 routes + response conventions), `apis/authentication-process-3eUk.md`
/// / `apis/authentication-WlDp.md` (auth + rate limits) and
/// `apis/environments-bsg8.md` (base URLs). `apis/readme-v3Nm.md` is the
/// superseded first draft — Discover only, no Programs/Challenges/Body
/// Focus/admin split, kept for history.
///
/// [baseUrl], [apiKey] and [appSignatureSecret] come from the `.env` file
/// (via `flutter_dotenv`), never hardcoded, so secrets never land in source
/// control — `.env` is git-ignored. Copy `.env.example` to `.env` and fill in
/// the real values. [main.dart] loads it (`dotenv.load(...)`) before
/// anything else runs.
///
/// Without `PILATES_API_KEY` set, every request past `/health` comes back
/// 401 — repositories should fall back to their bundled catalogue JSON in
/// that case, so the app still runs, just off-network.
class ApiEndpoints {
  ApiEndpoints._();

  /// Production, per `apis/environments-bsg8.md`. Override in `.env` for
  /// local backend dev (`PILATES_API_BASE_URL=http://localhost:8128`).
  static String get baseUrl =>
      dotenv.maybeGet('PILATES_API_BASE_URL', fallback: 'http://56.228.38.227:8128')!;

  /// `X-API-KEY` header value. Empty until set in `.env`. Required on every
  /// route except [health].
  static String get apiKey => dotenv.maybeGet('PILATES_API_KEY', fallback: '')!;

  /// `APP_SIGNATURE_SECRET` shared with the backend, used to HMAC-sign every
  /// request (`X-App-Timestamp` / `X-App-Nonce` / `X-App-Signature` — see
  /// `apis/authentication-process-3eUk.md`). The server doesn't enforce this
  /// layer yet (`ENFORCE_APP_SIGNATURE=false`), but [ApiClient] signs
  /// whenever this is set so flipping enforcement on later needs no client
  /// hotfix. Empty (the default) simply skips signing.
  static String get appSignatureSecret =>
      dotenv.maybeGet('PILATES_APP_SIGNATURE_SECRET', fallback: '')!;

  /// No auth, no signature — the one route that stays open either way.
  static const String health = '/health';

  // --- Discover catalogue (mobile) ---
  // All four of these are bare-array (or, for `discover`, grouped-object)
  // responses per `apis/readme-cLqG (1).md` §"Discover catalogue" — same
  // Category → workouts[] → exercises[] nesting, plus `section_type`.

  /// All active sections combined (Programs + Challenges + Body Focus),
  /// backward compatible with the original `readme-v3Nm.md` contract; each
  /// item now also carries `section_type` (`program` | `challenge` |
  /// `body_focus`).
  static const String pilatesCategories = '/api/v1/pilates/categories';

  /// Programs tab only (`section_type == 'program'`).
  static const String pilatesPrograms = '/api/v1/pilates/programs';

  /// Challenges tab only (`section_type == 'challenge'`).
  static const String pilatesChallenges = '/api/v1/pilates/challenges';

  /// Body Focus tab only (`section_type == 'body_focus'`).
  static const String pilatesBodyFocus = '/api/v1/pilates/body-focus';

  /// All three tabs in one call, grouped:
  /// `{ "programs": [...], "challenges": [...], "body_focus": [...] }`.
  static const String pilatesDiscover = '/api/v1/pilates/discover';

  static String pilatesCategory(String categoryId) =>
      '/api/v1/pilates/categories/$categoryId';
  static String pilatesWorkout(String workoutId) =>
      '/api/v1/pilates/workouts/$workoutId';
  static String pilatesExercise(String exerciseId) =>
      '/api/v1/pilates/exercises/$exerciseId';

  // --- Not yet consumed by the app, but the base client is ready for them
  // the moment a screen needs them. ---
  static const String exercisesRecommend = '/api/v1/exercises/recommend';
  static const String scanPose = '/api/v1/scan/pose';

  // --- Admin CRUD (catalogue management) ---
  // Same `X-API-KEY`, success shape `{"success": true, "content": ...}`.
  // No in-app CMS screen consumes these yet — kept ready per
  // `apis/api-overview-QD3j.md` §"Admin CRUD". Category/workout deletes are
  // soft (`is_active=false`); exercise deletes are hard (only if unused).

  static const String adminCategories = '/api/v1/admin/categories';
  static String adminCategory(String categoryId) =>
      '/api/v1/admin/categories/$categoryId';

  static const String adminWorkouts = '/api/v1/admin/workouts';
  static String adminWorkout(String workoutId) =>
      '/api/v1/admin/workouts/$workoutId';

  static const String adminExercises = '/api/v1/admin/exercises';
  static String adminExercise(String exerciseId) =>
      '/api/v1/admin/exercises/$exerciseId';

  /// `GET`/`PUT` (replace full list) the ordered exercise links for a
  /// workout; `POST` the same path to add one link.
  static String adminWorkoutExercises(String workoutId) =>
      '/api/v1/admin/workouts/$workoutId/exercises';

  /// `DELETE` one link by its 1-based `order` within the workout.
  static String adminWorkoutExercise(String workoutId, int order) =>
      '/api/v1/admin/workouts/$workoutId/exercises/$order';
}
