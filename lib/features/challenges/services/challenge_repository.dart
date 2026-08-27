import 'dart:convert';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:flutter/services.dart';

/// Mirrors [DiscoverRepository] / [WorkoutRepository].
///
/// The bundled document keeps one exercise catalogue and has days reference it
/// by id, the way the API will; [_resolve] inlines those references before the
/// models parse, so the models stay reference-free.
class ChallengeRepository {
  static List<ChallengeProgramModel>? _cached;

  static Future<List<ChallengeProgramModel>> loadChallenges() async {
    if (_cached != null) return _cached!;

    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/challenges.json',
      );
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) return [];

      final catalogue =
          (decoded['exercises'] as Map<String, dynamic>?) ?? const {};
      final challenges = (decoded['challenges'] as List<dynamic>?) ?? const [];

      _cached = challenges
          .whereType<Map<String, dynamic>>()
          .map((c) => ChallengeProgramModel.fromJson(_resolve(c, catalogue)))
          .toList();
      return _cached!;
    } catch (e) {
      return [];
    }
  }

  /// Replaces every day's `exercise_ids` with the catalogue entries.
  static Map<String, dynamic> _resolve(
    Map<String, dynamic> challenge,
    Map<String, dynamic> catalogue,
  ) {
    final weeks = (challenge['weeks'] as List<dynamic>?) ?? const [];

    for (final week in weeks.whereType<Map<String, dynamic>>()) {
      final days = (week['days'] as List<dynamic>?) ?? const [];

      for (final day in days.whereType<Map<String, dynamic>>()) {
        final ids = (day['exercise_ids'] as List<dynamic>?) ?? const [];
        day['exercises'] = ids
            .map((id) => catalogue[id])
            .whereType<Map<String, dynamic>>()
            .toList();
      }
    }

    return challenge;
  }
}
