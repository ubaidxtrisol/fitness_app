import 'package:drift/drift.dart';
import 'package:fitness_app/core/database/app_database.dart';

/// The per-exercise duration the user dialled in with the detail screen's
/// stepper (Figma 11:1104).
///
/// Nothing is stored until the stepper is touched: an untouched exercise runs
/// for its clip's natural length, which the player resolves at playback time.
class ExercisePrefsRepository {
  final AppDatabase _db;

  ExercisePrefsRepository([AppDatabase? db]) : _db = db ?? AppDatabase.instance;

  /// The lower bound the stepper clamps to, shared with the detail screen.
  static const int minSeconds = 5;

  /// A sane ceiling — a single exercise looping past 30 minutes is a mis-tap.
  static const int maxSeconds = 1800;

  Future<int?> durationFor(String exerciseId) async {
    if (exerciseId.isEmpty) return null;

    final row = await (_db.select(
      _db.exercisePreferences,
    )..where((t) => t.exerciseId.equals(exerciseId))).getSingleOrNull();
    return row?.durationSeconds;
  }

  /// Every override the player needs for one session, in a single read.
  Future<Map<String, int>> durationsFor(Iterable<String> exerciseIds) async {
    final ids = exerciseIds.where((id) => id.isNotEmpty).toSet().toList();
    if (ids.isEmpty) return const {};

    final rows = await (_db.select(
      _db.exercisePreferences,
    )..where((t) => t.exerciseId.isIn(ids))).get();

    return {for (final row in rows) row.exerciseId: row.durationSeconds};
  }

  /// Stores the stepper's value. Clamped, so a runaway tap cannot write a
  /// duration the player would never finish.
  Future<void> setDuration(String exerciseId, int seconds) async {
    if (exerciseId.isEmpty) return;

    await _db
        .into(_db.exercisePreferences)
        .insertOnConflictUpdate(
          ExercisePreferencesCompanion.insert(
            exerciseId: exerciseId,
            durationSeconds: seconds.clamp(minSeconds, maxSeconds),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Drops the override so the exercise goes back to its clip's length.
  Future<void> clear(String exerciseId) async {
    await (_db.delete(
      _db.exercisePreferences,
    )..where((t) => t.exerciseId.equals(exerciseId))).go();
  }
}
