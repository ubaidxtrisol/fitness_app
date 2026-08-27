import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fitness_app/core/database/app_database.dart';

/// Reads and writes the resumable "in-progress day" checkpoint.
///
/// The player saves one of these every time an exercise finishes (not just at
/// the end of the day), so if the app is closed mid-workout the next attempt
/// at that same day can offer to pick up where the user left off. Finishing
/// the day, restarting it, or explicitly deferring it clears the checkpoint.
class ActiveSessionRepository {
  final AppDatabase _db;

  ActiveSessionRepository([AppDatabase? db]) : _db = db ?? AppDatabase.instance;

  Future<ActiveSession?> find(String planId, String dayId) {
    return (_db.select(_db.activeSessions)..where(
          (t) => t.planId.equals(planId) & t.dayId.equals(dayId),
        ))
        .getSingleOrNull();
  }

  Future<void> save({
    required String planId,
    required String dayId,
    required String planType,
    required String planTitle,
    required String dayTitle,
    String dayLevel = '',
    int dayIndex = 0,
    int totalDays = 0,
    required List<String> completedExerciseIds,
    required int elapsedSeconds,
    required DateTime startedAt,
  }) {
    return _db
        .into(_db.activeSessions)
        .insertOnConflictUpdate(
          ActiveSessionsCompanion.insert(
            planId: planId,
            dayId: dayId,
            planType: planType,
            planTitle: planTitle,
            dayTitle: dayTitle,
            dayLevel: Value(dayLevel),
            dayIndex: Value(dayIndex),
            totalDays: Value(totalDays),
            completedExerciseIdsJson: Value(jsonEncode(completedExerciseIds)),
            elapsedSeconds: Value(elapsedSeconds),
            startedAt: startedAt,
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<void> clear(String planId, String dayId) {
    return (_db.delete(_db.activeSessions)..where(
          (t) => t.planId.equals(planId) & t.dayId.equals(dayId),
        ))
        .go();
  }

  List<String> decodeCompletedIds(String json) {
    try {
      final decoded = jsonDecode(json);
      return decoded is List ? decoded.map((e) => '$e').toList() : const [];
    } catch (_) {
      return const [];
    }
  }
}
