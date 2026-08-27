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
          .map(
            (c) => ChallengeProgramModel.fromJson(
              _repaginate(_resolve(c, catalogue)),
            ),
          )
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

  /// The bundled content authors every challenge with the same 4 weeks x 7
  /// days (28 days) regardless of what its `days_label` claims — "14 Days",
  /// "60 Days", "45 Days" and so on are placeholder display text that never
  /// matched the actual `weeks`/`days` shape. This re-chunks the days
  /// actually authored into the real week layout a challenge of that length
  /// should have: full 7-day weeks with whatever's left over in the last one
  /// (14 -> 7+7, 10 -> 7+3, 20 -> 7+7+6, ...), cycling back through the
  /// authored days when the label calls for more than were written down, so
  /// every length gets a plausible-looking week/day layout instead of every
  /// challenge silently being the same 28 days.
  static Map<String, dynamic> _repaginate(Map<String, dynamic> challenge) {
    final rawWeeks = ((challenge['weeks'] as List<dynamic>?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    if (rawWeeks.isEmpty) return challenge;

    final pool = <Map<String, dynamic>>[
      for (final week in rawWeeks)
        ...((week['days'] as List<dynamic>?) ?? const [])
            .whereType<Map<String, dynamic>>(),
    ];
    if (pool.isEmpty) return challenge;

    final target =
        _parseDayCount(challenge['days_label'] as String?) ?? pool.length;

    final weeks = <Map<String, dynamic>>[];
    var cursor = 0;
    while (cursor < target) {
      final remaining = target - cursor;
      final count = remaining < 7 ? remaining : 7;
      final weekIndex = weeks.length;
      final rawWeek = rawWeeks[weekIndex % rawWeeks.length];

      weeks.add({
        'id': 'week_${weekIndex + 1}',
        'title': 'Week ${weekIndex + 1}',
        'subtitle': rawWeek['subtitle'],
        'current_day_index': 0,
        'days': List<Map<String, dynamic>>.generate(count, (i) {
          final template = pool[(cursor + i) % pool.length];
          return {...template, 'id': 'day_${i + 1}', 'title': 'Day ${i + 1}'};
        }),
      });
      cursor += count;
    }

    return {...challenge, 'weeks': weeks};
  }

  /// Pulls the leading integer out of a label like "14 Days" -> 14.
  static int? _parseDayCount(String? label) {
    if (label == null) return null;
    final match = RegExp(r'\d+').firstMatch(label);
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
  }
}
