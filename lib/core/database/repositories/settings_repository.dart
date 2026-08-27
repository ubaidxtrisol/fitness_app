import 'package:drift/drift.dart';
import 'package:fitness_app/core/database/app_database.dart';

/// Reads and writes the single workout-settings row.
///
/// The player reads these to decide the pre-exercise countdown, playback
/// volume and whether cue sounds fire.
class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository([AppDatabase? db]) : _db = db ?? AppDatabase.instance;

  Future<WorkoutSettingsRow> load() async {
    final row = await (_db.select(
      _db.workoutSettingsRows,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row != null) return row;

    await _db
        .into(_db.workoutSettingsRows)
        .insert(
          const WorkoutSettingsRowsCompanion(),
          mode: InsertMode.insertOrIgnore,
        );
    return (_db.select(
      _db.workoutSettingsRows,
    )..where((t) => t.id.equals(1))).getSingle();
  }

  /// Emits on every change so open screens stay in sync.
  Stream<WorkoutSettingsRow> watch() {
    return (_db.select(
      _db.workoutSettingsRows,
    )..where((t) => t.id.equals(1))).watchSingleOrNull().asyncMap((row) async {
      return row ?? await load();
    });
  }

  Future<void> update({
    bool? voiceGuideEnabled,
    bool? detailedGuide,
    double? volume,
    bool? soundEffectEnabled,
    int? countdownSeconds,
  }) async {
    await load();
    await (_db.update(
      _db.workoutSettingsRows,
    )..where((t) => t.id.equals(1))).write(
      WorkoutSettingsRowsCompanion(
        voiceGuideEnabled: Value.absentIfNull(voiceGuideEnabled),
        detailedGuide: Value.absentIfNull(detailedGuide),
        volume: Value.absentIfNull(volume),
        soundEffectEnabled: Value.absentIfNull(soundEffectEnabled),
        countdownSeconds: Value.absentIfNull(countdownSeconds),
      ),
    );
  }
}
