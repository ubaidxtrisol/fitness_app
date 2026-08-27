import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fitness_app/core/database/app_database.dart';

/// Persists the user info flow answers and the onboarding gate.
class UserProfileRepository {
  final AppDatabase _db;

  UserProfileRepository([AppDatabase? db]) : _db = db ?? AppDatabase.instance;

  Future<UserProfile> load() async {
    final row = await (_db.select(
      _db.userProfiles,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row != null) return row;

    await _db
        .into(_db.userProfiles)
        .insert(
          UserProfilesCompanion.insert(
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrIgnore,
        );
    return (_db.select(
      _db.userProfiles,
    )..where((t) => t.id.equals(1))).getSingle();
  }

  /// True once the user info flow has been completed at least once.
  Future<bool> isOnboardingComplete() async {
    final profile = await load();
    return profile.onboardingComplete;
  }

  /// Saves the answer map the user info flow builds up.
  ///
  /// Unknown keys are ignored, so the flow can add questions without this
  /// having to change first.
  Future<void> saveAnswers(
    Map<String, dynamic> answers, {
    bool markComplete = false,
  }) async {
    await load();

    String? str(String key) => answers[key] as String?;
    int? intOf(String key) => (answers[key] as num?)?.toInt();
    String? list(String key) {
      final value = answers[key];
      return value is List ? jsonEncode(value.map((e) => '$e').toList()) : null;
    }

    await (_db.update(_db.userProfiles)..where((t) => t.id.equals(1))).write(
      UserProfilesCompanion(
        goal: Value.absentIfNull(str('goal')),
        gender: Value.absentIfNull(str('gender')),
        age: Value.absentIfNull(intOf('age')),
        heightCm: Value.absentIfNull(intOf('height')),
        weightKg: Value.absentIfNull(intOf('weight')),
        targetWeightKg: Value.absentIfNull(intOf('target_weight')),
        currentBodyShape: Value.absentIfNull(str('current_body_shape')),
        targetBodyShape: Value.absentIfNull(str('target_body_shape')),
        workoutPlace: Value.absentIfNull(str('workout_place')),
        workoutLevel: Value.absentIfNull(str('workout_level')),
        bellyHipType: Value.absentIfNull(str('belly_hip_type')),
        legType: Value.absentIfNull(str('leg_type')),
        activitiesJson: Value.absentIfNull(list('activities')),
        injuriesJson: Value.absentIfNull(list('injuries')),
        onboardingComplete: markComplete
            ? const Value(true)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// The difficulty label the rest of the app shows, derived from the answers.
  Future<String> difficultyLabel() async {
    final profile = await load();
    return switch (profile.workoutLevel) {
      'beginner' => 'Beginner',
      'advanced' => 'Advanced',
      _ => 'Intermediate',
    };
  }

  List<String> decodeList(String json) {
    try {
      final decoded = jsonDecode(json);
      return decoded is List ? decoded.map((e) => '$e').toList() : const [];
    } catch (_) {
      return const [];
    }
  }
}
