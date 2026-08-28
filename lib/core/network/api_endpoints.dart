import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Every backend URL and route in one place — see `readme-v3Nm.md` for the
/// full API contract.
///
/// [baseUrl] and [apiKey] come from the `.env` file (via `flutter_dotenv`),
/// never hardcoded, so the secret never lands in source control — `.env` is
/// git-ignored. Copy `.env.example` to `.env` and fill in the real key.
/// [main.dart] loads it (`dotenv.load(...)`) before anything else runs.
///
/// Without `PILATES_API_KEY` set, every request past `/health` comes back
/// 401 — [ApiClient] falls back to the bundled catalogue JSON in that case,
/// so the app still runs, just off-network.
class ApiEndpoints {
  ApiEndpoints._();

  /// Production, per `readme-v3Nm.md`. Override in `.env` for local backend
  /// dev (e.g. `http://localhost:8128`).
  static String get baseUrl =>
      dotenv.maybeGet('PILATES_API_BASE_URL', fallback: 'http://56.228.38.227:8128')!;

  /// `X-API-KEY` header value. Empty until set in `.env`.
  static String get apiKey => dotenv.maybeGet('PILATES_API_KEY', fallback: '')!;

  static const String health = '/health';

  // --- Pilates discover catalogue ---
  static const String pilatesCategories = '/api/v1/pilates/categories';
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
}
